#ifndef _gc_para_h
#define _gc_para_h

#include "tag.h"

/* Functions associated with TwoRoom_t are not exported */

typedef struct TwoRoom__t
{
  long Gate, Turn1, Turn2;
} TwoRoom_t;

/* Shared stack of objects */

typedef struct SharedStack__t
{
  ptr_t *rootValData;   /* Stack contains root values - not root locations */
  ptr_t *objData;       /* Stack contains gray objectsn */
  ptr_t *segmentData;   /* Stack contains ranges of gray objects; represented as triples of (gray, start, stop) */
  long rootValSize;     /* Size of corresponding stacks */
  long objSize;         
  long segmentSize;     
  long rootValCursor;   /* Index of first unused obj stack slot */
  long objCursor;
  long segmentCursor;   
  long numLocalStack;   /* Number of local stacks that might be non-empty */
  TwoRoom_t twoRoom;    /* Used to support parallel pushes and parallel pops by forbidding concurrent pushes and pops */
} SharedStack_t;

SharedStack_t *SharedStack_Alloc(int rootValSize, int objSize, int segmentSize);
int isEmptySharedStack(SharedStack_t *);                /* Requires access to TwoRoom */
void resetSharedStack(SharedStack_t *, int);            /* Resets numStack to given number */
void popSharedStack(SharedStack_t *, 
		    Stack_t *rootVal, int rootValRequest,
		    Stack_t *obj, int objRequest,
		    Stack_t *segment, int segmentRequest);  /* Increments numStack if number of items fetched > 0 */
int pushSharedStack(SharedStack_t *, 
		    Stack_t *rootVal, Stack_t *obj, Stack_t *segment);  /* Decrements numStack if number of items returned > 0;
									   Returns 1 if global stack empty and numStack is 0 */
int condPushSharedStack(SharedStack_t *, 
			Stack_t *rootVal, Stack_t *obj, Stack_t *segment);  /* Does not decrement numStack;
									       If global stack empty and numStack is 0, return 0;
									       else perform the transfer and return 1 */




/* ----------------------------------------------------------------------------------------
   Barrier synchronization is done by counting up a counter from 0 to the number of threads
   that are being synchronized.  When the barrier is passed, the previous counter
   is reset.  This cyclic resetting works as long as there are at least 3 counters.
   ----------------------------------------------------------------------------------------
*/

/* A synchronous barrier routine - returning the counter value before the increment */
long synchBarrier(long *counter, long barrierSize, long *prevCounter);

/* An asychronous version that allows threads to perform work after it has reached
   the barrier but before the other threads have reached the barrier. */
long asynchReachBarrier(long *counter);
long asynchCheckBarrier(long *counter, long barrierSize, long *prevCounter);  /* returns 1 if all threads have reached barrier */

#endif
