 # Remember to be careful about the usage of $gp.  This code assumes
 # that the save area begins with 32 longs and then 32 doubles and
 # that the thread pointer is unmodified by call to GCFromML.  Code
 # that transitions from ML to C must set the thread-specific value
 # notInML (used by signal handlers).  Code that transitions from C to
 # ML must clear notInML.

#define _asm_
#include "general.h"
#include "thread.h"

	.text
	.align	4

	.globl	load_regs		# helper function used locally and in service_alpha_asm.s
	.globl	save_regs		# helper function used locally and in service_alpha_asm.s
	.globl  NewStackletFromML	# called from ML mutator function prologs
	.globl  PopStackletFromML	# (installed by runtime) called before ML mutator function epilogs
	.globl	RestoreStackFromML
	.globl	GCFromML		# called from ML mutator
	.globl	returnFromGCFromML	# used by scheduler to go back to ML
	.globl	GCFromC			# called from C function including those of runtime
	.globl	returnFromGCFromC	# used by scheduler to go back to C function
	.globl	returnFromYield		# used by scheduler to go back to ML mutator's Yield
	.globl	returnToML
	.globl	save_regs_MLtoC		# used by ML mutator before calling a C function
	.globl	load_regs_MLtoC		# used by ML mutator after calling a C function
 	.globl	start_client
	.globl  global_exnrec
        .globl  GetRpcc
	.globl	raise_exception_raw
	.globl  CompareAndSwap
	.globl  FetchAndAdd
	.globl  TestAndSet
	.globl  Yield
	.globl  Spawn
	.globl  scheduler
	.globl	memOrder
	.globl	memBarrier

 # ----------------- save_regs---------------------------------
 # save_regs stores both GP and FP registers (exceptions noted) into the save area pointed to by v0.
 # It will then return to the caller using the standard r26.
 # The save area begins with the GP area and then the FP area.
 #
 # r0 is skipped because it is used as the argument register to the save area
 # r1 is skipped so the caller can use it as a temp register
 # r12 is skipped because it is the THREADPTR_REG
 # r26 is skipped because it is our return address
 # r29 is skipped because it is the gp register which is needed by caller
 # r31 is skipped because it is the zero register
 # The called must take care to save r0, r1, r26, r29 manually
 # ----------------------------------------------------------
	.ent	save_regs
	.frame $sp, 0, $26
save_regs:
.set noat
 #	stq	$0, ($0)		# skip save area argument register
 #	stq	$1, 8($0)		# skip temp register used by caller
	stq	$2, 16($0)
	stq	$3, 24($0)
	stq	$4, 32($0)
	stq	$5, 40($0)
	stq	$6, 48($0)
	stq	$7, 56($0)
	stq	$8, 64($0)
	stq	$9, 72($0)
	stq	$10, 80($0)
	stq	$11, 88($0)
 #	stq	$12, 96($0)		# skip thread pointer register
	stq	$13, 104($0)
	stq	$14, 112($0)
	stq	$15, 120($0)
	stq	$16, 128($0)
	stq	$17, 136($0)
	stq	$18, 144($0)
	stq	$19, 152($0)
	stq	$20, 160($0)
	stq	$21, 168($0)
	stq	$22, 176($0)
	stq	$23, 184($0)
	stq	$24, 192($0)
	stq	$25, 200($0)
 #	stq	$26, 208($0)		# skip return address register
	stq	$27, 216($0)
	stq	$28, 224($0)
 #	stq	$29, 232($0)		# skip GP register
	stq	$30, 240($0)
 #	stq	$31, 248($0)		# skip zero register
	stt	$f0, 256($0)
	stt	$f1, 264($0)
	stt	$f2, 272($0)
	stt	$f3, 280($0)
	stt	$f4, 288($0)
	stt	$f5, 296($0)
	stt	$f6, 304($0)
	stt	$f7, 312($0)
	stt	$f8, 320($0)
	stt	$f9, 328($0)
	stt	$f10, 336($0)
	stt	$f11, 344($0)
	stt	$f12, 352($0)
	stt	$f13, 360($0)
	stt	$f14, 368($0)
	stt	$f15, 376($0)
	stt	$f16, 384($0)
	stt	$f17, 392($0)
	stt	$f18, 400($0)
	stt	$f19, 408($0)
	stt	$f20, 416($0)
	stt	$f21, 424($0)
	stt	$f22, 432($0)
	stt	$f23, 440($0)
	stt	$f24, 448($0)
	stt	$f25, 456($0)
	stt	$f26, 464($0)
	stt	$f27, 472($0)
	stt	$f28, 480($0)
	stt	$f29, 488($0)
	stt	$f30, 496($0)
	stt	$f31, 504($0)
						# perform consistency check
	ldq	$2, MLsaveregs_disp+96($12)	# use $2 to hold the memory-version of thread pointer
	cmpeq	$2, $12, $2			# is memory version same as threadptr register
	bne	$2, save_regs_ok
	ldq	$16, MLsaveregs_disp+96($12)
	mov	$12, $17
	br	$gp, save_regs_getgp
save_regs_getgp:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	save_regs_fail
save_regs_ok:
	ldq	$2, 16($0)			# restore $2
	ret	$31, ($26), 1
.set at
	.end	save_regs

 # ----------------- load_regs---------------------------------
 # load_regs restores the GP and FP registers (exceptions noted) from the save area pointed to by $0.
 # It will then return to the caller by using $26
 # The save area begins with the GP area and then the FP area.
 #
 # See the comment for save_regs for why these register are skipped:
 # r0, r1, r12, r26, r29, r31 are skipped
 # The called must take care to restore r0, r1, r26, r29 manually
 # ----------------------------------------------------------
	.ent	load_regs
	.frame $sp, 0, $26
load_regs:
.set noat
 #	ldq	$0, ($0)		# skip save area argument register
 #	ldq	$1, 8($0)		# skip temp register of caller
	ldq	$2, 16($0)
	ldq	$3, 24($0)
	ldq	$4, 32($0)
	ldq	$5, 40($0)
	ldq	$6, 48($0)
	ldq	$7, 56($0)
	ldq	$8, 64($0)
	ldq	$9, 72($0)
	ldq	$10, 80($0)
	ldq	$11, 88($0)
 #	ldq	$12, 96($0)		# skip thread pointer register
	ldq	$13, 104($0)
	ldq	$14, 112($0)
	ldq	$15, 120($0)
	ldq	$16, 128($0)
	ldq	$17, 136($0)
	ldq	$18, 144($0)
	ldq	$19, 152($0)
	ldq	$20, 160($0)
	ldq	$21, 168($0)
	ldq	$22, 176($0)
	ldq	$23, 184($0)
	ldq	$24, 192($0)
	ldq	$25, 200($0)
 #	ldq	$26, 208($0)		# skip return address register
	ldq	$27, 216($0)
	ldq	$28, 224($0)
 #	ldq	$29, 232($0)		# skip gp
	ldq	$30, 240($0)
 #	ldq	$31, 248($0)		# skip zero register
	ldt	$f0, 256($0)
	ldt	$f1, 264($0)
	ldt	$f2, 272($0)
	ldt	$f3, 280($0)
	ldt	$f4, 288($0)
	ldt	$f5, 296($0)
	ldt	$f6, 304($0)
	ldt	$f7, 312($0)
	ldt	$f8, 320($0)
	ldt	$f9, 328($0)
	ldt	$f10, 336($0)
	ldt	$f11, 344($0)
	ldt	$f12, 352($0)
	ldt	$f13, 360($0)
	ldt	$f14, 368($0)
	ldt	$f15, 376($0)
	ldt	$f16, 384($0)
	ldt	$f17, 392($0)
	ldt	$f18, 400($0)
	ldt	$f19, 408($0)
	ldt	$f20, 416($0)
	ldt	$f21, 424($0)
	ldt	$f22, 432($0)
	ldt	$f23, 440($0)
	ldt	$f24, 448($0)
	ldt	$f25, 456($0)
	ldt	$f26, 464($0)
	ldt	$f27, 472($0)
	ldt	$f28, 480($0)
	ldt	$f29, 488($0)
	ldt	$f30, 496($0)
	ldt	$f31, 504($0)
						# perform consistency check
	ldq	$2, MLsaveregs_disp+96($12)	# use $2 to hold the memory-version of thread pointer
	cmpeq	$2, $12, $2			# is memory version same as threadptr register
	bne	$2, load_regs_ok
	ldq	$16, MLsaveregs_disp+96($12)
	mov	$12, $17
	br	$gp, load_regs_getgp
load_regs_getgp:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	load_regs_fail
load_regs_ok:
	ldq	$2, 16($0)			# restore $2
	ret	$31, ($26), 1
.set at
	.end	load_regs

 # ----------------- NewStackletFromML --------------------------------------------------------------------
 # When an ML function A calls B, the prolog of B checks if a new stacklet is necessary.  If so, this routine is called.
 # Rra:	 The return address back to B comes in the normal return address register
 # Rat2: The return address of B back to A is saved in Rat2
 # Rat:	 Rat (normal temp) contains offset above highest argument retrieved from previous frame for additional arguments
 # does not use a stack frame
 # -----------------------------------------------------------------------------------------------------
	.ent	NewStackletFromML
	.frame $sp, 0, $26
	.prologue 0
NewStackletFromML:
.set noat
	stq	$0,  MLsaveregs_disp(THREADPTR_REG)	# save $0, $1, $26, $29 manually
	stq	$1,  MLsaveregs_disp+8(THREADPTR_REG)
	stq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG)
	stq	$29, MLsaveregs_disp+232(THREADPTR_REG)
	br	$gp, NewStackletFromMLgetgp1
NewStackletFromMLgetgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/c call
	mov	1, $0
	stq	$0, notinml_disp(THREADPTR_REG)		# leaving ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer
	bsr	save_regs
	mov	THREADPTR_REG, CFIRSTARG_REG		# pass user thread pointer as arg
	mov	ASMTMP_REG, CSECONDARG_REG		# pass max offset we need to copy
	ldq	ASMTMP_REG, proc_disp(THREADPTR_REG)	# get system thread pointer
	ldq	$sp, (ASMTMP_REG)			# run on system thread stack
	jsr	$26, NewStackletFromMutator
	br	$gp, NewStackletFromMLgetgp2
NewStackletFromMLgetgp2:
	ldgp	$gp, 0($gp)				# compute self-gp for abort
	jsr	abort
	nop
.set at
	.end	NewStackletFromML


 # ----------------- PopStackletFromML --------------------------------------------------------------------
 # return address comes in normal return address register
 # does not use a stack frame
 # -----------------------------------------------------------------------------------------------------
	.ent	PopStackletFromML
	.frame $sp, 0, $26
	.prologue 0
PopStackletFromML:
.set noat
	stq	$0,  MLsaveregs_disp(THREADPTR_REG)	# save $0, $1, $26, $29 manually
	stq	$1,  MLsaveregs_disp+8(THREADPTR_REG)
	stq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG)
	stq	$29, MLsaveregs_disp+232(THREADPTR_REG)
	br	$gp, PopStackletFromMLgetgp1
PopStackletFromMLgetgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/c call
	mov	1, $0
	stq	$0, notinml_disp(THREADPTR_REG)		# leaving ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer
	bsr	save_regs
	mov	THREADPTR_REG, CFIRSTARG_REG		# pass user thread pointer as arg
	ldq	ASMTMP_REG, proc_disp(THREADPTR_REG)	# get system thread pointer
	ldq	$sp, (ASMTMP_REG)			# run on system thread stack
	jsr	$26, PopStackletFromMutator
	br	$gp, PopStackletFromMLgetgp2
PopStackletFromMLgetgp2:
	ldgp	$gp, 0($gp)				# compute self-gp for abort
	jsr	abort
	nop
.set at
	.end	PopStackletFromML

 # ----------------- RestoreStackFromML ----------------------------------------------------------------
 # This routine is called when raising an exception sets $sp outside the top stacklet.
 # -----------------------------------------------------------------------------------------------------
	.ent	RestoreStackFromML
	.frame $sp, 0, $26
	.prologue 0
RestoreStackFromML:
.set noat
	stq	$0,  MLsaveregs_disp(THREADPTR_REG)	# save $0, $1, $26, $29 manually
	stq	$1,  MLsaveregs_disp+8(THREADPTR_REG)
	stq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG)
	stq	$29, MLsaveregs_disp+232(THREADPTR_REG)
	br	$gp, RestoreStackFromMLgetgp1
RestoreStackFromMLgetgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/c call
	mov	1, $0
	stq	$0, notinml_disp(THREADPTR_REG)		# leaving ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer
	bsr	save_regs
	mov	THREADPTR_REG, CFIRSTARG_REG		# pass user thread pointer as arg
	ldq	ASMTMP_REG, proc_disp(THREADPTR_REG)	# get system thread pointer
	ldq	$sp, (ASMTMP_REG)			# run on system thread stack
	jsr	$26, RestoreStackFromMutator
	br	$gp, RestoreStackFromMLgetgp2
RestoreStackFromMLgetgp2:
	ldgp	$gp, 0($gp)				# compute self-gp for abort
	jsr	abort
	nop
.set at
	.end	RestoreStackFromML

 # ----------------- GCFromML ---------------------------------
 # return address comes in normal return address register
 # temp register contains heap pointer + request size
 # does not use a stack frame
 # ----------------------------------------------------------
	.ent	GCFromML
	.frame $sp, 0, $26
	.prologue 0
GCFromML:
.set noat
	stq	$0,  MLsaveregs_disp(THREADPTR_REG)	# save $0, $1, $26, $29 manually
	stq	$1,  MLsaveregs_disp+8(THREADPTR_REG)
	stq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG)
	stq	$29, MLsaveregs_disp+232(THREADPTR_REG)
	br	$gp, GCFromMLgetgp1
GCFromMLgetgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/gc
	mov	1, $0
	stq	$0, notinml_disp(THREADPTR_REG)		# leaving ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer
	bsr	save_regs
	subl	$at, ALLOCPTR_REG, $at			# compute how many bytes requested
	stq	$at, requestInfo_disp(THREADPTR_REG)	# record bytes needed
	lda	$at, GCRequestFromML($31)
	stq	$at, request_disp(THREADPTR_REG)	# record that this is an MLtoGC request
	ldq	$at, proc_disp(THREADPTR_REG)		# get system thread pointer
	ldq	$sp, ($at)				# run on system thread stack
	mov	THREADPTR_REG, $16			# pass user thread pointer as arg
	jsr	$26, GCFromMutator
	br	$gp, GCFromMLgetgp2
GCFromMLgetgp2:
	ldgp	$gp, 0($gp)				# compute self-gp for abort
	jsr	abort
	nop
.set at
	.end	GCFromML


 # --------------------------------------------------------
 # Called from the runtime with the thread pointer argument.
 # Note returnToML does the normal C -> ML transition work for us.
 # --------------------------------------------------------
	.ent	returnFromGCFromML
.set noat
returnFromGCFromML:
	ldgp	$gp, 0($27)				# fix gp
	ldq	CSECONDARG_REG, RA_DISP(CFIRSTARG_REG)
	br	returnToML
	br	$gp, returnFromGCFromMLgetgp
returnFromGCFromMLgetgp:
	ldgp	$gp, 0($gp)				# compute correct gp for self
	jsr	abort
.set at
	.end	returnFromGCFromML

 # -------------------------------------------------------------------------------
 # returnToML is called from the runtime with
 # thread pointer as 1st argument
 # link value/return address as 2nd argument - this may or may not be the same saveregs[RA]
 # -------------------------------------------------------------------------------
	.ent	returnToML
.set noat
returnToML:
	ldgp	$gp, 0($27)				# compute self-gp for load_regs
	mov	CFIRSTARG_REG, THREADPTR_REG		# restore THREADPTR_REG
	mov	CSECONDARG_REG, $1			# use $1 as temp for return address
	stq	$31, notinml_disp(THREADPTR_REG)	# set notInML to zero
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer structure
	bsr	load_regs
	mov	$1, ASMTMP2_REG
	ldq	$1, MLsaveregs_disp+8(THREADPTR_REG)	# restore r1 which was used to save return address
	ldq	$0, MLsaveregs_disp+0(THREADPTR_REG)	# restore r0 which was used as arg to load_regs
	ldq	$gp, MLsaveregs_disp+232(THREADPTR_REG)	# restore r29/gp return address
	ldq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG) # restore return address register but not used to get back to ML
	ret	$31, (ASMTMP2_REG), 1
	br	$gp, returnToMLgetgp1
returnToMLgetgp1:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
	nop
.set at
	.end    returnToML

 # ----------------- GCFromC ---------------------------------
 # gcFromC is called from the runtime system with 3 arguments:
 #	thread pointer, request size, a bool for majorGC
 # gcFromC does not use a stack frame
 # ----------------------------------------------------------
	.ent	GCFromC
	.frame	$sp, 0, $26
	.prologue
GCFromC:
.set noat
	mov	CFIRSTARG_REG, THREADPTR_REG			# restore thread pointer
								# don't change notInML
	stq	$0 , Csaveregs_disp(THREADPTR_REG)		# we save $0, $1, $26 manually
	stq	$1 , Csaveregs_disp+8(THREADPTR_REG)
	stq	$26, Csaveregs_disp + RA_DISP(THREADPTR_REG)
	stq	$29, Csaveregs_disp+232(THREADPTR_REG)
	br	$gp, GCFromCgetgp1
GCFromCgetgp1:
	ldgp	$gp, 0($gp)					# compute self-gp for save_regs/gc
	addq	THREADPTR_REG, Csaveregs_disp, $0		# use C save area of thread pointer
	bsr	save_regs
	stq	CSECONDARG_REG, requestInfo_disp(THREADPTR_REG)	# record bytes needed
	mov	GCRequestFromC, ASMTMP_REG
	stq	ASMTMP_REG, request_disp(THREADPTR_REG)		# record that this is an CtoGC request
	cmpeq	$31, CTHIRDARG_REG, ASMTMP_REG
	bne	ASMTMP_REG, MinorGCFromC
	nop
	mov	MajorGCRequestFromC, ASMTMP_REG
	stq	ASMTMP_REG, request_disp(THREADPTR_REG)		# record that this is an CtoGC request
MinorGCFromC:
	ldq	ASMTMP_REG, proc_disp(THREADPTR_REG)		# must use temp so SP always correct
	ldq	$sp, (ASMTMP_REG)				# run on system thread stack
	mov	THREADPTR_REG, CFIRSTARG_REG			# pass user thread pointer as arg
	jsr	GCFromMutator					# call runtime GC
	br	$gp, GCfromCgetgp2
GCfromCgetgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
	nop
.set at
	.end GCFromC

 # -------------------------------------------------------------------------------
 # returnFromGCFromC is called from the runtime with the thread pointer argument
 # -------------------------------------------------------------------------------
	.ent	returnFromGCFromC
	.frame	$sp, 0, $26
	.prologue
returnFromGCFromC:
.set noat
	ldgp	$gp, 0($27)				# compute self-gp for load_regs
	mov	CFIRSTARG_REG, THREADPTR_REG		# restore THREADPTR_REG
							# don't change notInML
	addq	THREADPTR_REG, Csaveregs_disp, $0	# use C save area of thread pointer structure
	bsr	load_regs				# don't need to save return address
	ldq	$0, Csaveregs_disp(THREADPTR_REG)	# restore $0 used as arg to load_regs
	ldq	$26, Csaveregs_disp+RA_DISP(THREADPTR_REG) # restore return address to C code
	ldq	$1, Csaveregs_disp+8(THREADPTR_REG)	# restore $1 - temp not saved by load_regs
							# C functions don't touch THREADPTR_REG
	ldq	$gp, Csaveregs_disp+232(THREADPTR_REG)		# restore r29/gp return address
	ret	$31, ($26), 1
	br	$gp, returnFromGCFromCgetgp1
returnFromGCFromCgetgp1:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
	nop
.set at
	.end returnFromGCFromC



 # ------------------------------------------------------------------------------------
 # returnFromYield is called from the runtime with the thread pointer argument
 # Yield was called from ML code as a C function so load_regs_MLtoC will take care of
 # C -> ML transition work for us.
 # -------------------------------------------------------------------------------------
	.ent	returnFromYield
	.frame	$sp, 0, $26
	.prologue
.set noat
returnFromYield:
	mov	CFIRSTARG_REG, THREADPTR_REG		# C calls keep threadptr in THREADPTR_REG
	ldq	$sp, MLsaveregs_disp+SP_DISP(THREADPTR_REG)
	ldq	$26, MLsaveregs_disp+RA_DISP(THREADPTR_REG)
	ret	$31, ($26), 1
	br	$gp, returnFromYieldgetgp1
returnFromYieldgetgp1:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
.set at
	.end	returnFromYield

 # ----------------- save_regs_MLtoC -------------------------
 # This is called using the C calling convention.
 # This routine does not use a stack frame.
 # The THREADPTR_REG is unmodified by C calls because it is in a callee-save register
 # ----------------------------------------------------------
	.ent	save_regs_MLtoC
	.frame	$sp, 0, $26
	.prologue
save_regs_MLtoC:
	stq	$0 , MLsaveregs_disp(THREADPTR_REG)	# save_regs does not save $0 (used for arg)
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer structure
	stq	$1 , 8($0)				# save_regs does not save $1
							#    so we can use this as temp if we save it
	mov	$26, $1					# use $1 to hold return address
	addq	$26, 8, $26				# we want C to return to load_regs_MLtoC
							# and NOT to the C call again so we skip
							# 2 instructions (jsr and ldgp)
	stq	$29, MLsaveregs_disp+232(THREADPTR_REG)
	br	$gp, save_regs_MLtoC_getgp1
save_regs_MLtoC_getgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/gc
	stq	$26 , MLsaveregs_disp+RA_DISP(THREADPTR_REG)	# save_regs does not save o7
	jsr	save_regs
	mov	$1, $26					# restore return address
	mov	1, $1
	stq	$1, notinml_disp(THREADPTR_REG)		# leaving ML
	ldq	$1, 8($0)				# restore $1 which we use as temp
	ldq	$0, MLsaveregs_disp(THREADPTR_REG)	# restore $0 which was used as arg to save_regs
	ldq	$29, MLsaveregs_disp+232(THREADPTR_REG) # restore gp to caller's version
	ret	$31, ($26), 1
	br	$gp, save_regs_MLtoC_getgp2
save_regs_MLtoC_getgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
        .end save_regs_MLtoC


 # ----------------- load_regs_MLtoC -------------------------
 # This is called using the C calling convention.
 # This routine does not use a stack frame.
 # It will restore all registers EXCEPT the result registers.
 # ----------------------------------------------------------
	.ent	load_regs_MLtoC
	.frame	$sp, 0, $26
	.prologue
load_regs_MLtoC:
	br	$gp, load_regs_MLtoC_getgp1
load_regs_MLtoC_getgp1:
	ldgp	$gp, 0($gp)				# compute self-gp for save_regs/gc
							# THREADPTR_REG is already correct
	stq	$31, notinml_disp(THREADPTR_REG)	# entering ML
	stq	$0, MLsaveregs_disp(THREADPTR_REG)	# overwrite GP result register
	stt	$f0, MLsaveregs_disp+256(THREADPTR_REG)	# overwrite FP result register
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer structure
	mov	$26, $1					# save our return address
	bsr	load_regs
	mov	$1, $26					# restore return address
	ldq	$1, 8($0)				# restore $1 which we use as temp
	ldq	$0, MLsaveregs_disp(THREADPTR_REG) 	# restore $0 which was used as arg to load_regs
	ldq	$gp, MLsaveregs_disp+232(THREADPTR_REG) 	# restore $gp which was used locally
	ret	$31, ($26), 1
	br	$gp, load_regs_MLtoC_getgp2
load_regs_MLtoC_getgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
        .end load_regs_MLtoC

 # Returns the pre-incremented value
 # ----------------------------------------------------------------------------
        .ent FetchAndAdd
FetchAndAdd:
.set noat
	ldl_l	$at, ($16)
	addq	$at, $17, $18
	stl_c	$18, ($16)
	beq	$18, FetchAndAdd	# might need to retry
	mov	$at, $0
        ret     $31, ($26), 1
.set at
        .end FetchAndAdd

 # ----------------------------------------------------------------------------
 # TestAndSet takes the address of the variable to be test-and-set
 # If the value was 0, it is set to 1.  Returns 1.
 # If the value was 1, it is unchanged.  Returns 0.
 # If the value is not 0 or 1, then the result is unpredictable.
 # If the reservation fails, value is unchaged. Returns 0.
 # ----------------------------------------------------------------------------
        .ent TestAndSet
TestAndSet:
.set noat
	ldl_l	$at, ($16)
	bne	$at, AlreadySet	# test
	mov	1, $0
	stl_c	$0, ($16)	# try to set
        ret     $31, ($26), 1
AlreadySet:
	stl_c	$at, ($16)	# cancel reservation
	mov	$31, $0
        ret     $31, ($26), 1
.set at
        .end TestAndSet

 # ----------------------------------------------------------------------------
 # CompareAndSwap takes an address, a test value, and a new value
 # If the address contains the test value, it is changed to the new value
 # In any case, the address's old value is returned
 # ----------------------------------------------------------------------------
        .ent CompareAndSwap
CompareAndSwap:
.set noat
	ldl_l	$0, ($16)
	cmpeq	$0, $17, $at
	beq	$at, NotEqual
	mov	$18, $19		# need temp $19 since stl_c modifies register
	stl_c	$19, ($16)		# try to set
	beq	$19, CompareAndSwap	# must retry
        ret     $31, ($26), 1
NotEqual:
	mov	$0, $19			# need temp $19 since stl_c modifies register
	stl_c	$19, ($16)		# cancel reservation by writing old value
        ret     $31, ($26), 1
.set at
        .end CompareAndSwap


 # ----------------------------------------------------------------------------
 # one might call getrpcc twice and take the different between the two results
 # to obtain the cycles used; remember to subtract 5 from the result
 # return the rpcc in standard result register $0 (a 32-bit-quantity)
 # GetRpcc returns the contents of the cycle count for this process
 # this is some multiple(in range 1..16) of the number of cycles
 # ----------------------------------------------------------------------------
        .ent GetRpcc
GetRpcc:
        rpcc    $0
        sll     $0,   32,  $1
        addq    $0,   $1,  $0
        srl     $0,   32,  $0
        ret     $31, ($26), 1
        .end GetRpcc



 # ------------------------ start_client  -------------------------------------
 # first C arg = current thread pointer
 # second C arg = thunk
 # ----------------------------------------------------------------------------
	.ent	start_client
start_client:
.set noat
 	ldgp	$gp, 0($27)				# get self gp
	mov	$16,THREADPTR_REG			# initialize thread ptr
	mov	$17,$1					# save thunk
	addq	THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer structure
	bsr	load_regs				# restore dedicated pointers like
							# heap pointer, heap limit, and stack pointer
							# don't need to restore return address
	mov	$1, $at					# restore thunk to temp
	ldq	$1, MLsaveregs_disp+8($0)		# restore $1 which is not restored by load_regs
	ldq	$0, MLsaveregs_disp($0)			# restore $0 which was used as arg to load_regs
	br	$gp, start_client_getgp1
start_client_getgp1:
	ldgp	$gp, 0($gp)				# fix $gp
	stq	$31, notinml_disp(THREADPTR_REG)	# entering ML
	ldl	$27, ($at)				# fetch code pointer
	ldl	$0, 4($at)				# fetch type env
	ldl	$1, 8($at)				# fetch term env
	lda	EXNPTR_REG, global_exnrec		# install global handler
	stl	$sp, 4(EXNPTR_REG)			# initialize the stack pointer
	jsr	$26,  ($27)				# jump to thunk
	br	$gp, start_client_getgp2		# returning from mutator
start_client_getgp2:
	ldgp	$gp, 0($gp)				# fix gp
	mov	1, $at
	stq	$at, notinml_disp(THREADPTR_REG)	# returning from ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0
	bsr	save_regs				# need to save register set to get
							#    alloction pointer into thread state
	ldq	$at, proc_disp(THREADPTR_REG)	# get system thread pointer
	ldq	$sp, ($at)				# run on system thread stack
	jsr	Finish
	br	$gp, start_client_getgp3
start_client_getgp3:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
	.end	start_client
.set at

 # ------------------------------------------------------------------------------------
 # Yield is called by mutator like a C function so save_regs_MLtoC will take care of
 # ML -> C transition work for us.
 # ------------------------------------------------------------------------------------
	.ent	Yield
	.frame $sp, 0, $26
	.prologue 0
Yield:
.set noat
	br	$gp, Yield_getgp
Yield_getgp:
	ldgp	$gp, 0($gp)			# compute correct gp for self to we can jsr
	ldq	$at, proc_disp(THREADPTR_REG) # get system thread pointer
	ldq	$sp, ($at)		        # run on system thread stack
	jsr	$26, YieldRest			# no need to restore $gp after this call
	br	$gp, Yield_getgp2
Yield_getgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
.set at
	.end	Yield


 # ------------------------------------------------------------------------------------
 # Spawn is called by mutator like a C function so save_regs_MLtoC will take care of
 # ML -> C transition work for us.
 # ------------------------------------------------------------------------------------
	.ent	Spawn
	.frame $sp, 0, $26
	.prologue 0
Spawn:
.set noat
	stq	$26, 208(THREADPTR_REG)	# note that this is return address of Spawn
	br	$gp, Spawn_getgp
Spawn_getgp:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	ldq	$at, proc_disp(THREADPTR_REG) # get system thread pointer
	ldq	$sp, ($at)		        # run on system thread stack
	jsr	$26, SpawnRest			# no need to restore $gp after this call
	ldgp	$gp, 0($26)			# compute correct gp for self
	bsr	load_regs			# THREADPTR_REG is a callee-save register
	ldq	$26, 208(THREADPTR_REG)		# note that this is return address of Spawn
	ret	$31, ($26), 1
.set at
	.end	Spawn

 # -------------------------------------------------------------------------------
 # Scheduler is called by a C function with the Proc_t * pointer.
 # We switch to processor's stack and then call schedulerRest.
 # -------------------------------------------------------------------------------
	.ent	scheduler
	.frame $sp, 0, $26
	.prologue 0
scheduler:
	br	$gp, scheduler_getgp
scheduler_getgp:
	ldgp	$gp, 0($gp)			# compute correct gp for self
.set noat
	ldl	$sp, (CFIRSTARG_REG)	        # run on system thread stack  XXX:	ldq?
	jsr	$26, schedulerRest		# no need to restore $gp after this call
	br	$gp, scheduler_getgp2
scheduler_getgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
.set at
	.end	scheduler

 # XXX dummy functions
        .ent memOrder
memOrder:
        ret     $31, ($26), 1
	.end memOrder

        .ent memBarrier
memBarrier:
        ret     $31, ($26), 1
	.end memBarrier

 # ------------------------------------------------------------
 # global_exnhandler when all else fails
 # saves all registers and calls C function toplevel_exnhandler
 # ------------------------------------------------------------
	.ent	global_exnhandler
global_exnhandler:
	br	$gp, global_exn_handler_getgp1
global_exn_handler_getgp1:
	ldgp	$gp, 0($gp)					# fix $gp
	ldl	$sp, 4(EXNPTR_REG)
	stq	EXNARG_REG, EXNARG_DISP(THREADPTR_REG)
	mov	1, $0
	stq	$0, notinml_disp(THREADPTR_REG)			# returning from ML
	addq	THREADPTR_REG, MLsaveregs_disp, $0		# use ML save area of thread pointer
	bsr	save_regs
	mov	THREADPTR_REG, $16
	lda	$27, toplevel_exnhandler
	bsr	toplevel_exnhandler
	br	$gp, global_exn_handler_getgp2
global_exn_handler_getgp2:
	ldgp	$gp, 0($gp)			# compute correct gp for self
	jsr	abort
	.end	global_exnhandler

 # ------------------------------------------------------------
 # first C arg = thread structure
 # second C arg = exn argument	;  will eventually pass in return address
 # ------------------------------------------------------------
	.ent	raise_exception_raw
raise_exception_raw:
	mov	$16, THREADPTR_REG			# restore thread pointer
	mov	$17, $1					# save the exn value;  load_regs does not change $1
	addq    THREADPTR_REG, MLsaveregs_disp, $0	# use ML save area of thread pointer structure
	br	$gp, restore_dummy
restore_dummy:
	ldgp	$gp, 0($gp)				# get own gp
	stq	$31, notinml_disp(THREADPTR_REG)	# entering ML
.set noat
	bsr	load_regs
	mov	$1, EXNARG_REG				# restore exn arg from $1 temp (unmodified by load_regs)
	ldq	$0, MLsaveregs_disp+0*8(THREADPTR_REG)	# restore $0 which was used as arg to load_regs
	ldq	$1, MLsaveregs_disp+1*8(THREADPTR_REG)	# restore $1 which was used to save exn arg unmodified by load_regs
							# don't need to restore r26 and r29 due to load_regs
							# at this point, all registers restored
	br	$gp, restore_dummy2			# Fix gp
restore_dummy2:
	ldgp	$gp, 0($gp)
	lda	ASMTMP2_REG, primaryStackletOffset
	ldl	ASMTMP2_REG, (ASMTMP2_REG)
	ldl	ASMTMP_REG, 4(EXNPTR_REG)	# fetch sp in handler
	addl	ASMTMP_REG, ASMTMP2_REG, $sp	# restore sp
	ldl	$27, 0(EXNPTR_REG)	# fetch pc of handler
	jmp	$31, ($27), 1		# jump without link
.set at
	.end	raise_exception_raw


	.data

 # a triple to represent the top-level exn record
	.align 4
	.long   (0 << 24) + (4 << 3) + 0
global_exnrec:
	.long	global_exnhandler
	.long   0
	.long   0
	.long	0

	.align 4