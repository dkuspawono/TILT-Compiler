#include "general.h"
#include <sys/time.h>
#include <sys/resource.h>

#include "tag.h"
#include "queue.h"
#include "forward.h"
#include "gc.h"
#include "gc_para.h"
#include "thread.h"
#include "global.h"
#include "stack.h"
#include "bitmap.h"
#include "stats.h"
#include "gcstat.h"
#include "show.h"


static Heap_t *fromheap = NULL, *toheap = NULL;
static int collectionRate = 4;   /* Ratio of collection rate to allocation rate */
static int fetchSize = 20;       /* Number of objects to fetch from global pool */
static int localWorkSize = 40;   /* Number of objects to work on from local pool */

/* ------------------  Parallel array allocation routines ------------------- */

static mem_t alloc_big(int byteLen, int hasPointers)
{
  Thread_t *curThread = getThread();
  unsigned long *saveregs = curThread->saveregs;
  mem_t res = NULL;
  int request = RoundUp(byteLen, pagesize);

  /* Should be at least 0.5K to be considered big */
  assert(byteLen >= 512);                

  /* Get the large region */
  if (saveregs[ALLOCPTR] + byteLen > saveregs[ALLOCLIMIT]) 
    GCFromC(curThread, request, 0);
  assert(saveregs[ALLOCPTR] + byteLen <= saveregs[ALLOCLIMIT]);

  /* Perform actual allocation */
  res = (mem_t) saveregs[ALLOCPTR];
  saveregs[ALLOCPTR] = (unsigned long) (res + (byteLen / (sizeof (val_t))));

  gcstat_normal(byteLen, 0, 0);
  return res;
}

ptr_t alloc_bigintarray_SemiConc(int elemLen, int initVal, int ptag)
{
  /* elemements are byte-sized */
  int wordLen = 1 + (elemLen + 3) / 4;
  mem_t space = alloc_big(4 * wordLen,0);
  ptr_t res = space + 1;
  init_iarray(res, elemLen, initVal);
  return res;
}

ptr_t alloc_bigptrarray_SemiConc(int elemLen, ptr_t initVal, int ptag)
{
  int wordLen = 1 + elemLen;
  mem_t space = alloc_big(4 * wordLen,1);
  ptr_t res = space + 1;
  init_parray(res, elemLen, initVal);
  return res;
}

ptr_t alloc_bigfloatarray_SemiConc(int elemLen, double initVal, int ptag)
{
  ptr_t res = NULL;
  mem_t region = NULL;
  Thread_t *curThread = getThread();
  int wordLen = 2 + (elemLen << 1);  /* Includes one word for alignment */

  region = alloc_big(4 * wordLen,0);
  if ((((val_t)region) & 7) != 0) {
    region[0] = SKIP_TAG | (1 << SKIPLEN_OFFSET);
    res = region + 1;
  }
  else {
    region[wordLen-1] = SKIP_TAG | (1 << SKIPLEN_OFFSET);
    res = region;
  }
  init_farray(res, elemLen, initVal);
  return res;
}


/* --------------------- Concurrent collector --------------------- */
static long numOff = 0;
static long numFlip = 0;
static long numOffDone = 0;
static long req_size = 0;

static void CollectorOff(SysThread_t *sysThread)
{
  Thread_t *curThread = NULL;
  int isFirst;
  int rootCount = 0;

  if (diag)
    printf("Proc %d: entered CollectorOff\n", sysThread->stid);
  assert(sysThread->LocalCursor == 0); 
  flushStore();

  switch (GCStatus) {
  case GCOff: assert(0);       /* Collector already off! */
  case GCPendingOn: assert(0); /* Someone is turning the collector off while we are turning it on! */
  case GCOn:                   /* First to signal turning collector off */
    GCStatus = GCPendingOff;
    StopAllThreads();
    break;
  case GCPendingOff: break;   /* Responding to someone's signal to turn collector off */
  default: assert(0);
  }

  isFirst = (asynchReachBarrier(&numOff)) == 0;
  if (isFirst) {
    assert(isEmptyGlobalStack());
    ResetJob();
    asynchReachBarrier(&numOff);
  }
  while (!asynchCheckBarrier(&numOff, NumSysThread+1, &numOffDone))
    ;

  /* Replace all roots (global, local registers, local stack) with replica */
  if (isFirst) 
    major_global_scan(sysThread);
  while ((curThread = NextJob()) != NULL)
    local_root_scan(sysThread,curThread,fromheap);
  /* Now forward all the roots which initializes the local work stacks */
  while (!QueueIsEmpty(sysThread->root_lists)) {
    /* Cannot dequeue from roots since this may be a global */
    Heap_t *legalPrimaryHeaps[2] = {NULL, NULL};
    Heap_t *legalReplicaHeaps[2] = {NULL,NULL};
    Bitmap_t *legalStarts[2] = {NULL, NULL};
    Queue_t *roots = (Queue_t *) Dequeue(sysThread->root_lists);
    int i, len = QueueLength(roots);  
    legalPrimaryHeaps[0] = fromheap;
    legalReplicaHeaps[0] = toheap;
    for (i=0; i<len; i++) {
      ploc_t root = (ploc_t) QueueAccess(roots,i);
      loc_t primary = *root;
      loc_t replica;
      if (!inHeaps(primary,legalPrimaryHeaps, legalStarts))  /* root was not in heap; could be global or small constructor */
	continue;
      replica = (loc_t) primary[-1];
      if (!inHeaps(replica,legalReplicaHeaps, legalStarts) || verbose) {
	printf("GC %d: collector off %d root = %d   primary = %d, replica = %d",NumGC, ++rootCount,root,primary,replica);
	if (!verbose)
	  printf("   ERROR replica not in to heap\n");
	else printf("\n");
      }
      *root = replica;
    }
  }

  synchBarrier(&numFlip, NumSysThread, &numOff);

  /* Only the designated thread needs to perform the following */
  if (isFirst) {
    long alloc = (sizeof (val_t)) * (fromheap->top - fromheap->bottom);
    long copied = (sizeof (val_t)) * (toheap->alloc_start - toheap->bottom);
    Heap_t *froms[2] = {NULL, NULL};
    froms[0] = fromheap;

    /* Check the fromspace and tospace heap - zero out all of fromspace */
    if (paranoid) {
      paranoid_check_all(fromheap, NULL, toheap,NULL);
      bzero((char *)fromheap->bottom, (sizeof (val_t)) * (fromheap->top - fromheap->bottom));
    }
    
    /* Resize heaps and do stats */
    gcstat_normal(alloc,copied,0);
    HeapAdjust(0,req_size,froms,toheap);
    Heap_Protect(fromheap);
    fromheap->alloc_start = fromheap->bottom;
    typed_swap(Heap_t *, fromheap, toheap);
    NumGC++;
    GCStatus = GCOff;
  }

  /* Each thread has a separate write list */
  gcstat_normal(0,0, sysThread->writelistCursor - sysThread->writelistStart);

  /* All system threads need to reset their limit pointer */
  sysThread->allocStart = StartHeapLimit;
  sysThread->allocCursor = StartHeapLimit;
  sysThread->allocLimit = StartHeapLimit;
  sysThread->writelistCursor = sysThread->writelistStart;

  /* Resume normal scheduler work and start mutators */
  if (diag)
    printf("Proc %d: waiting to sync on completion of CollectorOff\n",sysThread->stid);
  flushStore();
  synchBarrier(&numOffDone, NumSysThread, &numFlip);
}

void GCRelease_SemiConc(SysThread_t *sysThread)
{
  mem_t allocCurrent = sysThread->allocStart;
  mem_t allocStop = sysThread->allocCursor;
  ploc_t writelistCurrent = sysThread->writelistStart;
  ploc_t writelistStop = sysThread->writelistCursor;
  mem_t to_alloc = 0, to_limit = 0;
  range_t from_range, to_range;
  int bytesCopied = 0;

  sysThread->allocStart = sysThread->allocCursor;  /* allocation area is NOT reused */
  sysThread->writelistCursor = sysThread->writelistStart;  /* write list reused once processed */

  switch (GCStatus) {
  case GCOff:
  case GCPendingOn:
    return;          /* We don't replicate or process the write list */
  case GCOn:
  case GCPendingOff:
    break;
  default:
    assert(0);
  }

  /* Get local ranges ready for use */
  SetRange(&from_range, fromheap->bottom, fromheap->top);
  SetRange(&to_range, toheap->bottom, toheap->top);
  assert(sysThread->LocalCursor == 0);

  if (diag)
    printf("Proc %d: Scanning/Replicating %d to %d\n",sysThread->stid,allocCurrent,allocStop);
  while (allocCurrent + 1 < allocStop) {
    tag_t tag = *allocCurrent;
    ptr_t obj = allocCurrent + 1;
    int bytesCopied, objSize;
    if (IS_SKIP(tag)) {
      allocCurrent += GET_SKIP(tag);
      continue;
    }
    bytesCopied = forward1_concurrent_stack(obj,&to_alloc,&to_limit,toheap,&from_range,sysThread);
    objSize = (bytesCopied) ? bytesCopied : objectLength((ptr_t)obj[-1]);
    allocCurrent += objSize / sizeof(val_t);
  }

  if (diag)
    printf("Proc %d: Processing writes from %d to %d\n",sysThread->stid,writelistCurrent,writelistStop);
  while (writelistCurrent < writelistStop) {
    ptr_t primary = *writelistCurrent++, replica;
    tag_t tag;
    int wordDisp = (int) *writelistCurrent++;

    forward1_concurrent_stack(primary,&to_alloc,&to_limit,toheap,&from_range,sysThread);
    replica = (ptr_t) primary[-1];
    tag = replica[-1];

    switch (GET_TYPE(tag)) {
    case PARRAY_TAG: {
      ptr_t primaryField = (ptr_t) primary[wordDisp], replicaField;
      forward1_concurrent_stack(primaryField,&to_alloc,&to_limit,toheap,&from_range,sysThread);
      replicaField = (ptr_t) primaryField[-1];
      replica[wordDisp] = (val_t) replicaField;  /* update replica with replicated object */
      break;
    }
    case IARRAY_TAG: {
      int primaryField = (int) primary[wordDisp];
      replica[wordDisp] = primaryField;       /* update replica with primary's non-pointer value */
      break;
    }
    case RARRAY_TAG: {
      int doublewordDisp = wordDisp * sizeof(val_t) / (sizeof(double));
      double primaryField = (int) primary[doublewordDisp];
      replica[doublewordDisp] = primaryField;  /* update replica with primary's non-pointer value */
      break;
    }
    default: assert(0);
    }
  }

  SynchStart();
  SynchMid();
  moveToGlobalStack(sysThread->LocalStack, &(sysThread->LocalCursor));
  SynchEnd();
  
  /* XXX wastage of space */
  if (to_alloc < to_limit)
    *to_alloc = SKIP_TAG | ((to_limit - to_alloc) << SKIPLEN_OFFSET);
  flushStore();
}


static void do_work(SysThread_t *sysThread, int bytesToCopy)
{
  int i;
  mem_t to_alloc_start;         /* Designated thread records this initially */
  mem_t to_alloc = 0;
  mem_t to_limit = 0;
  range_t from_range, to_range;
  int bytesCopied = 0;
  int lastAndEmpty = 0;

  /* Get local ranges ready for use */
  SetRange(&from_range, fromheap->bottom, fromheap->top);
  SetRange(&to_range, toheap->bottom, toheap->top);
  assert(sysThread->LocalCursor == 0); 

  while (!(isEmptyGlobalStack()) && bytesCopied < bytesToCopy) {
    int i;
    SynchStart();
    fetchFromGlobalStack(sysThread->LocalStack, &(sysThread->LocalCursor), fetchSize);
    for (i=0; i < localWorkSize && sysThread->LocalCursor > 0; i++) {
      loc_t grayCell = (loc_t)(sysThread->LocalStack[--sysThread->LocalCursor]);
      int bytesScanned = scan1_object_coarseParallel_stack(grayCell,&to_alloc,&to_limit,toheap,&from_range,&to_range,sysThread);
      bytesCopied += bytesScanned;
    }
    SynchMid();
    moveToGlobalStack(sysThread->LocalStack, &(sysThread->LocalCursor));
    lastAndEmpty = SynchEnd();
  }
  if (to_alloc < to_limit)
    *to_alloc = SKIP_TAG | ((to_limit - to_alloc) << SKIPLEN_OFFSET);

  if (lastAndEmpty)
    CollectorOff(sysThread);
  flushStore();
}




static int GCTry_SemiConcHelp(SysThread_t *sysThread, int roundSize)
{
  mem_t tmp_alloc, tmp_limit;
  switch (GCStatus) {
    case GCOff: 
    case GCOn: 
       GetHeapArea(fromheap,roundSize,&tmp_alloc,&tmp_limit);
       break;
    case GCPendingOn: 
    case GCPendingOff: 
    default : 
       assert(0);
  }
  if (tmp_alloc) {
    sysThread->allocStart = tmp_alloc;
    sysThread->allocCursor = tmp_alloc;
    sysThread->allocLimit = tmp_limit;
    return 1;
  }
  else {
    return 0;
  }
}

static long numOn1 = 0;
static long numOn2 = 0;
static long numOn3 = 0;

static void CollectorOn(SysThread_t *sysThread)
{
  Thread_t *curThread = NULL;
  int isFirst;
  range_t from_range, to_range;
  mem_t to_alloc = 0, to_limit = 0;
  int rootCount = 0;

  if (diag)
    printf("Proc %d: CollectorOn\n", sysThread->stid); 

  switch (GCStatus) {
  case GCOff:                   /* Signalling to other processors that collector is turning on */
    GCStatus = GCPendingOn;
    StopAllThreads();
    break;
  case GCPendingOn: break;      /* Responding to signal that collector is turning on */
  case GCOn: assert(0);         /* Collector already on */
  case GCPendingOff: assert(0); /* Someone is turning the collector off while we are turning it on! */
  default: assert(0);
  }

  /* Get local ranges ready for use; check local stack empty; reset root lists */
  SetRange(&from_range, fromheap->bottom, fromheap->top);
  SetRange(&to_range, toheap->bottom, toheap->top);
  assert(sysThread->LocalCursor == 0);
  QueueClear(sysThread->root_lists);

  req_size = 0;
  ResetJob();
  isFirst = (synchBarrier(&numOn1, NumSysThread, &numOn3)) == 0;
  if (paranoid) {
    if (isFirst) {
      paranoid_check_all(fromheap, NULL, NULL, NULL);
      synchBarrier(&numOn1, NumSysThread+1, &numOn3);
    }
    else {
      while (!asynchCheckBarrier(&numOn1, NumSysThread+1, &numOn3))
	;
    }
  }
  if (isFirst) {
    int neededSize = (sizeof(val_t)) * (fromheap->top - fromheap->bottom);
    neededSize += neededSize / collectionRate;
    Heap_Resize(fromheap,neededSize);
    Heap_Unprotect(toheap); 
    Heap_Resize(toheap,neededSize);
    major_global_scan(sysThread);
  }
  while ((curThread = NextJob()) != NULL) {
    assert(curThread->requestInfo >= 0);
    FetchAndAdd(&req_size, curThread->requestInfo);
    local_root_scan(sysThread,curThread,fromheap);
  }

  /* Now forward all the roots which initializes the local work stacks */
  synchBarrier(&numOn2, NumSysThread, &numOn1);
  while (!QueueIsEmpty(sysThread->root_lists)) {
    /* Cannot dequeue from roots since this may be a global */
    Queue_t *roots = (Queue_t *) Dequeue(sysThread->root_lists);
    int i, len = QueueLength(roots);  
    for (i=0; i<len; i++) {
      ploc_t root = (ploc_t) QueueAccess(roots,i);
      ptr_t obj = *root;
      forward1_concurrent_stack(obj,&to_alloc,&to_limit,toheap,&from_range,sysThread);
      if (verbose)
	printf("GC %d: collector on %d root = %d   primary = %d, replica = %d\n",NumGC,++rootCount,root,obj,obj[-1]);
    }
  }

  if (to_alloc < to_limit)
    *to_alloc = SKIP_TAG | ((to_limit - to_alloc) << SKIPLEN_OFFSET);

  /* Move to global stack */
  SynchStart();
  SynchMid();
  moveToGlobalStack(sysThread->LocalStack, &(sysThread->LocalCursor));
  sysThread->LocalCursor = 0;
  SynchEnd();
  GCStatus = GCOn;
  synchBarrier(&numOn3, NumSysThread, &numOn2);
  flushStore();
}

int GCTry_SemiConc(SysThread_t *sysThread, Thread_t *th)
{
  int roundSize = RoundUp(th->requestInfo,pagesize);
  assert(sysThread->writelistCursor + 2 <= sysThread->writelistEnd);
  flushStore();

  switch (GCStatus) {
  case GCOff:
    if (GCTry_SemiConcHelp(sysThread,roundSize))
      return 1;
    CollectorOn(sysThread);
    do_work(sysThread,collectionRate * roundSize);
    if (GCTry_SemiConcHelp(sysThread,roundSize))
      return 1;
    printf("Concurrent collector fell too far behind just as it is activated - check parameters\n");
    assert(0);
    break;
  case GCPendingOn:
    CollectorOn(sysThread);
    do_work(sysThread,collectionRate * roundSize);
    if (GCTry_SemiConcHelp(sysThread,roundSize))
      return 1;
    printf("Concurrent collector fell too far behind while GC pending - check parameters\n");
    assert(0);
    break;
  case GCOn:
    do_work(sysThread,collectionRate * roundSize);
    if (GCTry_SemiConcHelp(sysThread,roundSize))
      return 1;
    printf("Concurrent collector fell too far behind with collector fully on - check parameters\n");
    assert(0);
    break;
  case GCPendingOff:
    do_work(sysThread,sizeof(val_t) * 
	    (fromheap->top - fromheap->bottom));    /* this is bounded by the size of objects allocated 
						       by all processors since CollectorOff is triggered */
    if (GCStatus == GCPendingOff)                                  /* do_work may trigger CollectorOff */
      CollectorOff(sysThread);
    return GCTry_SemiConc(sysThread, th);
  default: 
    assert(0);
  }
  assert(0);
}

void gc_poll_SemiConc(SysThread_t *sth)
{
  switch (GCStatus) {
  case GCOff:
    return;
  case GCPendingOn:
    CollectorOn(sth);
    return;
  case GCOn:
    do_work(sth,collectionRate * pagesize);  /* collect as though one page had been allocated */
    return;
  case GCPendingOff:
    CollectorOff(sth);
    return;
  }
}

void gc_init_SemiConc()
{
  init_int(&MaxHeap, 80 * 1024);
  init_int(&MinHeap, 256);
  if (MinHeap > MaxHeap)
    MinHeap = MaxHeap;
  init_double(&MinRatio, 0.1);
  init_double(&MaxRatio, 0.7);
  init_int(&MinRatioSize, 512);         
  init_int(&MaxRatioSize, 50 * 1024);
  fromheap = Heap_Alloc(MinHeap * 1024, MaxHeap * 1024);
  toheap = Heap_Alloc(MinHeap * 1024, MaxHeap * 1024);  
}

void gc_finish_SemiConc()
{
  Thread_t *th = getThread();
  int allocsize = (unsigned int) th->saveregs[ALLOCPTR] - (unsigned int) fromheap->alloc_start;
  gcstat_normal(allocsize,0,0);
}
