/* Assumes exceptions look a certain way in the creation of the divide and overflow exception */
#include "general.h"
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
/*
#include <siginfo.h>
#include <machine/fpu.h>
*/
#include <sys/sysinfo.h>
#include <sys/proc.h>
#include <string.h>
#include "tag.h"
#include "exn.h"
#include "create.h"
#include "til-signal.h"
#include "global.h"
#include "thread.h"

exn divide_exn;
exn overflow_exn;
extern int Divide_exncon;
extern int Overflow_exncon;
extern void raise_exception_raw(long *regs, value_t exn_arg, value_t code);


void exn_init()
{
  static int buf[100];
  static value_t alloc=0, limit=0;
  if (!alloc)
    {
      alloc = (value_t) buf;
      limit = alloc + 100 * sizeof(int);
    }
  divide_exn = alloc_recrec(*(value_t *)Divide_exncon,0);
  overflow_exn = alloc_recrec(*(value_t *)Overflow_exncon,0);
}

void raise_exception(struct sigcontext *scp, exn exn_arg)
{
  long *the_iregs = (long *) GetIRegs(scp);
  value_t exn_ptr = (value_t)(the_iregs[EXNPTR_REG]);
  value_t code = get_record(exn_ptr,0);

#ifdef DEBUG
  {
    int i;
    fprintf(stderr,"\n\n--------exn_raise entered---------\n");
    fprintf(stderr,"raise: exn_ptr is %d\n",exn_ptr);
    fprintf(stderr,"raise: rec[-1] is %d\n",((int *)exn_ptr)[-1]);
    fprintf(stderr,"raise: rec[0] is %d\n",((int *)exn_ptr)[0]);
    for (i=0; i<32; i++)
      fprintf(stderr,"RAISE: the_iregs[%d] is %ld\n",i,the_iregs[i]);
    fprintf(stderr,"raise: the_iregs[0] is %d\n",the_iregs[0]);
    fprintf(stderr,"raise: the_iregs[at] is %d\n",the_iregs[ASMTMP_REG]);
    fprintf(stderr,"returning from exn_raise to asm linkage\n");
  }
#endif
  
  raise_exception_raw(the_iregs,exn_arg,code);
}

void toplevel_exnhandler(long *saveregs)
{
  char buf[100];
  char *msg;
  value_t exn_arg = (saveregs[EXNARG_REG]);
  value_t first = get_record(exn_arg,0);

  if (first == *(value_t *)Divide_exncon)
    { msg = "Divide by zero"; }
  else if (first == *(value_t *)Overflow_exncon)
    { msg = "Overflow"; }
  else
    {
      value_t name = get_record(exn_arg,2);
      unsigned int tag = ((int *)name)[-1];
      int bytelen = GET_ARRLEN(tag);
      bcopy((char *)name,buf,bytelen);
      buf[bytelen] = 0;
      msg = buf;
    }
  
  printf("Runtime uncaught exception: %s\n",msg);
  Finish();
}
