/* Not thread-safe */
#include "general.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <string.h>

#include "tag.h"
#include "queue.h"
#include "show.h"
#include "gc.h"
#include "memobj.h"
#include "thread.h"
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

extern Queue_t *float_roots;
extern Heap_t *floatheap;

const int stall = -1;

void SetRange(range_t *range, value_t low, value_t high)
{
  range->low = low;
  range->high = high;
  range->diff = high - low;
}

/* ------------------ Forwarding Routines ------------------ */


/* This should not be called directly. */
value_t *forward(value_t *vpp, value_t *alloc_ptr)
{
  value_t *v = (value_t *)(*vpp);
  int tag;
  unsigned int a,b;

  /* read some garbage to simulate write-allocate */
  int foobar = *(alloc_ptr + 4); 

#ifdef DIAG
  update_object_profile(&collected_object_profile,v);
#endif
  tag = v[-1];

  switch (tag)
    {
    case TAG_REC_EMPTY: /* empty records have one word of storage */
    case TAG_REC_INT:
    case TAG_REC_TRACE:
#ifdef HEAPPROFILE
	*alloc_ptr = v[-2];
	SetBirth(alloc_ptr);
	alloc_ptr++;
#endif
      {
	value_t *temp = alloc_ptr;
	temp[0] = v[-1];
	temp[1] = v[0];
	v[-1] = FORWARD_TAG;
	v[0] = (value_t)(temp+1);
	*vpp = (value_t)(temp+1);
	alloc_ptr = temp+2;
#ifdef SEMANTIC_GARBAGE
      update_lifetime(&v[-1],temp,1);
#endif
      }
      return alloc_ptr;
    case TAG_REC_INTINT:
    case TAG_REC_TRACEINT:
    case TAG_REC_INTTRACE:
    case TAG_REC_TRACETRACE:
#ifdef HEAPPROFILE
      *alloc_ptr = v[-2];
      SetBirth(alloc_ptr);
      alloc_ptr++;
#endif
      {
	value_t *temp = alloc_ptr;
	temp[0] = v[-1];
	temp[1] = v[0];
	temp[2] = v[1];
	v[-1] = FORWARD_TAG;
	v[0] = (value_t)(temp+1);
	*vpp =  (value_t)(temp+1);
	alloc_ptr = temp+3;
#ifdef SEMANTIC_GARBAGE
      update_lifetime(&v[-1],temp,2);
#endif
      }
      return alloc_ptr;
    default:
      break;
    }

  switch (GET_TYPE(tag))
    {
    case IARRAY_TAG:
    case PARRAY_TAG:
    case RARRAY_TAG:
      {
	value_t *rawstart = v-1;
	int i,upper = GET_ARRLEN(tag), newadd = 0;
	upper = (upper + 3) / 4;

	if (floatheap &&
	    ((value_t) v) >= floatheap->bottom &&
	    ((value_t) v) < floatheap->top)
	  {
	    Enqueue(float_roots,(void *)v);
	    return alloc_ptr;
	  }
	
	if (GET_TYPE(tag) == RARRAY_TAG)
	  {
	    int temp = (int) (alloc_ptr);
/* odd/even-word align the pointer so data is even/odd-aligned */
#ifdef HEAPPROFILE
	    if ((temp & 7) == 4)  
#else
	    if ((temp & 7) == 0)
#endif
	      {
		*((int *)temp) = SKIP_TAG;
		alloc_ptr = (value_t *)(temp+4);
	      }
	  }
#ifdef HEAPPROFILE
	    *alloc_ptr = v[-2];
	    SetBirth(alloc_ptr);
	    alloc_ptr++;
#endif
	/* empty arrays have 1 word of storage */
	if (upper == 0)
	  upper = 1;


	bcopy((char *)rawstart,(char *)(alloc_ptr),4*(1+upper));
	newadd = ((int)(alloc_ptr)) + 4;
	alloc_ptr += (1 + upper);
	v[-1] = FORWARD_TAG;
	v[0] = newadd;
	*vpp = newadd;
#ifdef SEMANTIC_GARBAGE
	update_lifetime(&v[-1],(value_t *)(((int)newadd)-4),upper);
#endif
	return alloc_ptr;
      }
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      {
	value_t *rawstart = v-1;
	int upper = -1; 
        if (IS_RECORD(rawstart[0]))
	  {
	    int curlen = GET_RECLEN(rawstart[0]);
	    if (curlen > RECLEN_MAX)
	      curlen = RECLEN_MAX;
#ifdef PARANOID
	    if ((GET_RECMASK(rawstart[0]) >> curlen) != 0) {
	      printf("BAD RECORD TAG\n");
	      assert(0);
	    }
#endif
	    upper += curlen + 1;
	  }
	else
	  {
	    while (IS_RECORD_SUB(rawstart[0]))
	      {
		int curlen = GET_RECLEN(rawstart[0]);
		if (curlen > RECLEN_MAX)
		  curlen = RECLEN_MAX;
#ifdef PARANOID
	    if ((GET_RECMASK(rawstart[0]) >> curlen) != 0) {
	      printf("BAD RECORD TAG\n");
	      assert(0);
	    }
#endif
		rawstart--;
		upper += curlen + 1;
	      }
	    if (IS_RECORD(rawstart[0]))
	      {
		int curlen = GET_RECLEN(rawstart[0]);
		if (curlen > RECLEN_MAX)
		  curlen = RECLEN_MAX;
#ifdef PARANOID
	    if ((GET_RECMASK(rawstart[0]) >> curlen) != 0) {
	      printf("BAD RECORD TAG\n");
	      assert(0);
	    }
#endif
		upper += curlen + 1;
	      }
	    else
	      BUG("forward: bad record");
	  }
#ifdef HEAPPROFILE
	*alloc_ptr = rawstart[-1];
	SetBirth(alloc_ptr);
	alloc_ptr++;
#endif
	switch (upper)
	  {
	    /* empty records have one word of storage */
	  case 0: 
	  case 1:
	    {
	      int *temp = (int *)alloc_ptr;
	      temp[0] = rawstart[0];
	      temp[1] = rawstart[1];
	      v[-1] = FORWARD_TAG;
	      v[0] = (int)(((value_t)alloc_ptr) + ((value_t)v-(value_t)rawstart));
	      alloc_ptr += 2;
	      *vpp = v[0];
#ifdef SEMANTIC_GARBAGE
	    update_lifetime(&v[-1],(value_t *)(((int)(alloc_ptr))-8),1);
#endif
	      return alloc_ptr;
	    }
	  case 2:
	    {
	      int *temp = (int *)alloc_ptr;
	      value_t newadd = (value_t)temp + ((value_t)v-(value_t)rawstart);
	      temp[0] = rawstart[0];
	      temp[1] = rawstart[1];
	      temp[2] = rawstart[2];
	      alloc_ptr += 3;
	      v[-1] = FORWARD_TAG;
	      v[0] = (int)newadd;
	      *vpp = newadd;
	    }
#ifdef SEMANTIC_GARBAGE
	    update_lifetime(&v[-1],(value_t *)(((int)(*alloc_ptr))-12),2);
#endif
	    return alloc_ptr;
	  case 3:
	    {
	      int *temp = (int *)alloc_ptr;
	      temp[0] = rawstart[0];
	      temp[1] = rawstart[1];
	      temp[2] = rawstart[2];
	      temp[3] = rawstart[3];
	      v[-1] = FORWARD_TAG;
	      v[0] = (int)((value_t)temp + ((value_t)v-(value_t)rawstart));
	      alloc_ptr += 4;
	      *vpp = v[0];
#ifdef SEMANTIC_GARBAGE
	    update_lifetime(&v[-1],(value_t *)(((int)(alloc_ptr))-16),3);
#endif
	    }
	    return alloc_ptr;
	  default:

	    bcopy((char *)rawstart,(char *)(alloc_ptr),4*(1+upper));
	    v[-1] = FORWARD_TAG;
	    v[0] = (int)(((value_t)alloc_ptr) + ((value_t)v-(value_t)rawstart));
	    alloc_ptr += (1 + upper);
	    *vpp = v[0];
#ifdef SEMANTIC_GARBAGE
	    update_lifetime(&v[-1],(value_t *)(((int)(alloc_ptr))-4*(1+upper)),upper);
#endif
	    return alloc_ptr;
	  }
	break;
      }
    case FORWARD_TAG:
      *vpp = v[0];
      return alloc_ptr;
    case SKIP_TAG:
      printf("\n\nv = %d\n",v);
      printf("tag = %d\n",tag);
      BUG("forward: IMPOSSIBLE to get SKIP_TAG");
    default:
      printf("\n\nv = %d\n",v);
      printf("tag = %d\n",tag);
      BUG("forward: IMPOSSIBLE TAG");
    }
  foobar++;
  assert(0);
}



/* This should not be called directly. */
void forward_stack(value_t *vpp, value_t **alloc_ptr, value_t **limit_ptr, Heap_t *toheap)
{
  value_t *white = (value_t *)(*vpp); /* old object */
  value_t *obj;                   /* forwarded object */
  int tmp,tag;
  value_t *alloc = *alloc_ptr;
  value_t *limit = *limit_ptr;

  /* Check for forward tag first since ldl_l/stl_c is expensive */
  if (white[-1] == FORWARD_TAG)
   {
     *vpp = white[0];
     return;
   }



 /* Atomically try commiting to be the copier; 
    we exit this when there is some copier */

#ifdef alpha_osf
  {
    int done = 0;
    while (!done) {
      /*    asm("ldl_l %0,-4(%1)" : "=i" (tag) : "i" (white)); */
      tag = asm("ldl_l %v0,-4(%a0)",white); 
      if (tag == stall) 
	done = 1;
      else 
	done |= asm("stl_c %a0,-4(%a1) ; mov %a0,%v0",stall,white);
    }
  }
#endif

#ifdef sparc
    {
       value_t *tagloc = white - 1;
       value_t tag = * tagloc;
       value_t newval = stall;
       if (tag == stall || tag == FORWARD_TAG)
	 ;
       else {
	 /* Excample of a SPARC ld statement with gcc asm
	    int *ptr;
	    int val;
	    asm("ld   [%1],%0" : "=r" (val) : "r" (ptr)); */
	 asm("cas [%1],%2,%0" : "=r" (newval) : "r" (tagloc), "r" (tag)); 
       }
    }
#endif


  /* If tag is stall, somebody else is copier; wait for forwarding address */
  while (tag == stall) {
    tag = white[-1];
  }


  /* In the ensuing code, the tag must be restored only after the forwarding address is written */

  switch (tag)
    {
    case TAG_REC_EMPTY: /* empty records have one word of storage */
    case TAG_REC_INT:
    case TAG_REC_TRACE:
      {
	if (alloc+2 >= limit) {
	  GetHeapArea(toheap,pagesize,&alloc,limit_ptr);
	  assert(alloc);
	}
	obj = alloc + 1;
	alloc += 2;
	*alloc_ptr = alloc;
	obj[-1] = tag;
	obj[0] = white[0];
	*vpp = (value_t)obj;
	white[0] = (value_t)obj;
	white[-1] = FORWARD_TAG;
	return;
      }
    case TAG_REC_INTINT:
    case TAG_REC_TRACEINT:
    case TAG_REC_INTTRACE:
    case TAG_REC_TRACETRACE:
      {
	if (alloc+3 >= limit) {
	  GetHeapArea(toheap,pagesize,&alloc,limit_ptr);
	  assert(alloc);
	}
	obj = alloc + 1;
	alloc += 3;
	*alloc_ptr = alloc;
	obj[-1] = tag;
	obj[0] = white[0];
	obj[1] = white[1];
	*vpp =  (value_t)obj;
	white[0] = (value_t)obj;
	white[-1] = FORWARD_TAG;
	return;
      }
    default:
      break;
    }

  switch (GET_TYPE(tag))
    {
    case IARRAY_TAG:
    case PARRAY_TAG:
    case RARRAY_TAG:
      {
	value_t *rawstart = white-1;
	int i,upper = GET_ARRLEN(tag), newadd = 0;
	upper = (upper + 3) / 4;
	/* empty arrays have 1 word of storage */
	if (upper == 0)
	  upper = 1;

	if (alloc + (1+upper) >= limit) {
	  GetHeapArea(toheap,pagesize,&alloc,limit_ptr);
	  assert(alloc);
	}

	if (floatheap &&
	    ((value_t) white) >= floatheap->bottom &&
	    ((value_t) white) < floatheap->top)
	  {
	    Enqueue(float_roots,(void *)white);
	    return;
	  }
	
	if (GET_TYPE(tag) == RARRAY_TAG)
	  {
	    int temp = (int) (alloc);
	    /* odd-word align the pointer so data is even-aligned */
	    if ((temp & 7) == 0)
	      {
		*((int *)temp) = SKIP_TAG;
		alloc = (value_t *)(temp+4);
	      }
	  }
	obj = alloc + 1;
	alloc += (1 + upper);
	*alloc_ptr = alloc;
	obj[-1] = tag;
	bcopy((const char *)white,(char *)obj,4*upper);
	*vpp = (value_t)obj;
	white[0] = (value_t)obj;
	white[-1] = FORWARD_TAG;
	return;
      }
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      {
	/* We must use tag to initialize curtag and NOT use white[-1] */
	int curtag = tag;
	int numfields = 0;
	int numtags = 0;
	while (1) {
	  int curlen = GET_RECLEN(curtag);
	  if (curlen > RECLEN_MAX)
	    numfields += RECLEN_MAX;
	  else 
	    numfields += curlen;
	  numtags++;
	  if (IS_RECORD(curtag))
	    break;
	  curtag = white[-(numtags+1)];
	}
	/* records with less than 3 components already handled */
	assert(numfields > 2);

	if (alloc+numtags+numfields >= limit) {
	  GetHeapArea(toheap,pagesize,&alloc,limit_ptr);
	  assert(alloc);
	}
	obj = alloc + numtags;
	alloc += numtags+numfields;
	*alloc_ptr = alloc;
	bcopy((char *)(white-numtags),(char *)(obj-numtags),4*(numtags+numfields));
	obj[-1] = tag; /* the bcopy is getting the temporary stall(-1) tag */
	*vpp = (value_t)obj;
	white[0] = (value_t)obj;
	white[-1] = FORWARD_TAG;
	return;
      }
    case FORWARD_TAG:
      *vpp = white[0];
      white[-1] = FORWARD_TAG;
      return;
    case SKIP_TAG:
    default:
      printf("\n\nforward_stack: BAD TAG: white = %d, tag = %d\n",white,tag);
      BUG("forward_stack: IMPOSSIBLE TAG");
    }
  assert(0);
}


/* ------------ These forwarding routines/macros are the ones to use --------- */



value_t *forward_root_lists_minor(Queue_t *root_lists, value_t *to_ptr, 
				 range_t *from_range, range_t *to_range)
{
  long i, j, rlen = QueueLength(root_lists);
  for (i=0; i<rlen; i++)
    {
      Queue_t *roots = QueueAccess(root_lists,i);
      int qlen = QueueLength(roots);
      for (j=0; j<qlen; j++)
	{
	  value_t *temp = (value_t *)QueueAccess(roots,j);
	  forward_minor(temp,to_ptr,from_range);
	  NumRoots++;
	}
    }
  return to_ptr;
}


value_t *forward_root_lists_major(Queue_t *root_lists, value_t *to_ptr, 
				  range_t *from_range, range_t *from2_range, range_t *to_range)
{
  long i, j, rlen = QueueLength(root_lists);
  for (i=0; i<rlen; i++)
    {
      Queue_t *roots = QueueAccess(root_lists,i);
      int qlen = QueueLength(roots);
      for (j=0; j<qlen; j++)
	{
	  value_t *temp = (value_t *)QueueAccess(roots,j);
	  forward_major(temp,to_ptr,from_range,from2_range,to_range);
	  NumRoots++;
	}
    }
  return to_ptr;
}



/* -------------------------------------------------------------- */

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


void update_object_profile(Object_Profile_t *prof, value_t *objstart)
{
  value_t *tagstart = objstart - 1;
  int tag = *tagstart;
  switch(GET_TYPE(tag))
    {
    case IARRAY_TAG:
      prof->IArray++;
      prof->IArrayWord += ((GET_ARRLEN(tag) + 3) / 4) + 1;
      break;
    case RARRAY_TAG:
      prof->RArray++;
      prof->RArrayWord += GET_ARRLEN(tag) / 4 + 1;
      break;
    case PARRAY_TAG:
      prof->PArray++;
      prof->PArrayWord += GET_ARRLEN(tag) / 4 + 1;
      break;
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      {
	int len = 0;
	for(;;tagstart--)
	  {
	    int tag = *tagstart;
	    int temp = GET_RECLEN(tag);
	    if (temp > RECLEN_MAX)
	      len += RECLEN_MAX;
	    else 
	      len += temp;
	    if (GET_TYPE(tag) == RECORD_TAG)
	      break;
	    if (GET_TYPE(tag) != RECORD_SUB_TAG)
	      assert(0);
	  }
	prof->Record++;
	if (len == 2)
	  prof->Pair++;
	prof->RecordWord += len + 1;
      }
      return;
    case SKIP_TAG:
    case FORWARD_TAG:
      return;
    default:
      printf("objstart = %d\n",objstart);
      printf("Got a tag of %d\n",tag);
      assert(0);
      return;
    }
}

#ifdef HEAPPROFILE
void SetBirth(value_t *proftag_addr)
{
  unsigned int proftag = *proftag_addr;
  unsigned int oldage = proftag >> HP_AGESHIFT;
  /*
  printf("NumGC = %d   progtag_addr = %d, proftag = %d, oldage = %d\n",
	 NumGC,proftag_addr, proftag,oldage);
	 */
  if (oldage == 0)
    proftag += NumGC << HP_AGESHIFT;
  *proftag_addr = proftag;
}
#endif





/* --------------- Scanning routines ----------------------- */

value_t * scan_oneobject_major(value_t **where,  value_t *alloc_ptr, 
			       range_t *from_range, range_t *from2_range, range_t *to_range)
{
  value_t *cur = (value_t *)(*where);
  value_t tag = cur[0];
  value_t type= GET_TYPE(tag);
  value_t local_to_low = to_range->low;
  value_t local_to_diff = to_range->diff;

  if (tag == SKIP_TAG)
    {
      *where = cur + 1;
      return alloc_ptr;
    }



  switch (type)
    {
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      if (GET_RECLEN(tag) <= RECLEN_MAX)
	{
	  int i, fieldlen = GET_RECLEN(tag);
	  value_t *end = cur + 1 + fieldlen;
	  unsigned mask = GET_RECMASK(tag);
	  cur++;
	  for (; cur<end; cur++, mask >>= 1)
	    if (mask & 1)
	      forward_major(cur,alloc_ptr,from_range,from2_range,to_range);
	}
      else
	{
	  value_t *rawstart = cur;
	  int i, fieldlen = 0;
	  
	  value_t *objstart;
	  {
	    
	    value_t *curtag = rawstart;
	    while (1)
	      {
		int curlen = GET_RECLEN(*curtag);
		if (curlen <= RECLEN_MAX)
		  {
		    fieldlen += curlen;
		    break;
		  }
		else
		  fieldlen += RECLEN_MAX;
		curtag++;
	      }
	    objstart = curtag + 1;
	  }
	  for (i=0; i<fieldlen; i++)
	    {
	      unsigned int mask = GET_RECMASK(rawstart[i/RECLEN_MAX]);
	      if (mask & 1 << (i % RECLEN_MAX))
		forward_major(objstart+i,alloc_ptr,from_range,from2_range,to_range);
	    }
	  cur = objstart + fieldlen;
	}
      break;
    case SKIP_TAG:
      cur++;
      break;
    case IARRAY_TAG:
      {
	unsigned int upper = GET_ARRLEN(tag);
	upper = (upper + 3) / 4; /* round up to multiple of 4 first */
	if (upper == 0)
	  upper = 1;
	cur += 1 + upper;
	break;
      }
    case RARRAY_TAG:
      {
	unsigned int upper = GET_ARRLEN(tag);
	upper /= 4;   /* already a multiple of 8 */
	if (upper == 0)
	  upper = 1;
	cur += 1 + upper;
	break;
      }
    case PARRAY_TAG:
      {
	unsigned int upper = GET_ARRLEN(tag);
	upper /= 4;   /* already a multiple of 4 */
	if (upper == 0)
	  cur += 2;
	else
	  {
	    unsigned int *end = cur + 1 + upper;
	    cur++;
	    while (cur < end)
	      {
		forward_major((cur),alloc_ptr,from_range,from2_range,to_range);
		cur++;
	      }
	  }
	break;
      }
    case FORWARD_TAG:
    default:
      printf("\n\ntag = %d at cur=%d\n",tag,cur);
      printf("scan_gen: IMPOSSIBLE TAG\n");
      assert(0);
    }
  (*where) = cur;
  return alloc_ptr;
}


value_t * scan_oneobject_minor(value_t **where,  value_t *alloc_ptr, 
			       range_t *from_range,  range_t *to_range)
{
  value_t *cur = (value_t *)(*where);
  value_t tag = cur[0];
  value_t type= GET_TYPE(tag);
  value_t local_from_low = from_range->low;
  value_t local_from_diff = from_range->diff;

  if (tag == SKIP_TAG)
    {
      *where = cur + 1;
      return alloc_ptr;
    }

  switch (type)
    {
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      if (GET_RECLEN(tag) <= RECLEN_MAX)
	{
	  int i, fieldlen = GET_RECLEN(tag);
	  value_t *end = cur + 1 + fieldlen;
	  unsigned mask = GET_RECMASK(tag);
	  cur++;
	  for (; cur<end; cur++, mask >>= 1)
	    if (mask & 1)
	      forward_local_minor(cur,alloc_ptr);
	}
      else
	{
	  value_t *rawstart = cur;
	  int i, fieldlen = 0;
	  
	  value_t *objstart;
	  {
	    
	    value_t *curtag = rawstart;
	    while (1)
	      {
		int curlen = GET_RECLEN(*curtag);
		if (curlen <= RECLEN_MAX)
		  {
		    fieldlen += curlen;
		    break;
		  }
		else
		  fieldlen += RECLEN_MAX;
		curtag++;
	      }
	    objstart = curtag + 1;
	  }
	  for (i=0; i<fieldlen; i++)
	    {
	      unsigned int mask = GET_RECMASK(rawstart[i/RECLEN_MAX]);
	      if (mask & 1 << (i % RECLEN_MAX))
		forward_local_minor(objstart+i,alloc_ptr);
	    }
	  cur = objstart + fieldlen;
	}
      break;
    case SKIP_TAG:
      cur++;
      break;
    case IARRAY_TAG:
      {
	unsigned int upper = (GET_ARRLEN(tag) + 3) / 4;
	if (upper == 0)
	  upper = 1;
	cur += 1 + upper;
	break;
      }
    case RARRAY_TAG:
      {
	unsigned int upper = GET_ARRLEN(tag) / 4;
	if (upper == 0)
	  upper = 1;
	cur += 1 + upper;
	break;
      }
    case PARRAY_TAG:
      {
	unsigned int upper = GET_ARRLEN(tag) / 4;
	if (upper == 0)
	  cur += 2;
	else
	  {
	    unsigned int *end = cur + 1 + upper;
	    cur++;
	    while (cur < end)
	      {
		forward_local_minor(cur,alloc_ptr);
		cur++;
	      }
	  }
	break;
      }
    case FORWARD_TAG:
    default:
      printf("\n\nscan_gen impossible: forward tag = %d at cur=%d\n",tag,cur);
      assert(0);
    }
  (*where) = cur;
  return alloc_ptr;
}


value_t* scan_major(value_t start_scan, value_t *alloc_ptr, value_t *stop, 
		    range_t *from_range, range_t *from2_range, range_t *to_range)
{
  value_t *cur = (value_t *)start_scan;
  unsigned int a,b, c=0;
  value_t local_to_low = to_range->low;
  value_t local_to_diff = to_range->diff;


  while (cur < alloc_ptr && cur < stop)
    {
#ifdef HEAPPROFILE
      unsigned int proftag = *(cur++);
#endif
      value_t tag = cur[0];
      value_t type= GET_TYPE(tag);
      

#ifdef HEAPPROFILE
      if (proftag == SKIP_TAG)
	  continue; /* break; */
#endif

      if ((GET_TYPE(tag) == RECORD_TAG) && (GET_RECLEN(tag) <= 2))
	{
	  if (tag == TAG_REC_TRACETRACE)
	    {
	      forward_major(cur+1,alloc_ptr,from_range,from2_range,to_range);
	      forward_major(cur+2,alloc_ptr,from_range,from2_range,to_range);
	      cur += 3;
	      continue;
	    }
	  if (tag == TAG_REC_INTTRACE)
	    {
	      forward_major(cur+2,alloc_ptr,from_range,from2_range,to_range);
	      cur += 3;
	      continue;
	    }
	  if (tag == TAG_REC_EMPTY ||
	      tag == TAG_REC_INT)
	    {
	      cur += 2;
	      continue;
	    }
	  if (tag == TAG_REC_TRACE)
	    {
	      forward_major(cur+1,alloc_ptr,from_range,from2_range,to_range);
	      cur += 2;
	      continue;
	    }
	  if (tag == TAG_REC_INTINT)
	    {
	      cur += 3;
	      continue;
	    }
	  if (tag == TAG_REC_TRACEINT)
	    {
		forward_major(cur+1,alloc_ptr,from_range,from2_range,to_range);
		cur += 3;
		continue;
	    }
      }
      else if (GET_TYPE(tag) == SKIP_TAG)
	{
	  cur++;
	  continue;
	}

      {
	value_t *temp = cur;
	alloc_ptr = scan_oneobject_major(&temp, alloc_ptr, from_range, from2_range, to_range);
	cur = temp;
	continue;
      }
    }
  return alloc_ptr;
}



value_t* scan_nostop_minor(value_t start_scan, value_t *alloc_ptr, 
			   range_t *from_range, range_t *to_range)
{
  value_t *cur = (value_t *)start_scan;
  unsigned int a,b, c=0;
  value_t local_from_low = from_range->low;
  value_t local_from_diff = from_range->diff;

  while (cur < alloc_ptr)
    {
#ifdef HEAPPROFILE
      unsigned int proftag = *(cur++);
#endif
      value_t tag = cur[0];
      value_t type= GET_TYPE(tag);
      

#ifdef HEAPPROFILE
      if (proftag == SKIP_TAG)
	  continue; /* break; */
#endif

      if ((GET_TYPE(tag) == RECORD_TAG) && (GET_RECLEN(tag) <= 2))
	{
	  if (tag == TAG_REC_TRACETRACE)
	    {
	      forward_local_minor(cur+1,alloc_ptr);
	      forward_local_minor(cur+2,alloc_ptr);
	      cur += 3;
	    }
	  else if (tag == TAG_REC_INTTRACE)
	    {
	      forward_local_minor(cur+2,alloc_ptr);
	      cur += 3;
	    }
	  else if (tag == TAG_REC_EMPTY ||
		   tag == TAG_REC_INT)
	    {
	      cur += 2;
	    }
	  else if (tag == TAG_REC_TRACE)
	    {
	      forward_local_minor(cur+1,alloc_ptr);
	      cur += 2;
	    }
	  else if (tag == TAG_REC_INTINT)
	    {
	      cur += 3;
	    }
	  else if (tag == TAG_REC_TRACEINT)
	    {
		forward_local_minor(cur+1,alloc_ptr);
		cur += 3;
	    }
	  else 
	    alloc_ptr = scan_oneobject_minor(&cur, alloc_ptr, from_range, to_range);
      }
      else if (GET_TYPE(tag) == SKIP_TAG)
	cur++;
      else
	alloc_ptr = scan_oneobject_minor(&cur, alloc_ptr, from_range, to_range);
    }
  return alloc_ptr;
}


value_t* scan_stop_minor(value_t start_scan, value_t *alloc_ptr, value_t *stop,
			range_t *from_range, range_t *to_range)
{
  register value_t *cur = (value_t *)start_scan;
  register value_t local_from_low = from_range->low;
  register value_t local_from_diff = from_range->diff;


  while (cur < stop)
    {

#ifdef HEAPPROFILE
      unsigned int proftag = *(cur++);
#endif
      
      value_t tag = cur[0]; /* note that declaration of variable causes a stack slot
				 allocated for it by the C compiler */


      
#ifdef HEAPPROFILE
      if (proftag == SKIP_TAG)
	continue; /* break; */
#endif
      if (tag == SKIP_TAG)
	continue;
      if ((GET_TYPE(tag) == RECORD_TAG) && (GET_RECLEN(tag) <= 2))
	{
	  if (tag == TAG_REC_TRACETRACE)
	    {
	      forward_local_minor(cur+1,alloc_ptr);
	      forward_local_minor(cur+2,alloc_ptr);
	      cur += 3;
	    }
	  else if (tag == TAG_REC_INTTRACE)
	    {
	      forward_local_minor(cur+2,alloc_ptr);
	      cur += 3;
	    }
	  else if (tag == TAG_REC_EMPTY ||
		   tag == TAG_REC_INT)
	    {
	      cur += 2;
	    }
	  else if (tag == TAG_REC_TRACE)
	    {
	      forward_local_minor(cur+1,alloc_ptr);
	      cur += 2;
	    }
	  else if (tag == TAG_REC_INTINT)
	    {
	      cur += 3;
	    }
	  else if (tag == TAG_REC_TRACEINT)
	    {
		forward_local_minor(cur+1,alloc_ptr);
		cur += 3;
	    }
	  else 
	    {
	      value_t *temp = cur;
	      alloc_ptr = scan_oneobject_minor(&temp, alloc_ptr, from_range, to_range);
	      cur = temp;
	    }
	}
      else if (GET_TYPE(tag) == SKIP_TAG)
	  cur++;
      else 
	{
	  value_t *temp = cur;
	  alloc_ptr = scan_oneobject_minor(&temp, alloc_ptr, from_range, to_range);
	  cur = temp;
	}
    }

  return alloc_ptr;
}
  
void scan_oneobject_minor_stack(value_t *gray,  value_t **alloc_ptr, value_t **limit_ptr, Heap_t *toheap,
				range_t *from_range,  range_t *to_range, SysThread_t *sysThread)
{
  value_t tag = gray[-1];
  value_t type= GET_TYPE(tag);
  value_t local_from_low = from_range->low;
  value_t local_from_diff = from_range->diff;
  value_t *alloc = *alloc_ptr;
  value_t *limit = *limit_ptr;

  if (tag == SKIP_TAG)
    assert(0);

  while (tag == stall)
    tag = gray[-1];

  switch (type)
    {
    case RECORD_TAG:
    case RECORD_SUB_TAG:
      if (GET_RECLEN(tag) <= RECLEN_MAX)
	{
	  int i, fieldlen = GET_RECLEN(tag);
	  value_t *end = gray + fieldlen;
	  unsigned mask = GET_RECMASK(tag);
	  for (; gray<end; gray++, mask >>= 1)
	    if (mask & 1)
	      forward_local_minor_stack(gray,alloc,limit,toheap,sysThread);
	}
      else
	{
	  value_t *rawstart = gray-1;
	  int i, fieldlen = 0;
	  
	  while (1)
	    {
	      int curlen = GET_RECLEN(*rawstart);
	      if (curlen <= RECLEN_MAX)
		fieldlen += curlen;
	      else
		fieldlen += RECLEN_MAX;
	      if (IS_RECORD(*rawstart))
		break;
	      rawstart--;
	  }
	  for (i=0; i<fieldlen; i++)
	    {
	      unsigned int mask = GET_RECMASK(rawstart[i/RECLEN_MAX]);
	      if (mask & 1 << (i % RECLEN_MAX))
		forward_local_minor_stack(gray+i,alloc,limit,toheap,sysThread);
	    }
	}
      break;
    case IARRAY_TAG:
      break;
    case RARRAY_TAG:
      break;
    case PARRAY_TAG:
      {
	unsigned int len = GET_ARRLEN(tag) / 4, i;
	for (i=0; i<len; i++) {
	  forward_local_minor_stack(gray,alloc,limit,toheap,sysThread);
	  gray++;
	}
	break;
      }
    case SKIP_TAG:
    case FORWARD_TAG:
    default:
      printf("\n\nScan_oneobject_minor_stack impossible: tag = %d at gray=%d\n",tag,gray);
      assert(0);
    }

  *alloc_ptr = alloc;
  *limit_ptr = limit;
}


void scan_minor_stack(value_t *gray, value_t **alloc_ptr, value_t **limit_ptr, Heap_t *toheap,
		      range_t *from_range, range_t *to_range, SysThread_t *sysThread)
{
  value_t local_from_low = from_range->low;
  value_t local_from_diff = from_range->diff;
  value_t *alloc = *alloc_ptr;
  value_t *limit = *limit_ptr;

#ifdef HEAPPROFILE
  unsigned int proftag = gray[-2];
#endif
  value_t tag = gray[-1];
  value_t type = GET_TYPE(tag);

#ifdef DEBUG
  assert(type != SKIP_TAG);
#endif

  if ((GET_TYPE(tag) == RECORD_TAG) && (GET_RECLEN(tag) <= 2))
    {
      if (tag == TAG_REC_TRACETRACE)
	{
	  forward_local_minor_stack(gray,alloc,limit,toheap,sysThread);
	  forward_local_minor_stack(gray+1,alloc,limit,toheap,sysThread);
	}
      else if (tag == TAG_REC_INTTRACE)
	{
	  forward_local_minor_stack(gray+1,alloc,limit,toheap,sysThread);
	}
      else if (tag == TAG_REC_EMPTY ||
	       tag == TAG_REC_INT ||
	       tag == TAG_REC_INTINT)
	{
	}
      else if (tag == TAG_REC_TRACE ||
	       tag == TAG_REC_TRACEINT)
	{
	  forward_local_minor_stack(gray,alloc,limit,toheap,sysThread);
	}
      else 
	scan_oneobject_minor_stack(gray, &alloc, &limit, toheap, from_range, to_range,sysThread);
    }
  else if (GET_TYPE(tag) == SKIP_TAG)
    assert(0);
  else
    scan_oneobject_minor_stack(gray, &alloc, &limit, toheap, from_range, to_range,sysThread);

  *alloc_ptr = alloc;
  *limit_ptr = limit;
}

