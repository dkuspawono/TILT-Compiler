	
 ! start_client makes assumption about how to invoke closures and thread pointer structure
	
#define _asm_
#include "general.h"
#include "thread.h"
		
	.section ".text"
	.align	4
 	.globl	start_client
 	.globl	start_client_retadd_val
	.globl  global_exnrec
        .globl  GetTick
	.globl	raise_exception_raw
	.globl	Overflow_exncon
	.globl	Divide_exncon
	.globl  FetchAndAdd
	.globl  TestAndSet
	.globl  Yield
	.globl	flushStore

	.proc	07
	.align	4
flushStore:
	membar	#StoreStore | #StoreLoad | #LoadLoad | #LoadStore | #Sync | #MemIssue | #Lookaside
	retl
	nop
			
 ! ----------------------------------------------------------------------------	
 ! FetchAndAdd takes the address of the variable to be incremented (%o0) and the increment (%o1)
 ! Returns the pre-incremented value (%o0)
 ! Don't use register windows;  unused parameters slots used as temp (%o2 and %o3)
 ! ----------------------------------------------------------------------------
        .proc	07
	.align	4  
FetchAndAdd:	
	ld	[%o0], %o2
	add	%o2, %o1, %o3
	cas	[%o0], %o2, %o3
	cmp	%o2, %o3
	bne	FetchAndAdd
	nop
	mov	%o2, %o0
        retl
	nop
        .size FetchAndAdd,(.-FetchAndAdd)

 ! ----------------------------------------------------------------------------	
 ! TestAndSet takes the address of the variable to be test-and-set
 ! If the value was 0, it is set to 1.  Returns 1.
 ! If the value was 1, it is unchanged.  Returns 0.
 ! If the value is not 0 or 1, then the result is unpredictable.
 ! Under the Sparc, this sequence requires no retry.
 ! Don't use register windows	;  parameters come in and result leaves in %o0; %o1 is scratch
 ! ----------------------------------------------------------------------------
        .proc	07
	.align  4
TestAndSet:
	mov	1, %o1
	cas	[%o0], %g0, %o1
	xor	%o1, 1, %o0
        retl     
	nop
	.size   TestAndSet,(.-TestAndSet)


 ! ----------------------------------------------------------------------------	
 ! one might call GetTick twice and take the different between the two results
 ! to obtain the number of intervening cycles used
 ! Done use register windows;  result leaves in %o0
 ! ----------------------------------------------------------------------------	
        .proc	07
	.align  4
GetTick:	
        rd	%tick, %o0
        retl
	nop
        .size   GetTick,(.-GetTick)

	
 ! ------------------------ start_client  -------------------------------------
 ! first C arg = current thread pointer
 ! ----------------------------------------------------------------------------
	.proc	07
	.align	4
start_client:
	mov	%o0, THREADPTR_REG		! initialize thread ptr outside loop
	call	load_regs			! restore dedicated pointers like
						! heap pointer, heap limit, and stack pointer
	nop
	ba	start_client_retadd_val
	nop
thunk_loop:
	st	%g0, [THREADPTR_REG + notinml_disp]
 	ld	[THREADPTR_REG + nextThunk_disp], %o0		! fetch nextThunk
	add	%o0, 1, %o1					! increment and
 	st	%o1, [THREADPTR_REG + nextThunk_disp]		!   save nextThunk
 	ld	[THREADPTR_REG + thunk_disp], %o1		! fetch thunks
	sll	%o0, 2, %o0				
	add	%o1, %o0, %o0				! %o0 holds current thunk's address
	ld	[%o0], ASMTMP_REG			! fetch current thunk
	ld	[ASMTMP_REG + 0], LINK_REG		! fetch code pointer
	ld	[ASMTMP_REG + 4], %o0			! fetch type env
	ld	[ASMTMP_REG + 8], %o2			! fetch term env
        sethi   %hi(global_exnrec),EXNPTR_REG
	or      EXNPTR_REG,%lo(global_exnrec),EXNPTR_REG  ! install global handler
	jmpl	LINK_REG, %o7				! jump to thunk
	nop
start_client_retadd_val:					! used by stack.c

	ld	[THREADPTR_REG + nextThunk_disp], %o0		! fetch nextThunk

	
	ld	[THREADPTR_REG + numThunk_disp], %o1		! fetch numThunk
	cmp	%o0, %o1
	bl	thunk_loop					! execute if nextThunk < numThunk
	nop
	mov	1, ASMTMP_REG
	st	ASMTMP_REG, [THREADPTR_REG + notinml_disp]
	call	save_regs					! need to save register set to get 
								!   alloction pointer into thread state
	nop
	ld	[THREADPTR_REG + sysThread_disp], ASMTMP_REG	! get system thread pointer
	ld	[ASMTMP_REG], SP_REG				! run on system thread stack	
	call	Finish
	nop
        sethi   %hi($$errormsg),%o0				! should not return from Finish
	or      %o0,%lo($$errormsg),%o0  
	call	printf
	nop
	call	abort
	nop
	.size	start_client,(.-start_client)

	
 ! -------------------------------------------------------------------------------
 ! Yield - called by mutator as a C function 
 ! (1) Don't call save_regs and load_regs
 ! (2) Make sure %l0 contains thread pointer for use by save_regs_forC
 ! -------------------------------------------------------------------------------
	.proc	07
	.align	4
Yield:
	st	LINK_REG, [THREADPTR_REG + LINK_DISP]    ! note that this is return address of Yield
	ld	[THREADPTR_REG + sysThread_disp],ASMTMP_REG ! get system thread pointer into temp
	ld	[ASMTMP_REG], SP_REG			! run on system thread stack
	call	YieldRest				! no need to restore $gp after this call
	nop
	mov	%o0, THREADPTR_REG			! user thread pointer returned
	mov	%o0, %l0				! fix %l0 for use by save_regs_forC
	ld	[THREADPTR_REG + LINK_DISP], LINK_REG	! note that this is return address of Yield
	retl
	nop
	.size	Yield,(.-Yield)



 ! ------------------------------------------------------------
 ! global_exnhandler when all else fails
 ! saves all registers and calls C function toplevel_exnhandler with thread pointer
 ! ------------------------------------------------------------
	.proc	07
	.align	4
global_exnhandler:
	st	EXNARG_REG, [THREADPTR_REG + EXNARG_DISP]    ! note that this is return address of Yield
	call	save_regs
	nop
	mov	THREADPTR_REG, %o0
	call	toplevel_exnhandler
	nop
	call	abort
	nop
	.size	global_exnhandler,(.-global_exnhandler)

 ! ------------------------------------------------------------
 ! first C arg = thread structure
 ! second C arg = exn argument	;  will eventually pass in return address
 ! third C arg = exn code handler address
 ! Don't use register window
 ! ------------------------------------------------------------
	.proc	07
	.align	4
raise_exception_raw:
	mov	%o0, THREADPTR_REG		! save where regs are
	mov	%o1, RESULT_REG			! load_Iregs_forC does not change this reg
	st	%o2, [SP_REG + 24]		! save handler address
	call	load_regs_forC
	nop
	mov	RESULT_REG, EXNARG_REG		! restore exn arg
	ld	[EXNPTR_REG], ASMTMP_REG	! fetch exn handler code
	jmpl	ASMTMP_REG, %g0			! jump not return and do not link
	nop
	.size	raise_exception_raw,(.-raise_exception_raw)

	.data
Overflow_exncon:
	.word	Prelude_31_Overflow_1
Divide_exncon:
	.word	Prelude_57_Div_1

	
	.data

 ! a triple to represent the top-level exn record
	.align 4
	.word   (3 << 27) + (0 << 3) + 0
global_exnrec:
	.word	global_exnhandler
	.word   0
	.word	0
	.type   global_exnrec,#object
	.size   global_exnrec,4
	
	.align 4
$$errormsg:
	.ascii "Thread Finish returned!!!\n\000"

	.align 4
$$global_exnmsg:
	.ascii "Runtime Error: Uncaught exception!!!\n\000"
	
