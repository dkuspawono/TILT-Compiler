#include "tag.h"
#include "memobj.h"
#include "bitmap.h"
#include <limits.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <assert.h>
#include <stdio.h>
#include <errno.h>
#include <strings.h>
#include "general.h"
#include "til-signal.h"
#include <fcntl.h>
#include "stats.h"
#include "thread.h"
#include "platform.h"

Stacklet_t   *Stacklets; 
StackChain_t *StackChains;
Heap_t       *Heaps;

int NumHeap       = 20;
int NumStackChain = 200;  /* 2 * NumThread */
int NumStacklet   = 200;  /* NumStackChain */
int NumStackletPerChain = 10;	/* Initial size of a chain's stacklet array.  */


mem_t StopHeapLimit  = (mem_t) 1; /* A user thread heap limit used to indicates that it has been interrupted */
mem_t StartHeapLimit = (mem_t) 2; /* A user thread heap limit used to indicates that it has not been given space */

/* Sizes measured in Kb */
int MLStackletSize = 128;        /* Normal area available to ML */
int CStackletSize = 32;          /* Extra area made available when calling C */
int GuardStackletSize;           /* Guard page at bottom */
int primaryStackletOffset, replicaStackletOffset, stackletOffset;

static const int kilobyte  = 1024;

void* my_malloc(size_t size)
{
  void* mem = malloc(size);
  if (mem == NULL) {
    fprintf(stderr, "malloc %u failed with %d (%s)\n", (unsigned)size,errno,strerror(errno));
    assert(0);
  }
  return mem;
}

void* my_realloc(void* src, size_t size)
{
  void* mem = realloc(src, size);
  if (mem == NULL && size != 0) {
    fprintf(stderr, "realloc %u failed with %d (%s)\n", (unsigned)size,errno,strerror(errno));
    assert(0);
  }
  return mem;
}


void my_mprotect(int which, caddr_t bottom, int size, int perm)
{
  int status = mprotect(bottom, size, perm);
  if (status) {
    fprintf (stderr, "mprotect %d failed (%d,%d,%d) with %d\n",which,bottom,size,perm,errno);
    assert(0);
  }
}


mem_t my_mmap(int size, int prot)
{
  caddr_t start = NULL;
  static int fd = -1;
  int flags;
  mem_t mapped;
#ifdef solaris
  {
    if (fd == -1)
      if ((fd = open("/dev/zero", O_RDWR)) == -1) {
	fprintf (stderr, "unable to open /dev/zero, errno = %d\n", errno);
	exit(-1);
      }
    flags = MAP_PRIVATE;
  }
#else
  flags = MAP_ANONYMOUS;
#endif
  mapped = (mem_t) mmap(start, size, prot, flags, fd, 0);
  if (mapped == (mem_t) -1) {
    fprintf(stderr,"mmap failed with size = %d: %s\n", size, strerror(errno));
    assert(0);
  }
  if (diag)
    fprintf(stderr,"mmap succeeded with mapped = %x, size = %d, prot = %d\n",
	    mapped, size, prot);
  return mapped;
}


void StackInitialize(void)
{
  int i;
  Stacklets = (Stacklet_t *)my_malloc(sizeof(Stacklet_t) * NumStacklet);
  for (i=0; i<NumStacklet; i++) {
    Stacklets[i].count = 0;
    Stacklets[i].mapped = 0;
  }
  StackChains = (StackChain_t *)my_malloc(sizeof(StackChain_t) * NumStackChain);
  for (i=0; i<NumStackChain; i++) {
    StackChains[i].used = 0;
    StackChains[i].thread = NULL;
    StackChains[i].avail = 0;
    StackChains[i].stacklets = NULL;
  }
}

void Stacklet_Dealloc(Stacklet_t *stacklet)
{
  assert(stacklet->count > 0);
  if (stacklet->count == 1)
    stacklet->parent = NULL;
  stacklet->count--;
}

void Stacklet_KillReplica(Stacklet_t *stacklet)
{
  assert(stacklet->count > 0);
  if (stacklet->state == Pending)
    Stacklet_Copy(stacklet);
  while (stacklet->state == Copying)
    ;
  CompareAndSwap((int*) &stacklet->state, InactiveCopied, ActiveCopied);
  assert(stacklet->state == Inconsistent ||
	 stacklet->state == ActiveCopied);
}

static Stacklet_t* Stacklet_Alloc(StackChain_t *stackChain)
{
  int i;
  Stacklet_t *res = NULL;
  /* Each stacklet contains the primary and replica.  Each one starts with a guard page, a C area, and then an ML area. */
  int size = (GuardStackletSize + MLStackletSize + CStackletSize) * kilobyte;  /* for just one of the two: primary and replica */

  assert(stackletOffset == size);
  for (i=0; i<NumStacklet; i++)
    if (CompareAndSwap(&Stacklets[i].count, 0, 1) == 0) {
      res = &Stacklets[i];
      break;
    }
  if (res == NULL) {
    Thread_t* thread = (Thread_t*)stackChain->thread;
    volatile Proc_t* proc = (thread ? thread->proc : NULL);
    if(thread && proc)
      fprintf(stderr,"Proc %d: thread %d: out of stack space\n",
	      proc->procid, thread->tid);
    else
      fprintf(stderr,"out of stack space\n");
    abort();
  }

  res->parent = stackChain;
  res->state = Inconsistent;
  if (!res->mapped) {
    mem_t start = my_mmap(2 * size, PROT_READ | PROT_WRITE);
    mem_t middle = start + size / (sizeof (val_t));
    mem_t end = start + 2 * size / (sizeof (val_t));

    res->baseExtendedBottom = start + (GuardStackletSize * kilobyte) / (sizeof (val_t));
    res->baseBottom         = res->baseExtendedBottom + (CStackletSize * kilobyte) / (sizeof (val_t));
    res->baseTop            = res->baseBottom + (MLStackletSize * kilobyte) / (sizeof (val_t));
    assert(res->baseTop == middle);
    res->baseTop            -= (128 / sizeof(val_t));     /* Get some initial room in multiples of 64 bytes; 
				   		                   Sparc requires at least 68 byte for the save area */
    my_mprotect(0, (caddr_t) start,  GuardStackletSize * kilobyte, PROT_NONE);  /* Guard page at bottom of primary */
    my_mprotect(1, (caddr_t) middle, GuardStackletSize * kilobyte, PROT_NONE);  /* Guard page at bottom of replica */

    res->callinfoStack = SetCreate(size / (32 * sizeof (val_t)));
    res->mapped = 1;
  }
  res->baseCursor = res->baseTop;
  for (i=0; i<32; i++)
    res->bottomBaseRegs[i] = 0;
  SetReset(res->callinfoStack);
  return res;
}

int StackletId(Stacklet_t* stacklet)
{
  return (int)(stacklet - Stacklets);
}

mem_t StackletPrimaryTop(Stacklet_t *stacklet)
{
  return stacklet->baseTop + (primaryStackletOffset / sizeof(val_t));
}

mem_t StackletPrimaryCursor(Stacklet_t *stacklet)
{
  return stacklet->baseCursor + (primaryStackletOffset / sizeof(val_t));
}


mem_t StackletPrimaryBottom(Stacklet_t *stacklet)
{
  return stacklet->baseBottom + (primaryStackletOffset / sizeof(val_t));
}

Stacklet_t *NewStacklet(StackChain_t *stackChain)
{
  int i;
  Stacklet_t *newStacklet = Stacklet_Alloc(stackChain);
  if (stackChain->cursor + 1 == stackChain->avail) {
    int avail = stackChain->avail * 2;
    assert(avail > 0);
    stackChain->stacklets = (Stacklet_t**) my_realloc(stackChain->stacklets, sizeof(Stacklet_t*) * avail);
    for (i=stackChain->avail; i < avail; i++) {
      stackChain->stacklets[i] = NULL;
    }
    stackChain->avail = avail;
  }
  stackChain->stacklets[stackChain->cursor++] = newStacklet;
  for (i=0; i<stackChain->cursor; i++) 
    assert(stackChain->stacklets[i]->count > 0);
  return newStacklet;
}

int badcode(Stacklet_t *stacklet)
{
  StackletState_t state;

  state = CompareAndSwap((int*) &stacklet->state, Pending, Copying);
  if (state == Pending) {
    return 1;
  }
  while (stacklet->state == Copying)
    ;
  return 0;
}

/* Copy primary into replica */
int Stacklet_Copy(Stacklet_t *stacklet)
{
  StackletState_t state;

  state = CompareAndSwap((int*) &stacklet->state, Pending, Copying);
  if (state == Pending) {
    int i;
    int activeSize = (stacklet->baseTop - stacklet->baseCursor) * sizeof(val_t);
    mem_t primaryBottom = stacklet->baseBottom + (primaryStackletOffset / sizeof(val_t));
    mem_t replicaBottom = stacklet->baseBottom + (replicaStackletOffset / sizeof(val_t));
    mem_t primaryCursor = stacklet->baseCursor + (primaryStackletOffset / sizeof(val_t));
    mem_t replicaCursor = stacklet->baseCursor + (replicaStackletOffset / sizeof(val_t));
    volatile reg_t* primaryRegs = &stacklet->bottomBaseRegs[primaryStackletOffset == 0 ? 0 : 32];
    volatile reg_t* replicaRegs = &stacklet->bottomBaseRegs[primaryStackletOffset == 0 ? 32 : 0];
    assert(stacklet->count > 0);
    assert(stacklet->baseExtendedBottom <= stacklet->baseCursor);
    assert(stacklet->baseCursor <= stacklet->baseTop);
    SetReset(stacklet->callinfoStack);
    stacklet->replicaCursor = stacklet->baseCursor;
    stacklet->replicaRetadd = stacklet->retadd;
    memcpy(replicaCursor, primaryCursor, activeSize);
    for (i=0; i<32; i++) 
      replicaRegs[i] = primaryRegs[i];
    stacklet->state = InactiveCopied;
    return 1;
  }
  while (stacklet->state == Copying)
    ;
  assert(stacklet->state != Inconsistent);
  assert(stacklet->state != Pending);
  return 0;
}


/* Given the new sp, establish the most recent stacklet.
   Return the most recent stacklet.
*/
Stacklet_t *EstablishStacklet(StackChain_t *stackChain, mem_t sp)
{
  int i,active;
  mem_t sp_base = sp - primaryStackletOffset / sizeof(val_t);
  for (active=stackChain->cursor-1; active>=0; active--) {
    Stacklet_t *stacklet = stackChain->stacklets[active];
    if (stacklet->baseExtendedBottom <= sp_base && 
	sp_base <= stacklet->baseTop) { 
      stacklet->baseCursor = sp_base;
      break;
    }
  }
  if (active < 0) {
    printf("EstablishStacklet failed for sp = %d  sp_base = %d",sp, sp_base);
    for (i=0; i < stackChain->cursor; i++) {
      Stacklet_t *stacklet = stackChain->stacklets[i];
      printf("Stacklet %d: %d to %d\n",
	     stacklet->baseExtendedBottom, stacklet->baseTop);
    } 
    assert(active>=0);
  }
  for (i=active+1; i<stackChain->cursor; i++) {
    Stacklet_Dealloc(stackChain->stacklets[i]);
    stackChain->stacklets[i] = NULL;
  }
  stackChain->cursor = active + 1;
  return stackChain->stacklets[active]; 
}

/* Deallocate most recent stacklet - at least one active must remain */
void PopStacklet(StackChain_t *stackChain)
{
  int active = stackChain->cursor - 1;
  Stacklet_Dealloc(stackChain->stacklets[active]);
  stackChain->stacklets[active] = NULL;
  stackChain->cursor--;
  assert(stackChain->cursor >= 0);
}

/* Remove oldest stacklet from stack chain */
void DequeueStacklet(StackChain_t *stackChain)
{
  int i;
  Stacklet_Dealloc(stackChain->stacklets[0]);
  for (i=1; i<stackChain->cursor; i++) {
    stackChain->stacklets[i-1] = stackChain->stacklets[i];
    assert(stackChain->stacklets[i-1]->count > 0);
  }
  stackChain->stacklets[stackChain->cursor-1] = NULL;
  stackChain->cursor--;
  assert(stackChain->cursor>=0);
}

void showAllThreads(void)
{
  int i;
  for (i=0; i<NumThread; i++) {
    Thread_t *th = &Threads[i];
    StackChain_t *stack = th->stack;
    int stackNum = (stack == NULL) ? -1 : (stack - &StackChains[0]);
    printf("%3d: stat = %d    tid = %4d  stack = %3d\n", 
	   i, th->status, th->tid, stackNum);
  }
  printf("\n\nStackChains:\n");
  for (i=0; i<NumStackChain; i++) {
    StackChain_t *sc = &StackChains[i];
    Thread_t *th = (Thread_t *) sc->thread;
    int tid = (th == NULL) ? -1 : (th - &Threads[0]);
    printf("%3d: th = %d\n",
	   i, tid);
  }
}

StackChain_t* StackChain_BaseAlloc(Thread_t *t, int n)
{
  int i;
  for (i=0; i<NumStackChain; i++)
    if (CompareAndSwap(&StackChains[i].used, 0, 1) == 0) {
      StackChain_t *res = &StackChains[i];
      /* memBarrier(); */
      assert(res->used == 1);
      res->cursor = 0;
      res->thread = t;
      res->avail = n;
      assert(n > 0);
      res->stacklets = (Stacklet_t**) my_malloc(sizeof(Stacklet_t*) * n);
      for (i=0; i < n; i++) {
	res->stacklets[i] = NULL;
      }
      return res;
    }
  showAllThreads();
  assert(0);
}


StackChain_t* StackChain_Copy(void *tVoid, StackChain_t *src)
{
  int i;
  Thread_t *t = (Thread_t *) tVoid;
  StackChain_t* res = StackChain_BaseAlloc(t, src->avail);
  assert(t == t->stack->thread);
  assert(src->used);
  res->cursor = src->cursor;
  for (i=0; i<src->cursor; i++) {
    res->stacklets[i] = src->stacklets[i];
    src->stacklets[i]->count++;
  }
  return res;
}

int StackChain_Size(StackChain_t *chain) 
{
  int i, sum = 0;
  for (i=0; i<chain->cursor; i++) {
    Stacklet_t *stacklet = chain->stacklets[i];
    sum += (stacklet->baseTop - stacklet->baseCursor) * sizeof(val_t);
  }
  return sum;
}


StackChain_t* StackChain_Alloc(void *tVoid)
{
  Thread_t *t = (Thread_t *) tVoid;
  StackChain_t* res = StackChain_BaseAlloc(t, NumStackletPerChain);
  NewStacklet(res);
  return res;
}

void StackChain_Dealloc(StackChain_t *stackChain)
{
  int i;
  for (i=0; i<stackChain->cursor; i++) {
    Stacklet_Dealloc(stackChain->stacklets[i]);
    stackChain->stacklets[i] = NULL;
  }
  stackChain->cursor = 0;
  stackChain->thread = NULL;
  stackChain->used = 0;   /* Should be last */
}

Stacklet_t* GetStacklet(mem_t add)
{
  int i;
  mem_t offsetAdd = add - stackletOffset / sizeof(val_t);
  for (i=0; i<NumStacklet; i++) {
    Stacklet_t *s = &Stacklets[i];
    if (s->count && 
	((s->baseExtendedBottom <= add       &&       add <= s->baseTop) ||
	 (s->baseExtendedBottom <= offsetAdd && offsetAdd <= s->baseTop)))
      return s;
  }
  return NULL;
}

Stacklet_t* CurrentStacklet(StackChain_t *stackChain)
{
  Stacklet_t *stacklet = stackChain->stacklets[stackChain->cursor-1];
  assert(stackChain->used);
  assert(stackChain->cursor > 0 && stackChain->cursor < stackChain->avail);
  assert(stacklet->count > 0);
  return stacklet;
}

void HeapInitialize(void)
{
  int i;
  Heaps = (Heap_t *)my_malloc(sizeof(Heap_t) * NumHeap);
  for (i=0; i<NumHeap; i++) {
    Heap_t *heap = &(Heaps[i]);
    heap->id = i;
    heap->valid = 0;
    heap->top = 0;
    heap->bottom = 0;
    heap->cursor = 0;
    heap->mappedTop = 0;
    heap->writeableTop = 0;
    heap->lock = (pthread_mutex_t *) my_malloc(sizeof(pthread_mutex_t));
    pthread_mutex_init(heap->lock,NULL);
  }
}


void PadHeapArea(mem_t bottom, mem_t top)
{
  if (bottom > top)
    printf("bottom = %d   top = %d\n", bottom , top);
  assert(bottom <= top);
  if (bottom < top)
    *bottom = MAKE_SKIP(top - bottom);
}


Heap_t* GetHeap(mem_t add)
{
  int i;
  for (i=0; i<NumHeap; i++)
    if (Heaps[i].valid && Heaps[i].id==i &&
	Heaps[i].bottom <= add &&
	Heaps[i].top    >= add)
      return (Heaps+i);
  return NULL;
}

int inSomeHeap(ptr_t v)
{
  int i;
  for (i=0; i < NumHeap; i++) {
    if (Heaps[i].valid && Heaps[i].id==i && inHeap(v, &Heaps[i]))
      return 1;
  }
  return 0;
}

void SetRange(range_t *range, mem_t low, mem_t high)
{
  range->low = low;
  range->high = high;
  range->diff = (high - low) * (sizeof (val_t));
}

Heap_t* Heap_Alloc(int MinSize, int MaxSize)
{
  static int heap_count = 0;
  int stat;
  mem_t cursor;
  Heap_t *res = &(Heaps[heap_count++]);
  int maxsize_pageround = RoundUp(MaxSize,TILT_PAGESIZE);
  res->size = maxsize_pageround;
  res->bottom = (mem_t) my_mmap(maxsize_pageround, PROT_READ | PROT_WRITE);
  res->cursor = res->bottom;
  res->top    = res->bottom + MinSize / (sizeof (val_t));
  res->writeableTop = res->bottom + maxsize_pageround / (sizeof (val_t));
  res->mappedTop = res->writeableTop;
  SetRange(&(res->range), res->bottom, res->mappedTop);
  res->valid  = 1;
  res->bitmap = paranoid ? CreateBitmap(maxsize_pageround / 4) : NULL;
  res->freshPages = (int *) my_malloc(DivideUp(maxsize_pageround / TILT_PAGESIZE, 32) * sizeof(int));
  memset((int *)res->freshPages, 0, DivideUp(maxsize_pageround / TILT_PAGESIZE, 32) * sizeof(int));
  assert(res->bottom != (mem_t) -1);
  assert(heap_count < NumHeap);
  assert(MaxSize >= MinSize);
  /* Lock down pages and force page-table to be initialized; otherwise, PadHeapArea can often take 0.1 - 0.2 ms. 
     Even with this, there are occasional (but far fewer) page table misses.
   */
  if (geteuid() == 0) {
    stat = mlock((caddr_t) res->bottom, maxsize_pageround); 
    if (stat) {
      printf("mlock failed with errno %d\n", errno);
      assert(0);
    }
  }
  return res;
}

int Heap_ResetFreshPages(Proc_t *proc, Heap_t *h)
{
  int MaxSize = sizeof(val_t) * (h->mappedTop - h->bottom);
  int i, pages = DivideUp(MaxSize,TILT_PAGESIZE);
  memset((int *)h->freshPages, 0, DivideUp(pages, 32) * sizeof(int));
  /*  proc->segUsage.pagesTouched += pages / 100;   XXX These refer to pages of the pageMap itself */
  return pages;
}

int Heap_GetMaximumSize(Heap_t *h)
{
  return (sizeof (val_t)) * (h->mappedTop - h->bottom);
}

int Heap_GetSize(Heap_t *h)
{
  return (sizeof (val_t)) * (h->top - h->bottom);
}

int Heap_GetAvail(Heap_t *h)
{
  return (sizeof (val_t)) * (h->top - h->cursor);
}

int Heap_GetUsed(Heap_t *h)
{
  return (sizeof (val_t)) * (h->cursor - h->bottom);
}

void Heap_Reset(Heap_t *h)
{
  h->cursor = h->bottom;
}

void Heap_Resize(Heap_t *h, long newSize, int reset)
{
  long usedSize;
  long maxSize = (h->mappedTop - h->bottom) * sizeof(val_t);
  long oldSize = (h->top - h->bottom) * sizeof(val_t);
  long oldWriteableSize = (h->writeableTop - h->bottom) * sizeof(val_t);
  long oldSizeRound = RoundUp(oldSize, TILT_PAGESIZE);
  long newSizeRound = RoundUp(newSize, TILT_PAGESIZE);

  if (newSize > maxSize) {
    printf("FATAL ERROR in Heap_Resize at GC %d.  Heap size = %d.  Trying to resize to %d\n", NumGC, maxSize, newSize);
    assert(0);
  }
  if (reset) {
    h->cursor = h->bottom;
  }
  usedSize = (h->cursor - h->bottom) * sizeof(val_t);
  assert(usedSize <= newSize);
  h->top = h->bottom + (newSize / sizeof(val_t));

  if (newSizeRound > oldWriteableSize) {
    my_mprotect(6,(caddr_t) h->writeableTop, newSizeRound - oldWriteableSize, PROT_READ | PROT_WRITE);
    h->writeableTop = h->bottom + newSizeRound / sizeof(val_t);
  }
  else if (paranoid && newSizeRound < oldWriteableSize) {
    my_mprotect(7,(caddr_t) (h->bottom + newSizeRound / sizeof(val_t)), oldWriteableSize - newSizeRound, PROT_NONE);
    h->writeableTop = h->bottom + newSizeRound / sizeof(val_t);
  }
  assert(h->bottom <= h->cursor);
  assert(h->cursor <= h->top);
  assert(h->top <= h->writeableTop);
  assert(h->writeableTop <= h->mappedTop);
}


mem_t StackError(ucontext_t *ucontext, mem_t badadd)
{
  Stacklet_t *faultstack = 0;
  StackChain_t *faultchain = 0;
  int i;
  mem_t sp = GetSp(ucontext);

  printf("\n------------------StackError---------------------\n");
  printf("sp, badreference:  %u   %u\n",sp,badadd);
  assert(0);
  return sp; /* Bogus!  silence warnings. */
}

extern mem_t datastart;

void memobj_init(void)
{
  Stacklet_t *s1, *s2;
  unsigned long mem_bytes = GetPhysicalPages() * 0.30 * TILT_PAGESIZE;
  unsigned long heap_bytes;
  int max_heap_byte;
  heap_bytes = (unsigned long)INT_MAX;
  heap_bytes = Min(heap_bytes, mem_bytes);
  init_int(&MinHeapByte, 2048 * 1024);
  init_int(&MaxHeapByte, 0.40 * heap_bytes);
#ifdef solaris
  assert(TILT_PAGESIZE == sysconf(_SC_PAGESIZE));
#else
  assert(TILT_PAGESIZE == sysconf(_SC_PAGE_SIZE));
#endif
  StackInitialize();
  HeapInitialize();
  GuardStackletSize = TILT_PAGESIZE / kilobyte;
  stackletOffset = (GuardStackletSize + MLStackletSize + CStackletSize) * kilobyte;
  primaryStackletOffset = 0;
  replicaStackletOffset = stackletOffset;
  /* So we don't pay mmap for first thread - general case? XXXX */
  { int i;
    Stacklet_t *temp[5];
    for (i=0; i<5; i++)
      temp[i] = Stacklet_Alloc(NULL);
    for (i=0; i<5; i++)
      Stacklet_Dealloc(temp[i]);
  }
}
