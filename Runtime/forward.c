#include "general.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <string.h>

#include "tag.h"
#include "queue.h"
#include "gc.h"
#include "memobj.h"
#include "thread.h"
#include "show.h"
#ifdef alpha_osf
#include <c_asm.h>
#endif

#include "global.h"
#include "stack.h"
#include "bitmap.h"
#include "stats.h"
#include "gcstat.h"
#include "general.h"
#include "forward.h"


/* General Comment:

   Using switch statements to dispatch on the "type" of objects causes gcc to "optimize"
   the code into a jump table.  The jump table turns out to be slower than a sequence of if-then-else 
   statements because 
   (1) Some cases are more common and we can order the if-then-else
   (2) Some cases can be collased together so there are not that many tests.
   (3) The jump defeats instruction prefetching.
*/


/* ---------------------------- CopyRange functions --------------------------------------- */
void SetCopyRange(CopyRange_t *copyRange, Proc_t *proc, Heap_t *heap, Set_t *rStack)
{
  if (copyRange->heap == heap)
    return;
  copyRange->proc = proc;
  copyRange->start = copyRange->cursor = copyRange->stop = copyRange->reserve = 0;
  copyRange->heap = heap;
}

void ClearCopyRange(CopyRange_t *copyRange)
{
  if (copyRange->start == NULL)
    return;
  PadHeapArea(copyRange->cursor, copyRange->stop);
  copyRange->start = copyRange->cursor = copyRange->stop = copyRange->reserve = NULL;
  copyRange->heap = NULL;
}

void AddGrayCopyRange(CopyRange_t *copyRange)
{
  assert(ordering == HybridOrder);
  if (copyRange->start < copyRange->cursor) {
    SetPush2(&copyRange->proc->work.grayRegion,copyRange->start,copyRange->cursor);
    copyRange->start = copyRange->cursor;
  }
}


mem_t AllocFromCopyRangeSlow(Proc_t *proc, int request, Align_t align)
{
  CopyRange_t *copyRange = &proc->copyRange;
  mem_t region;
  int alignedRequest = (align == NoWordAlign) ? request : 4 + request;
  int reserveArea = sizeof(val_t) * (copyRange->reserve - copyRange->cursor);

  /* First, add the current gray region */
  if (ordering == HybridOrder)
    AddGrayCopyRange(copyRange);

  /* Check reserve area first */
  if (0 && alignedRequest <= reserveArea) {
    int additional = Max(alignedRequest,copyCheckSize);
    additional = Min(additional,reserveArea);
    copyRange->stop = copyRange->cursor + additional / sizeof(val_t);
    assert(copyRange->stop <= copyRange->reserve);
    copyRange->cursor = AlignMemoryPointer(copyRange->cursor,align);
    region = copyRange->cursor;
    copyRange->cursor += (request / sizeof(val_t));
    return region;
  }

  /* Large object */
  if (alignedRequest >= copyChunkSize) {
    mem_t start, cursor, stop;
    GetHeapArea(copyRange->heap, alignedRequest, &start, &cursor, &stop);
    if (start == NULL) {
      printf("Error: AllocFromCopyRangeSlow failed to allocate %d bytes from heap\n", alignedRequest);
      printf("       GC = %d    GCStatus = %d    GCtype = %d\n", NumGC, GCStatus, GCType);
      assert(0);
    }
    cursor = AlignMemoryPointer(cursor,align);
    region = cursor;
    cursor += (request / sizeof(val_t));
    if (ordering == HybridOrder)   /* Gray region must be added separately for large object */
      SetPush2(&proc->work.grayRegion,region,cursor);
    PadHeapArea(cursor, stop);
    return region;
  }

  /* Allocate a new local pool */
  /*  Is it necessary to modify the memory for weird cache coherence protocols? 
      if (copyRange->cursor != NULL) 
      memset(copyRange->cursor, 1, sizeof(val_t) * (copyRange->stop - copyRange->cursor)); 
  */
  PadHeapArea(copyRange->cursor, copyRange->reserve);
  GetHeapArea(copyRange->heap, copyPageSize, &copyRange->start, &copyRange->cursor, &copyRange->reserve);
  assert(copyRange->start != NULL);
  copyRange->cursor = AlignMemoryPointer(copyRange->cursor,align);
  copyRange->stop = copyRange->reserve; 
  /*   copyRange->stop = copyRange->cursor + (Max(alignedRequest,copyCheckSize)) / sizeof(val_t);  */
  region = copyRange->cursor;
  copyRange->cursor += (request / sizeof(val_t));
  return region;

}

void  AllocEntireCopyRange(CopyRange_t *copyRange)    /* Allocate entire heap to copy range - for uniprocessors so space check is avoided */
{
  copyRange->start = copyRange->heap->cursor;
  copyRange->cursor = copyRange->heap->cursor;
  copyRange->stop = copyRange->heap->top;
  copyRange->reserve = copyRange->heap->top;
  copyRange->heap->cursor = copyRange->heap->top;
}

void  ReturnCopyRange(CopyRange_t *copyRange)         /* Return remainder of copy range to heap - copy range must reside contiguous to heap */
{
  assert(copyRange->heap != NULL);
  assert(copyRange->heap->cursor == copyRange->reserve);  /* Check for contiguity */
  copyRange->heap->cursor = copyRange->cursor;
  copyRange->reserve = copyRange->stop = copyRange->cursor;
}

int IsNullCopyRange(CopyRange_t *copyRange)
{
  return (copyRange->heap == NULL);
}

void PadCopyRange(CopyRange_t *copyRange)
{
  PadHeapArea(copyRange->cursor, copyRange->stop);
}

/* Returns object length including tag word in bytes */
unsigned long objectLength(ptr_t obj, mem_t *start)
{
  tag_t tag = getTag(obj);
  int type = GET_TYPE(tag);

  switch (type) {
    case RECORD_TYPE: {
      int numFields = GET_RECLEN(tag);
      assert (numFields != 0);  /* There should be no empty records */
      *start = obj - 1;
      return 4 * (1 + numFields);
    }
    case WORD_ARRAY_TYPE: 
    case QUAD_ARRAY_TYPE: 
    case PTR_ARRAY_TYPE:  
    case MIRROR_PTR_ARRAY_TYPE: { 
      int byteLen = GET_ANY_ARRAY_LEN(tag); 
      int dataWordLen = RoundUp(byteLen, 4);
      int numTags = 1 + (arraySegmentSize ? (byteLen > arraySegmentSize ? DivideUp(byteLen,arraySegmentSize) : 0) : 0);
      if (type != WORD_ARRAY_TYPE)
	assert(byteLen % 4 == 0);
      *start = obj - numTags;
      return 4 * numTags + dataWordLen;
    }
    case OTHER_TYPE:
       if (IS_SKIP_TAG(tag)) {
	 *start = obj;
	 return 4 * (GET_SKIPWORD(tag));
       }
    /* Fall-through */
    case FORWARD1_TYPE:
    case FORWARD2_TYPE: {
      mem_t tagstart = (mem_t) (obj - 1);
      printf("bad tag %d at %d\n",tag,tagstart);
      memdump("",tagstart-10,30,tagstart);
      printf("\n\n\n");
      printf("NumGC is %d\n",NumGC);
      assert(0);
    }
  } /* case */
}


/* ----------- Functions relating to copying an object or allocating space for a copy ------------------- */

INLINE(acquireOwnership)
tag_t acquireOwnership(Proc_t *proc, ptr_t white, tag_t tag)
     /* Tag is the the tag value when the caller checked.  It may have changed */
{

#ifdef alpha_osf
  int done = 0;
  while (!done) {
    /*    asm("ldl_l %0,-4(%1)" : "=i" (tag) : "i" (white)); */
    tag = asm("ldl_l %v0,-4(%a0)",white); 
    if (tag == STALL_TAG)
      done = 1;
    else 
      done |= asm("stl_c %a0,-4(%a1) ; mov %a0,%v0",STALL_TAG,white);
  }
  while (tag == STALL_TAG)
    tag = white[-1];
  return tag;
#endif

#ifdef sparc
  mem_t tagloc = white - 1;
  if (tag == STALL_TAG) {         /* Somebody grabbed it but did not finish forwarding */
    while (tag == STALL_TAG) {
      tag = white[-1];
      memBarrier();               /* Might need to refetch from memory */
    }
    assert(TAG_IS_FORWARD(tag));  /* Object forwarded by someone else now */
  }
  else {                          /* Try to be the copier */
    /* Example of a SPARC ld statement with gcc asm
       int *ptr;
       int val;
       asm("ld   [%1],%0" : "=r" (val) : "r" (ptr)); 
       
       The following tries to atomicaly swap in the stall tag by comparing with original tag.
       Note that registers that are input and output are specified twice with the input
       use referring to the output register.
    */
    val_t localStall = STALL_TAG;
    asm("cas [%2],%3,%0" : "=r" (localStall) : "0" (localStall), "r" (tagloc), "r" (tag)); 
    /* localStall == tag           : we are the copier
       localStall == STALL_TAG     : somebody else is the copier and was in the middle of its operation
       localStall == a forward ptr : somebody else is the copier and forwarded it already */
    if (localStall == tag)
      ;                             
    else if (localStall == STALL_TAG) {
      proc->numContention++;
      if (diag) 
	printf("Proc %d: contention copying object white = %d\n", proc->procid, white);
      while ((tag = white[-1]) == STALL_TAG)
	memBarrier();
      assert(TAG_IS_FORWARD(tag));
    }
    else if (TAG_IS_FORWARD(localStall))
      tag = localStall;
    else {
      printf("Proc %d: forward.c: Odd tag of %d from white obj %d with original tag = %d -----------\n", 
	     proc->procid, localStall, white, tag);
      assert(0);
    }
  }
  return tag;
#endif
}

/* Returns the copied/allocated version 
   (1) Check proc->bytesCopied to see if actually copied 
   (2) Check proc->needScan (in addition to bytesCopied) for non-zero to see if copied object might have pointer field
*/
INLINE(genericAlloc)
ptr_t genericAlloc(Proc_t *proc, ptr_t white, int doCopy, 
		   int doCopyCopy, int skipSpaceCheck, StackType_t stackType)
{
  ptr_t obj;                       /* forwarded object */
  tag_t tag = white[-1];           /* original tag */
  int type;

  /* assert(white < copyRange->start || white >= copyRange->stop); */

  /* If the objects has not been forwarded, atomically try commiting to be the copier.
     When we leave the block, we are the copier if "tag" is not a forwarding pointer. */
  if (TAG_IS_FORWARD(tag)) {
     ptr_t replica = (ptr_t) tag;
     fastAssert(replica != (ptr_t) replica[-1]); /* Make sure object is not self-forwarded */
     proc->numShared++;
     proc->bytesCopied = 0;
     return replica;
  }
  else {
    if (doCopyCopy && doCopyCopySync)  { /* We omit copy-copy sync for measuring the costs of the copy-copy sync */
      tag = acquireOwnership(proc, white, tag);
    }
  }

  proc->segUsage.objsCopied++;

  /* The tag must be restored only after the forwarding address is written */
  type = GET_TYPE(tag);
  if (type == RECORD_TYPE) {           /* As usual, the record case is the most common */
    int i, numFields = GET_RECLEN(tag);
    int objByteLen = 4 * (1 + numFields);
    mem_t region = allocFromCopyRange(proc, objByteLen, NoWordAlign, skipSpaceCheck);
    obj = region + 1;
    if (doCopy)
      for (i=0; i<numFields; i++) {    /* Copy fields */
	obj[i] = white[i];
      }
    else
      obj[0] = (val_t) white;          /* Install backpointer */
    obj[-1] = tag;                  /* Write tag last */
    white[-1] = (val_t) obj;        /* Store forwarding pointer last */
    /* Sparc TSO order guarantees forwarding pointer will be visible only after fields are visible */
    proc->numCopied++;
    proc->segUsage.fieldsCopied += numFields;
    proc->bytesCopied = objByteLen;
    proc->needScan = GET_RECMASK(tag);
    if (stackType == PrimarySet)
      SetPush(&proc->work.objs, white);
    else if (stackType == ReplicaSet)
      SetPush(&proc->work.objs, obj);
    return obj;
  }
  else if (TYPE_IS_FORWARD(type)) {
    ptr_t replica = (ptr_t) tag;
    fastAssert(replica != (ptr_t) replica[-1]); /* Make sure object is not self-forwarded */
    proc->numShared++;
    proc->bytesCopied = 0;
    return replica;
  }
  else if (TYPE_IS_ARRAY(type)) {
    int i, arrayByteLen = GET_ANY_ARRAY_LEN(tag);
    int dataByteLen = RoundUp(arrayByteLen, 4);
    int numTags = 1 + ((arraySegmentSize > 0) ? 
		       (arrayByteLen > arraySegmentSize ? DivideUp(arrayByteLen,arraySegmentSize) : 0) : 0);
    int objByteLen = dataByteLen + 4 * numTags;
    Align_t align = (type == QUAD_ARRAY_TYPE) ? ((numTags & 1) ? OddWordAlign : EvenWordAlign) : NoWordAlign;
    mem_t region = allocFromCopyRange(proc, objByteLen, align, skipSpaceCheck);
    obj = region + numTags;
    if (type != WORD_ARRAY_TYPE)
      assert(arrayByteLen % 4 == 0);
    if (doCopy)
      memcpy((char *) obj, (const char *)white, objByteLen - 4);
    else {
      if (dataByteLen > 0)       /* Empty arrays don't have backpointers */
	obj[0] = (val_t) white;  /* Install backpointer */
    }
    for (i=0; i<numTags-1; i++)
      obj[-2-i] = SEGPROCEED_TAG;
    obj[-1] = tag;	
    white[-1] = (val_t) obj;
    proc->numCopied++;
    proc->segUsage.fieldsCopied += objByteLen / 2;
    proc->bytesCopied = objByteLen;
    proc->needScan = (type == PTR_ARRAY_TYPE || type == MIRROR_PTR_ARRAY_TYPE);
    if (stackType == PrimarySet)
      SetPush(&proc->work.objs, white);
    else if (stackType == ReplicaSet)
      SetPush(&proc->work.objs, obj);
    return obj;
  }

  printf("\n\nError in genericAlloc: bad tag value %d of white object %d\n",tag, white);
  memdump("", white - 8, 16, white - 1);

  assert(0);
}

ptr_t copy(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 0, 0, NoSet);
}

ptr_t alloc(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 0, 0, 0, NoSet);
}

ptr_t alloc_primarySet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 0, 0, 0, PrimarySet);
}

ptr_t copy_noSpaceCheck(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 0, 1, NoSet);
}

ptr_t copy_noSpaceCheck_replicaSet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 0, 1, ReplicaSet);
}

ptr_t copy_replicaSet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 0, 0, ReplicaSet);
}


ptr_t copy_copyCopySync(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 1, 0, NoSet);
}

ptr_t copy_copyCopySync_primarySet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 1, 0, PrimarySet);
}

ptr_t copy_copyCopySync_replicaSet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 1, 0, ReplicaSet);
}

ptr_t copy_noSpaceCheck_copyCopySync(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 1, 1, NoSet);
}

ptr_t copy_noSpaceCheck_copyCopySync_replicaSet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 1, 1, 1, ReplicaSet);
}

ptr_t alloc_copyCopySync(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 0, 1, 0, NoSet);
}


ptr_t alloc_copyCopySync_primarySet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 0, 1, 0, PrimarySet);
}

ptr_t alloc_copyCopySync_replicaSet(Proc_t *proc, ptr_t white)
{
  return genericAlloc(proc, white, 0, 1, 0, ReplicaSet);
}

/* ------------------------------------------------------- */
/* -------------- Exported functions --------------------- */
/* ------------------------------------------------------- */

int empty_writelist(Proc_t *proc)
{
  return (proc->writelistCursor == proc->writelistStart);
}

/* (1) Add global roots.
   (2) If from and to are not NULL, add the locations of all pointer arrays containing back pointers 
*/
void process_writelist(Proc_t *proc, Heap_t *from, Heap_t *to)
{
  ploc_t curLoc = proc->writelistStart;
  ploc_t end = proc->writelistCursor;

  procChangeState(proc, GCWrite, 800);
  proc->numWrite += (proc->writelistCursor - proc->writelistStart) / 3;
  proc->writelistCursor = proc->writelistStart;
  if (curLoc < end) 
    proc->segmentType |= MinorWork;

  while (curLoc < end) {
    /* Each writelist entry has 3 values */
    ptr_t obj = (ptr_t) (*(curLoc++)), data;
    int byteOffset = (int) (*(curLoc++));  
    ptr_t possPrevPtrVal = (ptr_t) (*(curLoc++));  /* We ignore this value for non-concurrent collectors */
    tag_t tag = getTag(obj);
    int type = GET_TYPE(tag);
    ploc_t field;

    if (IsGlobalData(obj)) {
      add_global_root(proc,obj);
      continue;
    }
    if (from == NULL)
      continue;
    if (type == WORD_ARRAY_TYPE || type == QUAD_ARRAY_TYPE)
      continue;
    else if (type == PTR_ARRAY_TYPE || type == MIRROR_PTR_ARRAY_TYPE)
      ;
    else {
      printf("Error in process_writelist: obj = %d   tag = %d   type = %d\n", obj, tag, type);
      assert(0);
    }
    field  = (ploc_t) (obj + byteOffset / sizeof(val_t));
    data = *field;
    if (NotInRange(data,&to->range)) {
      SetPush(&proc->work.roots, (ptr_t) field);
    }
  }
}

