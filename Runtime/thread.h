#ifdef alpha_osf
#define intSz        4
#define longSz       8
#define CptrSz       8
#define MLptrSz      4
#define doubleSz     8
#endif
#ifdef solaris
#define intSz        4
#define longSz       4
#define CptrSz       4
#define MLptrSz      4
#define doubleSz     8
#endif

#define MLsaveregs_disp     0
#define proc_disp           longSz*32+8*32
#define notinml_disp        longSz*32+8*32+CptrSz
#define scratch_disp        longSz*32+8*32+CptrSz+longSz
#define thunk_disp          longSz*32+8*32+CptrSz+longSz+doubleSz
#define request_disp        longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz
#define requestInfo_disp    longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz+longSz
#define Csaveregs_disp      longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz+longSz+longSz+longSz
#define writelistAlloc_disp longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz+longSz+longSz+longSz+32*longSz+32*doubleSz
#define writelistLimit_disp longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz+longSz+longSz+longSz+32*longSz+32*doubleSz+MLptrSz
#define stackLimit_disp     longSz*32+8*32+CptrSz+longSz+doubleSz+CptrSz+longSz+longSz+longSz+32*longSz+32*doubleSz+MLptrSz+MLptrSz 
#if    defined(solaris)
#define snapshot_size       16
#elif  defined(alpha_osf)
#define snapshot_size       20
#endif
#define NoRequest 0
#define YieldRequest 1
#define StartRequest 2
#define GCRequestFromML 3
#define GCRequestFromC 4
#define MajorGCRequestFromC 5

#ifndef _thread_h
#define _thread_h
#ifndef _asm_

#include "memobj.h"
#include "stats.h"
#include "queue.h"
#include <signal.h>


/* These types should be in forward.h but mutually recusrive headers are broken. */
struct RegionStack__t;
struct Proc__t;
struct CopyRange__t;
typedef void discharge_t(struct CopyRange__t *);
typedef void expand_t(struct CopyRange__t *, int size);
typedef struct CopyRange__t   /* This is essentially an object clumsily expressed in C */
{
  mem_t start;
  mem_t cursor;
  mem_t stop;
  Heap_t *heap;
  expand_t *expand;
  discharge_t *discharge; 
  struct Proc__t *proc;
  Stack_t *regionStack;
} CopyRange_t;

typedef struct Usage__t
{
  long bytesAllocated;
  long fieldsCopied;
  long fieldsScanned;
  long ptrFieldsScanned;
  long objsCopied;
  long objsScanned;
  long pagesTouched;
  long globalsProcessed;
  long stackSlotsProcessed;
  long workDone;         /* Weighted average of bytesCopied, bytesScanned, and rootProcessed - not always up-to-date */
  long lastWorkDone;     /* Some snapshot of the past - upadted when sufficiently different from workDone */
  long counter;          /* Cycles down from localWorksize to zero repeatedly.  When zero, workDone is updated. */
} Usage_t;

/* Finally, these types actually do belong here */
/* Thread State:
   used    0 if thread structure is free; otherwise, 1
   status -1 : Thread has completed execution but may not be free due to pinning
           0 : Thread is ready to be scheduled
          >0 : Thread is running already or is blocked; not eligible to be run
   pinned  1 if thread must remain in scheduler queue even if not eligible to run

*/
     
/* decalpha.sml, sparc.sml, and the ***_disp above have to be changed if the fields are modified 
   Note that long is used to avoid padding problems.
*/
typedef struct Thread__t
{
  /* ---- These fields are accessed by assembly code ---- */
  unsigned long      saveregs[32];     /* Register set; compiler relied on this being first */
  double             fregs[32];        /* Register set; compiler relied on this being second */
  struct Proc__t     *proc;            /* of type Proc_t * - relied on by service_alpha_osf.s  */
  long               notInML;          /* set to true whenever mutator calls a normal external function */
  double             scratch;
  ptr_t              thunk;            /* Thunk of this thread - NULL after thunk has started */
  long               request;          /* Why were we stoppped and how do we resume? */
  long               requestInfo;      /* If positive, how many bytes needed for allocation.
					  If negative, how many bytes of write buffer needed. */
  long               filler;           /* must double align here */
  long               Csaveregs[32];    /* C register saved when we need to de-schedule while in a C function */
  double             Cfregs[32];        
  ploc_t             writelistAlloc;
  ploc_t             writelistLimit;
  mem_t              stackLimit;       /* Bottom of current stack */
  int                globalOffset;     /* zero or four */
  int                stackletOffset;   /* zero or stackletSize * 1024 */
  int                arrayOffset;      /* zero or four */

  /* ---- The remaining fields not accessed by assembly code or mutator ---- */
  StackChain_t       *stack;
  StackChain_t       *snapshot;          /* Stack chain copied for concurrent collector */
  unsigned long       snapshotRegs[32];  /* Register set copied for concurrent collector */
  ptr_t               snapshotThunk;     /* used by concurrent collector */
  long                tid;               /* Thread ID */
  long                id;                /* Structure ID */
  int                 used;
  long                status;            /* long so fetchAndAdd works */
  int                 pinned;
  struct Thread__t   *parent;
} Thread_t;



/* The states Scheduler, Mutator, GC,and  Done are disjoint.
   The remaining GC* states are substates of GC.
 */
typedef enum ProcessorState__t {Scheduler, Mutator, GC, Done,
				GCStack, GCGlobal, GCWork} ProcessorState_t;
/* Each segment might be no collection, minor, or major. 
   Independently, it migth invole flipping the collector on or off */
typedef enum GCSegment1__t {NoWork, MinorWork, MajorWork} GCSegment1_t;
typedef enum GCSegment2__t {Continue, FlipOn, FlipOff, FlipBoth} GCSegment2_t;

typedef struct Proc__t
{
  int                stack;        /* address of system thread stack that can be used to enter scheduler */
  int                procid;         /* sys thread id */
  mem_t              allocStart;     /* allocation range */
  mem_t              allocCursor;
  mem_t              allocLimit;      
  ploc_t             writelistStart;  /* write list range */
  ploc_t             writelistCursor;
  ploc_t             writelistEnd;
  ptr_t              writelist[4096];
  int                processor;      /* processor id that this pthread is bound to */
  pthread_t          pthread;        /* pthread that this system thread is implemented as */
  Thread_t           *userThread;    /* current user thread mapped to this system thread */

  Stack_t            *globalLocs;       /* Global variables */
  Stack_t            *rootLocs;         /* Stack root locations containing root values */
  /* In a generation, concurrent collector, backLocs and backObjs have to be processed twice.
     So, each entry is a pair containing the location/object and a count, initially 0. 
     The temp versions are necessary so we have a place to push.  At the end of the GC,
     we swap the two versions.
  */
  Stack_t            *backLocs, *backLocsTemp;  /* All modified pointer array field for generational, concurrent collector */
  Stack_t            *backObjs, *backObjsTemp;  /* Pointer arrays allocated in generational collector */
  Stack_t            threads;           /* Used by incremental collector for breaking up scanning stacks */
  Stack_t            minorObjStack;     /* Used by parallel/concurrent generational collector */
  Stack_t            minorSegmentStack; 
  Stack_t            majorObjStack;     /* Used by parallel/concurrent collector */
  Stack_t            majorSegmentStack;  
  Stack_t            majorRegionStack; /* Possibly used by a generational concurrent collector */

  Timer_t            totalTimer;     /* Time spent in entire processor */
  Timer_t            currentTimer;   /* Time spent running any subtask */
  int                segmentNumber;  /* Counts the Number of times we are in a GC since running a mutator */
  GCSegment1_t       gcSegment1;     /* Did GC work get done and was it a minor or major GC */
  GCSegment2_t       gcSegment2;     /* Did GC turn on, turn off, or continue? */
  double             gcTime;         /* How much time spent on current GC/Scheduler segment? */
  double             schedulerTime;  /* How much time spent on current GC/Scheduler segment? */
  ProcessorState_t   state;          /* What the processor is working on */
  long               numSegment;     /* Number of current segment, incremented each time we switch to a mutator */
  Usage_t            segUsage;       /* Info for current segment which will be added to a cycle */
  Usage_t            minorUsage;     /* Info for current GC cycle */
  Usage_t            majorUsage;
  Statistic_t        bytesAllocatedStatistic;  /* just minor - won't this exclude large objects? XXXX */
  Statistic_t        bytesCopiedStatistic;     /* both minor and major */
                                               /* XXX Should the next 3 be program-wide */
  Statistic_t        heapSizeStatistic;        /* in Kb */
  Statistic_t        minorSurvivalStatistic;
  Statistic_t        majorSurvivalStatistic;
  Statistic_t        schedulerStatistic;
  Histogram_t        mutatorHistogram;
  Statistic_t        gcStackStatistic;
  Statistic_t        gcGlobalStatistic;
  Statistic_t        gcNoneStatistic;
  Histogram_t        gcWorkHistogram;
  Histogram_t        gcMajorWorkHistogram;
  Histogram_t        gcFlipOffHistogram;
  Histogram_t        gcFlipOnHistogram;


  CopyRange_t        minorRange;   /* Used only by generational collector */
  CopyRange_t        majorRange;

  long               numCopied;        /* Number of objects copied */
  long               numShared;        /* Number of times an object is reached after it's already been forwarded */
  long               numContention;    /* Number of failed (simultaneous) attempts to copy an object */
  long               numWrite;
  long               numRoot;
  long               numLocative;

  unsigned long      lastHashKey;     /* Last hash entry key/data for optimizing LookupCallinfo */
  void               *lastHashData; 

} Proc_t;

void procChangeState(Proc_t *, ProcessorState_t);

long updateWorkDone(Proc_t *proc);

INLINE(getWorkDone)
long getWorkDone(Proc_t *proc)
{
  if (--proc->segUsage.counter) {
    proc->segUsage.counter = 50;
    updateWorkDone(proc);
  }
  return proc->segUsage.workDone;
}

INLINE(recentWorkDone)
long recentWorkDone(Proc_t *proc, int recentWorkThreshold)
{
  int workDone = getWorkDone(proc);
  if ((workDone - proc->segUsage.lastWorkDone) > recentWorkThreshold) {
    proc->segUsage.lastWorkDone = workDone;
    return 1;
  }
  return 0;
}


Thread_t *getThread(void);
Proc_t *getProc(void);
Proc_t *getNthProc(int);

extern pthread_mutex_t ScheduleLock;       /* locks (de)scheduling of sys threads */
void ResetJob(void);                       /* For iterating over all jobs in work list */
Thread_t *NextJob(void);
void StopAllThreads(void);                 /* Change all user thread's limit to StopHeapLimit */
double segmentTime(Proc_t *);              /* Time of current GC segment */

void thread_init(void);
void thread_go(ptr_t thunk);
void Interrupt(struct ucontext *);
void scheduler(Proc_t *);                  /* Unmap user thread of Proc if mapped */
void Finish(void);
Thread_t *YieldRest(void);
void ReleaseJob(Proc_t *);
void Thread_Pin(Thread_t *th);
void Thread_Unpin(Thread_t *th);

int thread_total(void);
int thread_max(void);

extern Thread_t    *Threads;
Thread_t *mainThread;

#endif
#endif
