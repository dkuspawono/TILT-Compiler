/* Not thread-safe */

#include "general.h"
#include <sys/time.h>
#include <sys/resource.h>

#include "stack.h"
#include "thread.h"
#include "tag.h"
#include "queue.h"
#include "show.h"
#include "forward.h"
#include "gc.h"
#include "global.h"
#include "bitmap.h"
#include "stats.h"
#include "gcstat.h"


extern long TotalGenBytesCollected;
extern long TotalBytesAllocated;
extern int NumGC;
extern Queue_t *ScanQueue;
extern value_t MUTABLE_TABLE_BEGIN_VAL;
extern value_t MUTABLE_TABLE_END_VAL;
extern int module_count;

static Heap_t *fromheap = NULL, *toheap = NULL;
static Queue_t *global_roots = 0;
static Queue_t *promoted_global_roots = 0;


/* ------------------  Semispace array allocation routines ------------------- */

value_t alloc_bigwordarray_semi(int tagType, int word_len, value_t init_val, int ptag)
{
  Thread_t *curThread = getThread();
  long *saveregs = curThread->saveregs;
  value_t alloc_ptr = saveregs[ALLOCPTR_REG];
  value_t alloc_limit = saveregs[ALLOCLIMIT_REG];
  int tag = tagType | word_len << (2 + ARRLEN_OFFSET);

  int i;
  value_t *res = 0;

  /* Make sure there is enough space */
  if (alloc_ptr + (word_len + 1) >= alloc_limit)
    {
#ifdef DEBUG
      printf("DOING GC inside int_alloc with a semispace collector\n");
#endif
      saveregs[ALLOCLIMIT_REG] = 4 * (word_len + 1);
      gc_semi(curThread);
      alloc_ptr = saveregs[ALLOCPTR_REG];
      alloc_limit = saveregs[ALLOCLIMIT_REG];
    }
  assert(alloc_ptr + (word_len + 1) < alloc_limit);

  /* Perform actual allocation and initialization */
#ifdef HEAPPROFILE
  *(value_t *)alloc_ptr = 30006;
  alloc_ptr += 4;
#endif
  res = (value_t *)(alloc_ptr + 4);
  alloc_ptr += 4 * (word_len + 1);
  saveregs[ALLOCPTR_REG] = alloc_ptr;
  res[-1] = tag;
  for (i=0; i<word_len; i++)
    res[i] = init_val;

  /* Update statistics */
  TotalBytesAllocated += 4*(word_len+1);

  return (value_t) res;
}


value_t alloc_bigintarray_semi(int wordlen, value_t value, int ptag)
{
  return alloc_bigwordarray_semi(IARRAY_TAG, wordlen, value, ptag);
}

value_t alloc_bigptrarray_semi(int wordlen, value_t value, int ptag)
{
  return alloc_bigwordarray_semi(PARRAY_TAG, wordlen, value, ptag);
}

value_t alloc_bigfloatarray_semi(int log_len, double init_val, int ptag)
{
  double *rawstart = NULL;
  value_t *res = NULL;
  long i;
  Thread_t *curThread = getThread();
  long *saveregs = curThread->saveregs;
  int pos, tag = RARRAY_TAG | (log_len << (3 + ARRLEN_OFFSET));
  value_t alloc_ptr = saveregs[ALLOCPTR_REG];
  value_t alloc_limit = saveregs[ALLOCLIMIT_REG];

  /* Make sure there is enough space */
  if (alloc_ptr + 8 * (log_len + 3) >= alloc_limit)
    {
      long req_size = 8 * (log_len + 3);
#ifdef DEBUG
      printf("DOING GC inside float_alloc with a semispace collector\n");
#endif
      saveregs[ALLOCLIMIT_REG] = req_size;
      gc_semi(curThread);
      alloc_ptr = saveregs[ALLOCPTR_REG];
      alloc_limit = saveregs[ALLOCLIMIT_REG];
    }
  assert(alloc_ptr + 8 * (log_len + 3) <= alloc_limit);

  /* Perform alignment and write heap profile tag */
#ifdef HEAPPROFILE
  if (alloc_ptr % 8 != 0)
    { 
      *(value_t *)alloc_ptr = SKIP_TAG;
      alloc_ptr += 4;       
    }
  *(value_t *)alloc_ptr = 30010;
  alloc_ptr += 4;
#else
  if (alloc_ptr % 8 == 0)
    { 
      *(value_t *)alloc_ptr = SKIP_TAG;
      alloc_ptr += 4;
    }
#endif

  /* Allocate and initialize */
  res = (value_t *)(alloc_ptr + 4);
  assert ((value_t)res % 8 == 0);
  alloc_ptr = (((value_t) res) + (8 * log_len));
  saveregs[ALLOCPTR_REG] = alloc_ptr;
  res[-1] = RARRAY_TAG | (log_len << (3 + ARRLEN_OFFSET));
  for (i=0; i<log_len; i++)
    ((double *)res)[i] = init_val;

  return (value_t) res;
}




/* --------------------- Semispace collector --------------------- */


void gc_semi(Thread_t *curThread)
{
  long *saveregs;
  int i;  
  int req_size, allocptr;
  value_t *to_ptr = (value_t *)toheap->bottom;
  range_t from_range, to_range;
  Queue_t *root_lists, *loc_roots;

#ifdef SEMANTIC_GARBAGE
  assert(0); /* unimplemented */
#endif

  /* Start timing this collection */
  root_lists = curThread->root_lists;
  loc_roots = curThread->loc_roots;
  start_timer(&curThread->gctime);
  saveregs = curThread->saveregs;
  allocptr = saveregs[ALLOCPTR_REG];
  req_size = saveregs[ALLOCLIMIT_REG];


  /* Check for first time heap value needs to be initialized */
  if (curThread->saveregs[ALLOCLIMIT_REG] == StartHeapLimit)
    {
      curThread->saveregs[ALLOCPTR_REG] = fromheap->bottom;
      curThread->saveregs[ALLOCLIMIT_REG] = fromheap->top;
    }

#ifdef DEBUG
  if (req_size == 0)
      fprintf(stderr,"alloc_size = 0    means writelist_full.\n");
  debug_and_stat_before(saveregs, req_size);
#endif

  /* Check that alloc pointer has not passed the heap limit */
  if (allocptr > curThread->sysThread->limit)
    {
      printf("allocptr=%d   limit=%d\n",allocptr,curThread->sysThread->limit);
      assert(0);
    }

  /* Compute the roots from the stack and register set */
  local_root_scan(curThread);
  global_root_scan(global_roots,promoted_global_roots);
  Enqueue(root_lists,global_roots);
  Enqueue(root_lists,promoted_global_roots);

  /* Also add in the locative roots */
  QueueClear(loc_roots);
  for (i=0; i<QueueLength(ScanQueue); i++)
    {
      value_t first = (value_t) (QueueAccess(ScanQueue,i));
      value_t data_addr = *((value_t *)first);
      value_t data = *((value_t *)data_addr);
      if (data > 255)
	Enqueue(loc_roots,(int *)first);
      else
	{
	  int offset = ((255 - data) * sizeof(value_t));
	  int obj_start = data_addr - offset;
	  forward_minor((value_t *)(&obj_start),to_ptr,&from_range);
	  *((int *)first) = obj_start + offset;
	}
    }
  Enqueue(root_lists, loc_roots); 
  
    
  /* Get tospace and ranges ready for the collection */
  Heap_Resize(toheap,allocptr - fromheap->bottom);
  Heap_Unprotect(toheap);
  SetRange(&from_range, fromheap->bottom, fromheap->top);
  SetRange(&to_range, toheap->bottom, toheap->top);

#ifdef HEAPPROFILE
  gcstat_heapprofile_beforecollect((value_t *)fromheap->alloc_start,
				   (value_t *)allocptr);

#endif


  /* forward the roots */
  to_ptr = forward_root_lists_minor(root_lists, to_ptr, 
				    &from_range, &to_range);

  /* perform a Cheney scan */
  to_ptr = scan_nostop_minor(to_range.low,to_ptr,&from_range,&to_range);
  toheap->alloc_start = (value_t) to_ptr;

#ifdef HEAPPROFILE
  gcstat_heapprofile_aftercollect((value_t *)from_low,
				(value_t *)allocptr);

#endif

#ifdef DEBUG
    if (SHOW_HEAPS)
      {
	memdump("From Heap After collection:", (int *)fromheap->bottom,40);
        memdump("To Heap After collection:", (int *)toheap->bottom,40);
	show_heap("FINAL FROM",fromheap->bottom,allocptr,fromheap->top);
	show_heap("FINAL TO",toheap->bottom,to_ptr,toheap->top);
      }
#endif
#ifdef PARANOID
  paranoid_check_stack(curThread,fromheap);
  paranoid_check_heap(fromheap,toheap);
#endif

  /* Resize the tospace by using the oldspace size and liveness ratio */
    {
      long alloc = allocptr - fromheap->alloc_start;
      long old = allocptr - fromheap->bottom;
      long copied = ((value_t)to_ptr) - toheap->bottom;
      double oldratio = (double)(copied) / old;
      long cur = copied + req_size;
      long live = (cur > old) ? cur : old;
      long new = ComputeHeapSize(live, oldratio);
      if (new < cur)
	{
	  fprintf(stderr,"FATAL ERROR: failure reqesting %d bytes\n",req_size);
	  exit(-1);
	}

      gcstat_normal(alloc,old,oldratio,new,copied);

      Heap_Resize(toheap,new);
      Heap_Unprotect(toheap); 

    }
 
  /* Make sure that we actually fulfilled the GC request */
  if (toheap->top - (value_t)to_ptr <= req_size)
    {
      printf("Error condition: toheap->top - (value_t)to_ptr <= req_size\n");
      printf("                 %d - %d <= %d\n\n",
	     toheap->top, (value_t)to_ptr, req_size);
      assert(0);
      exit(-1);
    }

  /* Switch roles of from-space and tospace-space */
  Heap_Protect(fromheap);
  typed_swap(Heap_t *, fromheap, toheap);
  fromheap->alloc_start = fromheap->bottom;

  /* Update thread's allocation variables */
  saveregs[ALLOCPTR_REG] = fromheap->alloc_start;
  saveregs[ALLOCLIMIT_REG] = fromheap->top;
  curThread->sysThread->limit = fromheap->top;

  NumGC++;

  /* Stop timer for collection */
  stop_timer(&curThread->gctime);
}

#define INT_INIT(x,y) { if (x == 0) x = y; }
#define DOUBLE_INIT(x,y) { if (x == 0.0) x = y; }

void gc_init_semi()
{
  INT_INIT(MaxHeap, 32 * 1024);
  INT_INIT(MinHeap, 256);
  if (MinHeap > MaxHeap)
    MinHeap = MaxHeap;
  DOUBLE_INIT(TargetRatio, 0.08);
  DOUBLE_INIT(MaxRatio, 0.8);
  DOUBLE_INIT(UpperRatioReward, 1.5);
  DOUBLE_INIT(LowerRatioReward, 0.75);
  DOUBLE_INIT(TargetSize, 8192.0);
  DOUBLE_INIT(SizePenalty, 0.1);
  fromheap = Heap_Alloc(MinHeap * 1024, MaxHeap * 1024);
  toheap = Heap_Alloc(MinHeap * 1024, MaxHeap * 1024);  
  global_roots = QueueCreate(0,100);
  promoted_global_roots = QueueCreate(0,100);
}


void gc_finish_semi()
{
  Thread_t *th = getThread();
  int allocsize = th->saveregs[ALLOCPTR_REG] - fromheap->alloc_start;
  gcstat_finish(allocsize);
#ifdef HEAPPROFILE
  gcstat_heapprofile_beforecollect((value_t *)fromheap->alloc_start,
				   (value_t *)allocptr);
  gcstat_heapprofile_aftercollect((value_t *)fromheap->bottom,
				   (value_t *)allocptr);
  gcstat_show_heapprofile("full",0.0,0.0);
  printf("\n\n\n\n");
  gcstat_show_heapprofile("short",1.0,1.0);
#endif
}
