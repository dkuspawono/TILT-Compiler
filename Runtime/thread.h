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
#define request_disp        longSz*32+8*32+CptrSz+longSz+doubleSz
#define requestInfo_disp    longSz*32+8*32+CptrSz+longSz+doubleSz+longSz
#define Csaveregs_disp      longSz*32+8*32+CptrSz+longSz+doubleSz+longSz+longSz
#define writelistAlloc_disp longSz*32+8*32+CptrSz+longSz+doubleSz+longSz+longSz+32*longSz+32*doubleSz
#define writelistLimit_disp longSz*32+8*32+CptrSz+longSz+doubleSz+longSz+longSz+32*longSz+32*doubleSz+MLptrSz
#define stackLimit_disp     longSz*32+8*32+CptrSz+longSz+doubleSz+longSz+longSz+32*longSz+32*doubleSz+MLptrSz+MLptrSz 
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

#include <values.h>
#include "general.h"
#include "memobj.h"
#include "stats.h"
#include "queue.h"
/* #include <signal.h> */

/* These types should be in stack.h but mutually recusrive headers are broken. */
typedef struct Callinfo__t  /* This structure must match the GC table entry format generated by the compiler */
{
  val_t   retadd;      
#ifdef GCTABLE_HASENTRYID
  int     entryid;
#endif
  int     size0;             /* low   16 bits = entry size in words; 
                                next  16 bits = frame size in words;
			     */
  int     size1;             /* low  16 bits = byte section size in words;
				next 5 bits = word offset of return address;
				upper 11 bits = zero
			     */
  int     regtrace_a;        /* ab=10: YES      ab=00:NO  */
  int     regtrace_b;        /* ab=11 CALLEE    ab=01:SPEC */
  char    __rawdata[4];      /* must be word aligned;
				for the stack status: 00 -> TRACE_NO; 01-> TRACE_YES;
				                      02 -> TRACE_CALLEE ?; 03 -> TRACE_?
				then comes byte data and then special data */
  /* Note that ONLY the BYTE DATA follows the natural endian-ness.
    The other fields use ints/4 bytes when laid out.  If the the other fields,
    like the regtrace or stacktrace are read fom memory in smaller sizes for
    optimization purposes, the runtime must dispatch at compile-time on endian-ness. 
    The pairs of bits in stacktrace/regtrace are laid out starting from the lsb
    to the most significant bit.  Note that this is biased towards little-endian,
    the one true endian!!!*/
} Callinfo_t;

typedef struct CallinfoCursor__t
{
  Callinfo_t *callinfo;
  int entrySize;
  int frameSize;
  int RAQuadOffset;
  int byteOffset;  /* cursors into the special sections */
  int wordOffset;
  unsigned int yesBits;
  unsigned int calleeMask;
  unsigned int specialBits;
  char *byteData;
  int *wordData;
  /* Cached information on stack slots */
  int slotCount;  /* -(n+1) cache called n times; >0 cache is active */
  int slot[10];
  int trace[10];
} CallinfoCursor_t;



/* These types should be in forward.h but mutually recusrive headers are broken. */
struct RegionStack__t;
struct Proc__t;
struct CopyRange__t;
typedef void discharge_t(struct CopyRange__t *);
typedef void expand_t(struct CopyRange__t *, int size);

/* Not volatile - not concurrently accessed */
typedef struct CopyRange__t   /* This is essentially an object clumsily expressed in C */
{
  mem_t start;
  mem_t cursor;
  mem_t stop;
  mem_t reserve;
  Heap_t *heap;
  struct Proc__t *proc;
} CopyRange_t;

/* Not volatile - not concurrently accessed */
typedef struct Usage__t
{
  long numWrites;
  long bytesAllocated;
  long bytesReplicated;
  long fieldsCopied;
  long fieldsScanned;
  long ptrFieldsScanned;
  long objsCopied;
  long objsScanned;
  long pagesTouched;
  long rootsProcessed;
  long globalsProcessed;
  long stackSlotsProcessed;
  long workDone;         /* Weighted average of bytesCopied, bytesScanned, and rootProcessed - not always up-to-date */
  long checkWork;        /* used by recentWorkDone; workDone (in the past) + localWorkSize */
  long maxWork;          /* maximum work to do in this segment */
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
  volatile unsigned long      saveregs[32];     /* Register set; compiler relied on this being first */
  volatile double             fregs[32];        /* Register set; compiler relied on this being second */
  volatile struct Proc__t     *proc;            /* of type Proc_t * - relied on by service_alpha_osf.s  */
  volatile long               notInML;          /* set to true whenever mutator calls a normal external function */
  volatile double             scratch;
  volatile long               request;          /* Why were we stoppped and how do we resume? */
  volatile long               requestInfo;      /* If positive, how many bytes needed for allocation.
						   If negative, how many bytes of write buffer needed. */
  volatile long               Csaveregs[32];    /* C register saved when we need to de-schedule while in a C function */
  volatile double             Cfregs[32];        
  volatile ploc_t             writelistAlloc;
  volatile ploc_t             writelistLimit;
  volatile mem_t              stackLimit;       /* Bottom of current stack */
  volatile int                globalOffset;     /* zero or four */
  volatile int                stackletOffset;   /* zero or stackletSize * 1024 */
  volatile int                arrayOffset;      /* zero or four */

  /* ---- The remaining fields not accessed by assembly code or mutator ---- */
  volatile ptr_t              thunk;            /* Thunk of this thread - NULL after thunk has started */
  volatile ptr_t              rootVals[10];     /* Contains root values - needed only for concurrent collector */
  volatile ploc_t             rootLocs[10];     /* Contains root locations (when non-NULL) from which the 
						   corresponding rootVals obtained their values */
  StackChain_t                *stack;           /* Stack chain used by mutator */
  long                        tid;              /* Thread ID */
  long                        id;               /* Structure ID */
  volatile int                used;
  volatile long               status;           /* long so fetchAndAdd works */
  volatile int                pinned;
  struct Thread__t            *parent;
} Thread_t;



/* The states Scheduler, Mutator, GC,and  Done are disjoint.
   The remaining GC* states are substates of GC.
 */
typedef enum ProcessorState__t {Scheduler, Mutator, GC, Done, Idle, 
				GCStack, GCGlobal, GCReplicate, GCWork, GCWrite, GCIdle} ProcessorState_t;
/* Each segment might be no collection, minor, or major. 
   Independently, it migth invole flipping the collector on or off or both */
#define MinorWork 1
#define MajorWork 2
#define FlipOn    4
#define FlipOff   8
#define FlipTransition 16

typedef struct LocalWork__t
{
  Set_t  objs;             /* Gray objects */
  Set_t  grayRegion;       /* Regions of gray objects */
  Set_t  globals;          /* Global variables */
  Set_t  roots;            /* Stack root locations containing root values */
  Set_t  segments;         /* Used by incremental collector for breaking up scanning stacks */
  Set_t  stacklets;        /* Used by incremental collector for breaking up scanning stacks */
  Set_t  backObjs;         /* Used by generational collectors for arrays allocated in tenured area */
  Set_t  backLocs;         /* Used by generational, concurrent collector for modified array fields */
  Set_t  nextBackObjs;     /* Used when double processing */
  Set_t  nextBackLocs;     /* Used when double processing - note that the location is the mirror of the ones in backLocs */
  volatile int hasShared;    /* 1 if local stack grabbed items from shared stack */
} LocalWork_t;

void init_localWork(LocalWork_t *lw, int objSize, int segSize, int globalSize, 
		    int rootSize, int stackletSize, int backObjSize, int backLocSize);
int isLocalWorkAlmostEmpty(LocalWork_t *lw);  /* exclued backObjs and backLocs */
int isLocalWorkEmpty(LocalWork_t *lw);

/* Not volatile - not concurently accessed 
   Fields that are frequently and directly accessed should be placed first so their displacement is small.
   Statistics, histories, histograms, or indirectly accessed fields come last.
*/

/* Summarizes information of a state */
typedef struct Summary__t { 
  double time;     /* Time in ms */
  int    segment;  /* segment number */
  int    state;    /* primary state type */
  int    type;     /* additional segment type info */
  int    data1;    /* value of segUsage.workdone for GC and bytes allocaetd for Mutator */
  int    data2;    /* numWrites for Mutator */
  int    data3;
  double util1;
  double util2;
  double util3;
} Summary_t;

typedef struct Proc__t
{
  int                stack;          /* address of system thread stack that can be used to enter scheduler */
  int                procid;         /* sys thread id */
  mem_t              allocStart;     /* allocation range */
  mem_t              allocCursor;
  mem_t              allocLimit;      
  ploc_t             writelistStart;  /* write list range */
  ploc_t             writelistCursor;
  ploc_t             writelistEnd;
  int                processor;      /* processor id that this pthread is bound to */
  Thread_t           *userThread;    /* current user thread mapped to this system thread */
  LocalWork_t        work;
  Usage_t            segUsage;       /* Info for current segment which will be added to a cycle */
  Usage_t            cycleUsage;     /* Info for current GC cycle */
  Set_t              majorRegionStack; /* Possibly used by a generational concurrent collector */
  int                barrierPhase;   
  Timer_t            totalTimer;     /* Time spent in entire processor */
  Timer_t            currentTimer;   /* Time spent running any subtask */
  int                segmentNumber;  /* Current segment number */
  int                segmentType;    /* Was there minor work, major work, flip off, or flip on? */
  double             mutatorTime;    /* Time last spent in mutator - used for computing utilization level */
  double             nonMutatorTime; /* Total time since mutator suspended */
  int                nonMutatorCount;
  int                nonMutatorSegmentType;
  ProcessorState_t   state;          /* What the processor is working on */
  int                bytesCopied;    /* Number of bytes just copied (0 if not copied).  Modified by call to alloc/copy */
  int                needScan;       /* Non-zero if object just copied (check bytesCopied) might have pointer field. */
  CopyRange_t        copyRange;        /* Only one active per processor */
  unsigned long      lastHashKey;     /* Last hash entry key/data for optimizing LookupCallinfo */
  void               *lastHashData; 
  CallinfoCursor_t   lastCallinfoCursor;


  /* Less frequently directly accessed fields */
  pthread_t          pthread;        /* pthread that this system thread is implemented as */
  ptr_t              writelist[3 * 4096];

  /* Rotating history of last $n$ segments */
  Summary_t          history[1000000];
  int                lastSegWorkDone;
  int                firstHistory, lastHistory;   /* Index of first slot and first unused slot */

  Statistic_t        numWritesStatistic;
  Statistic_t        bytesAllocatedStatistic;  /* just minor - won't this exclude large objects? XXXX */
  Statistic_t        bytesReplicatedStatistic;  /* only for concurrent collectors */
  Statistic_t        bytesCopiedStatistic;     /* both minor and major */
                                               /* XXX Should the next 3 be program-wide */
  Statistic_t        workStatistic;
  Statistic_t        schedulerStatistic;
  Statistic_t        accountingStatistic;
  Statistic_t        idleStatistic;
  Histogram_t        mutatorHistogram;
  Statistic_t        gcStatistic;
  Statistic_t        gcIdleStatistic;
  Statistic_t        gcWorkStatistic;
  Statistic_t        gcStackStatistic;
  Statistic_t        gcGlobalStatistic;
  Statistic_t        gcWriteStatistic;
  Statistic_t        gcReplicateStatistic;
  Statistic_t        gcOtherStatistic;
  Histogram_t        timeDivWorkHistogram;
  Histogram_t        gcPauseHistogram;
  Histogram_t        gcFlipOffHistogram;
  Histogram_t        gcFlipOnHistogram;
  Histogram_t        gcFlipBothHistogram;
  Histogram_t        gcFlipTransitionHistogram;
  WindowQuotient_t   utilizationQuotient1;
  WindowQuotient_t   utilizationQuotient2;

  long               numCopied;        /* Number of objects copied */
  long               numShared;        /* Number of times an object is reached after it's already been forwarded */
  long               numContention;    /* Number of failed (simultaneous) attempts to copy an object */
  long               numRoot;
  long               numLocative;

  char               buffer[1024];    /* For use in posix.c */
  char               *tab;
  char               delayMsg[1024];

  /* For Perf mon */
#ifdef sparc
  unsigned long last0, last1;
  long pic0[1024], pic1[1024], picCursor;
  long pic2[1024], pic3[1024];  /* Splitting into two areas */
#endif
} Proc_t;

void procChangeState(Proc_t *, ProcessorState_t, int which);

long bytesCopied(Usage_t *u);

extern int usageCount;
extern int localWorkSize;

void updateWorkDone(Proc_t *proc);     /* Updates workDone as a weighted average of other fields */

INLINE(updateGetWorkDone)
int updateGetWorkDone(Proc_t *proc)     /* Updates workDone as a weighted average of other fields */
{
  updateWorkDone(proc);
  return proc->segUsage.workDone;
}

INLINE(addMaxWork)
void addMaxWork(Proc_t *proc, int additionalWork)
{
  if (additionalWork <= 0)
    return;
  proc->segUsage.maxWork += additionalWork;
  if (proc->segUsage.maxWork < 0)    /* in case additionalWork is MAXINT */
    proc->segUsage.maxWork = MAXINT;
}

INLINE(reachMaxWork)                   /* Calls update and then check against maxWork */
int  reachMaxWork(Proc_t *proc)
{
  updateWorkDone(proc);
  proc->segUsage.checkWork = Min(proc->segUsage.maxWork, proc->segUsage.workDone + localWorkSize);
  return proc->segUsage.workDone >= proc->segUsage.maxWork;
}    

INLINE(updateReachCheckWork)                 /* Calls update and check against check */
int updateReachCheckWork(Proc_t *proc)
{
  int workDone;
  updateWorkDone(proc);
  workDone = proc->segUsage.workDone;
  if (workDone > proc->segUsage.checkWork) {
    proc->segUsage.checkWork = Min(proc->segUsage.maxWork, workDone + localWorkSize);
    return 1;
  }
  return 0;
}

INLINE(reachCheckWork)                 /* Periodically calls update and check against check */
int reachCheckWork(Proc_t *proc)
{
  int workDone;
  if (--proc->segUsage.counter == 0) {
    proc->segUsage.counter = usageCount;
    updateWorkDone(proc);
  }
  workDone = proc->segUsage.workDone;
  if (workDone > proc->segUsage.checkWork) {
    proc->segUsage.checkWork = Min(proc->segUsage.maxWork, workDone + localWorkSize);
    return 1;
  }
  return 0;
}


Thread_t *getThread(void);
Proc_t *getProc(void);
Proc_t *getNthProc(int);
void showHistory(Proc_t *proc, int howMany, char *);  /* filename; NULL for stdout */

extern pthread_mutex_t ScheduleLock;       /* locks (de)scheduling of sys threads */
void ResetJob(void);                       /* For iterating over all jobs in work list */
Thread_t *NextJob(void);
void StopAllThreads(void);                 /* Change all user thread's limit to StopHeapLimit */
double nonMutatorTime(Proc_t *);           /* Time of current GC segment */
double segmentTime(Proc_t *);           /* Time of current GC segment */

void thread_init(void);
void thread_go(ptr_t thunk);
void Interrupt(ucontext_t *);
void scheduler(Proc_t *);                  /* Unmap user thread of Proc if mapped */
void Finish(void);
Thread_t *YieldRest(void);
void UpdateJob(Proc_t *);        /* GCRelease tread; update processor's info */
void ReleaseJob(Proc_t *);       /* UpdateJob; release/unmap thread */
void Thread_Pin(Thread_t *th);
void Thread_Unpin(Thread_t *th);

int thread_total(void);
int thread_max(void);

extern Thread_t    *Threads;
Thread_t *mainThread;

#endif
#endif
