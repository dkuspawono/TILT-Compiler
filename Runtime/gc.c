/* Not thread-safe */
#include "general.h"
#include <sys/time.h>
#include <sys/resource.h>

#include "tag.h"
#include "queue.h"
#include "forward.h"
#include "gc.h"
#include "memobj.h"
#include "thread.h"
#include "global.h"
#include "stack.h"
#include "bitmap.h"
#include "stats.h"
#include "gcstat.h"
#include "show.h"

/* XXX for temp debugging */
extern int NumThread;


/* use generational by default */
int paranoid = 0;
int verbose = 0;
int diag = 0;
int collector_type = Generational;
int SHOW_GCDEBUG_FORWARD = 0;
int SHOW_GCERROR   = 1;
int SHOW_GCSTATS   = 0;
int SHOW_GCDEBUG   = 0;
int SHOW_HEAPS     = 0;
int SHOW_GCFORWARD = 0;

#ifdef HEAPPROFILE
int HeapProfileFlag = 0;
#define HP_AGESHIFT 16
#endif

#ifdef WRITE
Heap_t *writelist_obj = NULL;
value_t writelist_cursor = 0;
value_t writelist_start = 0;
value_t writelist_end = 0;
value_t write_count = 0;
#endif

int NumGC = 0;
int NumMajorGC = 0;
int NumLocatives = 0;
int NumRoots = 0;

#ifdef HEAPPROFILE
Object_Profile_t allocated_object_profile;
Object_Profile_t collected_object_profile;
#endif


extern int module_count;
extern value_t GLOBALS_BEGIN_VAL;
extern value_t GLOBALS_END_VAL;

static range_t null_range;


int YoungHeapByte = 0, MaxHeap = 0, MinHeap = 0;
double TargetRatio = 0.0, MaxRatio = 0.0;
double UpperRatioReward = 0.0, LowerRatioReward = 0.0;
double TargetSize = 0.0, SizePenalty = 0.0;

long ComputeHeapSize(long oldsize, double oldratio)
{
  double res = 0.0;
  double diff_ratio = (oldratio - TargetRatio) / TargetRatio;
  double diff_size  = (oldsize - 1024 * TargetSize) / (double) (1024 * TargetSize);
  double where = oldsize / (1024.0 * MaxHeap);
  double RatioReward = UpperRatioReward * (1 - where) + LowerRatioReward * where;
  double k_ratio = (diff_ratio < 0.0) ? 1.0 : (1.0 + diff_ratio * RatioReward);
  double k_size  = (diff_size < 0.0) ? 1.0 : (1.0 + diff_size * SizePenalty);
  if (k_size > 2.0)
    k_size = 2.0;
  res = oldsize * k_ratio / k_size;
  if (res < ((oldratio / MaxRatio) * oldsize))
      res = ((oldratio / MaxRatio) * oldsize);
  if (res >= 2.5 * oldsize)
    res = 2.5 * oldsize;
  if (res < 1024 * MinHeap)
    res = 1024 * MinHeap;
  if (res > (1024 * MaxHeap))
    res = 1024 * MaxHeap;
  
  if (!(res >= (long)(oldsize * oldratio)))
    {
      assert(0);
    }
  return ((long)res) / 4 * 4;
}



void debug_and_stat_before(unsigned long *saveregs, long req_size)
{

  Thread_t *curThread = getThread();
  long sp = saveregs[SP];
#ifdef solaris
  long ret_add = saveregs[LINK] + 8;
#else
  long ret_add = saveregs[RA];
#endif

  /* -------- print some debugging info and gather write statistics ---------- */
  int i;
  int allocptr = saveregs[ALLOCPTR];
  int limitptr = saveregs[ALLOCLIMIT];
  write_count += (writelist_cursor - writelist_start) / sizeof(int);

  if (req_size == 0)
    {
      fprintf(stderr,"req_size = 0    means writelist_full.\n");
    }
#ifdef DEBUG
  if (SHOW_GCDEBUG && NumGC > LEAST_GC_TO_CHECK)
    {
      printf("\n\n");
      printf("--------gc_handler entered---------\n");
      printf("ret_add = %d   *ret_add = %d\n",ret_add,*((int *)ret_add));
      printf("alloc/limit: %d %d\n",allocptr,limitptr);
      printf("sp of first ML frame is %ld\n",sp);
      printf("REGISTERS SAVED AT: %ld\n",saveregs);
      printf("\n\n");
      for (i=0; i<32; i++)
	{
	  printf("%2d - *%d: %10ld",i,&(saveregs[i]),saveregs[i]);
	  if (i == ALLOCPTR)
	    printf("    allocptr");
	  if (i == ALLOCLIMIT)
	    printf("    alloclimit");
	  printf("\n");
	}
      printf("-----------------------------------\n");
    }
#endif
}



#ifdef SEMANTIC_GARBAGE
void update_lifetime(value_t *from, value_t *to, value_t sz)
{
  extern value_t semantic_garbage_offset;
  int curstamp = *((value_t *)(((value_t)from) + semantic_garbage_offset));
  int used = 0, i;
  assert((*from) == FORWARD_TAG);
  for (i=1; i<=sz; i++)
    {
      int temp = *(int *)(((value_t)(from + i)) + semantic_garbage_offset);
      if (temp == 0)
	{ 
	  used = 1; 
	  break; 
	}
    }

  for (i=1; i<=sz; i++)
     *(int *)(((value_t)(to + i)) + semantic_garbage_offset) = 98765;
  if ((value_t)from >= fromheap->bottom && (value_t)from < fromheap->top)
    if ((value_t)to >= old_toheap->bottom && (value_t)to < old_toheap->top)
      curstamp = NumMajorGC;
    else
      curstamp = NumMajorGC-1;
  else if (used)
    curstamp = NumMajorGC;
  *((value_t *)(((value_t)to) + semantic_garbage_offset)) = curstamp;
}
#endif





void gc_init(void)
{
  /* ??? 64 does not work for MaxHeap for some reason */
  int writelist_size = 0;
#ifdef HEAPPROFILE
  object_profile_init(&allocated_object_profile);
  object_profile_init(&collected_object_profile);
#endif
  SetRange(&null_range,0,0);
  switch (collector_type) 
    {
      case Semispace :
	{
	  gc_init_semi();
	  writelist_size = (MinHeap*1024/2);
	  break;
	}
      case Generational :
	{ 
	  gc_init_gen();
	  writelist_size = (YoungHeapByte/2);
	  break;
	}
      case Parallel:
	{
	  gc_init_para();
	  writelist_size = (MinHeap*1024/2);
	  break;
	}
      }
#ifdef WRITE
  {
    writelist_obj = Heap_Alloc(writelist_size,writelist_size);
#ifdef DEBUG
    printf("YoungHeapByte = %d\n",YoungHeapByte);
    printf("writelist_obj->bottom = %d\n",writelist_obj->bottom);
    printf("writelist_obj->top = %d\n",writelist_obj->top);
#endif
    writelist_start = (int)(writelist_obj -> bottom);
    /* leave room to write the terminating zero and also permit
       that the invariant writelist_cursor <= writelist_end is what is needed*/ 
    writelist_end = ((int)(writelist_obj -> top)) - sizeof(int);
    writelist_cursor = writelist_start;
  }
#endif
}


void paranoid_check_stack(Thread_t *thread, Heap_t *fromspace)
{
    int count = 0, mi, i;
    long *saveregs = thread->saveregs;
    long sp = saveregs[SP];
    value_t stack_top = thread->stackchain->stacks[0]->top;
    /* should check start_addr */
    if (saveregs[ALLOCLIMIT] == StopHeapLimit)
      return;
    for (i=0; i<thread->numThunk; i++) { /* check thunks */
      value_t thunk = thread->thunks[i];
      if (thunk >= fromspace->bottom && thunk < fromspace->top) {
	printf("TRACE ERROR*: thunk has from-space value after collection: %d", thunk);
	assert(0);
      }
    }
      
    if (thread->nextThunk == 0) /* thunk not started */
      return;
    for (count = 0; count < 32; count++)
      {
	int data = saveregs[count];
	if (count == ALLOCPTR) {
	  if (verbose)
	    printf("Allocation Register %d has value %d\n", count, data);
	}
	else if (count == ALLOCLIMIT) {
	  if (verbose)
	    printf("Allocation Limit Register %d has value %d\n", count, data);
	}
	else if ((data & 3) == 0 && data >= fromspace->bottom && data < fromspace->top)
	  {
	    static int newval = 62000;
	    if (verbose) {
	      printf("TRACE WARNING: register %d has from space value %d",
		     count,data);
	      printf("      changing to %d\n", newval);
	    }
	    saveregs[count] = newval; 
	    newval++;
	  }
	else if (verbose)
	  printf("Register %d has okay value %d\n", count, data);
      }

    for (count = sp; count < stack_top - 64; count += 4)
      {
	int *data_add = (int *)count;
	int data = *data_add; 
	if ((data & 3) == 0 && data >= fromspace->bottom && data < fromspace->top)
	  {
	    static int newval = 42000;
	    if (verbose) {
	      printf("TRACE WARNING: stack loc %d has from space value %d",
		     data_add,data);
	      printf("      changing to %d\n", newval);
	    }
	    *data_add = newval; 
	    newval++;
	  }
      }

}


void paranoid_check_heap_global(Heap_t *curSpace)
{
    int count = 0, mi, i;
    scan_heap("Paranoid check heap",curSpace->bottom, curSpace->alloc_start, 
	      curSpace->top, curSpace, SHOW_HEAPS);
    /* check globals */
    for (mi=0; mi<module_count; mi++) {
      value_t start = (&GLOBALS_BEGIN_VAL)[mi];
      value_t stop = (&GLOBALS_END_VAL)[mi];
      scan_heap("Paranoid check global",start,stop,stop, curSpace, SHOW_HEAPS);
    }
}


void measure_semantic_garbage_after()
{
#ifdef SEMANTIC_GARBAGE
    /* from/to heap has been swapped at this point */
    extern long SemanticGarbageSize;
    if (GCtype == Major)
      scandead_heap("OLD_FROMHEAP",old_toheap->bottom,old_toheap->alloc_start,
		  old_toheap->top); 
    printf("\nSEMANTIC GARBAGE: GC,MajorGC = %d,%d    garb/copied = %d %d\n",
	 NumGC,NumMajorGC,SemanticGarbageSize,TotalBytesCollected);
#endif
}

void measure_semantic_garbage_before()
{  
#ifdef SEMANTIC_GARBAGE
  /* ---------- Old code to measure "semantic garbage" --------------- */
    extern value_t semantic_garbage_offset;
    int count = 0;
    value_t *i, *start, *end;
    printf("SEMANTIC GARBAGE: about to scan\n");

    start = (value_t *)(fromheap->bottom + semantic_garbage_offset);
    end = (value_t *)(fromheap->top + semantic_garbage_offset);
    for (i=start; i<end; i++)
      if (*i == 0) count++;
    printf("SEMANTIC GARBAGE: %d words were accessed in the fromheap area\n",count);

    count = 0;
    start = (value_t *)(old_fromheap->bottom + semantic_garbage_offset);
    end = (value_t *)(old_fromheap->top + semantic_garbage_offset);
    for (i=start; i<end; i++)
      if (*i == 0) count++;
    printf("SEMANTIC GARBAGE: %d words were accessed in the old_fromheap area\n",count);
#endif
}




void debug_after_collect(Heap_t *fromheap, Heap_t* old_fromheap)
{
#ifdef DEBUG
      value_t a = fromheap->bottom, b = fromheap->top;
      /*      gc_sanity_stackreg_check(saveregs,fromheap,(int *) sp, (int *)stack->top); */
      if (SHOW_HEAPS)
	show_heap("FINAL FROM",fromheap->bottom,fromheap->alloc_start,fromheap->top);
      fromheap->bottom = 0;
      fromheap->top = 0;
      if (SHOW_HEAPS)
	show_heap("OLD_FROMHEAP",old_fromheap->bottom,old_fromheap->alloc_start,
		 old_fromheap->top); 
      else
	check_heap("OLD_FROMHEAP",old_fromheap->bottom,old_fromheap->alloc_start,
		   old_fromheap->top); 
      fromheap->bottom = a;
      fromheap->top = b;
#endif
}



/* ------------------------------ Interface Routines -------------------- */
value_t alloc_bigintarray(int wordlen, value_t value, int ptag)
{  
  switch (collector_type) 
    {
    case Semispace :    { return alloc_bigintarray_semi(wordlen,value,ptag); }
    case Generational : { return alloc_bigintarray_gen (wordlen,value,ptag); }
    case Parallel :     { return alloc_bigintarray_para(wordlen,value,ptag); }
    }
}

value_t alloc_bigptrarray(int wordlen, value_t value, int ptag)
{  
  switch (collector_type) 
    {
    case Semispace :    { return alloc_bigptrarray_semi(wordlen,value,ptag); }
    case Generational : { return alloc_bigptrarray_gen (wordlen,value,ptag); }
    case Parallel :     { return alloc_bigptrarray_para(wordlen,value,ptag); }
    }
}

value_t alloc_bigfloatarray(int loglen, double value, int ptag)
{  
  switch (collector_type) 
    {
    case Semispace :    { return alloc_bigfloatarray_semi(loglen,value,ptag); }
    case Generational : { return alloc_bigfloatarray_gen (loglen,value,ptag); }
    case Parallel :     { return alloc_bigfloatarray_para(loglen,value,ptag); }
    }
}

void poll()
{
  if (collector_type == Parallel)
    poll_para();
  return;
}


void gc(Thread_t *curThread)
{
  SysThread_t *self = getSysThread();

  if (curThread != NULL) {
    /* Called from gc_raw; need to unmap first */ 
    SysThread_t *sth = curThread->sysThread;
    assert(self == sth);
    assert(sth->userThread == curThread);
    if (curThread->request < 0 ||
	curThread->request >= 8192) {
      fprintf(stderr,"GC request too big or negative: %d\n", curThread->request);
      assert(0);
    }
    ReleaseJob(sth);
  }

  assert((self->stack - (int) (&self)) < 1024); /* Check that we are running on own stack */

  /* If thread preempted, not a real GC */
  if ((curThread != NULL) && 
      (curThread->saveregs[ALLOCLIMIT] == StopHeapLimit)) {
      scheduler(self);
      assert(0);
    }

  switch (collector_type) 
    {
    case Semispace : 
      assert(curThread != NULL);
      gc_semi(curThread); 
      scheduler(self);
      assert(0);
      break; 
    case Generational : 
      assert(curThread != NULL);
      gc_gen(curThread,0);
      scheduler(self); 
      assert(0);
      break; 
    case Parallel :     
      gc_para(self); /* Does not return */
      break; 
    }
  assert(0);
}

  
void gc_finish()
{
  switch (collector_type) 
    {
    case Semispace : { gc_finish_semi(); break; }
    case Generational : { gc_finish_gen(); break; }
    case Parallel : { gc_finish_para(); break; }
    }
}
