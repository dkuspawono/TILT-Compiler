	.section	".rodata"
	.text
	.align 8
	.proc 07
localDivFromML:
	call	DivFromML
	nop
	call	abort
	nop
	.size localDivFromML,(.-localDivFromML)
	.align 8
	.proc 07
localOverflowFromML:
	call	OverflowFromML
	nop
	call	abort
	nop
	.size localOverflowFromML,(.-localOverflowFromML)
	.section	".rodata"
		! gcinfo
	.globl Normalize_unit_GCTABLE_BEGIN_VAL
Normalize_unit_GCTABLE_BEGIN_VAL:
	.text
	.globl Normalize_unit_CODE_END_VAL
	.globl Normalize_unit_CODE_BEGIN_VAL
Normalize_unit_CODE_BEGIN_VAL:
	.text
	.align 8
	.global Normalize__code_3262281
 ! arguments : [$3262283,$8] [$3047443,$9] 
 ! results    : [$3302946,$8] 
 ! destroys   :  $9 $8
 ! modifies   :  $9 $8
Normalize__code_3262281:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3302956
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3302956:
	st	%r15, [%sp+92]
code_3302952:
funtop_3302940:
	! allocating 1-record
	! done allocating 1 record
	sethi	%hi(record_3302945), %r8
	or	%r8, %lo(record_3302945), %r8
code_3302955:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize__code_3262281,(.-Normalize__code_3262281)

	.section	".rodata"
	.text
	.align 8
	.global Normalize__code_3262286
 ! arguments : [$3262288,$8] [$3047529,$9] 
 ! results    : [$3302939,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize__code_3262286:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3302963
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3302963:
	st	%r15, [%sp+92]
code_3302957:
funtop_3302929:
	! start making constructor call
	sethi	%hi(record_3265127), %r8
	or	%r8, %lo(record_3265127), %r8
	ld	[%r8], %r10
	jmpl	%r10, %r15
	ld	[%r8+4], %r8
code_3302962:
code_3302959:
	! done making constructor call
code_3302961:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize__code_3262286,(.-Normalize__code_3262286)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3302962
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize__code_3262291
 ! arguments : [$3262293,$8] [$3047532,$9] 
 ! results    : [$3302926,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize__code_3262291:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3302972
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3302972:
	st	%r15, [%sp+92]
	mov	%r9, %r10
code_3302964:
funtop_3302915:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3302965
	nop
code_3302966:
	call	GCFromML ! delay slot empty
	nop
needgc_3302965:
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r9
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3302971:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize__code_3262291,(.-Normalize__code_3262291)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3302965
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize__code_3262296
 ! arguments : [$3262298,$8] [$3047537,$9] 
 ! results    : [$3302908,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize__code_3262296:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3302982
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3302982:
	st	%r15, [%sp+92]
code_3302973:
funtop_3302897:
	! start making constructor call
	sethi	%hi(record_3265135), %r8
	or	%r8, %lo(record_3265135), %r8
	ld	[%r8], %r10
	jmpl	%r10, %r15
	ld	[%r8+4], %r8
code_3302981:
	mov	%r8, %r9
code_3302975:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3302976
	nop
code_3302977:
	call	GCFromML ! delay slot empty
	nop
needgc_3302976:
	! done making constructor call
	! allocating 5-record
	sethi	%hi(4137), %r8
	or	%r8, %lo(4137), %r8
	st	%r8, [%r4]
	or	%r0, 4, %r8
	st	%r8, [%r4+4]
	or	%r0, -1, %r8
	st	%r8, [%r4+8]
	or	%r0, 0, %r8
	st	%r8, [%r4+12]
	or	%r0, 2, %r8
	st	%r8, [%r4+16]
	st	%r9, [%r4+20]
	add	%r4, 4, %r8
	add	%r4, 24, %r4
	! done allocating 5 record
code_3302980:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize__code_3262296,(.-Normalize__code_3262296)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3302976
	.word 0x00180007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3302981
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262306
 ! arguments : [$3262308,$8] [$3262309,$9] [$3243867,$10] 
 ! results    : [$3302860,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262306:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303021
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303021:
	st	%r15, [%sp+92]
	st	%r10, [%sp+104]
code_3302983:
funtop_3302808:
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(profile_3193128), %r8
	or	%r8, %lo(profile_3193128), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303017:
code_3302989:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3302830
	nop
zero_case_3302829:
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(local_profile_3193131), %r8
	or	%r8, %lo(local_profile_3193131), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303019:
code_3302996:
	! done making normal call
	ba	after_zeroone_3302831 ! delay slot empty
	nop
one_case_3302830:
	or	%r0, 1, %r8
after_zeroone_3302831:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3302851
	nop
zero_case_3302850:
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3302999:
	! done making tail call
	ba	after_zeroone_3302852 ! delay slot empty
	nop
one_case_3302851:
	sethi	%hi(string_3265332), %r8
	or	%r8, %lo(string_3265332), %r10
	! making closure call
	sethi	%hi(_3243902), %r8
	or	%r8, %lo(_3243902), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3303018:
	mov	%r8, %r12
code_3303004:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303015:
	mov	%r8, %r9
code_3303011:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303012:
	! done making tail call
after_zeroone_3302852:
code_3303014:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262306,(.-Normalize_anonfun_code_3262306)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303015
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3303017
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00350000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3303018
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3303019
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00350000
		! worddata
	.word 0x80000000
	.long type_3222555
	.text
	.align 8
	.global Normalize_anonfun_code_3262301
 ! arguments : [$3262303,$8] [$3262304,$9] [$3043992,$10] 
 ! results    : [$3302807,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262301:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303049
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303049:
	st	%r15, [%sp+92]
code_3303022:
funtop_3302745:
	! making closure call
	sethi	%hi(_3222571), %r8
	or	%r8, %lo(_3222571), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303047:
	st	%r8, [%sp+96]
code_3303025:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3303046:
	mov	%r8, %r9
code_3303032:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303033
	nop
code_3303034:
	call	GCFromML ! delay slot empty
	nop
needgc_3303033:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262306), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262306), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303048:
code_3303043:
	! done making normal call
code_3303045:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262301,(.-Normalize_anonfun_code_3262301)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303046
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3303033
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3303047
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303048
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_outer_valbind_r_code_3262315
 ! arguments : [$3262317,$8] [$3044126,$9] [$3262318,$10] [$3044127,$11] 
 ! results    : [$3302744,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_outer_valbind_r_code_3262315:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303060
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303060:
	st	%r15, [%sp+92]
code_3303050:
funtop_3302719:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303051
	nop
code_3303052:
	call	GCFromML ! delay slot empty
	nop
needgc_3303051:
	! Proj_c at label 'a_TYV
	ld	[%r9], %r11
	! Proj_c at label 'b_TYV
	ld	[%r9+4], %r10
	! Proj_c at label 'c_TYV
	ld	[%r9+8], %r9
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r13
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(foldl_acc_3193405), %r8
	or	%r8, %lo(foldl_acc_3193405), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	mov	%r13, %r9
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3303056:
	! done making tail call
code_3303058:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_outer_valbind_r_code_3262315,(.-Normalize_outer_valbind_r_code_3262315)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303051
	.word 0x00180007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_outer_valbind_r_code_3262320
 ! arguments : [$3262322,$8] [$3044192,$9] [$3262323,$10] [$3044193,$11] 
 ! results    : [$3302718,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_outer_valbind_r_code_3262320:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303071
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303071:
	st	%r15, [%sp+92]
code_3303061:
funtop_3302696:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303062
	nop
code_3303063:
	call	GCFromML ! delay slot empty
	nop
needgc_3303062:
	! Proj_c at label 'a_TYV
	ld	[%r9], %r10
	! Proj_c at label 'b_TYV
	ld	[%r9+4], %r9
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r13
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(map_3193549), %r8
	or	%r8, %lo(map_3193549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	mov	%r13, %r9
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3303067:
	! done making tail call
code_3303069:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_outer_valbind_r_code_3262320,(.-Normalize_outer_valbind_r_code_3262320)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303062
	.word 0x00180007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_outer_valbind_r_code_3262325
 ! arguments : [$3262327,$8] [$3044288,$9] [$3262328,$10] [$3044289,$11] 
 ! results    : [$3302695,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_outer_valbind_r_code_3262325:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303082
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303082:
	st	%r15, [%sp+92]
code_3303072:
funtop_3302673:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303073
	nop
code_3303074:
	call	GCFromML ! delay slot empty
	nop
needgc_3303073:
	! Proj_c at label 'a_TYV
	ld	[%r9], %r10
	! Proj_c at label 'b_TYV
	ld	[%r9+4], %r9
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r13
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(unzip_3193719), %r8
	or	%r8, %lo(unzip_3193719), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	mov	%r13, %r9
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3303078:
	! done making tail call
code_3303080:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_outer_valbind_r_code_3262325,(.-Normalize_outer_valbind_r_code_3262325)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303073
	.word 0x00180007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_errorPRIME_inner_code_3262335
 ! arguments : [$3262337,$8] [$3262338,$9] [$3044432,$10] 
 ! results    : [$3302672,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_errorPRIME_inner_code_3262335:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303091
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303091:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	st	%r10, [%sp+100]
code_3303083:
funtop_3302655:
	sethi	%hi(string_3265690), %r8
	or	%r8, %lo(string_3265690), %r10
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303090:
	mov	%r8, %r9
code_3303085:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303086:
	! done making tail call
code_3303088:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_errorPRIME_inner_code_3262335,(.-Normalize_errorPRIME_inner_code_3262335)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303090
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.text
	.align 8
	.global Normalize_errorPRIME_r_code_3262330
 ! arguments : [$3262332,$8] [$3044428,$9] [$3262333,$10] [$3044429,$11] 
 ! results    : [$3302650,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_errorPRIME_r_code_3262330:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303103
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303103:
	st	%r15, [%sp+92]
	st	%r9, [%sp+96]
code_3303092:
funtop_3302630:
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(error_3193987), %r8
	or	%r8, %lo(error_3193987), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r9
code_3303102:
	mov	%r8, %r9
code_3303095:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303096
	nop
code_3303097:
	call	GCFromML ! delay slot empty
	nop
needgc_3303096:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_errorPRIME_inner_code_3262335), %r8
	or	%r8, %lo(Normalize_errorPRIME_inner_code_3262335), %r8
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303101:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_errorPRIME_r_code_3262330,(.-Normalize_errorPRIME_r_code_3262330)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303096
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3303102
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.text
	.align 8
	.global Normalize_push_code_3262344
 ! arguments : [$3262346,$8] [$3262347,$9] [$3044516,$10] 
 ! results    : [$3302618,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_push_code_3262344:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303175
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303175:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3303104:
funtop_3302485:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	addcc	%r8, 1, %r12
	bvs,pn	%icc,localOverflowFromML
	nop
code_3303107:
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3303111
	nop
code_3303112:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3303111:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	ld	[%r2+792], %r10
	mov	%r11, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r12, [%r11]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303168:
	mov	%r8, %r9
code_3303126:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303127
	nop
code_3303128:
	call	GCFromML ! delay slot empty
	nop
needgc_3303127:
	! allocating 2-record
	sethi	%hi(gctag_3194063), %r8
	ld	[%r8+%lo(gctag_3194063)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r13
	add	%r4, 12, %r4
	! done allocating 2 record
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	mov	%r11, %r8
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3303172:
code_3303136:
	! done making normal call
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r10
	! int sub end
	or	%r0, 20, %r11
	! making closure call
	sethi	%hi(imod_3194088), %r8
	or	%r8, %lo(imod_3194088), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3303169:
code_3303141:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3302562
	nop
zero_case_3302561:
	sethi	%hi(string_3265921), %r8
	or	%r8, %lo(string_3265921), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303174:
code_3303146:
	! done making normal call
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r10
	! int sub end
	! making closure call
	sethi	%hi(toString_3194100), %r8
	or	%r8, %lo(toString_3194100), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303170:
	mov	%r8, %r10
code_3303151:
	! done making normal call
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303171:
code_3303154:
	! done making normal call
	ba	after_zeroone_3302563 ! delay slot empty
	nop
one_case_3302562:
	or	%r0, 256, %r8
after_zeroone_3302563:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r9
	! int sub end
	sethi	%hi(10000), %r8
	or	%r8, %lo(10000), %r8
	cmp	%r9, %r8
	or	%r0, 1, %r8
	bg	cmpsi_3303158
	nop
code_3303159:
	or	%r0, 0, %r8
cmpsi_3303158:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3302614
	nop
zero_case_3302613:
	ba	after_zeroone_3302615
	or	%r0, 256, %r8
one_case_3302614:
	sethi	%hi(string_3265965), %r8
	or	%r8, %lo(string_3265965), %r10
	! making closure call
	sethi	%hi(_3194113), %r8
	or	%r8, %lo(_3194113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303165:
	! done making tail call
after_zeroone_3302615:
code_3303167:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_push_code_3262344,(.-Normalize_push_code_3262344)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303168
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x40000000
	.long record_3265060
		! -------- label,sizes,reg
	.long afterMutateCheck_3303111
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x40000000
	.long record_3265060
		! -------- label,sizes,reg
	.long needgc_3303127
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x40000000
	.long record_3265060
	.word 0x80000000
	.long type_3256487
		! -------- label,sizes,reg
	.long code_3303169
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303170
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303171
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303172
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303174
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_show_code_3262349
 ! arguments : [$3262351,$8] [$3262352,$9] [$3044632,$10] 
 ! results    : [$3302158,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_show_code_3262349:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303351
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303351:
	st	%r15, [%sp+92]
code_3303176:
funtop_3302070:
sumarm_3302077:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3302078
	nop
code_3303177:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(string_3266087), %r8
	or	%r8, %lo(string_3266087), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303316:
code_3303181:
	! done making normal call
	! making closure call
	sethi	%hi(_3223106), %r8
	or	%r8, %lo(_3223106), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303317:
code_3303184:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303318:
code_3303188:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303319:
code_3303191:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303320:
code_3303195:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303321:
code_3303198:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303202:
	! done making tail call
	ba	after_sum_3302074 ! delay slot empty
	nop
sumarm_3302078:
	ld	[%r10], %r8
	cmp	%r8, 1
	bne	sumarm_3302159
	nop
code_3303204:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(string_3266240), %r8
	or	%r8, %lo(string_3266240), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303323:
code_3303208:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303324:
code_3303211:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303325:
code_3303215:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303326:
code_3303218:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303327:
code_3303222:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303328:
code_3303225:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303229:
	! done making tail call
	ba	after_sum_3302074 ! delay slot empty
	nop
sumarm_3302159:
	ld	[%r10], %r8
	cmp	%r8, 2
	bne	sumarm_3302239
	nop
code_3303231:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(string_3266306), %r8
	or	%r8, %lo(string_3266306), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303330:
code_3303235:
	! done making normal call
	! making closure call
	sethi	%hi(_3223158), %r8
	or	%r8, %lo(_3223158), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303331:
code_3303238:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303332:
code_3303242:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303333:
code_3303245:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303334:
code_3303249:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303335:
code_3303252:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303256:
	! done making tail call
	ba	after_sum_3302074 ! delay slot empty
	nop
sumarm_3302239:
	ld	[%r10], %r8
	cmp	%r8, 3
	bne	sumarm_3302319
	nop
code_3303258:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(string_3266367), %r8
	or	%r8, %lo(string_3266367), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303337:
code_3303262:
	! done making normal call
	! making closure call
	sethi	%hi(_3223184), %r8
	or	%r8, %lo(_3223184), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303338:
code_3303265:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303339:
code_3303269:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303340:
code_3303272:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303341:
code_3303276:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303342:
code_3303279:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303283:
	! done making tail call
	ba	after_sum_3302074 ! delay slot empty
	nop
sumarm_3302319:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(string_3266432), %r8
	or	%r8, %lo(string_3266432), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303350:
code_3303288:
	! done making normal call
	sethi	%hi(string_3266442), %r8
	or	%r8, %lo(string_3266442), %r10
	sethi	%hi(string_3266442), %r8
	or	%r8, %lo(string_3266442), %r12
	sethi	%hi(string_3266442), %r8
	or	%r8, %lo(string_3266442), %r13
	! making closure call
	sethi	%hi(pp_module_3194348), %r8
	or	%r8, %lo(pp_module_3194348), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r18
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r18, %r15
	ld	[%sp+100], %r11
code_3303344:
code_3303294:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303345:
code_3303298:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303346:
code_3303301:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303347:
code_3303305:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303348:
code_3303308:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303312:
	! done making tail call
	ba	after_sum_3302074 ! delay slot empty
	nop
sumarm_3302399:
after_sum_3302074:
code_3303315:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_show_code_3262349,(.-Normalize_show_code_3262349)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303316
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193056
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303317
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303318
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303319
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303320
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303321
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303323
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303324
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303325
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303326
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303327
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303328
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303330
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303331
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303332
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303333
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303334
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303335
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303337
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303338
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303339
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303340
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303341
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303342
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303344
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303345
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303346
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303347
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3303348
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303350
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193078
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_anonfun_code_3262364
 ! arguments : [$3262366,$8] [$3262367,$9] [$3044717,$10] 
 ! results    : [$3301959,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262364:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303445
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303445:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	st	%r9, [%sp+104]
	st	%r10, [%sp+100]
code_3303352:
funtop_3301918:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303353
	nop
code_3303354:
	call	GCFromML ! delay slot empty
	nop
needgc_3303353:
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	sethi	%hi(exn_handler_3301923), %r8
	or	%r8, %lo(exn_handler_3301923), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3303361
	nop
code_3303362:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3303361:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	or	%r0, 0, %r11
	ld	[%r2+792], %r10
	mov	%r12, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r11, [%r12]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r13
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	or	%r0, 0, %r11
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	jmpl	%r12, %r15
	mov	%r13, %r8
code_3303434:
code_3303376:
	! done making normal call
	! making closure polycall
	ld	[%sp+100], %r17
	ld	[%r17], %r10
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	jmpl	%r10, %r15
	ld	[%r17+8], %r9
code_3303436:
code_3303377:
	! done making normal call
	ba	exn_handler_after_3301924
	ld	[%r1+12], %r1
exn_handler_3301923:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	st	%r15, [%sp+108]
	sethi	%hi(string_3266040), %r8
	or	%r8, %lo(string_3266040), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303444:
code_3303384:
	! done making normal call
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3303437:
code_3303387:
	! done making normal call
	sethi	%hi(string_3266052), %r8
	or	%r8, %lo(string_3266052), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303438:
code_3303391:
	! done making normal call
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303439:
	st	%r8, [%sp+100]
code_3303397:
	! done making normal call
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3303401
	nop
code_3303402:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3303401:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	or	%r0, 0, %r11
	ld	[%r2+792], %r10
	mov	%r12, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r11, [%r12]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r13
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	or	%r0, 0, %r11
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	jmpl	%r12, %r15
	mov	%r13, %r8
code_3303435:
code_3303416:
	! done making normal call
	sethi	%hi(show_3044631), %r8
	or	%r8, %lo(show_3044631), %r10
	! making closure call
	sethi	%hi(_3194374), %r8
	or	%r8, %lo(_3194374), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303440:
	st	%r8, [%sp+104]
code_3303420:
	! done making normal call
	! making closure call
	sethi	%hi(_3223268), %r8
	or	%r8, %lo(_3223268), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303441:
	st	%r8, [%sp+100]
code_3303423:
	! done making normal call
	sethi	%hi(type_3244655), %r8
	or	%r8, %lo(type_3244655), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	! allocating 2-record
	! done allocating 2 record
	sethi	%hi(record_3302052), %r8
	or	%r8, %lo(record_3302052), %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3303442:
	mov	%r8, %r9
code_3303429:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3303443:
code_3303430:
	! done making normal call
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3301924:
code_3303433:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262364,(.-Normalize_anonfun_code_3262364)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303434
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3303435
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004d0000
		! worddata
	.word 0x80000000
	.long type_3256487
		! -------- label,sizes,reg
	.long needgc_3303353
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00150000
		! -------- label,sizes,reg
	.long afterMutateCheck_3303361
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3303436
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3303437
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00410000
		! -------- label,sizes,reg
	.long code_3303438
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00410000
		! -------- label,sizes,reg
	.long code_3303439
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00410000
		! -------- label,sizes,reg
	.long afterMutateCheck_3303401
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004d0000
		! worddata
	.word 0x80000000
	.long type_3256487
		! -------- label,sizes,reg
	.long code_3303440
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004d0000
		! worddata
	.word 0x80000000
	.long type_3256487
		! -------- label,sizes,reg
	.long code_3303441
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00510000
		! -------- label,sizes,reg
	.long code_3303442
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004d0000
		! worddata
	.word 0x80000000
	.long type_3256487
		! -------- label,sizes,reg
	.long code_3303443
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00410000
		! -------- label,sizes,reg
	.long code_3303444
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00510000
	.text
	.align 8
	.global Normalize_wrap_inner_code_3262359
 ! arguments : [$3262361,$8] [$3262362,$9] [$3044715,$10] 
 ! results    : [$3301913,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_wrap_inner_code_3262359:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303453
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303453:
	st	%r15, [%sp+92]
	mov	%r8, %r11
code_3303446:
funtop_3301904:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303447
	nop
code_3303448:
	call	GCFromML ! delay slot empty
	nop
needgc_3303447:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262364), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262364), %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303452:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_wrap_inner_code_3262359,(.-Normalize_wrap_inner_code_3262359)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303447
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc3000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_wrap_r_code_3262354
 ! arguments : [$3262356,$8] [$3044711,$9] [$3262357,$10] [$3044712,$11] 
 ! results    : [$3301898,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_wrap_r_code_3262354:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303461
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303461:
	st	%r15, [%sp+92]
code_3303454:
funtop_3301890:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303455
	nop
code_3303456:
	call	GCFromML ! delay slot empty
	nop
needgc_3303455:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_wrap_inner_code_3262359), %r8
	or	%r8, %lo(Normalize_wrap_inner_code_3262359), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303460:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_wrap_r_code_3262354,(.-Normalize_wrap_r_code_3262354)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303455
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3200
	.word 0xbffc3000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262398
 ! arguments : [$3262400,$8] [$3262401,$9] 
 ! results    : [$3301889,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262398:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303467
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303467:
	st	%r15, [%sp+92]
code_3303462:
funtop_3301871:
	! Proj_c at label type_3223324_INT
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	! Proj_c at label type_3194410_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r9], %r10
	ld	[%r9+4], %r9
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303463:
	! done making tail call
code_3303465:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262398,(.-Normalize_anonfun_code_3262398)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3262392
 ! arguments : [$3262394,$8] [$3262395,$9] [$3044739,$10] 
 ! results    : [$3301870,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262392:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303479
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303479:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r10, %r18
code_3303468:
funtop_3301831:
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303469
	nop
code_3303470:
	call	GCFromML ! delay slot empty
	nop
needgc_3303469:
	! Proj_c at label type_3223324_INT
	ld	[%sp+96], %r17
	ld	[%r17], %r13
	! Proj_c at label type_3194410_INT
	ld	[%sp+96], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+100]
	ld	[%r9], %r12
	ld	[%r9+4], %r11
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r13, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 529, %r9
	cmp	%r13, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303472
	nop
code_3303473:
	or	%r0, 0, %r8
cmpui_3303472:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r9, %r9
	! allocating 2-record
	st	%r9, [%r4]
	st	%r18, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262398), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262398), %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	ld	[%r12], %r11
	ld	[%r12+4], %r8
	ld	[%r12+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303475:
	! done making tail call
code_3303477:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262392,(.-Normalize_anonfun_code_3262392)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303469
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00040000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! worddata
	.word 0x00000001
	.word 0x00000060
	.text
	.align 8
	.global Normalize_anonfun_code_3262385
 ! arguments : [$3262387,$8] [$3262388,$9] [$3044737,$10] 
 ! results    : [$3301830,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262385:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303495
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303495:
	st	%r15, [%sp+92]
	st	%r9, [%sp+100]
	mov	%r10, %r12
code_3303480:
funtop_3301779:
	! Proj_c at label type_3223324_INT
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	! Proj_c at label type_3194410_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	ld	[%sp+104], %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r10
code_3303493:
	mov	%r8, %r9
code_3303483:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303484
	nop
code_3303485:
	call	GCFromML ! delay slot empty
	nop
needgc_3303484:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262392), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262392), %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	ld	[%sp+104], %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r10
code_3303494:
code_3303490:
	! done making normal call
code_3303492:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262385,(.-Normalize_anonfun_code_3262385)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303484
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00150000
		! -------- label,sizes,reg
	.long code_3303493
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00150000
		! -------- label,sizes,reg
	.long code_3303494
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_wrap1_inner_code_3262379
 ! arguments : [$3262381,$8] [$3262382,$9] [$3044735,$10] 
 ! results    : [$3301774,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_wrap1_inner_code_3262379:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303505
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303505:
	st	%r15, [%sp+92]
code_3303496:
funtop_3301751:
	! Proj_c at label type_3223324_INT
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	! Proj_c at label type_3194410_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303504:
	mov	%r8, %r10
code_3303497:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303498
	nop
code_3303499:
	call	GCFromML ! delay slot empty
	nop
needgc_3303498:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262385), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262385), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303503:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_wrap1_inner_code_3262379,(.-Normalize_wrap1_inner_code_3262379)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303498
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3303504
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.text
	.align 8
	.global Normalize_wrap1_r_code_3262374
 ! arguments : [$3262376,$8] [$3044730,$9] [$3262377,$10] [$3044731,$11] 
 ! results    : [$3301746,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_wrap1_r_code_3262374:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303516
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303516:
	st	%r15, [%sp+92]
code_3303506:
funtop_3301721:
	! Proj_c at label 'a_TYV
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	! Proj_c at label 'b_TYV
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(wrap_r_3044729), %r8
	or	%r8, %lo(wrap_r_3044729), %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r9
code_3303515:
	mov	%r8, %r10
code_3303508:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303509
	nop
code_3303510:
	call	GCFromML ! delay slot empty
	nop
needgc_3303509:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_wrap1_inner_code_3262379), %r8
	or	%r8, %lo(Normalize_wrap1_inner_code_3262379), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303514:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_wrap1_r_code_3262374,(.-Normalize_wrap1_r_code_3262374)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303509
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3303515
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.text
	.align 8
	.global Normalize_anonfun_code_3262452
 ! arguments : [$3262454,$8] [$3262455,$9] 
 ! results    : [$3301720,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262452:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303528
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303528:
	st	%r15, [%sp+92]
code_3303517:
funtop_3301679:
	! Proj_c at label type_3223387_INT
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	! Proj_c at label type_3223386_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! Proj_c at label type_3194443_INT
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9], %r10
	ld	[%r9+4], %r16
	st	%r16, [%sp+108]
	ld	[%r9+8], %r9
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303527:
	mov	%r8, %r12
code_3303518:
	! done making normal call
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	ld	[%sp+100], %r9
	jmpl	%r13, %r15
	ld	[%sp+104], %r10
code_3303525:
	mov	%r8, %r9
code_3303521:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+108], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303522:
	! done making tail call
code_3303524:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262452,(.-Normalize_anonfun_code_3262452)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303525
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00d40000
		! worddata
	.word 0x00000000
	.word 0x00000064
		! -------- label,sizes,reg
	.long code_3303527
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00d40000
		! worddata
	.word 0x00000000
	.word 0x00000064
	.text
	.align 8
	.global Normalize_anonfun_code_3262446
 ! arguments : [$3262448,$8] [$3262449,$9] [$3044764,$10] 
 ! results    : [$3301678,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262446:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303542
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303542:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r10, %r19
code_3303529:
funtop_3301630:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303530
	nop
code_3303531:
	call	GCFromML ! delay slot empty
	nop
needgc_3303530:
	! Proj_c at label type_3223387_INT
	ld	[%sp+96], %r17
	ld	[%r17], %r18
	! Proj_c at label type_3223386_INT
	ld	[%sp+96], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+100]
	! Proj_c at label type_3194443_INT
	ld	[%sp+96], %r17
	ld	[%r17+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r12
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r9
	st	%r9, [%r4]
	st	%r18, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r11
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 1049, %r10
	ld	[%sp+100], %r17
	cmp	%r17, 3
	or	%r0, 1, %r9
	bgu	cmpui_3303533
	nop
code_3303534:
	or	%r0, 0, %r9
cmpui_3303533:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r10, %r10
	cmp	%r18, 3
	or	%r0, 1, %r9
	bgu	cmpui_3303535
	nop
code_3303536:
	or	%r0, 0, %r9
cmpui_3303535:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	st	%r13, [%r4+4]
	st	%r19, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r9
	st	%r9, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262452), %r9
	or	%r9, %lo(Normalize_anonfun_code_3262452), %r9
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	mov	%r12, %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303538:
	! done making tail call
code_3303540:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262446,(.-Normalize_anonfun_code_3262446)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303530
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00080000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! worddata
	.word 0x00000001
	.word 0x00000060
	.text
	.align 8
	.global Normalize_anonfun_code_3262440
 ! arguments : [$3262442,$8] [$3262443,$9] [$3044762,$10] 
 ! results    : [$3301629,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262440:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303556
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303556:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r9, %r8
	mov	%r10, %r20
code_3303543:
funtop_3301579:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303544
	nop
code_3303545:
	call	GCFromML ! delay slot empty
	nop
needgc_3303544:
	! Proj_c at label type_3223387_INT
	ld	[%sp+96], %r17
	ld	[%r17], %r9
	! Proj_c at label type_3223386_INT
	ld	[%sp+96], %r17
	ld	[%r17+4], %r19
	! Proj_c at label type_3194443_INT
	ld	[%sp+96], %r17
	ld	[%r17+8], %r10
	ld	[%r8], %r18
	ld	[%r8+4], %r13
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r19, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 1561, %r11
	cmp	%r19, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303547
	nop
code_3303548:
	or	%r0, 0, %r8
cmpui_3303547:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r20, [%r4+4]
	st	%r18, [%r4+8]
	st	%r13, [%r4+12]
	add	%r4, 4, %r11
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262446), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262446), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3303555:
code_3303552:
	! done making normal call
code_3303554:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262440,(.-Normalize_anonfun_code_3262440)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303555
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3303544
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000100
	.word 0x00100000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! worddata
	.word 0x00000002
	.word 0x00000060
	.text
	.align 8
	.global Normalize_anonfun_code_3262433
 ! arguments : [$3262435,$8] [$3262436,$9] [$3044760,$10] 
 ! results    : [$3301578,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262433:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303572
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3303572:
	st	%r15, [%sp+92]
	st	%r9, [%sp+100]
	mov	%r10, %r12
code_3303557:
funtop_3301520:
	! Proj_c at label type_3223387_INT
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	! Proj_c at label type_3223386_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
	! Proj_c at label type_3194444_INT
	ld	[%r8+8], %r16
	st	%r16, [%sp+112]
	! Proj_c at label type_3194443_INT
	ld	[%r8+12], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	ld	[%sp+108], %r9
	jmpl	%r13, %r15
	ld	[%sp+112], %r10
code_3303570:
	mov	%r8, %r9
code_3303560:
	! done making normal call
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303561
	nop
code_3303562:
	call	GCFromML ! delay slot empty
	nop
needgc_3303561:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262440), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262440), %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	ld	[%sp+108], %r9
	jmpl	%r13, %r15
	ld	[%sp+112], %r10
code_3303571:
code_3303567:
	! done making normal call
code_3303569:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3262433,(.-Normalize_anonfun_code_3262433)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303561
	.word 0x00200007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01550000
		! -------- label,sizes,reg
	.long code_3303570
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01550000
		! -------- label,sizes,reg
	.long code_3303571
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_wrap2_inner_code_3262427
 ! arguments : [$3262429,$8] [$3262430,$9] [$3044758,$10] 
 ! results    : [$3301515,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_wrap2_inner_code_3262427:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303582
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303582:
	st	%r15, [%sp+92]
code_3303573:
funtop_3301484:
	! Proj_c at label type_3223387_INT
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	! Proj_c at label type_3223386_INT
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! Proj_c at label type_3194444_INT
	ld	[%r8+8], %r16
	st	%r16, [%sp+108]
	! Proj_c at label type_3194443_INT
	ld	[%r8+12], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303581:
	mov	%r8, %r10
code_3303574:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303575
	nop
code_3303576:
	call	GCFromML ! delay slot empty
	nop
needgc_3303575:
	! allocating 1 closures
	! allocating 4-record
	or	%r0, 3873, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	ld	[%sp+108], %r17
	st	%r17, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262433), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262433), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303580:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_wrap2_inner_code_3262427,(.-Normalize_wrap2_inner_code_3262427)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303575
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00550000
		! -------- label,sizes,reg
	.long code_3303581
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00550000
	.text
	.align 8
	.global Normalize_wrap2_r_code_3262422
 ! arguments : [$3262424,$8] [$3044752,$9] [$3262425,$10] [$3044753,$11] 
 ! results    : [$3301479,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_wrap2_r_code_3262422:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303596
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303596:
	st	%r15, [%sp+92]
code_3303583:
funtop_3301444:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303584
	nop
code_3303585:
	call	GCFromML ! delay slot empty
	nop
needgc_3303584:
	! Proj_c at label 'a_TYV
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	! Proj_c at label 'b_TYV
	ld	[%r9+4], %r16
	st	%r16, [%sp+104]
	! Proj_c at label 'c_TYV
	ld	[%r9+8], %r16
	st	%r16, [%sp+108]
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	or	%r0, 6, %r8
	st	%r8, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	ld	[%sp+108], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 256, %r11
	! making closure call
	sethi	%hi(wrap_r_3044729), %r8
	or	%r8, %lo(wrap_r_3044729), %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	ld	[%sp+108], %r9
code_3303595:
	mov	%r8, %r10
code_3303588:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303589
	nop
code_3303590:
	call	GCFromML ! delay slot empty
	nop
needgc_3303589:
	! allocating 1 closures
	! allocating 4-record
	or	%r0, 3873, %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	ld	[%sp+108], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_wrap2_inner_code_3262427), %r8
	or	%r8, %lo(Normalize_wrap2_inner_code_3262427), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3303594:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_wrap2_r_code_3262422,(.-Normalize_wrap2_r_code_3262422)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303584
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3303589
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00550000
		! -------- label,sizes,reg
	.long code_3303595
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00550000
	.text
	.align 8
	.global Normalize_anonfun_code_3262496
 ! arguments : [$3262498,$8] [$3262499,$9] [$3223483,$10] [$3223484,$11] 
 ! results    : [$3301443,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262496:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303604
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303604:
	st	%r15, [%sp+92]
	mov	%r9, %r13
code_3303597:
funtop_3301431:
	! making closure call
	sethi	%hi(eq_label_3193328), %r8
	or	%r8, %lo(eq_label_3193328), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	mov	%r13, %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3303600:
	! done making tail call
code_3303602:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262496,(.-Normalize_anonfun_code_3262496)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_beta_conrecordPRIME_code_3262491
 ! arguments : [$3262493,$8] [$3262494,$9] [$3044778,$10] 
 ! results    : [$3301399,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_conrecordPRIME_code_3262491:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303680
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303680:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3303605:
funtop_3301237:
sumarm_3301244:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 10
	bne	sumarm_3301245
	nop
code_3303606:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3223477), %r8
	or	%r8, %lo(_3223477), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303673:
	mov	%r8, %r11
code_3303609:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303610
	nop
code_3303611:
	call	GCFromML ! delay slot empty
	nop
needgc_3303610:
sumarm_3301271:
	cmp	%r11, 0
	bne	sumarm_3301272
	nop
code_3303613:
	! allocating 2-record
	sethi	%hi(gctag_3194531), %r8
	ld	[%r8+%lo(gctag_3194531)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3301268 ! delay slot empty
	nop
sumarm_3301272:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262496), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262496), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3194541), %r8
	or	%r8, %lo(type_3194541), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3301303
	nop
code_3303619:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3301304
	nop
code_3303620:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3301303
	nop
code_3303621:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3301303
	nop
code_3303622:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3301303
	nop
dynamic_nobox_3301304:
	ba	projsum_single_after_3301300
	st	%r11, [%sp+96]
dynamic_box_3301303:
	ld	[%r11], %r16
	st	%r16, [%sp+96]
projsum_single_after_3301300:
	! making closure call
	sethi	%hi(_3194552), %r8
	or	%r8, %lo(_3194552), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303679:
	mov	%r8, %r12
code_3303627:
	! done making normal call
	sethi	%hi(type_3244862), %r8
	or	%r8, %lo(type_3244862), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244868), %r8
	or	%r8, %lo(type_3244868), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303674:
	mov	%r8, %r9
code_3303634:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303675:
code_3303635:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303636
	nop
code_3303637:
	call	GCFromML ! delay slot empty
	nop
needgc_3303636:
sumarm_3301346:
	cmp	%r8, 0
	bne	sumarm_3301347
	nop
code_3303639:
	sethi	%hi(exn_handler_3301350), %r8
	or	%r8, %lo(exn_handler_3301350), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	sethi	%hi(string_3266765), %r8
	or	%r8, %lo(string_3266765), %r10
	! making closure call
	sethi	%hi(_3194589), %r8
	or	%r8, %lo(_3194589), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303676:
code_3303645:
	! done making normal call
	ba	exn_handler_after_3301351
	ld	[%r1+12], %r1
exn_handler_3301350:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3301351:
	ba	after_sum_3301343 ! delay slot empty
	nop
sumarm_3301347:
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3194531), %r8
	ld	[%r8+%lo(gctag_3194531)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3301343 ! delay slot empty
	nop
sumarm_3301372:
after_sum_3301343:
	ba	after_sum_3301268 ! delay slot empty
	nop
sumarm_3301283:
after_sum_3301268:
	ba	after_sum_3301241 ! delay slot empty
	nop
sumarm_3301245:
nomatch_sum_3301242:
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303678:
code_3303657:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303658
	nop
code_3303659:
	call	GCFromML ! delay slot empty
	nop
needgc_3303658:
	sethi	%hi(exn_handler_3301410), %r8
	or	%r8, %lo(exn_handler_3301410), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	sethi	%hi(string_3266805), %r8
	or	%r8, %lo(string_3266805), %r10
	! making closure call
	sethi	%hi(_3194589), %r8
	or	%r8, %lo(_3194589), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303677:
code_3303666:
	! done making normal call
	ba	exn_handler_after_3301411
	ld	[%r1+12], %r1
exn_handler_3301410:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3301411:
after_sum_3301241:
code_3303672:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_beta_conrecordPRIME_code_3262491,(.-Normalize_beta_conrecordPRIME_code_3262491)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303673
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3303610
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3244906
		! -------- label,sizes,reg
	.long code_3303674
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3244904
		! -------- label,sizes,reg
	.long code_3303675
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3303636
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3244868
		! -------- label,sizes,reg
	.long code_3303676
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3303658
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303677
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303678
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3303679
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3244904
	.text
	.align 8
	.global Normalize_beta_conrecord_code_3262503
 ! arguments : [$3262505,$8] [$3262506,$9] [$3044847,$10] 
 ! results    : [$3301236,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_conrecord_code_3262503:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303687
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303687:
	st	%r15, [%sp+92]
code_3303681:
funtop_3301224:
	! making closure call
	sethi	%hi(beta_conrecordPRIME_3223448), %r8
	or	%r8, %lo(beta_conrecordPRIME_3223448), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303686:
code_3303683:
	! done making normal call
	ld	[%r8+4], %r8
code_3303685:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_beta_conrecord_code_3262503,(.-Normalize_beta_conrecord_code_3262503)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303686
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262508
 ! arguments : [$3262510,$8] [$3262511,$9] [$3244071,$10] 
 ! results    : [$3301184,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262508:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303729
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303729:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3303688:
funtop_3301135:
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(profile_3193128), %r8
	or	%r8, %lo(profile_3193128), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303725:
code_3303694:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3301153
	nop
zero_case_3301152:
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(local_profile_3193131), %r8
	or	%r8, %lo(local_profile_3193131), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3303727:
code_3303701:
	! done making normal call
	ba	after_zeroone_3301154 ! delay slot empty
	nop
one_case_3301153:
	or	%r0, 1, %r8
after_zeroone_3301154:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3301174
	nop
zero_case_3301173:
	! making closure call
	sethi	%hi(beta_conrecord_3223570), %r8
	or	%r8, %lo(beta_conrecord_3223570), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303705:
	! done making tail call
	ba	after_zeroone_3301175 ! delay slot empty
	nop
one_case_3301174:
	sethi	%hi(string_3266896), %r8
	or	%r8, %lo(string_3266896), %r10
	sethi	%hi(beta_conrecord_3044846), %r8
	or	%r8, %lo(beta_conrecord_3044846), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	! making closure call
	sethi	%hi(_3244106), %r8
	or	%r8, %lo(_3244106), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3303726:
	mov	%r8, %r12
code_3303712:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303723:
	mov	%r8, %r9
code_3303719:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303720:
	! done making tail call
after_zeroone_3301175:
code_3303722:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262508,(.-Normalize_anonfun_code_3262508)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303723
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3303725
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3303726
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3303727
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
	.text
	.align 8
	.global Normalize_eq_code_3262513
 ! arguments : [$3262515,$8] [$3262516,$9] [$3223735,$10] [$3223736,$11] 
 ! results    : [$3301134,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_eq_code_3262513:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303746
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303746:
	st	%r15, [%sp+92]
	mov	%r10, %r9
	mov	%r11, %r10
code_3303730:
funtop_3301098:
	add	%r4, 8, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303731
	nop
code_3303732:
	call	GCFromML ! delay slot empty
	nop
needgc_3303731:
	! allocating 1-record
	or	%r0, 9, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 8, %r4
	! done allocating 1 record
	! making closure call
	sethi	%hi(_3223755), %r8
	or	%r8, %lo(_3223755), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303745:
	mov	%r8, %r12
code_3303736:
	! done making normal call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(eq_opt_3244148), %r8
	or	%r8, %lo(eq_opt_3244148), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r11
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 112, %sp
code_3303741:
	! done making tail call
code_3303743:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_eq_code_3262513,(.-Normalize_eq_code_3262513)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303731
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303745
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.text
	.align 8
	.global Normalize_anonfun_code_3262529
 ! arguments : [$3262531,$8] [$3262532,$9] [$3044958,$10] 
 ! results    : [$3301097,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262529:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303758
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303758:
	st	%r15, [%sp+92]
	mov	%r9, %r11
	mov	%r10, %r13
code_3303747:
funtop_3301076:
	! making closure call
	sethi	%hi(member_3194842), %r8
	or	%r8, %lo(member_3194842), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	mov	%r11, %r10
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3303757:
	mov	%r8, %r10
code_3303750:
	! done making normal call
	! making closure call
	sethi	%hi(_3223867), %r8
	or	%r8, %lo(_3223867), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 96, %sp
code_3303753:
	! done making tail call
code_3303755:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262529,(.-Normalize_anonfun_code_3262529)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303757
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_help_inner_code_3262523
 ! arguments : [$3262525,$8] [$3262526,$9] [$3223642,$10] [$3223643,$11] [$3223644,$12] 
 ! results    : [$3300940,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_help_inner_code_3262523:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303810
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303810:
	st	%r15, [%sp+92]
	st	%r9, [%sp+108]
	st	%r11, [%sp+96]
	mov	%r12, %r10
code_3303759:
funtop_3300916:
	! making closure call
	sethi	%hi(_3223673), %r8
	or	%r8, %lo(_3223673), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303807:
code_3303762:
	! done making normal call
sumarm_3300936:
	cmp	%r8, 0
	bne	sumarm_3300937
	nop
code_3303763:
	ba	after_sum_3300933
	ld	[%sp+108], %r8
sumarm_3300937:
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3223732), %r8
	or	%r8, %lo(_3223732), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303809:
code_3303767:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	sethi	%hi(eq_3044916), %r8
	or	%r8, %lo(eq_3044916), %r10
	! making closure call
	sethi	%hi(all2_3193814), %r8
	or	%r8, %lo(all2_3193814), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303803:
	mov	%r8, %r9
code_3303771:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3303804:
code_3303772:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3301003
	nop
zero_case_3301002:
	ba	after_zeroone_3301004
	or	%r0, 0, %r8
one_case_3301003:
	or	%r0, 1, %r10
	or	%r0, 0, %r11
	! making closure call
	sethi	%hi(freeConVarInCon_3194820), %r8
	or	%r8, %lo(freeConVarInCon_3194820), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3303808:
	mov	%r8, %r11
code_3303777:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303778
	nop
code_3303779:
	call	GCFromML ! delay slot empty
	nop
needgc_3303778:
	! allocating 1 closures
	or	%r0, 537, %r10
	sethi	%hi(type_3194832), %r8
	or	%r8, %lo(type_3194832), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303783
	nop
code_3303784:
	or	%r0, 0, %r8
cmpui_3303783:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262529), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262529), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(all_3193773), %r8
	or	%r8, %lo(all_3193773), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303802:
	mov	%r8, %r12
code_3303788:
	! done making normal call
	sethi	%hi(type_3222901), %r8
	or	%r8, %lo(type_3222901), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303805:
	mov	%r8, %r9
code_3303795:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3303806:
code_3303796:
	! done making normal call
after_zeroone_3301004:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3301071
	nop
zero_case_3301070:
	ba	after_zeroone_3301072
	ld	[%sp+108], %r9
one_case_3301071:
	ld	[%sp+104], %r9
after_zeroone_3301072:
	ba	after_sum_3300933
	mov	%r9, %r8
sumarm_3300941:
after_sum_3300933:
code_3303801:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_help_inner_code_3262523,(.-Normalize_help_inner_code_3262523)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303802
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303803
	.word 0x001c000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00ff0000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303804
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3303778
	.word 0x001c000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
	.word 0x80000003
	.long type_3194832
		! -------- label,sizes,reg
	.long code_3303805
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303806
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f00000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303807
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long reify_3248774
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303808
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long type_3223727
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303809
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_eta_confunPRIME_code_3262537
 ! arguments : [$3262539,$8] [$3262540,$9] [$3044973,$10] 
 ! results    : [$3300914,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_eta_confunPRIME_code_3262537:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303846
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3303846:
	st	%r15, [%sp+92]
code_3303811:
funtop_3300723:
	ld	[%r9], %r16
	st	%r16, [%sp+112]
	ld	[%r9+4], %r16
	st	%r16, [%sp+108]
sumarm_3300734:
	ld	[%r10], %r8
	cmp	%r8, 7
	bne	sumarm_3300735
	nop
code_3303812:
	ld	[%r10+4], %r8
	ld	[%r8+4], %r9
	ld	[%r8+8], %r11
sumarm_3300752:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3300750
	nop
code_3303813:
	ld	[%r9], %r10
	ld	[%r9+4], %r9
sumarm_3300785:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3300786
	nop
code_3303814:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
sumarm_3300805:
	cmp	%r9, 0
	bne	sumarm_3300806
	nop
sumarm_3300813:
	ld	[%r11], %r8
	cmp	%r8, 13
	bne	sumarm_3300814
	nop
code_3303816:
	ld	[%r11+4], %r11
	! making closure call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+96], %r10
code_3303842:
code_3303819:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3300831
	nop
zero_case_3300830:
	ba	after_zeroone_3300832
	ld	[%sp+112], %r8
one_case_3300831:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r13
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+100], %r11
	ld	[%sp+104], %r12
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 128, %sp
code_3303822:
	! done making tail call
after_zeroone_3300832:
	ba	after_sum_3300810 ! delay slot empty
	nop
sumarm_3300814:
nomatch_sum_3300811:
	ld	[%sp+112], %r8
after_sum_3300810:
	ba	after_sum_3300802 ! delay slot empty
	nop
sumarm_3300806:
nomatch_sum_3300803:
	ld	[%sp+112], %r8
after_sum_3300802:
	ba	after_sum_3300782 ! delay slot empty
	nop
sumarm_3300786:
	ld	[%r10], %r8
	cmp	%r8, 2
	bne	sumarm_3300849
	nop
code_3303826:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+100]
sumarm_3300868:
	cmp	%r9, 0
	bne	sumarm_3300869
	nop
sumarm_3300876:
	ld	[%r11], %r8
	cmp	%r8, 13
	bne	sumarm_3300877
	nop
code_3303828:
	ld	[%r11+4], %r11
	! making closure call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r10
code_3303843:
code_3303831:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3300894
	nop
zero_case_3300893:
	ba	after_zeroone_3300895
	ld	[%sp+112], %r8
one_case_3300894:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r13
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+96], %r11
	ld	[%sp+100], %r12
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 128, %sp
code_3303834:
	! done making tail call
after_zeroone_3300895:
	ba	after_sum_3300873 ! delay slot empty
	nop
sumarm_3300877:
nomatch_sum_3300874:
	ld	[%sp+112], %r8
after_sum_3300873:
	ba	after_sum_3300865 ! delay slot empty
	nop
sumarm_3300869:
nomatch_sum_3300866:
	ld	[%sp+112], %r8
after_sum_3300865:
	ba	after_sum_3300782 ! delay slot empty
	nop
sumarm_3300849:
nomatch_sum_3300783:
	ld	[%sp+112], %r8
after_sum_3300782:
	ba	after_sum_3300749 ! delay slot empty
	nop
sumarm_3300753:
nomatch_sum_3300750:
	ld	[%sp+112], %r8
after_sum_3300749:
	ba	after_sum_3300731 ! delay slot empty
	nop
sumarm_3300735:
nomatch_sum_3300732:
	ld	[%sp+112], %r8
after_sum_3300731:
code_3303841:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_eta_confunPRIME_code_3262537,(.-Normalize_eta_confunPRIME_code_3262537)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303842
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303843
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x034f0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_eta_confun_inner_code_3262518
 ! arguments : [$3262520,$8] [$3262521,$9] [$3044879,$10] 
 ! results    : [$3300722,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_eta_confun_inner_code_3262518:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303885
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3303885:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3303847:
funtop_3300632:
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303848
	nop
code_3303849:
	call	GCFromML ! delay slot empty
	nop
needgc_3303848:
	! allocating 1 closures
	or	%r0, 537, %r10
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+4], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303853
	nop
code_3303854:
	or	%r0, 0, %r8
cmpui_3303853:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	sethi	%hi(Normalize_help_inner_code_3262523), %r8
	or	%r8, %lo(Normalize_help_inner_code_3262523), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r11
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	or	%r0, 529, %r10
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+4], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303858
	nop
code_3303859:
	or	%r0, 0, %r8
cmpui_3303858:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_eta_confunPRIME_code_3262537), %r8
	or	%r8, %lo(Normalize_eta_confunPRIME_code_3262537), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303881:
	mov	%r8, %r10
code_3303867:
	! done making normal call
	! making closure call
	sethi	%hi(map_annotate_3193309), %r8
	or	%r8, %lo(map_annotate_3193309), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3303882:
	mov	%r8, %r12
code_3303870:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3303883:
	mov	%r8, %r9
code_3303877:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3303878:
	! done making tail call
code_3303880:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_eta_confun_inner_code_3262518,(.-Normalize_eta_confun_inner_code_3262518)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3303881
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3303848
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303882
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3303883
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_insert_kind_inner_code_3262546
 ! arguments : [$3262548,$8] [$3262549,$9] [$3225449,$10] [$3225450,$11] [$3225451,$12] 
 ! results    : [$3300631,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_insert_kind_inner_code_3262546:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303893
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303893:
	st	%r15, [%sp+92]
code_3303886:
funtop_3300618:
	! making closure call
	sethi	%hi(strbindvar_r_insert_kind_3196279), %r8
	or	%r8, %lo(strbindvar_r_insert_kind_3196279), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 96, %sp
code_3303889:
	! done making tail call
code_3303891:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_insert_kind_inner_code_3262546,(.-Normalize_insert_kind_inner_code_3262546)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3262551
 ! arguments : [$3262553,$8] [$3262554,$9] [$3226528,$10] [$3226529,$11] 
 ! results    : [$3300615,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_anonfun_code_3262551:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303901
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303901:
	st	%r15, [%sp+92]
	mov	%r10, %r8
code_3303894:
funtop_3300599:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303895
	nop
code_3303896:
	call	GCFromML ! delay slot empty
	nop
needgc_3303895:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3197419), %r8
	ld	[%r8+%lo(gctag_3197419)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3303900:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262551,(.-Normalize_anonfun_code_3262551)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303895
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3100
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3262556
 ! arguments : [$3262558,$8] [$3262559,$9] [$3226754,$10] [$3226755,$11] 
 ! results    : [$3300596,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_anonfun_code_3262556:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303909
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303909:
	st	%r15, [%sp+92]
	mov	%r10, %r12
code_3303902:
funtop_3300580:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303903
	nop
code_3303904:
	call	GCFromML ! delay slot empty
	nop
needgc_3303903:
	ld	[%r11], %r9
	ld	[%r11+4], %r10
	! allocating 2-record
	or	%r0, 273, %r8
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3197477), %r8
	ld	[%r8+%lo(gctag_3197477)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3303908:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262556,(.-Normalize_anonfun_code_3262556)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303903
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_record_temp_code_3262561
 ! arguments : [$3262563,$8] [$3262564,$9] [$3228776,$10] [$3228777,$11] [$3228778,$12] 
 ! results    : [$3300576,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_record_temp_code_3262561:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303917
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303917:
	st	%r15, [%sp+92]
code_3303910:
funtop_3300564:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303911
	nop
code_3303912:
	call	GCFromML ! delay slot empty
	nop
needgc_3303911:
	! allocating 3-record
	sethi	%hi(record_gctag_3228784), %r8
	ld	[%r8+%lo(record_gctag_3228784)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3303916:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3262561,(.-Normalize_record_temp_code_3262561)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303911
	.word 0x0018000b
	.word 0x00170000
	.word 0xbffc2000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_record_temp_code_3262566
 ! arguments : [$3262568,$8] [$3262569,$9] [$3229055,$10] [$3229056,$11] [$3229057,$12] 
 ! results    : [$3300560,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_record_temp_code_3262566:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303925
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303925:
	st	%r15, [%sp+92]
code_3303918:
funtop_3300548:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303919
	nop
code_3303920:
	call	GCFromML ! delay slot empty
	nop
needgc_3303919:
	! allocating 3-record
	sethi	%hi(record_gctag_3228784), %r8
	ld	[%r8+%lo(record_gctag_3228784)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3303924:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3262566,(.-Normalize_record_temp_code_3262566)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303919
	.word 0x0018000b
	.word 0x00170000
	.word 0xbffc2000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3262571
 ! arguments : [$3262573,$8] [$3262574,$9] [$3046163,$10] 
 ! results    : [$3300544,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_anonfun_code_3262571:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303933
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303933:
	st	%r15, [%sp+92]
code_3303926:
funtop_3300538:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303927
	nop
code_3303928:
	call	GCFromML ! delay slot empty
	nop
needgc_3303927:
	! allocating 2-record
	sethi	%hi(gctag_3197419), %r8
	ld	[%r8+%lo(gctag_3197419)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3303932:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262571,(.-Normalize_anonfun_code_3262571)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3303927
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262576
 ! arguments : [$3262578,$8] [$3262579,$9] [$3229945,$10] [$3229946,$11] 
 ! results    : [$3229945,$8] 
 ! destroys   :  $11 $9 $8
 ! modifies   :  $11 $9 $8
Normalize_anonfun_code_3262576:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303937
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303937:
	st	%r15, [%sp+92]
	mov	%r10, %r8
code_3303934:
funtop_3300535:
code_3303936:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262576,(.-Normalize_anonfun_code_3262576)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3262581
 ! arguments : [$3262583,$8] [$3262584,$9] [$3230004,$10] [$3230005,$11] 
 ! results    : [$3230005,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_anonfun_code_3262581:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303941
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303941:
	st	%r15, [%sp+92]
	mov	%r11, %r8
code_3303938:
funtop_3300532:
code_3303940:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262581,(.-Normalize_anonfun_code_3262581)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_eta_confun_r_code_3262586
 ! arguments : [$3262588,$8] [$3044860,$9] [$3262589,$10] [$3044861,$11] 
 ! results    : [$3300529,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_eta_confun_r_code_3262586:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303947
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303947:
	st	%r15, [%sp+92]
code_3303942:
funtop_3300526:
	sethi	%hi(eta_confun_inner_3046403), %r8
	or	%r8, %lo(eta_confun_inner_3046403), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
code_3303946:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_eta_confun_r_code_3262586,(.-Normalize_eta_confun_r_code_3262586)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3262675
 ! arguments : [$3262677,$8] [$3262678,$9] [$3224101,$10] [$3224102,$11] [$3224103,$12] 
 ! results    : [$3300525,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262675:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3303955
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3303955:
	st	%r15, [%sp+92]
	mov	%r9, %r13
	mov	%r10, %r18
code_3303948:
funtop_3300513:
	! making closure call
	sethi	%hi(primequiv_3193318), %r8
	or	%r8, %lo(primequiv_3193318), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	mov	%r13, %r10
	mov	%r18, %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3303951:
	! done making tail call
code_3303953:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262675,(.-Normalize_anonfun_code_3262675)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_beta_typecasePRIME_code_3262669
 ! arguments : [$3262671,$8] [$3262672,$9] [$3045071,$10] 
 ! results    : [$3300481,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_typecasePRIME_code_3262669:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304044
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3304044:
	st	%r15, [%sp+92]
code_3303956:
funtop_3300237:
	ld	[%r9], %r16
	st	%r16, [%sp+116]
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+112]
sumarm_3300250:
	ld	[%r10], %r8
	cmp	%r8, 11
	bne	sumarm_3300251
	nop
code_3303957:
	ld	[%r10+4], %r8
	ld	[%r8], %r10
	ld	[%r8+8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+12], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3224092), %r8
	or	%r8, %lo(_3224092), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304031:
	mov	%r8, %r9
code_3303960:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3303961
	nop
code_3303962:
	call	GCFromML ! delay slot empty
	nop
needgc_3303961:
sumarm_3300279:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3300277
	nop
code_3303964:
	ld	[%r9], %r11
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
	! allocating 1 closures
	or	%r0, 537, %r10
	sethi	%hi(type_3248742), %r8
	or	%r8, %lo(type_3248742), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3303967
	nop
code_3303968:
	or	%r0, 0, %r8
cmpui_3303967:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262675), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262675), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(_3195170), %r8
	or	%r8, %lo(_3195170), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304030:
	mov	%r8, %r12
code_3303972:
	! done making normal call
	sethi	%hi(type_3248708), %r8
	or	%r8, %lo(type_3248708), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3248714), %r8
	or	%r8, %lo(type_3248714), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3304032:
	mov	%r8, %r9
code_3303979:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3304033:
code_3303980:
	! done making normal call
sumarm_3300362:
	cmp	%r8, 0
	bne	sumarm_3300363
	nop
code_3303981:
	ba	after_sum_3300359
	ld	[%sp+104], %r8
sumarm_3300363:
	ld	[%r8+4], %r10
	ld	[%r8+8], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3224226), %r8
	or	%r8, %lo(_3224226), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304043:
code_3303985:
	! done making normal call
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3224282), %r8
	or	%r8, %lo(_3224282), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304034:
	mov	%r8, %r12
code_3303988:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3224280), %r8
	or	%r8, %lo(type_3224280), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3304035:
	mov	%r8, %r9
code_3303995:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3304036:
	mov	%r8, %r10
code_3303996:
	! done making normal call
	! making closure call
	sethi	%hi(_3224340), %r8
	or	%r8, %lo(_3224340), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304037:
	mov	%r8, %r11
code_3303999:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r10
code_3304038:
	mov	%r8, %r12
code_3304000:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304039:
	mov	%r8, %r9
code_3304007:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3304008:
	! done making tail call
	ba	after_sum_3300359 ! delay slot empty
	nop
sumarm_3300367:
after_sum_3300359:
	ba	after_sum_3300276
	mov	%r8, %r10
sumarm_3300280:
nomatch_sum_3300277:
	ld	[%sp+96], %r10
after_sum_3300276:
	ba	after_sum_3300247
	mov	%r10, %r8
sumarm_3300251:
nomatch_sum_3300248:
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3304042:
code_3304014:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304015
	nop
code_3304016:
	call	GCFromML ! delay slot empty
	nop
needgc_3304015:
	sethi	%hi(exn_handler_3300492), %r8
	or	%r8, %lo(exn_handler_3300492), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	sethi	%hi(string_3267902), %r8
	or	%r8, %lo(string_3267902), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304041:
code_3304023:
	! done making normal call
	ba	exn_handler_after_3300493
	ld	[%r1+12], %r1
exn_handler_3300492:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3300493:
after_sum_3300247:
code_3304029:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_beta_typecasePRIME_code_3262669,(.-Normalize_beta_typecasePRIME_code_3262669)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304030
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0dfc0000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248755
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304031
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0df30000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248755
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3303961
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x0df30000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248755
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3248754
		! -------- label,sizes,reg
	.long code_3304032
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0dfc0000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248755
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304033
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d3c0000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304034
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d0f0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304035
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d0f0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304036
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d030000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304037
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d030000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304038
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3304039
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3304015
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304041
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304042
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304043
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d0f0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3262664
 ! arguments : [$3262666,$8] [$3262667,$9] [$3045068,$10] 
 ! results    : [$3300236,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262664:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304082
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304082:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3304045:
funtop_3300150:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304046
	nop
code_3304047:
	call	GCFromML ! delay slot empty
	nop
needgc_3304046:
	ld	[%r9], %r8
	ld	[%r9+4], %r12
	! allocating 1 closures
	or	%r0, 1049, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304051
	nop
code_3304052:
	or	%r0, 0, %r9
cmpui_3304051:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(_c_3044472), %r9
	or	%r9, %lo(_c_3044472), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+4], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304055
	nop
code_3304056:
	or	%r0, 0, %r9
cmpui_3304055:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_beta_typecasePRIME_code_3262669), %r8
	or	%r8, %lo(Normalize_beta_typecasePRIME_code_3262669), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304078:
	mov	%r8, %r10
code_3304064:
	! done making normal call
	! making closure call
	sethi	%hi(map_annotate_3193309), %r8
	or	%r8, %lo(map_annotate_3193309), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304079:
	mov	%r8, %r12
code_3304067:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304080:
	mov	%r8, %r9
code_3304074:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3304075:
	! done making tail call
code_3304077:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262664,(.-Normalize_anonfun_code_3262664)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304078
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3304046
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304079
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304080
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_beta_typecase_inner_code_3262656
 ! arguments : [$3262658,$8] [$3262659,$9] [$3045066,$10] 
 ! results    : [$3300149,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_typecase_inner_code_3262656:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304104
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304104:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
code_3304083:
funtop_3300094:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304103:
	mov	%r8, %r11
code_3304084:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304085
	nop
code_3304086:
	call	GCFromML ! delay slot empty
	nop
needgc_3304085:
	! allocating 1 closures
	or	%r0, 529, %r10
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304090
	nop
code_3304091:
	or	%r0, 0, %r8
cmpui_3304090:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262664), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262664), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304102:
code_3304099:
	! done making normal call
code_3304101:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_beta_typecase_inner_code_3262656,(.-Normalize_beta_typecase_inner_code_3262656)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304102
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304085
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000800
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304103
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_beta_typecase_r_code_3262591
 ! arguments : [$3262593,$8] [$3195065,$9] [$3262594,$10] [$3195066,$11] 
 ! results    : [$3300093,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_typecase_r_code_3262591:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304120
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304120:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304105:
funtop_3300058:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304106
	nop
code_3304107:
	call	GCFromML ! delay slot empty
	nop
needgc_3304106:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_beta_typecase_inner_code_3262656), %r8
	or	%r8, %lo(Normalize_beta_typecase_inner_code_3262656), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244064), %r8
	or	%r8, %lo(type_3244064), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304119:
code_3304116:
	! done making normal call
code_3304118:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_beta_typecase_r_code_3262591,(.-Normalize_beta_typecase_r_code_3262591)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304106
	.word 0x00180007
	.word 0x00170000
	.word 0x00001c00
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304119
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262706
 ! arguments : [$3262708,$8] [$3262709,$9] [$3045158,$10] 
 ! results    : [$3300057,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262706:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304146
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304146:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3304121:
funtop_3299992:
	ld	[%r9], %r10
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
	ld	[%r9+8], %r9
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304145:
	mov	%r8, %r12
code_3304122:
	! done making normal call
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224508), %r8
	or	%r8, %lo(type_3224508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304141:
	mov	%r8, %r9
code_3304129:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3304142:
	mov	%r8, %r12
code_3304130:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3223454), %r8
	or	%r8, %lo(type_3223454), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304143:
	mov	%r8, %r9
code_3304137:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3304144:
code_3304138:
	! done making normal call
	ld	[%r8+4], %r8
code_3304140:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262706,(.-Normalize_anonfun_code_3262706)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304141
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304142
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304143
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304144
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304145
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3262701
 ! arguments : [$3262703,$8] [$3262704,$9] [$3045156,$10] 
 ! results    : [$3299991,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262701:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304170
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304170:
	st	%r15, [%sp+92]
code_3304147:
funtop_3299939:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304148
	nop
code_3304149:
	call	GCFromML ! delay slot empty
	nop
needgc_3304148:
	ld	[%r9], %r13
	ld	[%r9+4], %r12
	! allocating 1 closures
	or	%r0, 1049, %r11
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304153
	nop
code_3304154:
	or	%r0, 0, %r8
cmpui_3304153:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304157
	nop
code_3304158:
	or	%r0, 0, %r8
cmpui_3304157:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r13, [%r4+4]
	st	%r10, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262706), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262706), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304169:
code_3304166:
	! done making normal call
code_3304168:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262701,(.-Normalize_anonfun_code_3262701)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304169
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304148
	.word 0x00180009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_beta_confun_inner_code_3262693
 ! arguments : [$3262695,$8] [$3262696,$9] [$3045154,$10] 
 ! results    : [$3299938,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_confun_inner_code_3262693:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304200
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304200:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
code_3304171:
funtop_3299867:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304199:
	mov	%r8, %r12
code_3304172:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224509), %r8
	or	%r8, %lo(type_3224509), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304198:
	mov	%r8, %r11
code_3304179:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304180
	nop
code_3304181:
	call	GCFromML ! delay slot empty
	nop
needgc_3304180:
	! allocating 1 closures
	or	%r0, 529, %r10
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304185
	nop
code_3304186:
	or	%r0, 0, %r8
cmpui_3304185:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262701), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262701), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244064), %r8
	or	%r8, %lo(type_3244064), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304197:
code_3304194:
	! done making normal call
code_3304196:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_beta_confun_inner_code_3262693,(.-Normalize_beta_confun_inner_code_3262693)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304197
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304198
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long needgc_3304180
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000800
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3304199
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
	.text
	.align 8
	.global Normalize_beta_confun_r_code_3262596
 ! arguments : [$3262598,$8] [$3195320,$9] [$3262599,$10] [$3195321,$11] 
 ! results    : [$3299866,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_confun_r_code_3262596:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304216
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304216:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304201:
funtop_3299831:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304202
	nop
code_3304203:
	call	GCFromML ! delay slot empty
	nop
needgc_3304202:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_beta_confun_inner_code_3262693), %r8
	or	%r8, %lo(Normalize_beta_confun_inner_code_3262693), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3195318), %r8
	or	%r8, %lo(type_3195318), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304215:
code_3304212:
	! done making normal call
code_3304214:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_beta_confun_r_code_3262596,(.-Normalize_beta_confun_r_code_3262596)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304202
	.word 0x00180007
	.word 0x00170000
	.word 0x00001c00
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304215
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262741
 ! arguments : [$3262743,$8] [$3262744,$9] [$3224925,$10] [$3224926,$11] 
 ! results    : [$3299827,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262741:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304276
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3304276:
	st	%r15, [%sp+92]
	st	%r11, [%sp+112]
code_3304217:
funtop_3299690:
	ld	[%r9], %r16
	st	%r16, [%sp+108]
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9+12], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3224984), %r8
	or	%r8, %lo(_3224984), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304273:
code_3304220:
	! done making normal call
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3225040), %r8
	or	%r8, %lo(_3225040), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304265:
	mov	%r8, %r12
code_3304223:
	! done making normal call
	sethi	%hi(type_3225033), %r8
	or	%r8, %lo(type_3225033), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3224337), %r8
	or	%r8, %lo(type_3224337), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3304266:
	mov	%r8, %r9
code_3304230:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3304267:
	mov	%r8, %r10
code_3304231:
	! done making normal call
	! making closure call
	sethi	%hi(_3224340), %r8
	or	%r8, %lo(_3224340), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304268:
	mov	%r8, %r13
code_3304234:
	! done making normal call
	ld	[%sp+100], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3299757
	nop
zero_case_3299756:
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3304275:
	mov	%r8, %r12
code_3304236:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304269:
	mov	%r8, %r9
code_3304243:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3304270:
code_3304244:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304245
	nop
code_3304246:
	call	GCFromML ! delay slot empty
	nop
needgc_3304245:
	ba	after_zeroone_3299758
	mov	%r8, %r9
one_case_3299757:
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	mov	%r13, %r10
code_3304274:
	mov	%r8, %r12
code_3304250:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304271:
	mov	%r8, %r9
code_3304257:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3304272:
code_3304258:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304259
	nop
code_3304260:
	call	GCFromML ! delay slot empty
	nop
needgc_3304259:
	mov	%r8, %r9
after_zeroone_3299758:
	! allocating 2-record
	sethi	%hi(gctag_3194531), %r8
	ld	[%r8+%lo(gctag_3194531)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3304264:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3262741,(.-Normalize_anonfun_code_3262741)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304265
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03d70000
		! worddata
	.word 0x80000000
	.long reify_3248289
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304266
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03d70000
		! worddata
	.word 0x80000000
	.long reify_3248289
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304267
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03d40000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304268
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03d40000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304269
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304270
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304245
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3304271
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304272
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304259
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3304273
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03d70000
		! worddata
	.word 0x80000000
	.long reify_3248289
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304274
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304275
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_reduce_inner_code_3262736
 ! arguments : [$3262738,$8] [$3262739,$9] [$3045299,$10] 
 ! results    : [$3299684,$8] 
 ! destroys   :  $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $18 $13 $12 $11 $10 $9 $8
Normalize_reduce_inner_code_3262736:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304292
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304292:
	st	%r15, [%sp+92]
	mov	%r9, %r11
code_3304277:
funtop_3299653:
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304278
	nop
code_3304279:
	call	GCFromML ! delay slot empty
	nop
needgc_3304278:
	ld	[%r11], %r9
	ld	[%r11+4], %r8
	ld	[%r11+8], %r18
	! allocating 1 closures
	or	%r0, 3105, %r13
	sethi	%hi(type_3193048), %r11
	or	%r11, %lo(type_3193048), %r12
	ld	[%r2+804], %r11
	add	%r12, %r11, %r11
	ld	[%r11], %r11
	cmp	%r11, 3
	or	%r0, 1, %r11
	bgu	cmpui_3304283
	nop
code_3304284:
	or	%r0, 0, %r11
cmpui_3304283:
	sll	%r11, 8, %r11
	add	%r11, %r0, %r11
	or	%r11, %r13, %r13
	sethi	%hi(reify_3248289), %r11
	or	%r11, %lo(reify_3248289), %r12
	ld	[%r2+804], %r11
	add	%r12, %r11, %r11
	ld	[%r11], %r11
	cmp	%r11, 3
	or	%r0, 1, %r11
	bgu	cmpui_3304287
	nop
code_3304288:
	or	%r0, 0, %r11
cmpui_3304287:
	sll	%r11, 9, %r11
	add	%r11, %r0, %r11
	or	%r11, %r13, %r13
	! allocating 4-record
	st	%r13, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	st	%r8, [%r4+12]
	st	%r18, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262741), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262741), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304291:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_reduce_inner_code_3262736,(.-Normalize_reduce_inner_code_3262736)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304278
	.word 0x00180009
	.word 0x00170000
	.word 0xbff80800
	.word 0xbff80400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248289
	.text
	.align 8
	.global Normalize_lambda_or_closure_code_3262762
 ! arguments : [$3262764,$8] [$3262765,$9] [$3045232,$10] 
 ! results    : [$3299440,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_lambda_or_closure_code_3262762:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304360
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304360:
	st	%r15, [%sp+92]
	mov	%r8, %r11
	st	%r9, [%sp+108]
code_3304293:
funtop_3299420:
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304294
	nop
code_3304295:
	call	GCFromML ! delay slot empty
	nop
needgc_3304294:
sumarm_3299427:
	ld	[%r10], %r8
	cmp	%r8, 1
	bne	sumarm_3299428
	nop
code_3304297:
	ld	[%r10+4], %r8
	ld	[%r8+4], %r8
	! making direct call 
	ba	funtop_3299420
	mov	%r8, %r10
code_3304298:
	! done making self tail call
	ba	after_sum_3299424
	or	%r0, 0, %r8
sumarm_3299428:
	ld	[%r10], %r8
	cmp	%r8, 3
	bne	sumarm_3299441
	nop
code_3304300:
	ld	[%r10+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r8
	sethi	%hi(type_3195690), %r9
	or	%r9, %lo(type_3195690), %r12
	ld	[%r2+804], %r9
	add	%r12, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3299459
	nop
code_3304303:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3299460
	nop
code_3304304:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3299459
	nop
code_3304305:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3299459
	nop
code_3304306:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3299459
	nop
dynamic_nobox_3299460:
	ba	xinject_sum_dyn_after_3299453
	st	%r8, [%sp+96]
dynamic_box_3299459:
	or	%r0, 9, %r13
	sethi	%hi(_c_3044472), %r9
	or	%r9, %lo(_c_3044472), %r12
	ld	[%r2+804], %r9
	add	%r12, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+4], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304311
	nop
code_3304312:
	or	%r0, 0, %r9
cmpui_3304311:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r13, %r13
	! allocating 1-record
	st	%r13, [%r4]
	st	%r8, [%r4+4]
	add	%r4, 4, %r8
	add	%r4, 8, %r4
	! done allocating 1 record
	st	%r8, [%sp+96]
xinject_sum_dyn_after_3299453:
	! making direct call 
	mov	%r11, %r8
	call	Normalize_lambda_or_closure_code_3262762
	ld	[%sp+108], %r9
code_3304359:
code_3304313:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304314
	nop
code_3304315:
	call	GCFromML ! delay slot empty
	nop
needgc_3304314:
	ld	[%r8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3195707), %r8
	ld	[%r8+%lo(gctag_3195707)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3299424 ! delay slot empty
	nop
sumarm_3299441:
	ld	[%r10], %r8
	cmp	%r8, 7
	bne	sumarm_3299484
	nop
code_3304319:
	ld	[%r10+4], %r8
	ld	[%r8+4], %r11
	ld	[%r8+8], %r10
sumarm_3299501:
	or	%r0, 255, %r8
	cmp	%r11, %r8
	bleu	nomatch_sum_3299499
	nop
code_3304320:
	ld	[%r11], %r9
	ld	[%r11+4], %r8
sumarm_3299538:
	cmp	%r8, 0
	bne	sumarm_3299539
	nop
sumarm_3299546:
	ld	[%r9], %r8
	cmp	%r8, 0
	bne	sumarm_3299547
	nop
code_3304322:
	ld	[%r9+4], %r8
	ld	[%r8], %r12
	ld	[%r8+4], %r11
	ld	[%r8+8], %r9
	! allocating 3-record
	sethi	%hi(gctag_3194968), %r8
	ld	[%r8+%lo(gctag_3194968)], %r8
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	st	%r11, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3299543 ! delay slot empty
	nop
sumarm_3299547:
	ld	[%r9], %r8
	cmp	%r8, 2
	bne	sumarm_3299566
	nop
code_3304325:
	ld	[%r9+4], %r8
	ld	[%r8], %r12
	ld	[%r8+4], %r11
	ld	[%r8+8], %r9
	! allocating 3-record
	sethi	%hi(gctag_3194968), %r8
	ld	[%r8+%lo(gctag_3194968)], %r8
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	st	%r11, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3299543 ! delay slot empty
	nop
sumarm_3299566:
nomatch_sum_3299544:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3299543:
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3224705), %r8
	or	%r8, %lo(_3224705), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304357:
	mov	%r8, %r9
code_3304331:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304332
	nop
code_3304333:
	call	GCFromML ! delay slot empty
	nop
needgc_3304332:
sumarm_3299605:
	ld	[%r9], %r8
	cmp	%r8, 13
	bne	sumarm_3299606
	nop
code_3304335:
	ld	[%r9+4], %r11
	! making closure call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r10
code_3304358:
code_3304338:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304339
	nop
code_3304340:
	call	GCFromML ! delay slot empty
	nop
needgc_3304339:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3299623
	nop
zero_case_3299622:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	ba	after_zeroone_3299624
	or	%r0, 0, %r8
one_case_3299623:
	! allocating 2-record
	sethi	%hi(gctag_3195594), %r8
	ld	[%r8+%lo(gctag_3195594)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
after_zeroone_3299624:
	ba	after_sum_3299602
	mov	%r8, %r9
sumarm_3299606:
nomatch_sum_3299603:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
	mov	%r8, %r9
after_sum_3299602:
	! allocating 2-record
	sethi	%hi(gctag_3195707), %r8
	ld	[%r8+%lo(gctag_3195707)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3299535 ! delay slot empty
	nop
sumarm_3299539:
nomatch_sum_3299536:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3299535:
	ba	after_sum_3299498 ! delay slot empty
	nop
sumarm_3299502:
nomatch_sum_3299499:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3299498:
	ba	after_sum_3299424 ! delay slot empty
	nop
sumarm_3299484:
nomatch_sum_3299425:
	ld	[%sp+108], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3299424:
code_3304356:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_lambda_or_closure_code_3262762,(.-Normalize_lambda_or_closure_code_3262762)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304357
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004f0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3304294
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000800
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00400000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3304314
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3304332
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x004f0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3304358
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x004f0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3304339
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x004f0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3304359
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.text
	.align 8
	.global Normalize_anonfun_code_3262757
 ! arguments : [$3262759,$8] [$3262760,$9] [$3045165,$10] 
 ! results    : [$3299388,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262757:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304430
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304430:
	st	%r15, [%sp+92]
	st	%r9, [%sp+108]
	st	%r10, [%sp+96]
code_3304361:
funtop_3299175:
	add	%r4, 84, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304362
	nop
code_3304363:
	call	GCFromML ! delay slot empty
	nop
needgc_3304362:
sumarm_3299182:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 2
	bne	sumarm_3299183
	nop
code_3304365:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	sethi	%hi(exncounter), %r8
	or	%r8, %lo(exncounter), %r11
	ld	[%r11], %r8
	add	%r8, 1, %r9
	st	%r9, [%r11]
	! allocating 3-record
	or	%r0, 1561, %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	or	%r0, 256, %r9
	st	%r9, [%r4+8]
	sethi	%hi(string_3299210), %r9
	or	%r9, %lo(string_3299210), %r9
	st	%r9, [%r4+12]
	add	%r4, 4, %r11
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r9
	st	%r9, [%r4]
	sethi	%hi(Normalize_lambda_or_closure_code_3262762), %r9
	or	%r9, %lo(Normalize_lambda_or_closure_code_3262762), %r9
	st	%r9, [%r4+4]
	or	%r0, 256, %r9
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r13
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1-record
	or	%r0, 9, %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	add	%r4, 4, %r12
	add	%r4, 8, %r4
	! done allocating 1 record
	sethi	%hi(exn_handler_3299224), %r8
	or	%r8, %lo(exn_handler_3299224), %r11
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r9, [%r4+8]
	st	%r12, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	ld	[%r13], %r11
	ld	[%r13+4], %r8
	jmpl	%r11, %r15
	ld	[%r13+8], %r9
code_3304423:
	mov	%r8, %r9
code_3304371:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304372
	nop
code_3304373:
	call	GCFromML ! delay slot empty
	nop
needgc_3304372:
	ba	exn_handler_after_3299225
	ld	[%r1+12], %r1
exn_handler_3299224:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	ld	[%r8], %r8
	mov	%r15, %r10
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304378
	nop
code_3304379:
	call	GCFromML ! delay slot empty
	nop
needgc_3304378:
	ld	[%r10], %r9
exnarm_3299252:
	cmp	%r9, %r8
	bne	exnarm_3299254
	nop
code_3304381:
	ld	[%r10+4], %r8
	ba	afterPLUSexncase_3299251
	or	%r0, 0, %r8
exnarm_3299254:
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
afterPLUSexncase_3299251:
	mov	%r8, %r9
exn_handler_after_3299225:
sumarm_3299270:
	cmp	%r9, 0
	bne	sumarm_3299271
	nop
code_3304384:
	! allocating 2-record
	sethi	%hi(gctag_3194531), %r8
	ld	[%r8+%lo(gctag_3194531)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3299267 ! delay slot empty
	nop
sumarm_3299271:
	ld	[%r9], %r8
	ld	[%r9+4], %r10
sumarm_3299317:
	cmp	%r10, 0
	bne	sumarm_3299318
	nop
code_3304387:
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r11
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3304424:
	mov	%r8, %r9
code_3304388:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+100], %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 112, %sp
code_3304389:
	! done making tail call
	ba	after_sum_3299314 ! delay slot empty
	nop
sumarm_3299318:
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	sethi	%hi(type_3195690), %r8
	or	%r8, %lo(type_3195690), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3299360
	nop
code_3304393:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3299361
	nop
code_3304394:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3299360
	nop
code_3304395:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3299360
	nop
code_3304396:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3299360
	nop
dynamic_nobox_3299361:
	ba	projsum_single_after_3299357
	mov	%r10, %r9
dynamic_box_3299360:
	ld	[%r10], %r9
projsum_single_after_3299357:
	! allocating 2-record
	sethi	%hi(gctag_3196163), %r8
	ld	[%r8+%lo(gctag_3196163)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r11
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3304429:
	mov	%r8, %r9
code_3304400:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+100], %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 112, %sp
code_3304401:
	! done making tail call
	ba	after_sum_3299314 ! delay slot empty
	nop
sumarm_3299344:
after_sum_3299314:
	ba	after_sum_3299267 ! delay slot empty
	nop
sumarm_3299282:
after_sum_3299267:
	ba	after_sum_3299179 ! delay slot empty
	nop
sumarm_3299183:
nomatch_sum_3299180:
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3304428:
code_3304407:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304408
	nop
code_3304409:
	call	GCFromML ! delay slot empty
	nop
needgc_3304408:
	sethi	%hi(exn_handler_3299399), %r8
	or	%r8, %lo(exn_handler_3299399), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	sethi	%hi(string_3268365), %r8
	or	%r8, %lo(string_3268365), %r10
	! making closure call
	sethi	%hi(_3194589), %r8
	or	%r8, %lo(_3194589), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304427:
code_3304416:
	! done making normal call
	ba	exn_handler_after_3299400
	ld	[%r1+12], %r1
exn_handler_3299399:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3299400:
after_sum_3299179:
code_3304422:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262757,(.-Normalize_anonfun_code_3262757)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304362
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00430000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304423
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00730000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long needgc_3304372
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00730000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long needgc_3304378
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00730000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3304424
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3194964
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3304408
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304427
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304428
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304429
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3194964
	.word 0x80000000
	.long type_3193062
	.text
	.align 8
	.global Normalize_anonfun_code_3262731
 ! arguments : [$3262733,$8] [$3262734,$9] [$3045163,$10] 
 ! results    : [$3299174,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262731:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304451
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304451:
	st	%r15, [%sp+92]
	mov	%r10, %r13
code_3304431:
funtop_3299119:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304432
	nop
code_3304433:
	call	GCFromML ! delay slot empty
	nop
needgc_3304432:
	ld	[%r9], %r12
	ld	[%r9+4], %r11
	! allocating 1 closures
	or	%r0, 1561, %r10
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304437
	nop
code_3304438:
	or	%r0, 0, %r8
cmpui_3304437:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	st	%r13, [%r4+4]
	st	%r12, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_reduce_inner_code_3262736), %r8
	or	%r8, %lo(Normalize_reduce_inner_code_3262736), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262757), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262757), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3223454), %r8
	or	%r8, %lo(type_3223454), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304450:
code_3304447:
	! done making normal call
code_3304449:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3262731,(.-Normalize_anonfun_code_3262731)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304450
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304432
	.word 0x00180009
	.word 0x00170000
	.word 0x00000200
	.word 0x00002000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_beta_confunPRIME_inner_code_3262723
 ! arguments : [$3262725,$8] [$3262726,$9] [$3045161,$10] 
 ! results    : [$3299118,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_confunPRIME_inner_code_3262723:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304469
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304469:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
code_3304452:
funtop_3299070:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304467:
	mov	%r8, %r9
code_3304453:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304454
	nop
code_3304455:
	call	GCFromML ! delay slot empty
	nop
needgc_3304454:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262731), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262731), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224508), %r8
	or	%r8, %lo(type_3224508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304468:
code_3304464:
	! done making normal call
code_3304466:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_beta_confunPRIME_inner_code_3262723,(.-Normalize_beta_confunPRIME_inner_code_3262723)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304454
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3304467
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3304468
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_beta_confunPRIME_r_code_3262601
 ! arguments : [$3262603,$8] [$3195392,$9] [$3262604,$10] [$3195393,$11] 
 ! results    : [$3299069,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_beta_confunPRIME_r_code_3262601:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304485
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304485:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304470:
funtop_3299034:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304471
	nop
code_3304472:
	call	GCFromML ! delay slot empty
	nop
needgc_3304471:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_beta_confunPRIME_inner_code_3262723), %r8
	or	%r8, %lo(Normalize_beta_confunPRIME_inner_code_3262723), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224509), %r8
	or	%r8, %lo(type_3224509), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304484:
code_3304481:
	! done making normal call
code_3304483:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_beta_confunPRIME_r_code_3262601,(.-Normalize_beta_confunPRIME_r_code_3262601)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304471
	.word 0x00180007
	.word 0x00170000
	.word 0x00001c00
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304484
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_insert_kind_r_code_3262606
 ! arguments : [$3262608,$8] [$3196242,$9] [$3262609,$10] [$3196243,$11] 
 ! results    : [$3299033,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_insert_kind_r_code_3262606:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304490
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304490:
	st	%r15, [%sp+92]
code_3304486:
funtop_3299030:
	sethi	%hi(insert_kind_inner_3046407), %r8
	or	%r8, %lo(insert_kind_inner_3046407), %r8
code_3304489:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_insert_kind_r_code_3262606,(.-Normalize_insert_kind_r_code_3262606)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_bind_at_kind_inner_code_3262777
 ! arguments : [$3262779,$8] [$3262780,$9] [$3225461,$10] [$3225462,$11] 
 ! results    : [$3299027,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bind_at_kind_inner_code_3262777:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304548
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3304548:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r9, %r8
code_3304491:
funtop_3298866:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	ld	[%r10], %r16
	st	%r16, [%sp+124]
	ld	[%r10+4], %r16
	st	%r16, [%sp+108]
	ld	[%r11], %r16
	st	%r16, [%sp+120]
	ld	[%r11+4], %r16
	st	%r16, [%sp+116]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3304544:
	st	%r8, [%sp+112]
code_3304492:
	! done making normal call
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3304539:
	mov	%r8, %r9
code_3304493:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3304540:
	mov	%r8, %r12
code_3304494:
	! done making normal call
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3304541:
	mov	%r8, %r9
code_3304501:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3304542:
	st	%r8, [%sp+104]
code_3304502:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304503
	nop
code_3304504:
	call	GCFromML ! delay slot empty
	nop
needgc_3304503:
	sethi	%hi(exn_handler_3298930), %r8
	or	%r8, %lo(exn_handler_3298930), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	sethi	%hi(strbindvar_r_find_kind_3193973), %r8
	or	%r8, %lo(strbindvar_r_find_kind_3193973), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3304545:
code_3304510:
	! done making normal call
	or	%r0, 1, %r8
	ba	exn_handler_after_3298931
	ld	[%r1+12], %r1
exn_handler_3298930:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r10
	ld	[%r10], %r9
exnarm_3298955:
	sethi	%hi(stamp_3196365), %r8
	ld	[%r8+%lo(stamp_3196365)], %r8
	cmp	%r9, %r8
	bne	exnarm_3298958
	nop
code_3304515:
	ld	[%r10+4], %r8
	ba	afterPLUSexncase_3298954
	or	%r0, 0, %r8
exnarm_3298958:
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
afterPLUSexncase_3298954:
exn_handler_after_3298931:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3298968
	nop
zero_case_3298967:
	ld	[%sp+124], %r16
	ba	after_zeroone_3298969
	st	%r16, [%sp+100]
one_case_3298968:
	! making closure call
	sethi	%hi(derived_var_3193334), %r8
	or	%r8, %lo(derived_var_3193334), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+124], %r10
code_3304547:
code_3304522:
	! done making normal call
	st	%r8, [%sp+100]
after_zeroone_3298969:
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r13
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r9
	ld	[%sp+120], %r10
	ld	[%sp+100], %r11
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3304538:
	st	%r8, [%sp+96]
code_3304523:
	! done making normal call
	! making closure call
	sethi	%hi(_3225548), %r8
	or	%r8, %lo(_3225548), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3304543:
	mov	%r8, %r9
code_3304526:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304527
	nop
code_3304528:
	call	GCFromML ! delay slot empty
	nop
needgc_3304527:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+124], %r10
code_3304546:
	mov	%r8, %r9
code_3304530:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304531
	nop
code_3304532:
	call	GCFromML ! delay slot empty
	nop
needgc_3304531:
	! allocating 2-record
	sethi	%hi(gctag_3196406), %r8
	ld	[%r8+%lo(gctag_3196406)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3195270), %r8
	ld	[%r8+%lo(gctag_3195270)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3304537:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_bind_at_kind_inner_code_3262777,(.-Normalize_bind_at_kind_inner_code_3262777)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304538
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c300000
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304539
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3dc00000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304540
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3dc00000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304541
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3dc00000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304542
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3d000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3304503
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3d300000
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304543
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long needgc_3304527
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long needgc_3304531
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304544
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cd50000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304545
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3d300000
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304546
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3304547
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3d300000
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_bind_at_kind_r_code_3262611
 ! arguments : [$3262613,$8] [$3196295,$9] [$3262614,$10] [$3196296,$11] 
 ! results    : [$3298861,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_bind_at_kind_r_code_3262611:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304556
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304556:
	st	%r15, [%sp+92]
	mov	%r9, %r12
	mov	%r10, %r8
code_3304549:
funtop_3298842:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304550
	nop
code_3304551:
	call	GCFromML ! delay slot empty
	nop
needgc_3304550:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_bind_at_kind_inner_code_3262777), %r8
	or	%r8, %lo(Normalize_bind_at_kind_inner_code_3262777), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304555:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_bind_at_kind_r_code_3262611,(.-Normalize_bind_at_kind_r_code_3262611)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304550
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3900
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262800
 ! arguments : [$3262802,$8] [$3262803,$9] [$3045449,$10] 
 ! results    : [$3298841,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262800:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304576
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304576:
	st	%r15, [%sp+92]
	st	%r10, [%sp+100]
code_3304557:
funtop_3298793:
	ld	[%r9], %r10
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3196518), %r8
	or	%r8, %lo(_3196518), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304575:
	mov	%r8, %r9
code_3304560:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3304572:
	mov	%r8, %r12
code_3304561:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304573:
	mov	%r8, %r9
code_3304568:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3304569:
	! done making tail call
code_3304571:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262800,(.-Normalize_anonfun_code_3262800)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304572
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3248062
		! -------- label,sizes,reg
	.long code_3304573
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3248062
		! -------- label,sizes,reg
	.long code_3304575
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_bind_at_kinds_inner_code_3262792
 ! arguments : [$3262794,$8] [$3262795,$9] [$3225582,$10] [$3225583,$11] 
 ! results    : [$3298792,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bind_at_kinds_inner_code_3262792:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304608
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304608:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3304577:
funtop_3298713:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304607:
code_3304578:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304579
	nop
code_3304580:
	call	GCFromML ! delay slot empty
	nop
needgc_3304579:
	! allocating 1 closures
	or	%r0, 281, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304584
	nop
code_3304585:
	or	%r0, 0, %r9
cmpui_3304584:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304588
	nop
code_3304589:
	or	%r0, 0, %r9
cmpui_3304588:
	sll	%r9, 10, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262800), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262800), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3222681), %r8
	or	%r8, %lo(type_3222681), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label kind_TYC
	ld	[%r8+24], %r10
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	or	%r0, 2, %r8
	st	%r8, [%r4+8]
	sethi	%hi(type_3196281), %r8
	or	%r8, %lo(type_3196281), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	st	%r8, [%r4+12]
	st	%r10, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	ld	[%r11], %r10
	jmpl	%r10, %r15
	ld	[%r11+4], %r8
code_3304605:
	mov	%r8, %r12
code_3304597:
	! done making constructor call
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3304606:
code_3304602:
	! done making normal call
code_3304604:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_bind_at_kinds_inner_code_3262792,(.-Normalize_bind_at_kinds_inner_code_3262792)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304605
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3304579
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304606
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304607
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_bind_at_kinds_r_code_3262616
 ! arguments : [$3262618,$8] [$3196456,$9] [$3262619,$10] [$3196457,$11] 
 ! results    : [$3298708,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_bind_at_kinds_r_code_3262616:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304616
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304616:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304609:
funtop_3298694:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304610
	nop
code_3304611:
	call	GCFromML ! delay slot empty
	nop
needgc_3304610:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_bind_at_kinds_inner_code_3262792), %r8
	or	%r8, %lo(Normalize_bind_at_kinds_inner_code_3262792), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304615:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_bind_at_kinds_r_code_3262616,(.-Normalize_bind_at_kinds_r_code_3262616)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304610
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_bind_at_con_inner_code_3262815
 ! arguments : [$3262817,$8] [$3262818,$9] [$3225719,$10] [$3225720,$11] 
 ! results    : [$3298691,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bind_at_con_inner_code_3262815:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304674
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3304674:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	mov	%r10, %r12
	mov	%r11, %r10
code_3304617:
funtop_3298536:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	ld	[%r12], %r16
	st	%r16, [%sp+116]
	ld	[%r12+4], %r16
	st	%r16, [%sp+96]
	ld	[%r10], %r16
	st	%r16, [%sp+112]
	ld	[%r10+4], %r16
	st	%r16, [%sp+108]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304670:
	mov	%r8, %r9
code_3304618:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3304666:
	mov	%r8, %r12
code_3304619:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3304667:
	mov	%r8, %r9
code_3304626:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3304668:
	st	%r8, [%sp+104]
code_3304627:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304628
	nop
code_3304629:
	call	GCFromML ! delay slot empty
	nop
needgc_3304628:
	sethi	%hi(exn_handler_3298591), %r8
	or	%r8, %lo(exn_handler_3298591), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	sethi	%hi(strbindvar_r_find_con_3193975), %r8
	or	%r8, %lo(strbindvar_r_find_con_3193975), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3304671:
code_3304635:
	! done making normal call
	or	%r0, 1, %r8
	ba	exn_handler_after_3298592
	ld	[%r1+12], %r1
exn_handler_3298591:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r10
	ld	[%r10], %r9
exnarm_3298616:
	sethi	%hi(stamp_3196365), %r8
	ld	[%r8+%lo(stamp_3196365)], %r8
	cmp	%r9, %r8
	bne	exnarm_3298619
	nop
code_3304640:
	ld	[%r10+4], %r8
	ba	afterPLUSexncase_3298615
	or	%r0, 0, %r8
exnarm_3298619:
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
afterPLUSexncase_3298615:
exn_handler_after_3298592:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3298629
	nop
zero_case_3298628:
	ld	[%sp+116], %r16
	ba	after_zeroone_3298630
	st	%r16, [%sp+100]
one_case_3298629:
	! making closure call
	sethi	%hi(derived_var_3193334), %r8
	or	%r8, %lo(derived_var_3193334), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3304673:
code_3304647:
	! done making normal call
	st	%r8, [%sp+100]
after_zeroone_3298630:
	! making closure call
	sethi	%hi(strbindvar_r_insert_con_3193976), %r8
	or	%r8, %lo(strbindvar_r_insert_con_3193976), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	ld	[%sp+100], %r11
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3304665:
	st	%r8, [%sp+96]
code_3304650:
	! done making normal call
	! making closure call
	sethi	%hi(_3225548), %r8
	or	%r8, %lo(_3225548), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3304669:
	mov	%r8, %r9
code_3304653:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304654
	nop
code_3304655:
	call	GCFromML ! delay slot empty
	nop
needgc_3304654:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r10
code_3304672:
	mov	%r8, %r9
code_3304657:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304658
	nop
code_3304659:
	call	GCFromML ! delay slot empty
	nop
needgc_3304658:
	! allocating 2-record
	sethi	%hi(gctag_3196399), %r8
	ld	[%r8+%lo(gctag_3196399)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3195270), %r8
	ld	[%r8+%lo(gctag_3195270)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3304664:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_bind_at_con_inner_code_3262815,(.-Normalize_bind_at_con_inner_code_3262815)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304665
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f00000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304666
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c30000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304667
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c30000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304668
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c00000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3304628
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03f00000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304669
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3304654
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3304658
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304670
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c30000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304671
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03f00000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3304672
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3304673
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03f00000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_bind_at_con_r_code_3262621
 ! arguments : [$3262623,$8] [$3196578,$9] [$3262624,$10] [$3196579,$11] 
 ! results    : [$3298531,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_bind_at_con_r_code_3262621:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304682
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304682:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304675:
funtop_3298517:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304676
	nop
code_3304677:
	call	GCFromML ! delay slot empty
	nop
needgc_3304676:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_bind_at_con_inner_code_3262815), %r8
	or	%r8, %lo(Normalize_bind_at_con_inner_code_3262815), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304681:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_bind_at_con_r_code_3262621,(.-Normalize_bind_at_con_r_code_3262621)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304676
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262835
 ! arguments : [$3262837,$8] [$3262838,$9] [$3045542,$10] 
 ! results    : [$3298516,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262835:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304702
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304702:
	st	%r15, [%sp+92]
	st	%r10, [%sp+100]
code_3304683:
funtop_3298468:
	ld	[%r9], %r10
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3196966), %r8
	or	%r8, %lo(_3196966), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304701:
	mov	%r8, %r9
code_3304686:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3304698:
	mov	%r8, %r12
code_3304687:
	! done making normal call
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225900), %r8
	or	%r8, %lo(type_3225900), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304699:
	mov	%r8, %r9
code_3304694:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3304695:
	! done making tail call
code_3304697:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3262835,(.-Normalize_anonfun_code_3262835)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304698
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3247863
		! -------- label,sizes,reg
	.long code_3304699
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3247863
		! -------- label,sizes,reg
	.long code_3304701
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_bind_at_cons_inner_code_3262827
 ! arguments : [$3262829,$8] [$3262830,$9] [$3225880,$10] [$3225881,$11] 
 ! results    : [$3298467,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bind_at_cons_inner_code_3262827:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304734
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304734:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3304703:
funtop_3298388:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3304733:
code_3304704:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304705
	nop
code_3304706:
	call	GCFromML ! delay slot empty
	nop
needgc_3304705:
	! allocating 1 closures
	or	%r0, 281, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304710
	nop
code_3304711:
	or	%r0, 0, %r9
cmpui_3304710:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304714
	nop
code_3304715:
	or	%r0, 0, %r9
cmpui_3304714:
	sll	%r9, 10, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262835), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262835), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3222681), %r8
	or	%r8, %lo(type_3222681), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r10
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	or	%r0, 2, %r8
	st	%r8, [%r4+8]
	sethi	%hi(type_3196281), %r8
	or	%r8, %lo(type_3196281), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	st	%r8, [%r4+12]
	st	%r10, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	ld	[%r11], %r10
	jmpl	%r10, %r15
	ld	[%r11+4], %r8
code_3304731:
	mov	%r8, %r12
code_3304723:
	! done making constructor call
	sethi	%hi(type_3225900), %r8
	or	%r8, %lo(type_3225900), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3304732:
code_3304728:
	! done making normal call
code_3304730:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_bind_at_cons_inner_code_3262827,(.-Normalize_bind_at_cons_inner_code_3262827)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304731
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3304705
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304732
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3304733
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_bind_at_cons_r_code_3262626
 ! arguments : [$3262628,$8] [$3196900,$9] [$3262629,$10] [$3196901,$11] 
 ! results    : [$3298383,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_bind_at_cons_r_code_3262626:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304742
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304742:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304735:
funtop_3298369:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304736
	nop
code_3304737:
	call	GCFromML ! delay slot empty
	nop
needgc_3304736:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_bind_at_cons_inner_code_3262827), %r8
	or	%r8, %lo(Normalize_bind_at_cons_inner_code_3262827), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304741:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_bind_at_cons_r_code_3262626,(.-Normalize_bind_at_cons_r_code_3262626)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304736
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262858
 ! arguments : [$3262860,$8] [$3262861,$9] [$3045564,$10] 
 ! results    : [$3298156,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262858:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304870
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3304870:
	st	%r15, [%sp+92]
	st	%r10, [%sp+112]
code_3304743:
funtop_3298096:
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+108]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9+12], %r16
	st	%r16, [%sp+100]
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(debug_3194017), %r8
	or	%r8, %lo(debug_3194017), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3304865:
code_3304749:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304750
	nop
code_3304751:
	call	GCFromML ! delay slot empty
	nop
needgc_3304750:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3298122
	nop
zero_case_3298121:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3304869:
	mov	%r8, %r12
code_3304754:
	! done making normal call
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304853:
	mov	%r8, %r9
code_3304761:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3304762:
	! done making tail call
	ba	after_zeroone_3298123 ! delay slot empty
	nop
one_case_3298122:
	! allocating 2-record
	sethi	%hi(gctag_3197225), %r8
	ld	[%r8+%lo(gctag_3197225)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(push_3044515), %r8
	or	%r8, %lo(push_3044515), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304866:
code_3304766:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(show_calls_3194020), %r8
	or	%r8, %lo(show_calls_3194020), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3304855:
code_3304772:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3298192
	nop
zero_case_3298191:
	ba	after_zeroone_3298193
	or	%r0, 256, %r8
one_case_3298192:
	sethi	%hi(string_3266367), %r8
	or	%r8, %lo(string_3266367), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304867:
code_3304778:
	! done making normal call
	! making closure call
	sethi	%hi(_3223184), %r8
	or	%r8, %lo(_3223184), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3304856:
code_3304781:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(show_context_3194023), %r8
	or	%r8, %lo(show_context_3194023), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3304857:
code_3304787:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3298232
	nop
zero_case_3298231:
	ba	after_zeroone_3298233
	or	%r0, 256, %r8
one_case_3298232:
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304868:
code_3304793:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3304858:
code_3304796:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304859:
code_3304800:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3304860:
code_3304803:
	! done making normal call
after_zeroone_3298233:
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304852:
code_3304807:
	! done making normal call
after_zeroone_3298193:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3304851:
	mov	%r8, %r12
code_3304808:
	! done making normal call
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304861:
	mov	%r8, %r9
code_3304815:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3304862:
	st	%r8, [%sp+96]
code_3304816:
	! done making normal call
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	subcc	%r8, 1, %r12
	bvs,pn	%icc,localOverflowFromML
	nop
code_3304819:
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3304823
	nop
code_3304824:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3304823:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	ld	[%r2+792], %r10
	mov	%r11, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r12, [%r11]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3304850:
	mov	%r8, %r10
code_3304838:
	! done making normal call
	! making closure call
	sethi	%hi(_3223092), %r8
	or	%r8, %lo(_3223092), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3304863:
	mov	%r8, %r13
code_3304841:
	! done making normal call
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	mov	%r11, %r8
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3304864:
code_3304847:
	! done making normal call
	ld	[%sp+96], %r8
after_zeroone_3298123:
code_3304849:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3262858,(.-Normalize_anonfun_code_3262858)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304850
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3304851
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304852
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3304750
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3304853
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304855
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304856
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304857
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304858
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304859
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304860
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304861
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304862
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long afterMutateCheck_3304823
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3304863
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3304864
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3304865
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304866
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304867
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304868
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000007
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3304869
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.text
	.align 8
	.global Normalize_kind_normalizePRIME_inner_code_3262850
 ! arguments : [$3262852,$8] [$3262853,$9] [$3226178,$10] [$3226179,$11] 
 ! results    : [$3298095,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_kind_normalizePRIME_inner_code_3262850:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304900
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3304900:
	st	%r15, [%sp+92]
	mov	%r8, %r12
	mov	%r9, %r8
	st	%r10, [%sp+100]
	st	%r11, [%sp+104]
code_3304871:
funtop_3298027:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304872
	nop
code_3304873:
	call	GCFromML ! delay slot empty
	nop
needgc_3304872:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! allocating 2-record
	sethi	%hi(record_gctag_3226181), %r8
	ld	[%r8+%lo(record_gctag_3226181)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r13, %r15
	mov	%r12, %r9
code_3304899:
code_3304876:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304877
	nop
code_3304878:
	call	GCFromML ! delay slot empty
	nop
needgc_3304877:
	! allocating 1 closures
	or	%r0, 801, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304882
	nop
code_3304883:
	or	%r0, 0, %r9
cmpui_3304882:
	sll	%r9, 10, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3304886
	nop
code_3304887:
	or	%r0, 0, %r9
cmpui_3304886:
	sll	%r9, 11, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 4-record
	st	%r11, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	ld	[%sp+104], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262858), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262858), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label kind_TYC
	ld	[%r8+24], %r18
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3304898:
code_3304895:
	! done making normal call
code_3304897:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_kind_normalizePRIME_inner_code_3262850,(.-Normalize_kind_normalizePRIME_inner_code_3262850)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3304898
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304872
	.word 0x001c000b
	.word 0x00170000
	.word 0x00001100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3304877
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3304899
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_kind_normalizePRIME_r_code_3262631
 ! arguments : [$3262633,$8] [$3197172,$9] [$3262634,$10] [$3197173,$11] 
 ! results    : [$3298022,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_kind_normalizePRIME_r_code_3262631:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3304908
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3304908:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3304901:
funtop_3298008:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304902
	nop
code_3304903:
	call	GCFromML ! delay slot empty
	nop
needgc_3304902:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_kind_normalizePRIME_inner_code_3262850), %r8
	or	%r8, %lo(Normalize_kind_normalizePRIME_inner_code_3262850), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3304907:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_kind_normalizePRIME_r_code_3262631,(.-Normalize_kind_normalizePRIME_r_code_3262631)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3304902
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262885
 ! arguments : [$3262887,$8] [$3262888,$9] [$3045598,$10] 
 ! results    : [$3297670,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262885:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305046
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3305046:
	st	%r15, [%sp+92]
code_3304909:
funtop_3297649:
	ld	[%r9], %r16
	st	%r16, [%sp+120]
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
	ld	[%r9+8], %r8
	ld	[%r9+12], %r16
	st	%r16, [%sp+116]
	ld	[%r9+16], %r16
	st	%r16, [%sp+112]
sumarm_3297666:
	cmp	%r10, 0
	bne	sumarm_3297667
	nop
code_3304910:
	ba	after_sum_3297663
	mov	%r10, %r8
sumarm_3297667:
	ld	[%r10], %r9
	cmp	%r9, 0
	bne	sumarm_3297671
	nop
code_3304912:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	! making closure call
	ld	[%sp+120], %r17
	ld	[%r17], %r12
	ld	[%sp+120], %r17
	ld	[%r17+4], %r8
	ld	[%sp+120], %r17
	ld	[%r17+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3305023:
	mov	%r8, %r12
code_3304913:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3305024:
	mov	%r8, %r9
code_3304920:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305025:
code_3304921:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3305026:
	mov	%r8, %r12
code_3304922:
	! done making normal call
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305027:
	mov	%r8, %r9
code_3304929:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3305028:
	mov	%r8, %r9
code_3304930:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304931
	nop
code_3304932:
	call	GCFromML ! delay slot empty
	nop
needgc_3304931:
	! allocating 3-record
	sethi	%hi(gctag_3197349), %r8
	ld	[%r8+%lo(gctag_3197349)], %r8
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3297663 ! delay slot empty
	nop
sumarm_3297671:
	ld	[%r10], %r9
	cmp	%r9, 1
	bne	sumarm_3297766
	nop
code_3304936:
	sethi	%hi(type_3197329), %r8
	or	%r8, %lo(type_3197329), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r10+4], %r10
	! making closure call
	sethi	%hi(_3226523), %r8
	or	%r8, %lo(_3226523), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305029:
	st	%r8, [%sp+96]
code_3304941:
	! done making normal call
	sethi	%hi(anonfun_3045644), %r8
	or	%r8, %lo(anonfun_3045644), %r10
	! making closure call
	sethi	%hi(_3197402), %r8
	or	%r8, %lo(_3197402), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305030:
	mov	%r8, %r12
code_3304945:
	! done making normal call
	sethi	%hi(type_3247660), %r8
	or	%r8, %lo(type_3247660), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3247613), %r8
	or	%r8, %lo(type_3247613), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3305031:
	mov	%r8, %r9
code_3304952:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305032:
	mov	%r8, %r10
code_3304953:
	! done making normal call
	! making closure call
	sethi	%hi(_3226635), %r8
	or	%r8, %lo(_3226635), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305033:
code_3304956:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%sp+120], %r17
	ld	[%r17], %r12
	ld	[%sp+120], %r17
	ld	[%r17+4], %r8
	ld	[%sp+120], %r17
	ld	[%r17+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3305034:
	mov	%r8, %r12
code_3304957:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305035:
	mov	%r8, %r9
code_3304964:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305036:
code_3304965:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	sethi	%hi(anonfun_3045670), %r8
	or	%r8, %lo(anonfun_3045670), %r10
	! making closure call
	sethi	%hi(map2_3193599), %r8
	or	%r8, %lo(map2_3193599), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305037:
	mov	%r8, %r9
code_3304969:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3305038:
	mov	%r8, %r10
code_3304970:
	! done making normal call
	! making closure call
	sethi	%hi(_3226858), %r8
	or	%r8, %lo(_3226858), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305039:
	mov	%r8, %r11
code_3304973:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304974
	nop
code_3304975:
	call	GCFromML ! delay slot empty
	nop
needgc_3304974:
	or	%r0, 17, %r10
	sethi	%hi(type_3247499), %r8
	or	%r8, %lo(type_3247499), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304979
	nop
code_3304980:
	or	%r0, 0, %r8
cmpui_3304979:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3297663 ! delay slot empty
	nop
sumarm_3297766:
	ld	[%r10], %r9
	cmp	%r9, 2
	bne	sumarm_3297904
	nop
code_3304982:
	sethi	%hi(type_3197329), %r9
	or	%r9, %lo(type_3197329), %r11
	ld	[%r2+804], %r9
	add	%r11, %r9, %r9
	ld	[%r9], %r9
	ld	[%r10+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r8], %r12
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3305040:
	mov	%r8, %r12
code_3304985:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305041:
	mov	%r8, %r9
code_3304992:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305042:
	mov	%r8, %r11
code_3304993:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3304994
	nop
code_3304995:
	call	GCFromML ! delay slot empty
	nop
needgc_3304994:
	or	%r0, 17, %r10
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3304999
	nop
code_3305000:
	or	%r0, 0, %r8
cmpui_3304999:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3297663 ! delay slot empty
	nop
sumarm_3297904:
	sethi	%hi(type_3197329), %r9
	or	%r9, %lo(type_3197329), %r11
	ld	[%r2+804], %r9
	add	%r11, %r9, %r9
	ld	[%r9], %r9
	ld	[%r10+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r8], %r12
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3305045:
	mov	%r8, %r12
code_3305004:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305043:
	mov	%r8, %r9
code_3305011:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305044:
	mov	%r8, %r11
code_3305012:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305013
	nop
code_3305014:
	call	GCFromML ! delay slot empty
	nop
needgc_3305013:
	or	%r0, 17, %r10
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3305018
	nop
code_3305019:
	or	%r0, 0, %r8
cmpui_3305018:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3297663 ! delay slot empty
	nop
sumarm_3297956:
after_sum_3297663:
code_3305022:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3262885,(.-Normalize_anonfun_code_3262885)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305023
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3305024
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3305025
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f40000
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3305026
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3305027
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000007
	.long _c_3044472
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3305028
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long needgc_3304931
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193074
		! -------- label,sizes,reg
	.long code_3305029
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x1f000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305030
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x1f030000
		! worddata
	.word 0x80000000
	.long type_3247660
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305031
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x1f030000
		! worddata
	.word 0x80000000
	.long type_3247660
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305032
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x1f000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305033
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x1f000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305034
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3194964
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3305035
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3194964
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3305036
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3305037
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3305038
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3305039
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304974
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3247499
		! -------- label,sizes,reg
	.long code_3305040
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305041
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305042
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3304994
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305043
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305044
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3305013
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305045
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_kind_normalize_inner_code_3262875
 ! arguments : [$3262877,$8] [$3262878,$9] [$3226316,$10] [$3226317,$11] 
 ! results    : [$3297648,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_kind_normalize_inner_code_3262875:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305076
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3305076:
	st	%r15, [%sp+92]
	st	%r8, [%sp+108]
	mov	%r9, %r8
	st	%r10, [%sp+100]
	st	%r11, [%sp+104]
code_3305047:
funtop_3297567:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+112]
	ld	[%r8+8], %r16
	st	%r16, [%sp+116]
	ld	[%r8+12], %r16
	st	%r16, [%sp+120]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+108], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3305075:
	st	%r8, [%sp+96]
code_3305048:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r10
	ld	[%sp+108], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3305073:
	st	%r8, [%sp+112]
code_3305049:
	! done making normal call
	! making closure call
	ld	[%sp+116], %r17
	ld	[%r17], %r12
	ld	[%sp+116], %r17
	ld	[%r17+4], %r8
	ld	[%sp+116], %r17
	ld	[%r17+8], %r10
	ld	[%sp+108], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3305074:
	mov	%r8, %r9
code_3305050:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305051
	nop
code_3305052:
	call	GCFromML ! delay slot empty
	nop
needgc_3305051:
	! allocating 1 closures
	or	%r0, 1833, %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3305056
	nop
code_3305057:
	or	%r0, 0, %r10
cmpui_3305056:
	sll	%r10, 11, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3305060
	nop
code_3305061:
	or	%r0, 0, %r10
cmpui_3305060:
	sll	%r10, 12, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 5-record
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	ld	[%sp+100], %r17
	st	%r17, [%r4+16]
	ld	[%sp+104], %r17
	st	%r17, [%r4+20]
	add	%r4, 4, %r9
	add	%r4, 24, %r4
	! done allocating 5 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262885), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262885), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label kind_TYC
	ld	[%r8+24], %r18
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305072:
code_3305069:
	! done making normal call
code_3305071:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_kind_normalize_inner_code_3262875,(.-Normalize_kind_normalize_inner_code_3262875)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305072
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3305073
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x147d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305074
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x013d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3305051
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x013d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305075
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x157c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_kind_normalize_r_code_3262636
 ! arguments : [$3262638,$8] [$3197282,$9] [$3262639,$10] [$3197283,$11] 
 ! results    : [$3297562,$8] 
 ! destroys   :  $13 $12 $11 $10 $9 $8
 ! modifies   :  $13 $12 $11 $10 $9 $8
Normalize_kind_normalize_r_code_3262636:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305084
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3305084:
	st	%r15, [%sp+92]
	mov	%r9, %r13
	mov	%r10, %r8
	mov	%r11, %r12
code_3305077:
funtop_3297540:
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305078
	nop
code_3305079:
	call	GCFromML ! delay slot empty
	nop
needgc_3305078:
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	! allocating 1 closures
	! allocating 4-record
	or	%r0, 3873, %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	st	%r12, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_kind_normalize_inner_code_3262875), %r8
	or	%r8, %lo(Normalize_kind_normalize_inner_code_3262875), %r8
	st	%r8, [%r4+4]
	st	%r13, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3305083:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_kind_normalize_r_code_3262636,(.-Normalize_kind_normalize_r_code_3262636)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3305078
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3100
	.word 0xbffc0000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262916
 ! arguments : [$3262918,$8] [$3262919,$9] [$3045709,$10] 
 ! results    : [$3297327,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262916:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305212
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3305212:
	st	%r15, [%sp+92]
	st	%r10, [%sp+112]
code_3305085:
funtop_3297267:
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+108]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9+12], %r16
	st	%r16, [%sp+100]
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(debug_3194017), %r8
	or	%r8, %lo(debug_3194017), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3305207:
code_3305091:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305092
	nop
code_3305093:
	call	GCFromML ! delay slot empty
	nop
needgc_3305092:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3297293
	nop
zero_case_3297292:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3305211:
	mov	%r8, %r12
code_3305096:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305195:
	mov	%r8, %r9
code_3305103:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3305104:
	! done making tail call
	ba	after_zeroone_3297294 ! delay slot empty
	nop
one_case_3297293:
	! allocating 2-record
	sethi	%hi(gctag_3197621), %r8
	ld	[%r8+%lo(gctag_3197621)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(push_3044515), %r8
	or	%r8, %lo(push_3044515), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305208:
code_3305108:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(show_calls_3194020), %r8
	or	%r8, %lo(show_calls_3194020), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3305197:
code_3305114:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3297363
	nop
zero_case_3297362:
	ba	after_zeroone_3297364
	or	%r0, 256, %r8
one_case_3297363:
	sethi	%hi(string_3269121), %r8
	or	%r8, %lo(string_3269121), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305209:
code_3305120:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3305198:
code_3305123:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(show_context_3194023), %r8
	or	%r8, %lo(show_context_3194023), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3305199:
code_3305129:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3297403
	nop
zero_case_3297402:
	ba	after_zeroone_3297404
	or	%r0, 256, %r8
one_case_3297403:
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305210:
code_3305135:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3305200:
code_3305138:
	! done making normal call
after_zeroone_3297404:
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305194:
code_3305142:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3305201:
code_3305145:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305202:
code_3305149:
	! done making normal call
after_zeroone_3297364:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3305193:
	mov	%r8, %r12
code_3305150:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305203:
	mov	%r8, %r9
code_3305157:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3305204:
	st	%r8, [%sp+96]
code_3305158:
	! done making normal call
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	subcc	%r8, 1, %r12
	bvs,pn	%icc,localOverflowFromML
	nop
code_3305161:
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3305165
	nop
code_3305166:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3305165:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	ld	[%r2+792], %r10
	mov	%r11, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r12, [%r11]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3305192:
	mov	%r8, %r10
code_3305180:
	! done making normal call
	! making closure call
	sethi	%hi(_3223092), %r8
	or	%r8, %lo(_3223092), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305205:
	mov	%r8, %r13
code_3305183:
	! done making normal call
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	mov	%r11, %r8
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3305206:
code_3305189:
	! done making normal call
	ld	[%sp+96], %r8
after_zeroone_3297294:
code_3305191:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3262916,(.-Normalize_anonfun_code_3262916)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305192
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305193
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305194
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3305092
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3305195
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305197
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305198
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305199
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305200
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305201
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305202
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305203
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305204
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long afterMutateCheck_3305165
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305205
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305206
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305207
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305208
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305209
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305210
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305211
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_con_normalizePRIME_inner_code_3262908
 ! arguments : [$3262910,$8] [$3262911,$9] [$3226946,$10] [$3226947,$11] 
 ! results    : [$3297266,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_normalizePRIME_inner_code_3262908:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305242
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3305242:
	st	%r15, [%sp+92]
	mov	%r8, %r12
	mov	%r9, %r8
	st	%r10, [%sp+100]
	st	%r11, [%sp+104]
code_3305213:
funtop_3297198:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305214
	nop
code_3305215:
	call	GCFromML ! delay slot empty
	nop
needgc_3305214:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! allocating 2-record
	sethi	%hi(record_gctag_3226181), %r8
	ld	[%r8+%lo(record_gctag_3226181)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r13, %r15
	mov	%r12, %r9
code_3305241:
code_3305218:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305219
	nop
code_3305220:
	call	GCFromML ! delay slot empty
	nop
needgc_3305219:
	! allocating 1 closures
	or	%r0, 801, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3305224
	nop
code_3305225:
	or	%r0, 0, %r9
cmpui_3305224:
	sll	%r9, 10, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3305228
	nop
code_3305229:
	or	%r0, 0, %r9
cmpui_3305228:
	sll	%r9, 11, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 4-record
	st	%r11, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	ld	[%sp+104], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262916), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262916), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305240:
code_3305237:
	! done making normal call
code_3305239:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_con_normalizePRIME_inner_code_3262908,(.-Normalize_con_normalizePRIME_inner_code_3262908)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305240
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3305214
	.word 0x001c000b
	.word 0x00170000
	.word 0x00001100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3305219
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305241
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_con_normalizePRIME_r_code_3262641
 ! arguments : [$3262643,$8] [$3197568,$9] [$3262644,$10] [$3197569,$11] 
 ! results    : [$3297193,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_con_normalizePRIME_r_code_3262641:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305250
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3305250:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3305243:
funtop_3297179:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305244
	nop
code_3305245:
	call	GCFromML ! delay slot empty
	nop
needgc_3305244:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_con_normalizePRIME_inner_code_3262908), %r8
	or	%r8, %lo(Normalize_con_normalizePRIME_inner_code_3262908), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3305249:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_normalizePRIME_r_code_3262641,(.-Normalize_con_normalizePRIME_r_code_3262641)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3305244
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3262943
 ! arguments : [$3262945,$8] [$3262946,$9] [$3045743,$10] 
 ! results    : [$3297059,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3262943:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 160, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305363
	nop
	add	%sp, 160, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 160, %sp
code_3305363:
	st	%r15, [%sp+92]
code_3305251:
funtop_3296803:
	ld	[%r9], %r16
	st	%r16, [%sp+144]
	ld	[%r9+4], %r16
	st	%r16, [%sp+140]
	ld	[%r9+8], %r16
	st	%r16, [%sp+136]
	ld	[%r9+12], %r16
	st	%r16, [%sp+132]
	ld	[%r9+16], %r16
	st	%r16, [%sp+128]
	ld	[%r10], %r16
	st	%r16, [%sp+124]
	ld	[%r10+4], %r16
	st	%r16, [%sp+120]
	ld	[%r10+8], %r16
	st	%r16, [%sp+116]
	ld	[%r10+12], %r16
	st	%r16, [%sp+112]
	ld	[%r10+16], %r16
	st	%r16, [%sp+108]
	ld	[%r10+20], %r16
	st	%r16, [%sp+100]
	ld	[%r10+24], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3227170), %r8
	or	%r8, %lo(_3227170), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3305357:
code_3305254:
	! done making normal call
	add	%r4, 60, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305255
	nop
code_3305256:
	call	GCFromML ! delay slot empty
	nop
needgc_3305255:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3296841
	nop
zero_case_3296840:
	ba	after_zeroone_3296842
	or	%r0, 0, %r8
one_case_3296841:
	! allocating 1-record
	or	%r0, 9, %r8
	st	%r8, [%r4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 8, %r4
	! done allocating 1 record
	! making closure call
	sethi	%hi(_3223755), %r8
	or	%r8, %lo(_3223755), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3305360:
	mov	%r8, %r12
code_3305262:
	! done making normal call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(eq_opt_3244148), %r8
	or	%r8, %lo(eq_opt_3244148), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r11
code_3305341:
code_3305267:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305268
	nop
code_3305269:
	call	GCFromML ! delay slot empty
	nop
needgc_3305268:
after_zeroone_3296842:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3296883
	nop
zero_case_3296882:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197912), %r8
	ld	[%r8+%lo(gctag_3197912)], %r8
	st	%r8, [%r4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+120], %r17
	ld	[%r17], %r13
	ld	[%sp+120], %r17
	ld	[%r17+4], %r8
	ld	[%sp+120], %r17
	ld	[%r17+8], %r9
	ld	[%sp+116], %r10
	ld	[%sp+112], %r11
	jmpl	%r13, %r15
	ld	[%sp+108], %r12
code_3305362:
	mov	%r8, %r9
code_3305273:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305274
	nop
code_3305275:
	call	GCFromML ! delay slot empty
	nop
needgc_3305274:
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r8
	ld	[%r8+%lo(gctag_3197849)], %r8
	st	%r8, [%r4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(_3227254), %r8
	or	%r8, %lo(_3227254), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3305358:
	mov	%r8, %r9
code_3305281:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3305342:
	mov	%r8, %r9
code_3305282:
	! done making normal call
sumarm_3296963:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3296961
	nop
code_3305283:
	sethi	%hi(string_3269287), %r8
	or	%r8, %lo(string_3269287), %r10
	! making closure call
	sethi	%hi(_3194113), %r8
	or	%r8, %lo(_3194113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3305343:
code_3305287:
	! done making normal call
	ba	after_sum_3296960 ! delay slot empty
	nop
sumarm_3296964:
nomatch_sum_3296961:
	or	%r0, 256, %r8
after_sum_3296960:
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3305340:
	mov	%r8, %r12
code_3305290:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3305344:
	mov	%r8, %r9
code_3305297:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305345:
	st	%r8, [%sp+96]
code_3305298:
	! done making normal call
	! making closure call
	sethi	%hi(_3225548), %r8
	or	%r8, %lo(_3225548), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3305346:
	mov	%r8, %r9
code_3305301:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3305347:
	mov	%r8, %r11
code_3305302:
	! done making normal call
	! making closure call
	ld	[%sp+140], %r17
	ld	[%r17], %r12
	ld	[%sp+140], %r17
	ld	[%r17+4], %r8
	ld	[%sp+140], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+136], %r10
code_3305348:
	mov	%r8, %r12
code_3305303:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305349:
	mov	%r8, %r9
code_3305310:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 160, %sp
code_3305311:
	! done making tail call
	ba	after_zeroone_3296884 ! delay slot empty
	nop
one_case_3296883:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+144], %r17
	ld	[%r17], %r12
	ld	[%sp+144], %r17
	ld	[%r17+4], %r8
	ld	[%sp+144], %r17
	ld	[%r17+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3305361:
	mov	%r8, %r12
code_3305313:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3305351:
	mov	%r8, %r9
code_3305320:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3305352:
code_3305321:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	ld	[%sp+140], %r17
	ld	[%r17], %r12
	ld	[%sp+140], %r17
	ld	[%r17+4], %r8
	ld	[%sp+140], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3305353:
	mov	%r8, %r12
code_3305322:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3305354:
	mov	%r8, %r9
code_3305329:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3305355:
	mov	%r8, %r12
code_3305330:
	! done making normal call
	! making closure call
	ld	[%sp+120], %r17
	ld	[%r17], %r13
	ld	[%sp+120], %r17
	ld	[%r17+4], %r8
	ld	[%sp+120], %r17
	ld	[%r17+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r13, %r15
	ld	[%sp+96], %r11
code_3305356:
	mov	%r8, %r9
code_3305331:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305332
	nop
code_3305333:
	call	GCFromML ! delay slot empty
	nop
needgc_3305332:
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r8
	ld	[%r8+%lo(gctag_3197849)], %r8
	st	%r8, [%r4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+128], %r17
	ld	[%r17], %r11
	ld	[%sp+128], %r17
	ld	[%r17+4], %r8
	ld	[%sp+128], %r17
	ld	[%r17+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 160, %sp
code_3305337:
	! done making tail call
after_zeroone_3296884:
code_3305339:
	ld	[%sp+92], %r15
	retl
	add	%sp, 160, %sp
	.size Normalize_anonfun_code_3262943,(.-Normalize_anonfun_code_3262943)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305340
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3305255
	.word 0x00280018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0xd3fc0000
	.word 0x0000017d
		! worddata
	.word 0x80000000
	.long reify_3247284
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3305341
	.word 0x00280016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd3fc0000
	.word 0x0000017d
		! worddata
	.word 0x80000000
	.long reify_3247284
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3305268
	.word 0x00280018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0xd3fc0000
	.word 0x0000017d
		! worddata
	.word 0x80000000
	.long reify_3247284
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long needgc_3305274
	.word 0x00280010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0xc0050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000003
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305342
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305343
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305344
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305345
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305346
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
	.word 0x00000070
		! worddata
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305347
	.word 0x0028000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x00000070
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305348
	.word 0x00280008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3305349
	.word 0x00280008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3305351
	.word 0x0028000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd3c40000
	.word 0x00000041
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305352
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd0c40000
	.word 0x00000041
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305353
	.word 0x0028000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd0c70000
	.word 0x00000001
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305354
	.word 0x0028000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd0c70000
	.word 0x00000001
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305355
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd0070000
	.word 0x00000001
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305356
	.word 0x0028000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0040000
	.word 0x00000001
		! worddata
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long needgc_3305332
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0xc0040000
	.word 0x00000001
		! worddata
	.word 0x80000000
	.long type_3197841
	.word 0x80000003
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305357
	.word 0x00280016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd3fc0000
	.word 0x0000017d
		! worddata
	.word 0x80000000
	.long reify_3247284
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305358
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305360
	.word 0x00280016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd3fd0000
	.word 0x0000017d
		! worddata
	.word 0x80000000
	.long reify_3247284
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3305361
	.word 0x0028000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xd3c40000
	.word 0x00000041
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248062
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3305362
	.word 0x0028000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0050000
	.word 0x0000007c
		! worddata
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_con_normalize_letfun_inner_code_3262933
 ! arguments : [$3262935,$8] [$3262936,$9] [$3227144,$10] [$3227145,$11] 
 ! results    : [$3296797,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_normalize_letfun_inner_code_3262933:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305393
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3305393:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r9, %r8
	st	%r10, [%sp+100]
	st	%r11, [%sp+104]
code_3305364:
funtop_3296722:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
	ld	[%r8+8], %r16
	st	%r16, [%sp+112]
	ld	[%r8+12], %r16
	st	%r16, [%sp+116]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3305392:
	st	%r8, [%sp+120]
code_3305365:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3305389:
	st	%r8, [%sp+108]
code_3305366:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3305390:
	st	%r8, [%sp+96]
code_3305367:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r12
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	mov	%r12, %r10
	jmpl	%r13, %r15
	ld	[%sp+120], %r12
code_3305391:
	mov	%r8, %r9
code_3305374:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305375
	nop
code_3305376:
	call	GCFromML ! delay slot empty
	nop
needgc_3305375:
	! allocating 1 closures
	sethi	%hi(4905), %r8
	or	%r8, %lo(4905), %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3305380
	nop
code_3305381:
	or	%r0, 0, %r10
cmpui_3305380:
	sll	%r10, 10, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3305384
	nop
code_3305385:
	or	%r0, 0, %r10
cmpui_3305384:
	sll	%r10, 11, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 5-record
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	ld	[%sp+104], %r17
	st	%r17, [%r4+16]
	st	%r9, [%r4+20]
	add	%r4, 4, %r9
	add	%r4, 24, %r4
	! done allocating 5 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3262943), %r8
	or	%r8, %lo(Normalize_anonfun_code_3262943), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3305388:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_con_normalize_letfun_inner_code_3262933,(.-Normalize_con_normalize_letfun_inner_code_3262933)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305389
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x153d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305390
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x107c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305391
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x007d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3305375
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x007d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3305392
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x057d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_con_normalize_letfun_r_code_3262646
 ! arguments : [$3262648,$8] [$3197678,$9] [$3262649,$10] [$3197679,$11] 
 ! results    : [$3296717,$8] 
 ! destroys   :  $13 $12 $11 $10 $9 $8
 ! modifies   :  $13 $12 $11 $10 $9 $8
Normalize_con_normalize_letfun_r_code_3262646:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305401
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3305401:
	st	%r15, [%sp+92]
	mov	%r9, %r13
	mov	%r10, %r8
	mov	%r11, %r12
code_3305394:
funtop_3296695:
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305395
	nop
code_3305396:
	call	GCFromML ! delay slot empty
	nop
needgc_3305395:
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	! allocating 1 closures
	! allocating 4-record
	or	%r0, 3873, %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	st	%r12, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_con_normalize_letfun_inner_code_3262933), %r8
	or	%r8, %lo(Normalize_con_normalize_letfun_inner_code_3262933), %r8
	st	%r8, [%r4+4]
	st	%r13, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3305400:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_normalize_letfun_r_code_3262646,(.-Normalize_con_normalize_letfun_r_code_3262646)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3305395
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3100
	.word 0xbffc0000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_folder_code_3262981
 ! arguments : [$3262983,$8] [$3262984,$9] [$3227777,$10] [$3227778,$11] 
 ! results    : [$3296634,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_folder_code_3262981:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305434
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3305434:
	st	%r15, [%sp+92]
	st	%r11, [%sp+100]
code_3305402:
funtop_3296564:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305403
	nop
code_3305404:
	call	GCFromML ! delay slot empty
	nop
needgc_3305403:
	ld	[%r9], %r11
	ld	[%r9+4], %r9
	ld	[%r10], %r16
	st	%r16, [%sp+96]
	ld	[%r10+4], %r16
	st	%r16, [%sp+104]
sumarm_3296583:
	ld	[%sp+96], %r17
	cmp	%r17, 0
	bne	sumarm_3296584
	nop
code_3305406:
	ld	[%sp+100], %r17
	ld	[%r17], %r10
	ld	[%sp+100], %r17
	ld	[%r17+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3305430:
	mov	%r8, %r12
code_3305407:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305431:
	mov	%r8, %r9
code_3305414:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3305432:
	mov	%r8, %r9
code_3305415:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305416
	nop
code_3305417:
	call	GCFromML ! delay slot empty
	nop
needgc_3305416:
	! allocating 2-record
	sethi	%hi(gctag_3198230), %r8
	ld	[%r8+%lo(gctag_3198230)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3296580 ! delay slot empty
	nop
sumarm_3296584:
	ld	[%sp+96], %r17
	ld	[%r17], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198255), %r8
	ld	[%r8+%lo(gctag_3198255)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r11], %r12
	ld	[%r11+4], %r8
	ld	[%r11+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3305433:
	mov	%r8, %r9
code_3305422:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305423
	nop
code_3305424:
	call	GCFromML ! delay slot empty
	nop
needgc_3305423:
	ld	[%r9], %r8
	ld	[%r9+4], %r11
	ld	[%r8], %r9
	ld	[%r8+4], %r10
	! allocating 1-record
	or	%r0, 9, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	add	%r4, 4, %r9
	add	%r4, 8, %r4
	! done allocating 1 record
	! allocating 2-record
	sethi	%hi(gctag_3198230), %r8
	ld	[%r8+%lo(gctag_3198230)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3296580 ! delay slot empty
	nop
sumarm_3296635:
after_sum_3296580:
code_3305429:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_folder_code_3262981,(.-Normalize_folder_code_3262981)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3305403
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000600
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
		! -------- label,sizes,reg
	.long code_3305430
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00370000
		! worddata
	.word 0x80000000
	.long reify_3246741
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305431
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00370000
		! worddata
	.word 0x80000000
	.long reify_3246741
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3305432
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long reify_3246741
		! -------- label,sizes,reg
	.long needgc_3305416
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long reify_3246741
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3305423
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3305433
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_doarm_inner_code_3262990
 ! arguments : [$3262992,$8] [$3262993,$9] [$3230164,$10] [$3230165,$11] [$3230166,$12] 
 ! results    : [$3296561,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_doarm_inner_code_3262990:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3305466
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3305466:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	st	%r10, [%sp+108]
	st	%r11, [%sp+96]
	st	%r12, [%sp+104]
code_3305435:
funtop_3296475:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r10
	ld	[%r8+12], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3305465:
	mov	%r8, %r12
code_3305436:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3305460:
	mov	%r8, %r9
code_3305443:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3305461:
code_3305444:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3305462:
	mov	%r8, %r12
code_3305445:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3305463:
	mov	%r8, %r9
code_3305452:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3305464:
	mov	%r8, %r9
code_3305453:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305454
	nop
code_3305455:
	call	GCFromML ! delay slot empty
	nop
needgc_3305454:
	! allocating 3-record
	sethi	%hi(gctag_3199151), %r8
	ld	[%r8+%lo(gctag_3199151)], %r8
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
code_3305459:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_doarm_inner_code_3262990,(.-Normalize_doarm_inner_code_3262990)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3305460
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
		! worddata
	.word 0x80000000
	.long reify_3248062
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3248742
		! -------- label,sizes,reg
	.long code_3305461
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f40000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3248742
		! -------- label,sizes,reg
	.long code_3305462
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3248742
		! -------- label,sizes,reg
	.long code_3305463
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3248742
		! -------- label,sizes,reg
	.long code_3305464
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3248742
		! -------- label,sizes,reg
	.long needgc_3305454
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3248742
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3305465
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
		! worddata
	.word 0x80000000
	.long reify_3248062
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3248742
	.text
	.align 8
	.global Normalize_anonfun_code_3263003
 ! arguments : [$3263005,$8] [$3263006,$9] [$3045857,$10] 
 ! results    : [$3294756,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263003:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 144, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306139
	nop
	add	%sp, 144, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 144, %sp
code_3306139:
	st	%r15, [%sp+92]
	mov	%r9, %r12
	mov	%r10, %r11
code_3305467:
funtop_3294570:
	add	%r4, 92, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305468
	nop
code_3305469:
	call	GCFromML ! delay slot empty
	nop
needgc_3305468:
	ld	[%r12], %r16
	st	%r16, [%sp+140]
	ld	[%r12+4], %r16
	st	%r16, [%sp+120]
	ld	[%r12+8], %r16
	st	%r16, [%sp+100]
	ld	[%r12+12], %r9
	ld	[%r12+16], %r8
	ld	[%r12+20], %r16
	st	%r16, [%sp+136]
	ld	[%r12+24], %r10
	ld	[%r12+28], %r16
	st	%r16, [%sp+132]
	ld	[%r12+32], %r16
	st	%r16, [%sp+128]
	ld	[%r12+36], %r16
	st	%r16, [%sp+104]
	ld	[%r12+40], %r16
	st	%r16, [%sp+116]
sumarm_3294599:
	ld	[%r11], %r12
	cmp	%r12, 0
	bne	sumarm_3294600
	nop
code_3305471:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+124]
	ld	[%r8+4], %r16
	st	%r16, [%sp+120]
	ld	[%r8+24], %r16
	st	%r16, [%sp+116]
	ld	[%r8+20], %r16
	st	%r16, [%sp+96]
	ld	[%r8+12], %r16
	st	%r16, [%sp+112]
	ld	[%r8+16], %r16
	st	%r16, [%sp+108]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306012:
	mov	%r8, %r12
code_3305472:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306013:
	mov	%r8, %r9
code_3305479:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306014:
code_3305480:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3198362), %r8
	or	%r8, %lo(_3198362), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3306015:
	mov	%r8, %r9
code_3305483:
	! done making normal call
	ld	[%sp+96], %r17
	ld	[%r17], %r10
	ld	[%sp+96], %r17
	ld	[%r17+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306016:
	mov	%r8, %r12
code_3305484:
	! done making normal call
	sethi	%hi(type_3227965), %r8
	or	%r8, %lo(type_3227965), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3227970), %r8
	or	%r8, %lo(type_3227970), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306017:
	mov	%r8, %r9
code_3305491:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3306018:
code_3305492:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3306019:
	mov	%r8, %r12
code_3305493:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306020:
	mov	%r8, %r9
code_3305500:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3306021:
	mov	%r8, %r9
code_3305501:
	! done making normal call
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305502
	nop
code_3305503:
	call	GCFromML ! delay slot empty
	nop
needgc_3305502:
	! allocating 7-record
	sethi	%hi(gctag_3198390), %r8
	ld	[%r8+%lo(gctag_3198390)], %r8
	st	%r8, [%r4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	ld	[%sp+108], %r17
	st	%r17, [%r4+20]
	ld	[%sp+100], %r17
	st	%r17, [%r4+24]
	ld	[%sp+116], %r17
	st	%r17, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3294600:
	ld	[%r11], %r12
	cmp	%r12, 1
	bne	sumarm_3294757
	nop
code_3305507:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306022:
	mov	%r8, %r12
code_3305508:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306023:
	mov	%r8, %r9
code_3305515:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306024:
	mov	%r8, %r9
code_3305516:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305517
	nop
code_3305518:
	call	GCFromML ! delay slot empty
	nop
needgc_3305517:
	! allocating 2-record
	sethi	%hi(gctag_3198415), %r8
	ld	[%r8+%lo(gctag_3198415)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3294757:
	ld	[%r11], %r12
	cmp	%r12, 2
	bne	sumarm_3294809
	nop
code_3305522:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306025:
	mov	%r8, %r12
code_3305523:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306026:
	mov	%r8, %r9
code_3305530:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306027:
	st	%r8, [%sp+96]
code_3305531:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306028:
	mov	%r8, %r10
code_3305532:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306029:
	mov	%r8, %r12
code_3305535:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306030:
	mov	%r8, %r9
code_3305542:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306031:
	mov	%r8, %r9
code_3305543:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305544
	nop
code_3305545:
	call	GCFromML ! delay slot empty
	nop
needgc_3305544:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 0, %r10
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r11
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3306129:
	mov	%r8, %r12
code_3305548:
	! done making normal call
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244064), %r8
	or	%r8, %lo(type_3244064), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306032:
	mov	%r8, %r9
code_3305555:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3306033:
	mov	%r8, %r12
code_3305556:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306034:
	mov	%r8, %r9
code_3305563:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305564:
	! done making tail call
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3294809:
	ld	[%r11], %r12
	cmp	%r12, 3
	bne	sumarm_3294956
	nop
code_3305566:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306036:
	mov	%r8, %r12
code_3305567:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306037:
	mov	%r8, %r9
code_3305574:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306038:
	st	%r8, [%sp+96]
code_3305575:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306039:
	mov	%r8, %r12
code_3305576:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306040:
	mov	%r8, %r9
code_3305583:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306041:
	mov	%r8, %r9
code_3305584:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305585
	nop
code_3305586:
	call	GCFromML ! delay slot empty
	nop
needgc_3305585:
	! allocating 2-record
	sethi	%hi(gctag_3198487), %r8
	ld	[%r8+%lo(gctag_3198487)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3294956:
	ld	[%r11], %r12
	cmp	%r12, 5
	bne	sumarm_3295039
	nop
code_3305590:
	sethi	%hi(type_3194501), %r8
	or	%r8, %lo(type_3194501), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r11+4], %r10
	! making closure call
	sethi	%hi(_3228379), %r8
	or	%r8, %lo(_3228379), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306042:
code_3305595:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306043:
	mov	%r8, %r10
code_3305596:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306044:
	mov	%r8, %r12
code_3305599:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306045:
	mov	%r8, %r9
code_3305606:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306046:
	st	%r8, [%sp+96]
code_3305607:
	! done making normal call
	! making closure call
	sethi	%hi(_3228506), %r8
	or	%r8, %lo(_3228506), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306047:
	mov	%r8, %r12
code_3305610:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244904), %r8
	or	%r8, %lo(type_3244904), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306048:
	mov	%r8, %r9
code_3305617:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306049:
	mov	%r8, %r11
code_3305618:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305619
	nop
code_3305620:
	call	GCFromML ! delay slot empty
	nop
needgc_3305619:
	or	%r0, 17, %r10
	sethi	%hi(type_3244904), %r8
	or	%r8, %lo(type_3244904), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3305624
	nop
code_3305625:
	or	%r0, 0, %r8
cmpui_3305624:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3295039:
	ld	[%r11], %r12
	cmp	%r12, 6
	bne	sumarm_3295147
	nop
code_3305627:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306050:
	mov	%r8, %r10
code_3305628:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306051:
	mov	%r8, %r12
code_3305631:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306052:
	mov	%r8, %r9
code_3305638:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306053:
	st	%r8, [%sp+96]
code_3305639:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306054:
	mov	%r8, %r12
code_3305640:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306055:
	mov	%r8, %r9
code_3305647:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306056:
	mov	%r8, %r9
code_3305648:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305649
	nop
code_3305650:
	call	GCFromML ! delay slot empty
	nop
needgc_3305649:
	! allocating 2-record
	sethi	%hi(gctag_3198571), %r8
	ld	[%r8+%lo(gctag_3198571)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 6, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3295147:
	ld	[%r11], %r12
	cmp	%r12, 7
	bne	sumarm_3295239
	nop
code_3305654:
	ld	[%r11+4], %r11
	ld	[%r11], %r9
	ld	[%r11+4], %r8
	ld	[%r11+8], %r16
	st	%r16, [%sp+96]
sumarm_3295258:
	cmp	%r8, 0
	bne	sumarm_3295259
	nop
code_3305655:
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306057:
	mov	%r8, %r12
code_3305656:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306058:
	mov	%r8, %r9
code_3305663:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305664:
	! done making tail call
	ba	after_sum_3295255 ! delay slot empty
	nop
sumarm_3295259:
	ld	[%r8], %r12
	ld	[%r8+4], %r8
sumarm_3295325:
	ld	[%r12], %r11
	cmp	%r11, 0
	bne	sumarm_3295326
	nop
code_3305666:
	ld	[%r12+4], %r11
	ld	[%r11], %r18
	ld	[%r11+4], %r13
	ld	[%r11+8], %r12
	! allocating 7-record
	sethi	%hi(gctag_3198662), %r11
	ld	[%r11+%lo(gctag_3198662)], %r11
	st	%r11, [%r4]
	st	%r9, [%r4+4]
	sethi	%hi(record_temp_3046085), %r9
	or	%r9, %lo(record_temp_3046085), %r9
	st	%r9, [%r4+8]
	st	%r18, [%r4+12]
	st	%r13, [%r4+16]
	st	%r12, [%r4+20]
	st	%r8, [%r4+24]
	ld	[%sp+96], %r17
	st	%r17, [%r4+28]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 32, %r4
	! done allocating 7 record
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306060:
	mov	%r8, %r9
code_3305669:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305670:
	! done making tail call
	ba	after_sum_3295322 ! delay slot empty
	nop
sumarm_3295326:
	ld	[%r12], %r11
	cmp	%r11, 1
	bne	sumarm_3295363
	nop
code_3305672:
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r10
	ld	[%r10+%lo(gctag_3197849)], %r10
	st	%r10, [%r4]
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+104]
	add	%r4, 12, %r4
	! done allocating 2 record
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306062:
	mov	%r8, %r12
code_3305674:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306063:
	mov	%r8, %r9
code_3305681:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306064:
	st	%r8, [%sp+96]
code_3305682:
	! done making normal call
	! making closure call
	sethi	%hi(_3225548), %r8
	or	%r8, %lo(_3225548), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+128], %r10
code_3306065:
	mov	%r8, %r9
code_3305685:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3306066:
	mov	%r8, %r11
code_3305686:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+132], %r10
code_3306067:
	mov	%r8, %r12
code_3305687:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306068:
	mov	%r8, %r9
code_3305694:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305695:
	! done making tail call
	ba	after_sum_3295322 ! delay slot empty
	nop
sumarm_3295363:
	ld	[%r12+4], %r11
	ld	[%r11], %r18
	ld	[%r11+4], %r13
	ld	[%r11+8], %r12
	! allocating 7-record
	sethi	%hi(gctag_3198662), %r11
	ld	[%r11+%lo(gctag_3198662)], %r11
	st	%r11, [%r4]
	st	%r9, [%r4+4]
	sethi	%hi(record_temp_3046124), %r9
	or	%r9, %lo(record_temp_3046124), %r9
	st	%r9, [%r4+8]
	st	%r18, [%r4+12]
	st	%r13, [%r4+16]
	st	%r12, [%r4+20]
	st	%r8, [%r4+24]
	ld	[%sp+96], %r17
	st	%r17, [%r4+28]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 32, %r4
	! done allocating 7 record
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306137:
	mov	%r8, %r9
code_3305699:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305700:
	! done making tail call
	ba	after_sum_3295322 ! delay slot empty
	nop
sumarm_3295463:
after_sum_3295322:
	ba	after_sum_3295255 ! delay slot empty
	nop
sumarm_3295294:
after_sum_3295255:
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3295239:
	ld	[%r11], %r12
	cmp	%r12, 8
	bne	sumarm_3295499
	nop
code_3305704:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(_3229179), %r8
	or	%r8, %lo(_3229179), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306071:
	mov	%r8, %r10
code_3305707:
	! done making normal call
	! making closure call
	sethi	%hi(_3229232), %r8
	or	%r8, %lo(_3229232), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306072:
code_3305710:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306073:
	st	%r8, [%sp+100]
code_3305711:
	! done making normal call
	sethi	%hi(anonfun_3046162), %r8
	or	%r8, %lo(anonfun_3046162), %r10
	! making closure call
	sethi	%hi(_3198802), %r8
	or	%r8, %lo(_3198802), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306074:
	mov	%r8, %r12
code_3305715:
	! done making normal call
	sethi	%hi(type_3224221), %r8
	or	%r8, %lo(type_3224221), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3194964), %r8
	or	%r8, %lo(type_3194964), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306075:
	mov	%r8, %r9
code_3305722:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306076:
	st	%r8, [%sp+96]
code_3305723:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r12
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	mov	%r12, %r10
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3306077:
	mov	%r8, %r9
code_3305730:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306078:
code_3305731:
	! done making normal call
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3229453), %r8
	or	%r8, %lo(_3229453), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306079:
code_3305734:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%sp+108], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3295615
	nop
zero_case_3295614:
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306138:
	mov	%r8, %r10
code_3305736:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306080:
	mov	%r8, %r12
code_3305739:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306081:
	mov	%r8, %r9
code_3305746:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3306082:
code_3305747:
	! done making normal call
	ba	after_zeroone_3295616
	st	%r8, [%sp+96]
one_case_3295615:
	ld	[%sp+96], %r17
	ld	[%r17], %r10
	ld	[%sp+96], %r17
	ld	[%r17+4], %r11
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3306134:
	mov	%r8, %r10
code_3305749:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306083:
	mov	%r8, %r12
code_3305752:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306084:
	mov	%r8, %r9
code_3305759:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3306085:
code_3305760:
	! done making normal call
	st	%r8, [%sp+96]
after_zeroone_3295616:
	! making closure call
	sethi	%hi(_3229651), %r8
	or	%r8, %lo(_3229651), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306011:
	mov	%r8, %r12
code_3305763:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306086:
	mov	%r8, %r9
code_3305770:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306087:
	mov	%r8, %r10
code_3305771:
	! done making normal call
	! making closure call
	sethi	%hi(_3229727), %r8
	or	%r8, %lo(_3229727), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306088:
	mov	%r8, %r9
code_3305774:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305775
	nop
code_3305776:
	call	GCFromML ! delay slot empty
	nop
needgc_3305775:
	! allocating 2-record
	sethi	%hi(gctag_3198913), %r8
	ld	[%r8+%lo(gctag_3198913)], %r8
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 8, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3295499:
	ld	[%r11], %r12
	cmp	%r12, 9
	bne	sumarm_3295758
	nop
code_3305780:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
sumarm_3295771:
	or	%r0, 255, %r8
	ld	[%sp+96], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3295769
	nop
code_3305781:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 3
	bne	sumarm_3295772
	nop
code_3305782:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r11
sumarm_3295790:
	or	%r0, 255, %r8
	cmp	%r11, %r8
	bleu	nomatch_sum_3295788
	nop
code_3305783:
	sethi	%hi(type_3198950), %r8
	or	%r8, %lo(type_3198950), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3295804
	nop
code_3305786:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3295805
	nop
code_3305787:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3295804
	nop
code_3305788:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3295804
	nop
code_3305789:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3295804
	nop
dynamic_nobox_3295805:
	ba	projsum_single_after_3295801
	st	%r11, [%sp+96]
dynamic_box_3295804:
	ld	[%r11], %r16
	st	%r16, [%sp+96]
projsum_single_after_3295801:
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306135:
	st	%r8, [%sp+100]
code_3305792:
	! done making normal call
	! making closure call
	sethi	%hi(_3224282), %r8
	or	%r8, %lo(_3224282), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306089:
	mov	%r8, %r12
code_3305795:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224280), %r8
	or	%r8, %lo(type_3224280), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306090:
	mov	%r8, %r9
code_3305802:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306091:
	st	%r8, [%sp+96]
code_3305803:
	! done making normal call
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3225900), %r8
	or	%r8, %lo(type_3225900), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3306092:
	mov	%r8, %r9
code_3305810:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306093:
code_3305811:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	sethi	%hi(anonfun_3046263), %r8
	or	%r8, %lo(anonfun_3046263), %r10
	! making closure call
	sethi	%hi(_3198994), %r8
	or	%r8, %lo(_3198994), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306094:
	mov	%r8, %r12
code_3305815:
	! done making normal call
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3229448), %r8
	or	%r8, %lo(type_3229448), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306095:
	mov	%r8, %r9
code_3305822:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306096:
	st	%r8, [%sp+96]
code_3305823:
	! done making normal call
	sethi	%hi(anonfun_3046272), %r8
	or	%r8, %lo(anonfun_3046272), %r10
	! making closure call
	sethi	%hi(_3199011), %r8
	or	%r8, %lo(_3199011), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306097:
	mov	%r8, %r12
code_3305827:
	! done making normal call
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306098:
	mov	%r8, %r9
code_3305834:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306099:
code_3305835:
	! done making normal call
	add	%r4, 56, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305836
	nop
code_3305837:
	call	GCFromML ! delay slot empty
	nop
needgc_3305836:
	sethi	%hi(type_3199027), %r9
	or	%r9, %lo(type_3199027), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3295954
	nop
code_3305841:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3295955
	nop
code_3305842:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3295954
	nop
code_3305843:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3295954
	nop
code_3305844:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3295954
	nop
dynamic_nobox_3295955:
	ba	xinject_sum_dyn_after_3295948
	ld	[%sp+96], %r10
dynamic_box_3295954:
	or	%r0, 9, %r11
	sethi	%hi(type_3229448), %r9
	or	%r9, %lo(type_3229448), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3305849
	nop
code_3305850:
	or	%r0, 0, %r9
cmpui_3305849:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 1-record
	st	%r11, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r9
	add	%r4, 8, %r4
	! done allocating 1 record
	mov	%r9, %r10
xinject_sum_dyn_after_3295948:
	! allocating 2-record
	sethi	%hi(gctag_3199039), %r9
	ld	[%r9+%lo(gctag_3199039)], %r9
	st	%r9, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 3, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r9
	ld	[%r9+%lo(gctag_3198155)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3295787 ! delay slot empty
	nop
sumarm_3295791:
nomatch_sum_3295788:
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306133:
	mov	%r8, %r10
code_3305854:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306100:
	mov	%r8, %r12
code_3305857:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306101:
	mov	%r8, %r9
code_3305864:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306102:
	mov	%r8, %r9
code_3305865:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305866
	nop
code_3305867:
	call	GCFromML ! delay slot empty
	nop
needgc_3305866:
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
after_sum_3295787:
	ba	after_sum_3295768 ! delay slot empty
	nop
sumarm_3295772:
nomatch_sum_3295769:
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306132:
	mov	%r8, %r10
code_3305871:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306103:
	mov	%r8, %r12
code_3305874:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306104:
	mov	%r8, %r9
code_3305881:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306105:
	mov	%r8, %r9
code_3305882:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305883
	nop
code_3305884:
	call	GCFromML ! delay slot empty
	nop
needgc_3305883:
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
after_sum_3295768:
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3295758:
	ld	[%r11], %r12
	cmp	%r12, 10
	bne	sumarm_3296096
	nop
code_3305888:
	ld	[%r11+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306106:
	mov	%r8, %r12
code_3305889:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306107:
	mov	%r8, %r9
code_3305896:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306108:
	mov	%r8, %r9
code_3305897:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305898
	nop
code_3305899:
	call	GCFromML ! delay slot empty
	nop
needgc_3305898:
	! allocating 2-record
	sethi	%hi(gctag_3199100), %r8
	ld	[%r8+%lo(gctag_3199100)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 10, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(anonfun_3244070), %r8
	or	%r8, %lo(anonfun_3244070), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305903:
	! done making tail call
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3296096:
	ld	[%r11], %r12
	cmp	%r12, 11
	bne	sumarm_3296155
	nop
code_3305905:
	ld	[%r11+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	ld	[%r9+8], %r16
	st	%r16, [%sp+112]
	ld	[%r9+12], %r16
	st	%r16, [%sp+108]
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r8], %r12
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306109:
	mov	%r8, %r12
code_3305906:
	! done making normal call
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193074), %r8
	or	%r8, %lo(type_3193074), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306110:
	mov	%r8, %r9
code_3305913:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306111:
	st	%r8, [%sp+104]
code_3305914:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306112:
	mov	%r8, %r12
code_3305915:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306113:
	mov	%r8, %r9
code_3305922:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306114:
	st	%r8, [%sp+100]
code_3305923:
	! done making normal call
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306115:
	mov	%r8, %r12
code_3305924:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306116:
	mov	%r8, %r9
code_3305931:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306117:
	st	%r8, [%sp+96]
code_3305932:
	! done making normal call
	! making closure call
	sethi	%hi(_3199219), %r8
	or	%r8, %lo(_3199219), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3306118:
	mov	%r8, %r12
code_3305935:
	! done making normal call
	sethi	%hi(type_3245257), %r8
	or	%r8, %lo(type_3245257), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3245263), %r8
	or	%r8, %lo(type_3245263), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306119:
	mov	%r8, %r9
code_3305942:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3306120:
	mov	%r8, %r9
code_3305943:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305944
	nop
code_3305945:
	call	GCFromML ! delay slot empty
	nop
needgc_3305944:
	! allocating 4-record
	sethi	%hi(gctag_3199248), %r8
	ld	[%r8+%lo(gctag_3199248)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 11, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+116], %r17
	ld	[%r17], %r11
	ld	[%sp+116], %r17
	ld	[%r17+4], %r8
	ld	[%sp+116], %r17
	ld	[%r17+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3306131:
	mov	%r8, %r12
code_3305948:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306121:
	mov	%r8, %r9
code_3305955:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305956:
	! done making tail call
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3296155:
	ld	[%r11], %r12
	cmp	%r12, 12
	bne	sumarm_3296338
	nop
code_3305958:
	sethi	%hi(string_3270420), %r8
	or	%r8, %lo(string_3270420), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305962:
	! done making tail call
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3296338:
	ld	[%r11], %r12
	cmp	%r12, 13
	bne	sumarm_3296351
	nop
code_3305964:
	ld	[%r11+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3227254), %r8
	or	%r8, %lo(_3227254), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+128], %r10
code_3306124:
	mov	%r8, %r9
code_3305967:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306125:
	mov	%r8, %r10
code_3305968:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3305969
	nop
code_3305970:
	call	GCFromML ! delay slot empty
	nop
needgc_3305969:
sumarm_3296379:
	cmp	%r10, 0
	bne	sumarm_3296380
	nop
code_3305972:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(strbindvar_r_find_kind_equation_3193977), %r8
	or	%r8, %lo(strbindvar_r_find_kind_equation_3193977), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3306126:
	mov	%r8, %r10
code_3305975:
	! done making normal call
sumarm_3296407:
	cmp	%r10, 0
	bne	sumarm_3296408
	nop
code_3305976:
	ba	after_sum_3296404
	ld	[%sp+96], %r8
sumarm_3296408:
	sethi	%hi(type_3199327), %r8
	or	%r8, %lo(type_3199327), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3296424
	nop
code_3305980:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3296425
	nop
code_3305981:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3296424
	nop
code_3305982:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3296424
	nop
code_3305983:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3296424
	nop
dynamic_nobox_3296425:
	ba	projsum_single_after_3296421
	st	%r10, [%sp+96]
dynamic_box_3296424:
	ld	[%r10], %r16
	st	%r16, [%sp+96]
projsum_single_after_3296421:
	! making closure call
	ld	[%sp+136], %r17
	ld	[%r17], %r12
	ld	[%sp+136], %r17
	ld	[%r17+4], %r8
	ld	[%sp+136], %r17
	ld	[%r17+8], %r9
	ld	[%sp+132], %r10
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306136:
	mov	%r8, %r12
code_3305986:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306127:
	mov	%r8, %r9
code_3305993:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3305994:
	! done making tail call
	ba	after_sum_3296404 ! delay slot empty
	nop
sumarm_3296412:
after_sum_3296404:
	ba	after_sum_3296376 ! delay slot empty
	nop
sumarm_3296380:
	sethi	%hi(type_3199336), %r8
	or	%r8, %lo(type_3199336), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3296470
	nop
code_3305999:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3296471
	nop
code_3306000:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3296470
	nop
code_3306001:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3296470
	nop
code_3306002:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3296470
	nop
dynamic_nobox_3296471:
	ba	projsum_single_after_3296467
	mov	%r10, %r8
dynamic_box_3296470:
	ld	[%r10], %r8
projsum_single_after_3296467:
	ba	after_sum_3296376 ! delay slot empty
	nop
sumarm_3296458:
after_sum_3296376:
	ba	after_sum_3294596 ! delay slot empty
	nop
sumarm_3296351:
nomatch_sum_3294597:
	sethi	%hi(record_3270494), %r8
	or	%r8, %lo(record_3270494), %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3294596:
code_3306010:
	ld	[%sp+92], %r15
	retl
	add	%sp, 144, %sp
	.size Normalize_anonfun_code_3263003,(.-Normalize_anonfun_code_3263003)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306011
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long needgc_3305468
	.word 0x0024000a
	.word 0x00170000
	.word 0x00001000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306012
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff330000
	.word 0x00000050
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306013
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff330000
	.word 0x00000050
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306014
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff300000
	.word 0x00000050
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306015
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff3d0000
	.word 0x00000010
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306016
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff3c0000
	.word 0x00000010
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306017
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff3c0000
	.word 0x00000010
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3246904
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306018
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc3c0000
	.word 0x00000010
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306019
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc3f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3227965
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306020
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc3f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3227965
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3306021
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc0f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3227965
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long needgc_3305502
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0xfc0f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3227965
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306022
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3246664
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306023
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3246664
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306024
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3246664
		! -------- label,sizes,reg
	.long needgc_3305517
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3246664
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306025
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306026
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306027
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001c0000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306028
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306029
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306030
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306031
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00130000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3305544
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00130000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306032
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306033
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306034
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306036
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306037
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306038
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306039
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306040
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306041
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3305585
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306042
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306043
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306044
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306045
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306046
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306047
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306048
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306049
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3305619
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3244904
		! -------- label,sizes,reg
	.long code_3306050
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306051
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306052
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306053
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306054
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306055
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306056
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long needgc_3305649
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306057
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306058
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306060
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306062
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00130000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306063
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00130000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306064
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00100000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306065
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00130000
	.word 0x0000001c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306066
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00100000
	.word 0x0000001c
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306067
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00100000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306068
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00100000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306071
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c40000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306072
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c40000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306073
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306074
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306075
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f70000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306076
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f40000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306077
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3194964
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306078
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f00000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306079
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f10000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306080
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306081
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306082
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306083
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306084
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306085
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306086
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306087
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c00000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306088
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c00000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long needgc_3305775
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00c00000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3245629
		! -------- label,sizes,reg
	.long code_3306089
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f40000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306090
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f40000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306091
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00340000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306092
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306093
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306094
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306095
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306096
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306097
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306098
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long reify_3247863
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long code_3306099
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3226630
		! -------- label,sizes,reg
	.long needgc_3305836
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306100
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306101
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306102
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
		! -------- label,sizes,reg
	.long needgc_3305866
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306103
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306104
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306105
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
		! -------- label,sizes,reg
	.long needgc_3305883
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long type_3248940
		! -------- label,sizes,reg
	.long code_3306106
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306107
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306108
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3305898
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306109
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17cf0000
	.word 0x0000001f
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306110
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17cf0000
	.word 0x0000001f
		! worddata
	.word 0x80000007
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306111
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17cc0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306112
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17fc0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193074
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306113
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17fc0000
	.word 0x0000001f
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193074
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306114
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17f00000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193074
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306115
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17fc0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306116
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x17fc0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306117
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x173c0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306118
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x073f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306119
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x073f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long reify_3245328
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306120
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x043f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3305944
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x043f0000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193074
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3245263
		! -------- label,sizes,reg
	.long code_3306121
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306124
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306125
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3305969
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3227252
		! -------- label,sizes,reg
	.long code_3306126
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000001f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306127
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3245079
		! -------- label,sizes,reg
	.long code_3306129
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306131
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306132
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306133
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long type_3248740
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306134
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3306135
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3306136
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3245079
		! -------- label,sizes,reg
	.long code_3306137
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306138
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193138
	.text
	.align 8
	.global Normalize_con_normalize_inner_code_3262966
 ! arguments : [$3262968,$8] [$3262969,$9] [$3227562,$10] [$3227563,$11] 
 ! results    : [$3294569,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_normalize_inner_code_3262966:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 160, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306211
	nop
	add	%sp, 160, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 160, %sp
code_3306211:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r9, %r8
	st	%r10, [%sp+152]
	st	%r11, [%sp+148]
code_3306140:
funtop_3294359:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+12], %r16
	st	%r16, [%sp+108]
	ld	[%r8+16], %r16
	st	%r16, [%sp+112]
	ld	[%r8+20], %r16
	st	%r16, [%sp+116]
	ld	[%r8+24], %r16
	st	%r16, [%sp+120]
	ld	[%r8+28], %r16
	st	%r16, [%sp+124]
	ld	[%r8+32], %r16
	st	%r16, [%sp+128]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306209:
	st	%r8, [%sp+144]
code_3306141:
	! done making normal call
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306202:
	st	%r8, [%sp+140]
code_3306142:
	! done making normal call
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306203:
	st	%r8, [%sp+136]
code_3306143:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306204:
	st	%r8, [%sp+100]
code_3306144:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306205:
	st	%r8, [%sp+132]
code_3306145:
	! done making normal call
	! making closure call
	ld	[%sp+116], %r17
	ld	[%r17], %r12
	ld	[%sp+116], %r17
	ld	[%r17+4], %r8
	ld	[%sp+116], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306206:
	st	%r8, [%sp+116]
code_3306146:
	! done making normal call
	! making closure call
	ld	[%sp+120], %r17
	ld	[%r17], %r12
	ld	[%sp+120], %r17
	ld	[%r17+4], %r8
	ld	[%sp+120], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306207:
	st	%r8, [%sp+112]
code_3306147:
	! done making normal call
	! making closure call
	ld	[%sp+124], %r17
	ld	[%r17], %r12
	ld	[%sp+124], %r17
	ld	[%r17+4], %r8
	ld	[%sp+124], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+128], %r11
code_3306208:
	st	%r8, [%sp+108]
code_3306148:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306149
	nop
code_3306150:
	call	GCFromML ! delay slot empty
	nop
needgc_3306149:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_folder_code_3262981), %r8
	or	%r8, %lo(Normalize_folder_code_3262981), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+104]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3195318), %r8
	or	%r8, %lo(type_3195318), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	ld	[%r11+8], %r11
	jmpl	%r13, %r15
	ld	[%sp+140], %r12
code_3306210:
	st	%r8, [%sp+100]
code_3306159:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306160
	nop
code_3306161:
	call	GCFromML ! delay slot empty
	nop
needgc_3306160:
	! allocating 1 closures
	or	%r0, 801, %r8
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3306165
	nop
code_3306166:
	or	%r0, 0, %r9
cmpui_3306165:
	sll	%r9, 10, %r9
	add	%r9, %r0, %r9
	or	%r9, %r8, %r8
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3306169
	nop
code_3306170:
	or	%r0, 0, %r9
cmpui_3306169:
	sll	%r9, 11, %r9
	add	%r9, %r0, %r9
	or	%r9, %r8, %r8
	! allocating 4-record
	st	%r8, [%r4]
	ld	[%sp+136], %r17
	st	%r17, [%r4+4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+8]
	ld	[%sp+152], %r17
	st	%r17, [%r4+12]
	ld	[%sp+148], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_doarm_inner_code_3262990), %r8
	or	%r8, %lo(Normalize_doarm_inner_code_3262990), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3244064), %r8
	or	%r8, %lo(type_3244064), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	ld	[%r11+8], %r11
	jmpl	%r13, %r15
	ld	[%sp+144], %r12
code_3306200:
	mov	%r8, %r9
code_3306178:
	! done making normal call
	add	%r4, 64, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306179
	nop
code_3306180:
	call	GCFromML ! delay slot empty
	nop
needgc_3306179:
	! allocating 1 closures
	sethi	%hi(425817), %r8
	or	%r8, %lo(425817), %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306184
	nop
code_3306185:
	or	%r0, 0, %r10
cmpui_3306184:
	sll	%r10, 15, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306188
	nop
code_3306189:
	or	%r0, 0, %r10
cmpui_3306188:
	sll	%r10, 16, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 11-record
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	ld	[%sp+136], %r17
	st	%r17, [%r4+12]
	ld	[%sp+132], %r17
	st	%r17, [%r4+16]
	ld	[%sp+116], %r17
	st	%r17, [%r4+20]
	ld	[%sp+112], %r17
	st	%r17, [%r4+24]
	ld	[%sp+108], %r17
	st	%r17, [%r4+28]
	ld	[%sp+152], %r17
	st	%r17, [%r4+32]
	ld	[%sp+148], %r17
	st	%r17, [%r4+36]
	ld	[%sp+100], %r17
	st	%r17, [%r4+40]
	st	%r9, [%r4+44]
	add	%r4, 4, %r9
	add	%r4, 48, %r4
	! done allocating 11 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263003), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263003), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306201:
code_3306197:
	! done making normal call
code_3306199:
	ld	[%sp+92], %r15
	retl
	add	%sp, 160, %sp
	.size Normalize_con_normalize_inner_code_3262966,(.-Normalize_con_normalize_inner_code_3262966)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306200
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05550000
	.word 0x00003c14
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306201
	.word 0x00280008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3306202
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x55510000
	.word 0x00003d01
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306203
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x55410000
	.word 0x00003d41
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306204
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x55010000
	.word 0x00003d51
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306205
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x54050000
	.word 0x00003d51
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306206
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x50050000
	.word 0x00003d55
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306207
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x44050000
	.word 0x00003d55
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306208
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05040000
	.word 0x00003d54
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3306149
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05440000
	.word 0x00003d54
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3306160
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05540000
	.word 0x00003d14
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3306179
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05550000
	.word 0x00003c14
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306209
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x55550000
	.word 0x00003c01
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306210
	.word 0x0028000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05500000
	.word 0x00003d14
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_con_normalize_r_code_3262651
 ! arguments : [$3262653,$8] [$3198090,$9] [$3262654,$10] [$3198091,$11] 
 ! results    : [$3294354,$8] 
 ! destroys   :  $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_normalize_r_code_3262651:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306219
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306219:
	st	%r15, [%sp+92]
	mov	%r11, %r22
code_3306212:
funtop_3294317:
	add	%r4, 56, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306213
	nop
code_3306214:
	call	GCFromML ! delay slot empty
	nop
needgc_3306213:
	ld	[%r10], %r21
	ld	[%r10+4], %r20
	ld	[%r10+8], %r19
	ld	[%r10+12], %r18
	ld	[%r10+16], %r13
	ld	[%r10+20], %r12
	ld	[%r10+24], %r11
	ld	[%r10+28], %r10
	! allocating 1 closures
	! allocating 9-record
	sethi	%hi(130889), %r8
	or	%r8, %lo(130889), %r8
	st	%r8, [%r4]
	st	%r21, [%r4+4]
	st	%r20, [%r4+8]
	st	%r19, [%r4+12]
	st	%r18, [%r4+16]
	st	%r13, [%r4+20]
	st	%r12, [%r4+24]
	st	%r11, [%r4+28]
	st	%r10, [%r4+32]
	st	%r22, [%r4+36]
	add	%r4, 4, %r10
	add	%r4, 40, %r4
	! done allocating 9 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_con_normalize_inner_code_3262966), %r8
	or	%r8, %lo(Normalize_con_normalize_inner_code_3262966), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3306218:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_normalize_r_code_3262651,(.-Normalize_con_normalize_r_code_3262651)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3306213
	.word 0x00180007
	.word 0x00170000
	.word 0xbfc00600
	.word 0xbf800000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_bind_at_tracecon_inner_code_3263048
 ! arguments : [$3263050,$8] [$3263051,$9] [$3225817,$10] [$3225818,$11] 
 ! results    : [$3294314,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bind_at_tracecon_inner_code_3263048:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306235
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306235:
	st	%r15, [%sp+92]
	mov	%r10, %r8
code_3306220:
funtop_3294268:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306221
	nop
code_3306222:
	call	GCFromML ! delay slot empty
	nop
needgc_3306221:
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3196399), %r8
	ld	[%r8+%lo(gctag_3196399)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(bind_at_con_3196764), %r8
	or	%r8, %lo(bind_at_con_3196764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306234:
	mov	%r8, %r9
code_3306227:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306228
	nop
code_3306229:
	call	GCFromML ! delay slot empty
	nop
needgc_3306228:
	ld	[%r9], %r8
	ld	[%r9+4], %r11
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 3-record
	sethi	%hi(gctag_3196848), %r8
	ld	[%r8+%lo(gctag_3196848)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3306233:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_bind_at_tracecon_inner_code_3263048,(.-Normalize_bind_at_tracecon_inner_code_3263048)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3306221
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000900
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3306228
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3196844
		! -------- label,sizes,reg
	.long code_3306234
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3196844
	.text
	.align 8
	.global Normalize_anonfun_code_3263053
 ! arguments : [$3263055,$8] [$3263056,$9] [$3046546,$10] 
 ! results    : [$3294267,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263053:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306244
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306244:
	st	%r15, [%sp+92]
code_3306236:
funtop_3294255:
	sethi	%hi(string_3270855), %r8
	or	%r8, %lo(string_3270855), %r10
	! making closure call
	sethi	%hi(_3199663), %r8
	or	%r8, %lo(_3199663), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 96, %sp
code_3306240:
	! done making tail call
code_3306242:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263053,(.-Normalize_anonfun_code_3263053)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3263098
 ! arguments : [$3263100,$8] [$3263101,$9] [$3046461,$10] 
 ! results    : [$3294027,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263098:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306356
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3306356:
	st	%r15, [%sp+92]
code_3306245:
funtop_3293914:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306246
	nop
code_3306247:
	call	GCFromML ! delay slot empty
	nop
needgc_3306246:
	ld	[%r9], %r16
	st	%r16, [%sp+112]
	ld	[%r9+4], %r16
	st	%r16, [%sp+108]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
sumarm_3293938:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3293939
	nop
code_3306249:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306336:
	mov	%r8, %r12
code_3306252:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306337:
	mov	%r8, %r9
code_3306259:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306338:
	st	%r8, [%sp+96]
code_3306260:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306339:
	mov	%r8, %r10
code_3306261:
	! done making normal call
	! making closure call
	sethi	%hi(_3199429), %r8
	or	%r8, %lo(_3199429), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306340:
	mov	%r8, %r9
code_3306264:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306341:
code_3306265:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306266
	nop
code_3306267:
	call	GCFromML ! delay slot empty
	nop
needgc_3306266:
	! allocating 2-record
	sethi	%hi(gctag_3199441), %r8
	ld	[%r8+%lo(gctag_3199441)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3293935
	mov	%r8, %r10
sumarm_3293939:
	ld	[%r10], %r8
	cmp	%r8, 1
	bne	sumarm_3294028
	nop
code_3306271:
	ba	after_sum_3293935 ! delay slot empty
	nop
sumarm_3294028:
	ld	[%r10], %r8
	cmp	%r8, 2
	bne	sumarm_3294031
	nop
code_3306273:
	ba	after_sum_3293935 ! delay slot empty
	nop
sumarm_3294031:
	ld	[%r10], %r8
	cmp	%r8, 3
	bne	sumarm_3294034
	nop
code_3306275:
	ld	[%r10+4], %r16
	st	%r16, [%sp+96]
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306342:
	st	%r8, [%sp+104]
code_3306276:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	mov	%r9, %r8
	jmpl	%r11, %r15
	ld	[%sp+96], %r9
code_3306343:
	st	%r8, [%sp+108]
code_3306280:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3306344:
	mov	%r8, %r9
code_3306287:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306345:
	mov	%r8, %r11
code_3306288:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	mov	%r9, %r8
	jmpl	%r12, %r15
	ld	[%sp+96], %r9
code_3306346:
code_3306292:
	! done making normal call
	ba	after_sum_3293935
	ld	[%sp+100], %r10
sumarm_3294034:
	ld	[%r10], %r8
	cmp	%r8, 4
	bne	sumarm_3294098
	nop
code_3306294:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306347:
	mov	%r8, %r12
code_3306297:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306348:
	mov	%r8, %r9
code_3306304:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306349:
	mov	%r8, %r9
code_3306305:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306306
	nop
code_3306307:
	call	GCFromML ! delay slot empty
	nop
needgc_3306306:
	! allocating 2-record
	sethi	%hi(gctag_3199545), %r8
	ld	[%r8+%lo(gctag_3199545)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 4, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3293935
	mov	%r8, %r10
sumarm_3294098:
	ld	[%r10], %r8
	cmp	%r8, 5
	bne	sumarm_3294164
	nop
code_3306311:
	ba	after_sum_3293935 ! delay slot empty
	nop
sumarm_3294164:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306355:
	mov	%r8, %r12
code_3306315:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306350:
	mov	%r8, %r9
code_3306322:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306351:
	st	%r8, [%sp+96]
code_3306323:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306352:
	mov	%r8, %r10
code_3306324:
	! done making normal call
	! making closure call
	sethi	%hi(_3199429), %r8
	or	%r8, %lo(_3199429), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306353:
	mov	%r8, %r9
code_3306327:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306354:
code_3306328:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306329
	nop
code_3306330:
	call	GCFromML ! delay slot empty
	nop
needgc_3306329:
	! allocating 2-record
	sethi	%hi(gctag_3199441), %r8
	ld	[%r8+%lo(gctag_3199441)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 6, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3293935
	mov	%r8, %r10
sumarm_3294167:
after_sum_3293935:
code_3306335:
	mov	%r10, %r8
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263098,(.-Normalize_anonfun_code_3263098)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3306246
	.word 0x00200009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3250628
		! -------- label,sizes,reg
	.long code_3306336
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f70000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306337
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f70000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306338
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f40000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306339
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306340
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306341
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3306266
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306342
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3306343
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00150000
		! -------- label,sizes,reg
	.long code_3306344
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c50000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3306345
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3306346
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
		! -------- label,sizes,reg
	.long code_3306347
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3199541
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306348
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3199541
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306349
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3199541
		! -------- label,sizes,reg
	.long needgc_3306306
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3199541
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306350
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f70000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306351
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f40000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306352
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306353
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306354
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3306329
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306355
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01f70000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_value_normalizePRIME_code_3263058
 ! arguments : [$3263060,$8] [$3263061,$9] [$3230615,$10] [$3230616,$11] 
 ! results    : [$3293913,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_value_normalizePRIME_code_3263058:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306386
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306386:
	st	%r15, [%sp+92]
code_3306357:
funtop_3293851:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306358
	nop
code_3306359:
	call	GCFromML ! delay slot empty
	nop
needgc_3306358:
	! allocating 1 closures
	or	%r0, 281, %r13
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r12
	ld	[%r2+804], %r8
	add	%r12, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306363
	nop
code_3306364:
	or	%r0, 0, %r8
cmpui_3306363:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r13, %r13
	sethi	%hi(type_3193047), %r8
	or	%r8, %lo(type_3193047), %r12
	ld	[%r2+804], %r8
	add	%r12, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306367
	nop
code_3306368:
	or	%r0, 0, %r8
cmpui_3306367:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r13, %r13
	! allocating 3-record
	st	%r13, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263098), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263098), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3230623), %r8
	or	%r8, %lo(type_3230623), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r13
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r12
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label exp_TYC
	ld	[%r8+16], %r10
	ld	[%r13], %r11
	ld	[%r13+4], %r8
	jmpl	%r11, %r15
	mov	%r12, %r9
code_3306384:
	mov	%r8, %r12
code_3306376:
	! done making constructor call
	sethi	%hi(type_3230628), %r8
	or	%r8, %lo(type_3230628), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3306385:
code_3306381:
	! done making normal call
code_3306383:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_value_normalizePRIME_code_3263058,(.-Normalize_value_normalizePRIME_code_3263058)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306384
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3306358
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3306385
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_switch_normalizePRIME_code_3263063
 ! arguments : [$3263065,$8] [$3263066,$9] [$3230857,$10] [$3230858,$11] 
 ! results    : [$3293848,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_switch_normalizePRIME_code_3263063:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306392
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306392:
	st	%r15, [%sp+92]
code_3306387:
funtop_3293845:
	sethi	%hi(anonfun_3046545), %r8
	or	%r8, %lo(anonfun_3046545), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
code_3306391:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_switch_normalizePRIME_code_3263063,(.-Normalize_switch_normalizePRIME_code_3263063)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3263110
 ! arguments : [$3263112,$8] [$3263113,$9] [$3046555,$10] 
 ! results    : [$3293844,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263110:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 144, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306458
	nop
	add	%sp, 144, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 144, %sp
code_3306458:
	st	%r15, [%sp+92]
	mov	%r10, %r8
code_3306393:
funtop_3293638:
	ld	[%r9], %r16
	st	%r16, [%sp+140]
	ld	[%r9+4], %r10
	ld	[%r9+8], %r11
sumarm_3293651:
	ld	[%r8], %r16
	st	%r16, [%sp+136]
	ld	[%r8+8], %r16
	st	%r16, [%sp+132]
	ld	[%r8+28], %r16
	st	%r16, [%sp+128]
	ld	[%r8+24], %r16
	st	%r16, [%sp+96]
	ld	[%r8+16], %r16
	st	%r16, [%sp+104]
	ld	[%r8+20], %r16
	st	%r16, [%sp+124]
	ld	[%r8+4], %r16
	st	%r16, [%sp+120]
	ld	[%r8+12], %r16
	st	%r16, [%sp+116]
	! making closure call
	sethi	%hi(_3199700), %r8
	or	%r8, %lo(_3199700), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306457:
	mov	%r8, %r12
code_3306396:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306445:
	mov	%r8, %r9
code_3306403:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306446:
code_3306404:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+112]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	sethi	%hi(bind_at_tracecon_inner_3046411), %r8
	or	%r8, %lo(bind_at_tracecon_inner_3046411), %r10
	! making closure call
	sethi	%hi(_3197101), %r8
	or	%r8, %lo(_3197101), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306447:
	mov	%r8, %r9
code_3306408:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3306448:
	mov	%r8, %r12
code_3306409:
	! done making normal call
	sethi	%hi(type_3226049), %r8
	or	%r8, %lo(type_3226049), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3226054), %r8
	or	%r8, %lo(type_3226054), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306449:
	mov	%r8, %r9
code_3306416:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3306450:
code_3306417:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! making closure call
	ld	[%sp+140], %r17
	ld	[%r17], %r12
	ld	[%sp+140], %r17
	ld	[%r17+4], %r8
	ld	[%sp+140], %r17
	ld	[%r17+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306451:
	mov	%r8, %r12
code_3306418:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306452:
	mov	%r8, %r9
code_3306425:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3306453:
	st	%r8, [%sp+96]
code_3306426:
	! done making normal call
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306454:
	mov	%r8, %r12
code_3306429:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306455:
	mov	%r8, %r9
code_3306436:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3306456:
	mov	%r8, %r9
code_3306437:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306438
	nop
code_3306439:
	call	GCFromML ! delay slot empty
	nop
needgc_3306438:
	! allocating 8-record
	sethi	%hi(gctag_3199745), %r8
	ld	[%r8+%lo(gctag_3199745)], %r8
	st	%r8, [%r4]
	ld	[%sp+136], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	ld	[%sp+132], %r17
	st	%r17, [%r4+12]
	st	%r9, [%r4+16]
	ld	[%sp+108], %r17
	st	%r17, [%r4+20]
	ld	[%sp+124], %r17
	st	%r17, [%r4+24]
	ld	[%sp+112], %r17
	st	%r17, [%r4+28]
	ld	[%sp+128], %r17
	st	%r17, [%r4+32]
	add	%r4, 4, %r8
	add	%r4, 36, %r4
	! done allocating 8 record
	ba	after_sum_3293648 ! delay slot empty
	nop
sumarm_3293652:
after_sum_3293648:
code_3306444:
	ld	[%sp+92], %r15
	retl
	add	%sp, 144, %sp
	.size Normalize_anonfun_code_3263110,(.-Normalize_anonfun_code_3263110)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306445
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc330000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000000
	.long reify_3250622
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306446
	.word 0x00240016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc300000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3250622
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306447
	.word 0x0024001c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff3f0000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250622
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306448
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff300000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3250622
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306449
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff300000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3250622
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306450
	.word 0x00240016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff000000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306451
	.word 0x0024001c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfffc0000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306452
	.word 0x0024001c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfffc0000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306453
	.word 0x0024001a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcffc0000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306454
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcfc30000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306455
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcfc30000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long code_3306456
	.word 0x00240016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc3c30000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
		! -------- label,sizes,reg
	.long needgc_3306438
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0xc3c30000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3250366
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306457
	.word 0x00240018
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfc330000
	.word 0x0000007f
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000000
	.long reify_3250622
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3199725
	.word 0x80000000
	.long type_3198371
	.text
	.align 8
	.global Normalize_function_normalizePRIME_code_3263068
 ! arguments : [$3263070,$8] [$3263071,$9] [$3230875,$10] [$3230876,$11] 
 ! results    : [$3293637,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_function_normalizePRIME_code_3263068:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306482
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306482:
	st	%r15, [%sp+92]
code_3306459:
funtop_3293589:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306460
	nop
code_3306461:
	call	GCFromML ! delay slot empty
	nop
needgc_3306460:
	! allocating 1 closures
	or	%r0, 281, %r13
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r12
	ld	[%r2+804], %r8
	add	%r12, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306465
	nop
code_3306466:
	or	%r0, 0, %r8
cmpui_3306465:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r13, %r13
	sethi	%hi(type_3193047), %r8
	or	%r8, %lo(type_3193047), %r12
	ld	[%r2+804], %r8
	add	%r12, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306469
	nop
code_3306470:
	or	%r0, 0, %r8
cmpui_3306469:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r13, %r13
	! allocating 3-record
	st	%r13, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263110), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263110), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label function_TYC
	ld	[%r8+20], %r18
	sethi	%hi(type_3230885), %r8
	or	%r8, %lo(type_3230885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306481:
code_3306478:
	! done making normal call
code_3306480:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_function_normalizePRIME_code_3263068,(.-Normalize_function_normalizePRIME_code_3263068)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306481
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3306460
	.word 0x0018000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_anonfun_code_3263122
 ! arguments : [$3263124,$8] [$3263125,$9] [$3231211,$10] [$3231212,$11] 
 ! results    : [$3293586,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263122:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306518
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306518:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3306483:
funtop_3293499:
	ld	[%r9], %r10
	ld	[%r9+4], %r11
	! making closure call
	sethi	%hi(_3199700), %r8
	or	%r8, %lo(_3199700), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306517:
	mov	%r8, %r12
code_3306486:
	! done making normal call
	sethi	%hi(type_3225699), %r8
	or	%r8, %lo(type_3225699), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225601), %r8
	or	%r8, %lo(type_3225601), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306512:
	mov	%r8, %r9
code_3306493:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306513:
code_3306494:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306514:
	mov	%r8, %r12
code_3306497:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306515:
	mov	%r8, %r9
code_3306504:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306516:
	mov	%r8, %r9
code_3306505:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306506
	nop
code_3306507:
	call	GCFromML ! delay slot empty
	nop
needgc_3306506:
	! allocating 2-record
	sethi	%hi(gctag_3199802), %r8
	ld	[%r8+%lo(gctag_3199802)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3306511:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263122,(.-Normalize_anonfun_code_3263122)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306512
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3248062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306513
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306514
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306515
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306516
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long reify_3247715
		! -------- label,sizes,reg
	.long needgc_3306506
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long reify_3247715
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306517
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3248062
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_cfunction_normalizePRIME_code_3263073
 ! arguments : [$3263075,$8] [$3263076,$9] [$3231204,$10] [$3231205,$11] 
 ! results    : [$3293493,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_cfunction_normalizePRIME_code_3263073:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306534
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306534:
	st	%r15, [%sp+92]
code_3306519:
funtop_3293470:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306520
	nop
code_3306521:
	call	GCFromML ! delay slot empty
	nop
needgc_3306520:
	! allocating 1 closures
	or	%r0, 17, %r12
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306525
	nop
code_3306526:
	or	%r0, 0, %r8
cmpui_3306525:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r12, %r12
	sethi	%hi(type_3193047), %r8
	or	%r8, %lo(type_3193047), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306529
	nop
code_3306530:
	or	%r0, 0, %r8
cmpui_3306529:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r12, %r12
	! allocating 2-record
	st	%r12, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263122), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263122), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3306533:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_cfunction_normalizePRIME_code_3263073,(.-Normalize_cfunction_normalizePRIME_code_3263073)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3306520
	.word 0x0018000b
	.word 0x00170000
	.word 0xbffc2000
	.word 0xbffc2c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_norm_bnd_code_3263131
 ! arguments : [$3263133,$8] [$3263134,$9] [$3231398,$10] [$3231399,$11] 
 ! results    : [$3293469,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_norm_bnd_code_3263131:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306550
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306550:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3306535:
funtop_3293432:
	ld	[%r11], %r10
	ld	[%r11+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306549:
	mov	%r8, %r12
code_3306536:
	! done making normal call
	sethi	%hi(type_3193056), %r8
	or	%r8, %lo(type_3193056), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3231448), %r8
	or	%r8, %lo(type_3231448), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306547:
	mov	%r8, %r9
code_3306543:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3306544:
	! done making tail call
code_3306546:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_norm_bnd_code_3263131,(.-Normalize_norm_bnd_code_3263131)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306547
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000001
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306549
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000001
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3263138
 ! arguments : [$3263140,$8] [$3263141,$9] [$3046642,$10] 
 ! results    : [$3293431,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263138:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306570
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306570:
	st	%r15, [%sp+92]
	st	%r10, [%sp+100]
code_3306551:
funtop_3293383:
	ld	[%r9], %r10
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3199885), %r8
	or	%r8, %lo(_3199885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3306569:
	mov	%r8, %r9
code_3306554:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306566:
	mov	%r8, %r12
code_3306555:
	! done making normal call
	sethi	%hi(type_3231391), %r8
	or	%r8, %lo(type_3231391), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3231396), %r8
	or	%r8, %lo(type_3231396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306567:
	mov	%r8, %r9
code_3306562:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3306563:
	! done making tail call
code_3306565:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263138,(.-Normalize_anonfun_code_3263138)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306566
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3306567
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3306569
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_bnds_normalizePRIME_code_3263078
 ! arguments : [$3263080,$8] [$3263081,$9] [$3231379,$10] [$3231380,$11] 
 ! results    : [$3293382,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bnds_normalizePRIME_code_3263078:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306599
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306599:
	st	%r15, [%sp+92]
code_3306571:
funtop_3293318:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306572
	nop
code_3306573:
	call	GCFromML ! delay slot empty
	nop
needgc_3306572:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_norm_bnd_code_3263131), %r8
	or	%r8, %lo(Normalize_norm_bnd_code_3263131), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r13
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	or	%r0, 281, %r12
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306578
	nop
code_3306579:
	or	%r0, 0, %r8
cmpui_3306578:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r12, %r12
	sethi	%hi(type_3193047), %r8
	or	%r8, %lo(type_3193047), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306582
	nop
code_3306583:
	or	%r0, 0, %r8
cmpui_3306582:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r12, %r12
	! allocating 3-record
	st	%r12, [%r4]
	st	%r13, [%r4+4]
	st	%r10, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263138), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263138), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3222681), %r8
	or	%r8, %lo(type_3222681), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label bnd_TYC
	ld	[%r8], %r9
	ld	[%r11], %r10
	jmpl	%r10, %r15
	ld	[%r11+4], %r8
code_3306597:
	mov	%r8, %r12
code_3306589:
	! done making constructor call
	sethi	%hi(type_3231396), %r8
	or	%r8, %lo(type_3231396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3306598:
code_3306594:
	! done making normal call
code_3306596:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_bnds_normalizePRIME_code_3263078,(.-Normalize_bnds_normalizePRIME_code_3263078)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306597
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3306572
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3306598
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3263150
 ! arguments : [$3263152,$8] [$3263153,$9] [$3231901,$10] [$3231902,$11] 
 ! results    : [$3293315,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263150:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306647
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3306647:
	st	%r15, [%sp+92]
	st	%r10, [%sp+124]
code_3306600:
funtop_3293188:
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+120]
	ld	[%r9+8], %r16
	st	%r16, [%sp+116]
	ld	[%r11], %r16
	st	%r16, [%sp+112]
	ld	[%r11+4], %r16
	st	%r16, [%sp+108]
	ld	[%r11+8], %r16
	st	%r16, [%sp+100]
	ld	[%r11+12], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3306646:
	mov	%r8, %r12
code_3306603:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306638:
	mov	%r8, %r9
code_3306610:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306639:
	st	%r8, [%sp+100]
code_3306611:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r12
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3306640:
	mov	%r8, %r12
code_3306612:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3306641:
	mov	%r8, %r9
code_3306619:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3306642:
	st	%r8, [%sp+96]
code_3306620:
	! done making normal call
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3306643:
	mov	%r8, %r12
code_3306623:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306644:
	mov	%r8, %r9
code_3306630:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3306645:
	mov	%r8, %r9
code_3306631:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306632
	nop
code_3306633:
	call	GCFromML ! delay slot empty
	nop
needgc_3306632:
	! allocating 4-record
	sethi	%hi(gctag_3200390), %r8
	ld	[%r8+%lo(gctag_3200390)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3306637:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263150,(.-Normalize_anonfun_code_3263150)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306638
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cfd0000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306639
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cf10000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306640
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cfc0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306641
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cfc0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306642
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3ccc0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3306643
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306644
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193062
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306645
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3306632
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306646
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cfd0000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3263161
 ! arguments : [$3263163,$8] [$3263164,$9] [$3232028,$10] [$3232029,$11] 
 ! results    : [$3293185,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263161:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306667
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306667:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3306648:
funtop_3293142:
	ld	[%r8], %r9
	ld	[%r8+4], %r10
	ld	[%r8+8], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306666:
	mov	%r8, %r12
code_3306649:
	! done making normal call
	sethi	%hi(type_3230885), %r8
	or	%r8, %lo(type_3230885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3230885), %r8
	or	%r8, %lo(type_3230885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306664:
	mov	%r8, %r9
code_3306656:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306665:
	mov	%r8, %r9
code_3306657:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306658
	nop
code_3306659:
	call	GCFromML ! delay slot empty
	nop
needgc_3306658:
	! allocating 2-record
	sethi	%hi(gctag_3200569), %r8
	ld	[%r8+%lo(gctag_3200569)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3306663:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263161,(.-Normalize_anonfun_code_3263161)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306664
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000006
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306665
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3306658
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3230885
		! -------- label,sizes,reg
	.long code_3306666
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000006
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3263172
 ! arguments : [$3263174,$8] [$3263175,$9] [$3232136,$10] [$3232137,$11] 
 ! results    : [$3293139,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263172:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306687
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3306687:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3306668:
funtop_3293096:
	ld	[%r8], %r9
	ld	[%r8+4], %r10
	ld	[%r8+8], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306686:
	mov	%r8, %r12
code_3306669:
	! done making normal call
	sethi	%hi(type_3230885), %r8
	or	%r8, %lo(type_3230885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3230885), %r8
	or	%r8, %lo(type_3230885), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306684:
	mov	%r8, %r9
code_3306676:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306685:
	mov	%r8, %r9
code_3306677:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306678
	nop
code_3306679:
	call	GCFromML ! delay slot empty
	nop
needgc_3306678:
	! allocating 2-record
	sethi	%hi(gctag_3200569), %r8
	ld	[%r8+%lo(gctag_3200569)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3306683:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263172,(.-Normalize_anonfun_code_3263172)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306684
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000006
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306685
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3306678
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3230885
		! -------- label,sizes,reg
	.long code_3306686
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000006
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3263183
 ! arguments : [$3263185,$8] [$3263186,$9] [$3046660,$10] 
 ! results    : [$3292854,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263183:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306847
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3306847:
	st	%r15, [%sp+92]
	mov	%r9, %r11
	mov	%r10, %r9
code_3306688:
funtop_3292509:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306689
	nop
code_3306690:
	call	GCFromML ! delay slot empty
	nop
needgc_3306689:
	ld	[%r11], %r8
	ld	[%r11+4], %r20
	ld	[%r11+8], %r16
	st	%r16, [%sp+116]
	ld	[%r11+12], %r18
	ld	[%r11+16], %r13
	ld	[%r11+20], %r12
	ld	[%r11+24], %r10
	ld	[%r11+28], %r11
sumarm_3292532:
	ld	[%r9], %r19
	cmp	%r19, 0
	bne	sumarm_3292533
	nop
code_3306692:
	ld	[%r9+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+112]
	ld	[%r9+4], %r12
sumarm_3292546:
	ld	[%r12], %r9
	cmp	%r9, 0
	bne	sumarm_3292547
	nop
code_3306693:
	ld	[%r12+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	ld	[%r9+4], %r16
	st	%r16, [%sp+104]
	ld	[%r9+8], %r16
	st	%r16, [%sp+108]
	! allocating 2-record
	or	%r0, 17, %r9
	st	%r9, [%r4]
	or	%r0, 13, %r9
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r8], %r13
	ld	[%r8+4], %r12
	ld	[%r8+8], %r9
	jmpl	%r13, %r15
	mov	%r12, %r8
code_3306828:
	mov	%r8, %r9
code_3306694:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3306829:
code_3306695:
	! done making normal call
	add	%r4, 132, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306696
	nop
code_3306697:
	call	GCFromML ! delay slot empty
	nop
needgc_3306696:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 3-record
	sethi	%hi(gctag_3199991), %r8
	ld	[%r8+%lo(gctag_3199991)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r9
	ld	[%r9+%lo(gctag_3197820)], %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r9
	ld	[%r9+%lo(gctag_3197849)], %r9
	st	%r9, [%r4]
	or	%r0, 1, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 7, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 3, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r9, %r10
	! allocating 3-record
	sethi	%hi(gctag_3200076), %r9
	ld	[%r9+%lo(gctag_3200076)], %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3292543 ! delay slot empty
	nop
sumarm_3292547:
	ld	[%r12], %r9
	cmp	%r9, 1
	bne	sumarm_3292642
	nop
code_3306704:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3306830:
	mov	%r8, %r12
code_3306707:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306831:
	mov	%r8, %r9
code_3306714:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306832:
code_3306715:
	! done making normal call
	add	%r4, 88, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306716
	nop
code_3306717:
	call	GCFromML ! delay slot empty
	nop
needgc_3306716:
	! allocating 2-record
	sethi	%hi(gctag_3198680), %r9
	ld	[%r9+%lo(gctag_3198680)], %r9
	st	%r9, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 1, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r12
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 17, %r11
	sethi	%hi(type_3193062), %r9
	or	%r9, %lo(type_3193062), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3306722
	nop
code_3306723:
	or	%r0, 0, %r9
cmpui_3306722:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 2-record
	st	%r11, [%r4]
	or	%r0, 3, %r9
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 3-record
	sethi	%hi(gctag_3200076), %r8
	ld	[%r8+%lo(gctag_3200076)], %r8
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3292543 ! delay slot empty
	nop
sumarm_3292642:
	ld	[%r12+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	! allocating 2-record
	or	%r0, 17, %r9
	st	%r9, [%r4]
	or	%r0, 13, %r9
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+108]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r8], %r13
	ld	[%r8+4], %r12
	ld	[%r8+8], %r9
	jmpl	%r13, %r15
	mov	%r12, %r8
code_3306845:
	mov	%r8, %r9
code_3306726:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+104], %r11
code_3306833:
code_3306727:
	! done making normal call
	add	%r4, 132, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306728
	nop
code_3306729:
	call	GCFromML ! delay slot empty
	nop
needgc_3306728:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 3-record
	sethi	%hi(gctag_3199991), %r8
	ld	[%r8+%lo(gctag_3199991)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r9
	ld	[%r9+%lo(gctag_3197820)], %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r9
	ld	[%r9+%lo(gctag_3197849)], %r9
	st	%r9, [%r4]
	or	%r0, 1, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	ld	[%sp+108], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 7, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 3, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r9, %r10
	! allocating 3-record
	sethi	%hi(gctag_3200076), %r9
	ld	[%r9+%lo(gctag_3200076)], %r9
	st	%r9, [%r4]
	st	%r8, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3292543 ! delay slot empty
	nop
sumarm_3292716:
after_sum_3292543:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	ld	[%r8+8], %r10
	! allocating 2-record
	sethi	%hi(gctag_3200246), %r8
	ld	[%r8+%lo(gctag_3200246)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3197419), %r8
	ld	[%r8+%lo(gctag_3197419)], %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(_3200259), %r8
	or	%r8, %lo(_3200259), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3306827:
code_3306740:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306741
	nop
code_3306742:
	call	GCFromML ! delay slot empty
	nop
needgc_3306741:
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3200309), %r8
	ld	[%r8+%lo(gctag_3200309)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3292529 ! delay slot empty
	nop
sumarm_3292533:
	ld	[%r9], %r19
	cmp	%r19, 1
	bne	sumarm_3292855
	nop
code_3306746:
	ld	[%r9+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8+8], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r20], %r12
	ld	[%r20+4], %r8
	jmpl	%r12, %r15
	ld	[%r20+8], %r9
code_3306834:
	mov	%r8, %r12
code_3306747:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3306835:
	mov	%r8, %r9
code_3306754:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306836:
	mov	%r8, %r9
code_3306755:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306756
	nop
code_3306757:
	call	GCFromML ! delay slot empty
	nop
needgc_3306756:
	! allocating 3-record
	sethi	%hi(gctag_3200325), %r8
	ld	[%r8+%lo(gctag_3200325)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3200309), %r8
	ld	[%r8+%lo(gctag_3200309)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3292529 ! delay slot empty
	nop
sumarm_3292855:
	ld	[%r9], %r19
	cmp	%r19, 2
	bne	sumarm_3292916
	nop
code_3306762:
	ld	[%r9+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3200454), %r8
	or	%r8, %lo(_3200454), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	mov	%r18, %r10
code_3306837:
	mov	%r8, %r12
code_3306765:
	! done making normal call
	sethi	%hi(type_3249900), %r8
	or	%r8, %lo(type_3249900), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3249900), %r8
	or	%r8, %lo(type_3249900), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306838:
	mov	%r8, %r9
code_3306772:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3306839:
	mov	%r8, %r9
code_3306773:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306774
	nop
code_3306775:
	call	GCFromML ! delay slot empty
	nop
needgc_3306774:
	! allocating 2-record
	sethi	%hi(gctag_3200519), %r8
	ld	[%r8+%lo(gctag_3200519)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3200309), %r8
	ld	[%r8+%lo(gctag_3200309)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3292529 ! delay slot empty
	nop
sumarm_3292916:
	ld	[%r9], %r19
	cmp	%r19, 3
	bne	sumarm_3292976
	nop
code_3306780:
	sethi	%hi(type_3199943), %r8
	or	%r8, %lo(type_3199943), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r8
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3200554), %r8
	or	%r8, %lo(_3200554), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	mov	%r13, %r10
code_3306840:
	mov	%r8, %r12
code_3306785:
	! done making normal call
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306841:
	mov	%r8, %r9
code_3306792:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306842:
	mov	%r8, %r11
code_3306793:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306794
	nop
code_3306795:
	call	GCFromML ! delay slot empty
	nop
needgc_3306794:
	or	%r0, 17, %r10
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306799
	nop
code_3306800:
	or	%r0, 0, %r8
cmpui_3306799:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3200309), %r8
	ld	[%r8+%lo(gctag_3200309)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3292529 ! delay slot empty
	nop
sumarm_3292976:
	sethi	%hi(type_3199943), %r8
	or	%r8, %lo(type_3199943), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r8
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3200554), %r8
	or	%r8, %lo(_3200554), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	mov	%r12, %r10
code_3306846:
	mov	%r8, %r12
code_3306807:
	! done making normal call
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306843:
	mov	%r8, %r9
code_3306814:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3306844:
	mov	%r8, %r11
code_3306815:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306816
	nop
code_3306817:
	call	GCFromML ! delay slot empty
	nop
needgc_3306816:
	or	%r0, 17, %r10
	sethi	%hi(type_3249764), %r8
	or	%r8, %lo(type_3249764), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3306821
	nop
code_3306822:
	or	%r0, 0, %r8
cmpui_3306821:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 4, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3200309), %r8
	ld	[%r8+%lo(gctag_3200309)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3292529 ! delay slot empty
	nop
sumarm_3293036:
after_sum_3292529:
code_3306826:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263183,(.-Normalize_anonfun_code_3263183)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306827
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3306689
	.word 0x00200009
	.word 0x00170000
	.word 0x00000800
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000001
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3306828
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07f10000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long code_3306829
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07010000
		! worddata
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long needgc_3306696
	.word 0x00200009
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07010000
		! worddata
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long code_3306830
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long code_3306831
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long code_3306832
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07000000
		! worddata
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long needgc_3306716
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x07000000
		! worddata
	.word 0x80000000
	.long type_3200242
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3306833
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07400000
		! worddata
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long needgc_3306728
	.word 0x00200009
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07400000
		! worddata
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long needgc_3306741
	.word 0x00200007
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3306834
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04330000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3196844
		! -------- label,sizes,reg
	.long code_3306835
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04330000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3196844
		! -------- label,sizes,reg
	.long code_3306836
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04300000
		! worddata
	.word 0x80000000
	.long type_3196844
		! -------- label,sizes,reg
	.long needgc_3306756
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x04300000
		! worddata
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3306837
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x040f0000
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long reify_3249931
		! -------- label,sizes,reg
	.long code_3306838
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x040f0000
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long reify_3249931
		! -------- label,sizes,reg
	.long code_3306839
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long needgc_3306774
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long type_3193138
	.word 0x80000000
	.long type_3249900
		! -------- label,sizes,reg
	.long code_3306840
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long reify_3249794
		! -------- label,sizes,reg
	.long code_3306841
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long reify_3249794
		! -------- label,sizes,reg
	.long code_3306842
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04000000
		! -------- label,sizes,reg
	.long needgc_3306794
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x04000000
		! worddata
	.word 0x80000000
	.long type_3249764
		! -------- label,sizes,reg
	.long code_3306843
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long reify_3249794
		! -------- label,sizes,reg
	.long code_3306844
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04000000
		! -------- label,sizes,reg
	.long needgc_3306816
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x04000000
		! worddata
	.word 0x80000000
	.long type_3249764
		! -------- label,sizes,reg
	.long code_3306845
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x077c0000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3200242
		! -------- label,sizes,reg
	.long code_3306846
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x04030000
		! worddata
	.word 0x80000000
	.long reify_3249794
	.text
	.align 8
	.global Normalize_bnd_normalizePRIME_code_3263083
 ! arguments : [$3263085,$8] [$3263086,$9] [$3231568,$10] [$3231569,$11] 
 ! results    : [$3292508,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_bnd_normalizePRIME_code_3263083:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3306899
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3306899:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	mov	%r10, %r20
	mov	%r11, %r19
code_3306848:
funtop_3292365:
	add	%r4, 160, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306849
	nop
code_3306850:
	call	GCFromML ! delay slot empty
	nop
needgc_3306849:
	ld	[%r8], %r9
	ld	[%r8+4], %r18
	ld	[%r8+8], %r13
	! allocating 2-record
	sethi	%hi(record_gctag_3225587), %r8
	ld	[%r8+%lo(record_gctag_3225587)], %r8
	st	%r8, [%r4]
	st	%r20, [%r4+4]
	st	%r19, [%r4+8]
	add	%r4, 4, %r12
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 1 closures
	or	%r0, 281, %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306855
	nop
code_3306856:
	or	%r0, 0, %r10
cmpui_3306855:
	sll	%r10, 9, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306859
	nop
code_3306860:
	or	%r0, 0, %r10
cmpui_3306859:
	sll	%r10, 10, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 3-record
	st	%r8, [%r4]
	st	%r13, [%r4+4]
	st	%r20, [%r4+8]
	st	%r19, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263150), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263150), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r11
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	or	%r0, 281, %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r21
	ld	[%r2+804], %r10
	add	%r21, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306864
	nop
code_3306865:
	or	%r0, 0, %r10
cmpui_3306864:
	sll	%r10, 9, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r21
	ld	[%r2+804], %r10
	add	%r21, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3306868
	nop
code_3306869:
	or	%r0, 0, %r10
cmpui_3306868:
	sll	%r10, 10, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 3-record
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r20, [%r4+8]
	st	%r19, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263161), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263161), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	or	%r0, 281, %r8
	sethi	%hi(type_3193048), %r21
	or	%r21, %lo(type_3193048), %r22
	ld	[%r2+804], %r21
	add	%r22, %r21, %r21
	ld	[%r21], %r21
	cmp	%r21, 3
	or	%r0, 1, %r21
	bgu	cmpui_3306873
	nop
code_3306874:
	or	%r0, 0, %r21
cmpui_3306873:
	sll	%r21, 9, %r21
	add	%r21, %r0, %r21
	or	%r21, %r8, %r8
	sethi	%hi(type_3193047), %r21
	or	%r21, %lo(type_3193047), %r22
	ld	[%r2+804], %r21
	add	%r22, %r21, %r21
	ld	[%r21], %r21
	cmp	%r21, 3
	or	%r0, 1, %r21
	bgu	cmpui_3306877
	nop
code_3306878:
	or	%r0, 0, %r21
cmpui_3306877:
	sll	%r21, 10, %r21
	add	%r21, %r0, %r21
	or	%r21, %r8, %r8
	! allocating 3-record
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r20, [%r4+8]
	st	%r19, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263172), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263172), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! allocating 1 closures
	sethi	%hi(16193), %r8
	or	%r8, %lo(16193), %r8
	sethi	%hi(type_3193048), %r21
	or	%r21, %lo(type_3193048), %r22
	ld	[%r2+804], %r21
	add	%r22, %r21, %r21
	ld	[%r21], %r21
	cmp	%r21, 3
	or	%r0, 1, %r21
	bgu	cmpui_3306882
	nop
code_3306883:
	or	%r0, 0, %r21
cmpui_3306882:
	sll	%r21, 14, %r21
	add	%r21, %r0, %r21
	or	%r21, %r8, %r8
	sethi	%hi(type_3193047), %r21
	or	%r21, %lo(type_3193047), %r22
	ld	[%r2+804], %r21
	add	%r22, %r21, %r21
	ld	[%r21], %r21
	cmp	%r21, 3
	or	%r0, 1, %r21
	bgu	cmpui_3306886
	nop
code_3306887:
	or	%r0, 0, %r21
cmpui_3306886:
	sll	%r21, 15, %r21
	add	%r21, %r0, %r21
	or	%r21, %r8, %r8
	! allocating 8-record
	st	%r8, [%r4]
	st	%r18, [%r4+4]
	st	%r13, [%r4+8]
	st	%r12, [%r4+12]
	st	%r11, [%r4+16]
	st	%r10, [%r4+20]
	st	%r9, [%r4+24]
	st	%r20, [%r4+28]
	st	%r19, [%r4+32]
	add	%r4, 4, %r9
	add	%r4, 36, %r4
	! done allocating 8 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263183), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263183), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label bnd_TYC
	ld	[%r8], %r18
	sethi	%hi(type_3231448), %r8
	or	%r8, %lo(type_3231448), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3306898:
code_3306895:
	! done making normal call
code_3306897:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_bnd_normalizePRIME_code_3263083,(.-Normalize_bnd_normalizePRIME_code_3263083)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306898
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3306849
	.word 0x0018000b
	.word 0x00170000
	.word 0x00000100
	.word 0x00180000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3263207
 ! arguments : [$3263209,$8] [$3263210,$9] [$3046963,$10] 
 ! results    : [$3292173,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263207:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307018
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3307018:
	st	%r15, [%sp+92]
	st	%r10, [%sp+112]
code_3306900:
funtop_3292113:
	ld	[%r9], %r16
	st	%r16, [%sp+108]
	ld	[%r9+4], %r16
	st	%r16, [%sp+96]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9+12], %r16
	st	%r16, [%sp+100]
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(debug_3194017), %r8
	or	%r8, %lo(debug_3194017), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3307014:
code_3306906:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3306907
	nop
code_3306908:
	call	GCFromML ! delay slot empty
	nop
needgc_3306907:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3292139
	nop
zero_case_3292138:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3307017:
	mov	%r8, %r12
code_3306911:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307001:
	mov	%r8, %r9
code_3306918:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3306919:
	! done making tail call
	ba	after_zeroone_3292140 ! delay slot empty
	nop
one_case_3292139:
	! allocating 2-record
	sethi	%hi(gctag_3200695), %r8
	ld	[%r8+%lo(gctag_3200695)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(push_3044515), %r8
	or	%r8, %lo(push_3044515), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307015:
code_3306923:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(show_calls_3194020), %r8
	or	%r8, %lo(show_calls_3194020), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3307003:
code_3306929:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3292209
	nop
zero_case_3292208:
	ba	after_zeroone_3292210
	or	%r0, 256, %r8
one_case_3292209:
	sethi	%hi(string_3266306), %r8
	or	%r8, %lo(string_3266306), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307016:
code_3306935:
	! done making normal call
	! making closure call
	sethi	%hi(_3223158), %r8
	or	%r8, %lo(_3223158), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307004:
code_3306938:
	! done making normal call
	sethi	%hi(string_3266126), %r8
	or	%r8, %lo(string_3266126), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307005:
code_3306942:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307006:
code_3306945:
	! done making normal call
	sethi	%hi(string_3266165), %r8
	or	%r8, %lo(string_3266165), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307007:
code_3306949:
	! done making normal call
	! making closure call
	sethi	%hi(_3223122), %r8
	or	%r8, %lo(_3223122), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307008:
code_3306952:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307009:
code_3306956:
	! done making normal call
after_zeroone_3292210:
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3307000:
	mov	%r8, %r12
code_3306957:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307010:
	mov	%r8, %r9
code_3306964:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307011:
	st	%r8, [%sp+96]
code_3306965:
	! done making normal call
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	subcc	%r8, 1, %r12
	bvs,pn	%icc,localOverflowFromML
	nop
code_3306968:
	ld	[%r2+792], %r8
	ld	[%r2+796], %r9
	add	%r8, 12, %r8
	cmp	%r8, %r9
	bleu	afterMutateCheck_3306972
	nop
code_3306973:
	sub	%r4, 12, %r16
	call	GCFromML ! delay slot empty
	nop
afterMutateCheck_3306972:
	sethi	%hi(depth_3194044), %r8
	or	%r8, %lo(depth_3194044), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	ld	[%r2+792], %r10
	mov	%r11, %r9
	or	%r0, 0, %r8
	st	%r9, [%r10]
	st	%r8, [%r10+4]
	add	%r10, 12, %r8
	st	%r8, [%r2+792]
	st	%r12, [%r11]
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3306999:
	mov	%r8, %r10
code_3306987:
	! done making normal call
	! making closure call
	sethi	%hi(_3223092), %r8
	or	%r8, %lo(_3223092), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307012:
	mov	%r8, %r13
code_3306990:
	! done making normal call
	sethi	%hi(type_3256487), %r8
	or	%r8, %lo(type_3256487), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r11
	sethi	%hi(stack_3194043), %r8
	or	%r8, %lo(stack_3194043), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polyUpdate_INT), %r8
	ld	[%r8+%lo(polyUpdate_INT)], %r12
	mov	%r11, %r8
	jmpl	%r12, %r15
	mov	%r13, %r11
code_3307013:
code_3306996:
	! done making normal call
	ld	[%sp+96], %r8
after_zeroone_3292140:
code_3306998:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263207,(.-Normalize_anonfun_code_3263207)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3306999
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307000
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3306907
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3307001
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307003
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307004
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307005
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307006
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307007
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307008
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307009
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307010
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307011
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long afterMutateCheck_3306972
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307012
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307013
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307014
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037d0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307015
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307016
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x037c0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307017
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.text
	.align 8
	.global Normalize_exp_normalizePRIME_code_3263088
 ! arguments : [$3263090,$8] [$3263091,$9] [$3232252,$10] [$3232253,$11] 
 ! results    : [$3292112,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_exp_normalizePRIME_code_3263088:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307043
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307043:
	st	%r15, [%sp+92]
code_3307019:
funtop_3292057:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307020
	nop
code_3307021:
	call	GCFromML ! delay slot empty
	nop
needgc_3307020:
	! allocating 2-record
	sethi	%hi(record_gctag_3226181), %r8
	ld	[%r8+%lo(record_gctag_3226181)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 1 closures
	or	%r0, 801, %r18
	sethi	%hi(type_3193048), %r12
	or	%r12, %lo(type_3193048), %r13
	ld	[%r2+804], %r12
	add	%r13, %r12, %r12
	ld	[%r12], %r12
	cmp	%r12, 3
	or	%r0, 1, %r12
	bgu	cmpui_3307026
	nop
code_3307027:
	or	%r0, 0, %r12
cmpui_3307026:
	sll	%r12, 10, %r12
	add	%r12, %r0, %r12
	or	%r12, %r18, %r18
	sethi	%hi(type_3193047), %r12
	or	%r12, %lo(type_3193047), %r13
	ld	[%r2+804], %r12
	add	%r13, %r12, %r12
	ld	[%r12], %r12
	cmp	%r12, 3
	or	%r0, 1, %r12
	bgu	cmpui_3307030
	nop
code_3307031:
	or	%r0, 0, %r12
cmpui_3307030:
	sll	%r12, 11, %r12
	add	%r12, %r0, %r12
	or	%r12, %r18, %r18
	! allocating 4-record
	st	%r18, [%r4]
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	st	%r11, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263207), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263207), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label exp_TYC
	ld	[%r8+16], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307042:
code_3307039:
	! done making normal call
code_3307041:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_exp_normalizePRIME_code_3263088,(.-Normalize_exp_normalizePRIME_code_3263088)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307042
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3307020
	.word 0x0018000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_anonfun_code_3263221
 ! arguments : [$3263223,$8] [$3263224,$9] [$3046994,$10] 
 ! results    : [$3291472,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263221:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 144, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307329
	nop
	add	%sp, 144, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 144, %sp
code_3307329:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	mov	%r10, %r12
code_3307044:
funtop_3291282:
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	ld	[%r8+12], %r16
	st	%r16, [%sp+132]
	ld	[%r8+16], %r16
	st	%r16, [%sp+128]
	ld	[%r8+20], %r16
	st	%r16, [%sp+124]
sumarm_3291301:
	ld	[%r12], %r8
	cmp	%r8, 0
	bne	sumarm_3291302
	nop
code_3307045:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+120]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+12], %r16
	st	%r16, [%sp+116]
	ld	[%r8+16], %r16
	st	%r16, [%sp+112]
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307277:
	st	%r8, [%sp+108]
code_3307046:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	ld	[%r11+8], %r11
	jmpl	%r13, %r15
	ld	[%sp+108], %r12
code_3307278:
	mov	%r8, %r9
code_3307053:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307279:
	st	%r8, [%sp+104]
code_3307054:
	! done making normal call
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307280:
	mov	%r8, %r10
code_3307057:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307281:
	mov	%r8, %r12
code_3307060:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307282:
	mov	%r8, %r9
code_3307067:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307283:
	st	%r8, [%sp+100]
code_3307068:
	! done making normal call
	! making closure call
	sethi	%hi(_3200783), %r8
	or	%r8, %lo(_3200783), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3307284:
	mov	%r8, %r12
code_3307071:
	! done making normal call
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307285:
	mov	%r8, %r9
code_3307078:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3307286:
	st	%r8, [%sp+96]
code_3307079:
	! done making normal call
	! making closure call
	sethi	%hi(_3200783), %r8
	or	%r8, %lo(_3200783), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3307287:
	mov	%r8, %r12
code_3307082:
	! done making normal call
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307288:
	mov	%r8, %r9
code_3307089:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307289:
	mov	%r8, %r9
code_3307090:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307091
	nop
code_3307092:
	call	GCFromML ! delay slot empty
	nop
needgc_3307091:
	! allocating 5-record
	sethi	%hi(gctag_3200816), %r8
	ld	[%r8+%lo(gctag_3200816)], %r8
	st	%r8, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	st	%r9, [%r4+20]
	add	%r4, 4, %r9
	add	%r4, 24, %r4
	! done allocating 5 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291302:
	ld	[%r12], %r8
	cmp	%r8, 2
	bne	sumarm_3291473
	nop
code_3307096:
	sethi	%hi(type_3200748), %r8
	or	%r8, %lo(type_3200748), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r12+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r11], %r12
	ld	[%r11+4], %r8
	ld	[%r11+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307290:
	mov	%r8, %r12
code_3307099:
	! done making normal call
	sethi	%hi(type_3230628), %r8
	or	%r8, %lo(type_3230628), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3230628), %r8
	or	%r8, %lo(type_3230628), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307291:
	mov	%r8, %r9
code_3307106:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307292:
	mov	%r8, %r11
code_3307107:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307108
	nop
code_3307109:
	call	GCFromML ! delay slot empty
	nop
needgc_3307108:
	or	%r0, 17, %r10
	sethi	%hi(type_3230628), %r8
	or	%r8, %lo(type_3230628), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307113
	nop
code_3307114:
	or	%r0, 0, %r8
cmpui_3307113:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291473:
	ld	[%r12], %r8
	cmp	%r8, 3
	bne	sumarm_3291525
	nop
code_3307116:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307293:
	st	%r8, [%sp+100]
code_3307117:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3307294:
	mov	%r8, %r9
code_3307124:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307295:
	st	%r8, [%sp+96]
code_3307125:
	! done making normal call
	! making closure call
	sethi	%hi(_3200783), %r8
	or	%r8, %lo(_3200783), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307296:
	mov	%r8, %r12
code_3307128:
	! done making normal call
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307297:
	mov	%r8, %r9
code_3307135:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307298:
	mov	%r8, %r9
code_3307136:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307137
	nop
code_3307138:
	call	GCFromML ! delay slot empty
	nop
needgc_3307137:
	! allocating 2-record
	sethi	%hi(gctag_3200868), %r8
	ld	[%r8+%lo(gctag_3200868)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291525:
	ld	[%r12], %r8
	cmp	%r8, 5
	bne	sumarm_3291610
	nop
code_3307142:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+112]
	ld	[%r8+12], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307299:
	mov	%r8, %r12
code_3307143:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307300:
	st	%r8, [%sp+96]
code_3307150:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307301:
	st	%r8, [%sp+100]
code_3307151:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307302:
	st	%r8, [%sp+96]
code_3307152:
	! done making normal call
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307303:
	mov	%r8, %r12
code_3307155:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307304:
	mov	%r8, %r9
code_3307162:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3307305:
	mov	%r8, %r9
code_3307163:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307164
	nop
code_3307165:
	call	GCFromML ! delay slot empty
	nop
needgc_3307164:
	! allocating 4-record
	sethi	%hi(gctag_3200904), %r8
	ld	[%r8+%lo(gctag_3200904)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+112], %r17
	st	%r17, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291610:
	ld	[%r12], %r8
	cmp	%r8, 6
	bne	sumarm_3291708
	nop
code_3307169:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307306:
	mov	%r8, %r12
code_3307170:
	! done making normal call
	sethi	%hi(type_3231391), %r8
	or	%r8, %lo(type_3231391), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3231396), %r8
	or	%r8, %lo(type_3231396), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307307:
	mov	%r8, %r9
code_3307177:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307308:
code_3307178:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	jmpl	%r12, %r15
	ld	[%r17+8], %r9
code_3307309:
	mov	%r8, %r12
code_3307179:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307310:
	mov	%r8, %r9
code_3307186:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307311:
	mov	%r8, %r9
code_3307187:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307188
	nop
code_3307189:
	call	GCFromML ! delay slot empty
	nop
needgc_3307188:
	! allocating 3-record
	sethi	%hi(gctag_3200935), %r8
	ld	[%r8+%lo(gctag_3200935)], %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 6, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291708:
	ld	[%r12], %r8
	cmp	%r8, 7
	bne	sumarm_3291803
	nop
code_3307193:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8+8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+12], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307312:
	mov	%r8, %r10
code_3307196:
	! done making normal call
	! making closure call
	sethi	%hi(_3198144), %r8
	or	%r8, %lo(_3198144), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307313:
	mov	%r8, %r12
code_3307199:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3307314:
	mov	%r8, %r9
code_3307206:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307315:
	st	%r8, [%sp+96]
code_3307207:
	! done making normal call
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307316:
	mov	%r8, %r10
code_3307208:
	! done making normal call
	! making closure call
	sethi	%hi(_3200783), %r8
	or	%r8, %lo(_3200783), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307317:
	mov	%r8, %r12
code_3307211:
	! done making normal call
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3249521), %r8
	or	%r8, %lo(type_3249521), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307318:
	mov	%r8, %r9
code_3307218:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307319:
	mov	%r8, %r9
code_3307219:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307220
	nop
code_3307221:
	call	GCFromML ! delay slot empty
	nop
needgc_3307220:
	! allocating 4-record
	sethi	%hi(gctag_3200997), %r8
	ld	[%r8+%lo(gctag_3200997)], %r8
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	st	%r9, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291803:
	ld	[%r12], %r8
	cmp	%r8, 8
	bne	sumarm_3291913
	nop
code_3307225:
	ld	[%r12+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307320:
	mov	%r8, %r12
code_3307228:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307321:
	mov	%r8, %r9
code_3307235:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307322:
	st	%r8, [%sp+96]
code_3307236:
	! done making normal call
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307323:
	mov	%r8, %r12
code_3307237:
	! done making normal call
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307324:
	mov	%r8, %r9
code_3307244:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307325:
	mov	%r8, %r9
code_3307245:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307246
	nop
code_3307247:
	call	GCFromML ! delay slot empty
	nop
needgc_3307246:
	! allocating 2-record
	sethi	%hi(gctag_3201026), %r8
	ld	[%r8+%lo(gctag_3201026)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 8, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291913:
	ld	[%r12], %r8
	cmp	%r8, 9
	bne	sumarm_3291999
	nop
code_3307251:
	sethi	%hi(type_3200748), %r8
	or	%r8, %lo(type_3200748), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r12+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+128], %r10
	jmpl	%r12, %r15
	ld	[%sp+124], %r11
code_3307326:
	mov	%r8, %r12
code_3307254:
	! done making normal call
	sethi	%hi(type_3230865), %r8
	or	%r8, %lo(type_3230865), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3230865), %r8
	or	%r8, %lo(type_3230865), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307327:
	mov	%r8, %r9
code_3307261:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307328:
	mov	%r8, %r11
code_3307262:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307263
	nop
code_3307264:
	call	GCFromML ! delay slot empty
	nop
needgc_3307263:
	or	%r0, 17, %r10
	sethi	%hi(type_3230865), %r8
	or	%r8, %lo(type_3230865), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307268
	nop
code_3307269:
	or	%r0, 0, %r8
cmpui_3307268:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3291298 ! delay slot empty
	nop
sumarm_3291999:
	ld	[%r12], %r8
	cmp	%r8, 11
	bne	sumarm_3292051
	nop
code_3307271:
	ba	after_sum_3291298
	mov	%r12, %r8
sumarm_3292051:
nomatch_sum_3291299:
	sethi	%hi(record_3270494), %r8
	or	%r8, %lo(record_3270494), %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3291298:
code_3307276:
	ld	[%sp+92], %r15
	retl
	add	%sp, 144, %sp
	.size Normalize_anonfun_code_3263221,(.-Normalize_anonfun_code_3263221)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307277
	.word 0x00240016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff0f0000
	.word 0x00000003
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307278
	.word 0x00240016
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff4f0000
	.word 0x00000003
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307279
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xff4c0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307280
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f7c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307281
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f7c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307282
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f7c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307283
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f700000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307284
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f7c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307285
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f7c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307286
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x337c0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307287
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x333f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3249521
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307288
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x333f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3249521
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3307289
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x303f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3249521
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long needgc_3307091
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x303f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3249521
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3249521
		! -------- label,sizes,reg
	.long code_3307290
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3249421
		! -------- label,sizes,reg
	.long code_3307291
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3249421
		! -------- label,sizes,reg
	.long code_3307292
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3307108
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3230628
		! -------- label,sizes,reg
	.long code_3307293
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long reify_3249615
		! -------- label,sizes,reg
	.long code_3307294
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00370000
	.word 0x00000000
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long reify_3249615
		! -------- label,sizes,reg
	.long code_3307295
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00340000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3249615
		! -------- label,sizes,reg
	.long code_3307296
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
		! -------- label,sizes,reg
	.long code_3307297
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long reify_3249615
		! -------- label,sizes,reg
	.long code_3307298
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long needgc_3307137
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3249521
		! -------- label,sizes,reg
	.long code_3307299
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0fc0000
	.word 0x00000003
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307300
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0fc0000
	.word 0x00000003
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307301
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0f10000
	.word 0x00000003
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307302
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0cc0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307303
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193068
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307304
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193068
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307305
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long needgc_3307164
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193068
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3307306
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000004
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3307307
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000004
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3307308
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
	.word 0x00000004
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3307309
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3307310
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long code_3307311
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3197841
		! -------- label,sizes,reg
	.long needgc_3307188
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00330000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307312
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0ff0000
	.word 0x00000007
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307313
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0ff0000
	.word 0x00000007
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307314
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0ff0000
	.word 0x00000007
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307315
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc0fc0000
	.word 0x00000007
		! worddata
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307316
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00ff0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
		! -------- label,sizes,reg
	.long code_3307317
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00ff0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
		! -------- label,sizes,reg
	.long code_3307318
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00ff0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long reify_3249615
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
		! -------- label,sizes,reg
	.long code_3307319
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
		! -------- label,sizes,reg
	.long needgc_3307220
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00f30000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long reify_3249191
	.word 0x80000001
	.long type_3200983
	.word 0x80000000
	.long type_3249521
		! -------- label,sizes,reg
	.long code_3307320
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc00f0000
	.word 0x00000007
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307321
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc00f0000
	.word 0x00000007
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307322
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xc00c0000
	.word 0x00000007
		! worddata
	.word 0x80000005
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307323
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307324
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000005
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307325
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long needgc_3307246
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193068
		! -------- label,sizes,reg
	.long code_3307326
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000008
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307327
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000008
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3307328
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3307263
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3230865
	.text
	.align 8
	.global Normalize_exp_normalize_code_3263093
 ! arguments : [$3263095,$8] [$3263096,$9] [$3232350,$10] [$3232351,$11] 
 ! results    : [$3291281,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_exp_normalize_code_3263093:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307353
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307353:
	st	%r15, [%sp+92]
	mov	%r10, %r18
	mov	%r11, %r13
code_3307330:
funtop_3291222:
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307331
	nop
code_3307332:
	call	GCFromML ! delay slot empty
	nop
needgc_3307331:
	ld	[%r9], %r12
	ld	[%r9+4], %r11
	ld	[%r9+8], %r10
	ld	[%r9+12], %r9
	! allocating 1 closures
	or	%r0, 3889, %r8
	sethi	%hi(type_3193048), %r19
	or	%r19, %lo(type_3193048), %r20
	ld	[%r2+804], %r19
	add	%r20, %r19, %r19
	ld	[%r19], %r19
	cmp	%r19, 3
	or	%r0, 1, %r19
	bgu	cmpui_3307336
	nop
code_3307337:
	or	%r0, 0, %r19
cmpui_3307336:
	sll	%r19, 12, %r19
	add	%r19, %r0, %r19
	or	%r19, %r8, %r8
	sethi	%hi(type_3193047), %r19
	or	%r19, %lo(type_3193047), %r20
	ld	[%r2+804], %r19
	add	%r20, %r19, %r19
	ld	[%r19], %r19
	cmp	%r19, 3
	or	%r0, 1, %r19
	bgu	cmpui_3307340
	nop
code_3307341:
	or	%r0, 0, %r19
cmpui_3307340:
	sll	%r19, 13, %r19
	add	%r19, %r0, %r19
	or	%r19, %r8, %r8
	! allocating 6-record
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	st	%r11, [%r4+8]
	st	%r10, [%r4+12]
	st	%r9, [%r4+16]
	st	%r18, [%r4+20]
	st	%r13, [%r4+24]
	add	%r4, 4, %r9
	add	%r4, 28, %r4
	! done allocating 6 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263221), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263221), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label exp_TYC
	ld	[%r8+16], %r18
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307352:
code_3307349:
	! done making normal call
code_3307351:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_exp_normalize_code_3263093,(.-Normalize_exp_normalize_code_3263093)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307352
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3307331
	.word 0x0018000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00042000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_kind_normalize_code_3263242
 ! arguments : [$3263244,$8] [$3263245,$9] [$3047352,$10] 
 ! results    : [$3291221,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_kind_normalize_code_3263242:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307365
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307365:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3307354:
funtop_3291201:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307364:
	mov	%r8, %r11
code_3307357:
	! done making normal call
	! making closure call
	sethi	%hi(_3201402), %r8
	or	%r8, %lo(_3201402), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 112, %sp
code_3307360:
	! done making tail call
code_3307362:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_kind_normalize_code_3263242,(.-Normalize_kind_normalize_code_3263242)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307364
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_con_normalize_code_3263247
 ! arguments : [$3263249,$8] [$3263250,$9] [$3047363,$10] 
 ! results    : [$3291200,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_normalize_code_3263247:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307377
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307377:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3307366:
funtop_3291180:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307376:
	mov	%r8, %r11
code_3307369:
	! done making normal call
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 112, %sp
code_3307372:
	! done making tail call
code_3307374:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_con_normalize_code_3263247,(.-Normalize_con_normalize_code_3263247)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307376
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_exp_normalize_code_3263252
 ! arguments : [$3263254,$8] [$3263255,$9] [$3047374,$10] 
 ! results    : [$3291179,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_exp_normalize_code_3263252:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307388
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307388:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3307378:
funtop_3291161:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307387:
	mov	%r8, %r11
code_3307381:
	! done making normal call
	! making closure call
	sethi	%hi(exp_normalizePRIME_3046457), %r8
	or	%r8, %lo(exp_normalizePRIME_3046457), %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 112, %sp
code_3307383:
	! done making tail call
code_3307385:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_exp_normalize_code_3263252,(.-Normalize_exp_normalize_code_3263252)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307387
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_folder_code_3263257
 ! arguments : [$3263259,$8] [$3263260,$9] [$3233301,$10] [$3233302,$11] 
 ! results    : [$3291076,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_folder_code_3263257:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307438
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3307438:
	st	%r15, [%sp+92]
code_3307389:
funtop_3290980:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307390
	nop
code_3307391:
	call	GCFromML ! delay slot empty
	nop
needgc_3307390:
	ld	[%r11], %r16
	st	%r16, [%sp+112]
	ld	[%r11+4], %r16
	st	%r16, [%sp+116]
	! allocating 2-record
	sethi	%hi(record_gctag_3225587), %r8
	ld	[%r8+%lo(record_gctag_3225587)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
sumarm_3290997:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3290998
	nop
code_3307394:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3197419), %r8
	ld	[%r8+%lo(gctag_3197419)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(_3200259), %r8
	or	%r8, %lo(_3200259), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3307432:
code_3307398:
	! done making normal call
	ld	[%r8], %r9
	ld	[%r8+4], %r8
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	ld	[%r9+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
	! making closure call
	sethi	%hi(strbindvar_r_insert_label_3201077), %r8
	or	%r8, %lo(strbindvar_r_insert_label_3201077), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r11
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3307433:
	mov	%r8, %r9
code_3307401:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307402
	nop
code_3307403:
	call	GCFromML ! delay slot empty
	nop
needgc_3307402:
	! allocating 2-record
	sethi	%hi(record_gctag_3226181), %r8
	ld	[%r8+%lo(record_gctag_3226181)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3201185), %r8
	ld	[%r8+%lo(gctag_3201185)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3201197), %r8
	ld	[%r8+%lo(gctag_3201197)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290994 ! delay slot empty
	nop
sumarm_3290998:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+12], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3199419), %r8
	or	%r8, %lo(_3199419), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	jmpl	%r12, %r15
	ld	[%sp+116], %r11
code_3307437:
	mov	%r8, %r12
code_3307411:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3307434:
	mov	%r8, %r9
code_3307418:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307435:
	st	%r8, [%sp+96]
code_3307419:
	! done making normal call
	! making closure call
	sethi	%hi(strbindvar_r_insert_label_3201077), %r8
	or	%r8, %lo(strbindvar_r_insert_label_3201077), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+112], %r10
	ld	[%sp+108], %r11
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3307436:
	mov	%r8, %r9
code_3307422:
	! done making normal call
	add	%r4, 56, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307423
	nop
code_3307424:
	call	GCFromML ! delay slot empty
	nop
needgc_3307423:
	! allocating 2-record
	sethi	%hi(record_gctag_3226181), %r8
	ld	[%r8+%lo(record_gctag_3226181)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 4-record
	sethi	%hi(gctag_3201234), %r8
	ld	[%r8+%lo(gctag_3201234)], %r8
	st	%r8, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	ld	[%sp+96], %r17
	st	%r17, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3201197), %r8
	ld	[%r8+%lo(gctag_3201197)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290994 ! delay slot empty
	nop
sumarm_3291077:
after_sum_3290994:
code_3307431:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_folder_code_3263257,(.-Normalize_folder_code_3263257)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307390
	.word 0x00200009
	.word 0x00170000
	.word 0x00000800
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3233130
		! -------- label,sizes,reg
	.long code_3307432
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3307433
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00f10000
		! worddata
	.word 0x80000000
	.long type_3196282
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307402
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00f10000
		! worddata
	.word 0x80000000
	.long type_3196282
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307434
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0f730000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307435
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0f700000
		! worddata
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307436
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c730000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307423
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x0c730000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307437
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0f730000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3196844
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_anonfun_code_3263262
 ! arguments : [$3263264,$8] [$3263265,$9] [$3047281,$10] 
 ! results    : [$3290958,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_anonfun_code_3263262:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307448
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307448:
	st	%r15, [%sp+92]
code_3307439:
funtop_3290929:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307440
	nop
code_3307441:
	call	GCFromML ! delay slot empty
	nop
needgc_3307440:
sumarm_3290936:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3290937
	nop
code_3307443:
	ld	[%r10+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 2-record
	or	%r0, 273, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290933 ! delay slot empty
	nop
sumarm_3290937:
	ld	[%r10+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 2-record
	or	%r0, 273, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290933 ! delay slot empty
	nop
sumarm_3290959:
after_sum_3290933:
code_3307447:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263262,(.-Normalize_anonfun_code_3263262)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307440
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc3c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3201352
	.text
	.align 8
	.global Normalize_export_normalizePRIME_inner_code_3263267
 ! arguments : [$3263269,$8] [$3263270,$9] [$3047279,$10] 
 ! results    : [$3290926,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_export_normalizePRIME_inner_code_3263267:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307454
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307454:
	st	%r15, [%sp+92]
code_3307449:
funtop_3290923:
	sethi	%hi(anonfun_3047280), %r8
	or	%r8, %lo(anonfun_3047280), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
code_3307453:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_export_normalizePRIME_inner_code_3263267,(.-Normalize_export_normalizePRIME_inner_code_3263267)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3263277
 ! arguments : [$3263279,$8] [$3263280,$9] [$3047304,$10] 
 ! results    : [$3290922,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263277:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307511
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3307511:
	st	%r15, [%sp+92]
code_3307455:
funtop_3290757:
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
sumarm_3290768:
	ld	[%r10+8], %r16
	st	%r16, [%sp+112]
	ld	[%r10], %r16
	st	%r16, [%sp+104]
	ld	[%r10+4], %r16
	st	%r16, [%sp+108]
	sethi	%hi(folder_3047311), %r8
	or	%r8, %lo(folder_3047311), %r10
	! making closure call
	sethi	%hi(_3201342), %r8
	or	%r8, %lo(_3201342), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307510:
	mov	%r8, %r9
code_3307459:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3307500:
	mov	%r8, %r12
code_3307460:
	! done making normal call
	sethi	%hi(type_3233441), %r8
	or	%r8, %lo(type_3233441), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3233446), %r8
	or	%r8, %lo(type_3233446), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307501:
	mov	%r8, %r9
code_3307467:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307502:
code_3307468:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	sethi	%hi(bnds_normalizePRIME_3046455), %r8
	or	%r8, %lo(bnds_normalizePRIME_3046455), %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3307503:
	mov	%r8, %r12
code_3307470:
	! done making normal call
	sethi	%hi(type_3231391), %r8
	or	%r8, %lo(type_3231391), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3231396), %r8
	or	%r8, %lo(type_3231396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307504:
	mov	%r8, %r9
code_3307477:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307505:
code_3307478:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r11
	! making closure call
	sethi	%hi(export_normalizePRIME_inner_3047298), %r8
	or	%r8, %lo(export_normalizePRIME_inner_3047298), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3307506:
	mov	%r8, %r10
code_3307481:
	! done making normal call
	! making closure call
	sethi	%hi(_3201357), %r8
	or	%r8, %lo(_3201357), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307507:
	mov	%r8, %r12
code_3307484:
	! done making normal call
	sethi	%hi(type_3251056), %r8
	or	%r8, %lo(type_3251056), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3251056), %r8
	or	%r8, %lo(type_3251056), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307508:
	mov	%r8, %r9
code_3307491:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3307509:
	mov	%r8, %r9
code_3307492:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307493
	nop
code_3307494:
	call	GCFromML ! delay slot empty
	nop
needgc_3307493:
	! allocating 3-record
	sethi	%hi(gctag_3201381), %r8
	ld	[%r8+%lo(gctag_3201381)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3290765 ! delay slot empty
	nop
sumarm_3290769:
after_sum_3290765:
code_3307499:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263277,(.-Normalize_anonfun_code_3263277)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307500
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03f00000
		! worddata
	.word 0x80000000
	.long reify_3251171
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3307501
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03f00000
		! worddata
	.word 0x80000000
	.long reify_3251171
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3307502
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c00000
		! worddata
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3307503
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03cc0000
		! worddata
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3307504
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03cc0000
		! worddata
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3307505
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cc0000
		! worddata
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
		! -------- label,sizes,reg
	.long code_3307506
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
		! -------- label,sizes,reg
	.long code_3307507
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
		! -------- label,sizes,reg
	.long code_3307508
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cf0000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long reify_3251170
		! -------- label,sizes,reg
	.long code_3307509
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3233441
		! -------- label,sizes,reg
	.long needgc_3307493
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long reify_3250107
	.word 0x80000000
	.long type_3233441
	.word 0x80000000
	.long type_3251056
		! -------- label,sizes,reg
	.long code_3307510
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03ff0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long reify_3251171
	.word 0x80000000
	.long reify_3251170
	.word 0x80000000
	.long reify_3250107
	.text
	.align 8
	.global Normalize_module_normalize_code_3263272
 ! arguments : [$3263274,$8] [$3263275,$9] [$3047380,$10] 
 ! results    : [$3290756,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_module_normalize_code_3263272:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307539
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307539:
	st	%r15, [%sp+92]
	st	%r10, [%sp+96]
code_3307512:
funtop_3290703:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307538:
code_3307515:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307516
	nop
code_3307517:
	call	GCFromML ! delay slot empty
	nop
needgc_3307516:
	! allocating 1 closures
	or	%r0, 17, %r11
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307521
	nop
code_3307522:
	or	%r0, 0, %r9
cmpui_3307521:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307525
	nop
code_3307526:
	or	%r0, 0, %r9
cmpui_3307525:
	sll	%r9, 9, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 2-record
	st	%r11, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263277), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263277), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193078), %r8
	or	%r8, %lo(type_3193078), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193078), %r8
	or	%r8, %lo(type_3193078), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307537:
code_3307534:
	! done making normal call
code_3307536:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_module_normalize_code_3263272,(.-Normalize_module_normalize_code_3263272)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307537
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3307516
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307538
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3263291
 ! arguments : [$3263293,$8] [$3263294,$9] [$3047394,$10] 
 ! results    : [$3290659,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263291:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307565
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3307565:
	st	%r15, [%sp+92]
	st	%r10, [%sp+112]
code_3307540:
funtop_3290632:
	ld	[%r9], %r16
	st	%r16, [%sp+100]
	ld	[%r9+4], %r16
	st	%r16, [%sp+104]
	ld	[%r9+8], %r16
	st	%r16, [%sp+108]
	ld	[%r9+12], %r16
	st	%r16, [%sp+96]
intarm_3290645:
	or	%r0, -1, %r8
	ld	[%sp+112], %r17
	cmp	%r17, %r8
	bne	intarm_3290646
	nop
code_3307541:
	sethi	%hi(string_3272242), %r8
	or	%r8, %lo(string_3272242), %r10
	! making closure call
	sethi	%hi(_3201513), %r8
	or	%r8, %lo(_3201513), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3307545:
	! done making tail call
	ba	after_intcase_3290644 ! delay slot empty
	nop
intarm_3290646:
	! making closure call
	sethi	%hi(generate_tuple_label_3201496), %r8
	or	%r8, %lo(generate_tuple_label_3201496), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307563:
	mov	%r8, %r11
code_3307549:
	! done making normal call
	! making closure call
	sethi	%hi(eq_label_3193328), %r8
	or	%r8, %lo(eq_label_3193328), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r10
code_3307561:
code_3307552:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3290682
	nop
zero_case_3290681:
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3307564:
	mov	%r8, %r9
code_3307554:
	! done making normal call
	ld	[%sp+112], %r17
	subcc	%r17, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3307555:
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3307556:
	! done making tail call
	ba	after_zeroone_3290683 ! delay slot empty
	nop
one_case_3290682:
	ld	[%sp+112], %r8
after_zeroone_3290683:
after_intcase_3290644:
code_3307559:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263291,(.-Normalize_anonfun_code_3263291)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307561
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00050000
		! -------- label,sizes,reg
	.long code_3307563
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00150000
		! -------- label,sizes,reg
	.long code_3307564
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_lab2int_code_3263286
 ! arguments : [$3263288,$8] [$3263289,$9] [$3233738,$10] [$3233739,$11] 
 ! results    : [$3290626,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_lab2int_code_3263286:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307573
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307573:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3307566:
funtop_3290605:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307567
	nop
code_3307568:
	call	GCFromML ! delay slot empty
	nop
needgc_3307567:
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 1 closures
	! allocating 4-record
	or	%r0, 2849, %r8
	st	%r8, [%r4]
	st	%r12, [%r4+4]
	st	%r9, [%r4+8]
	st	%r10, [%r4+12]
	st	%r11, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263291), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263291), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3307572:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_lab2int_code_3263286,(.-Normalize_lab2int_code_3263286)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307567
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_vars_eq_0_code_3263305
 ! arguments : [$3263307,$8] [$3263308,$9] [$3233760,$10] [$3233761,$11] 
 ! results    : [$3290574,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_vars_eq_0_code_3263305:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307588
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307588:
	st	%r15, [%sp+92]
code_3307574:
funtop_3290551:
sumarm_3290558:
	cmp	%r10, 0
	bne	sumarm_3290559
	nop
sumarm_3290566:
	cmp	%r11, 0
	bne	sumarm_3290567
	nop
code_3307576:
	ba	after_sum_3290563
	or	%r0, 1, %r8
sumarm_3290567:
nomatch_sum_3290564:
	or	%r0, 0, %r8
after_sum_3290563:
	ba	after_sum_3290555 ! delay slot empty
	nop
sumarm_3290559:
	cmp	%r10, 1
	bne	sumarm_3290575
	nop
sumarm_3290582:
	cmp	%r11, 1
	bne	sumarm_3290583
	nop
code_3307580:
	ba	after_sum_3290579
	or	%r0, 1, %r8
sumarm_3290583:
nomatch_sum_3290580:
	or	%r0, 0, %r8
after_sum_3290579:
	ba	after_sum_3290555 ! delay slot empty
	nop
sumarm_3290575:
sumarm_3290597:
	cmp	%r11, 2
	bne	sumarm_3290598
	nop
code_3307583:
	ba	after_sum_3290594
	or	%r0, 1, %r8
sumarm_3290598:
nomatch_sum_3290595:
	or	%r0, 0, %r8
after_sum_3290594:
	ba	after_sum_3290555 ! delay slot empty
	nop
sumarm_3290590:
after_sum_3290555:
code_3307587:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_vars_eq_0_code_3263305,(.-Normalize_vars_eq_0_code_3263305)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_is_hnf_code_3263310
 ! arguments : [$3263312,$8] [$3263313,$9] [$3047548,$10] 
 ! results    : [$3290475,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_is_hnf_code_3263310:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307627
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307627:
	st	%r15, [%sp+92]
code_3307589:
funtop_3290463:
sumarm_3290470:
	ld	[%r10], %r8
	cmp	%r8, 0
	bne	sumarm_3290471
	nop
code_3307590:
	ba	after_sum_3290467
	or	%r0, 1, %r8
sumarm_3290471:
	ld	[%r10], %r8
	cmp	%r8, 1
	bne	sumarm_3290476
	nop
code_3307592:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290476:
	ld	[%r10], %r8
	cmp	%r8, 2
	bne	sumarm_3290480
	nop
code_3307594:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290480:
	ld	[%r10], %r8
	cmp	%r8, 3
	bne	sumarm_3290484
	nop
code_3307596:
	sethi	%hi(string_3272289), %r8
	or	%r8, %lo(string_3272289), %r10
	! making closure call
	sethi	%hi(_3201626), %r8
	or	%r8, %lo(_3201626), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 96, %sp
code_3307600:
	! done making tail call
	ba	after_sum_3290467 ! delay slot empty
	nop
sumarm_3290484:
	ld	[%r10], %r8
	cmp	%r8, 5
	bne	sumarm_3290497
	nop
code_3307602:
	ba	after_sum_3290467
	or	%r0, 1, %r8
sumarm_3290497:
	ld	[%r10], %r8
	cmp	%r8, 6
	bne	sumarm_3290501
	nop
code_3307604:
	ba	after_sum_3290467
	or	%r0, 1, %r8
sumarm_3290501:
	ld	[%r10], %r8
	cmp	%r8, 7
	bne	sumarm_3290505
	nop
code_3307606:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290505:
	ld	[%r10], %r8
	cmp	%r8, 8
	bne	sumarm_3290509
	nop
code_3307608:
	ba	after_sum_3290467
	or	%r0, 1, %r8
sumarm_3290509:
	ld	[%r10], %r8
	cmp	%r8, 9
	bne	sumarm_3290513
	nop
code_3307610:
	ba	after_sum_3290467
	or	%r0, 1, %r8
sumarm_3290513:
	ld	[%r10], %r8
	cmp	%r8, 10
	bne	sumarm_3290517
	nop
code_3307612:
	ld	[%r10+4], %r8
	ld	[%r8], %r8
sumarm_3290528:
	ld	[%r8], %r8
	cmp	%r8, 8
	bne	sumarm_3290529
	nop
code_3307613:
	ba	after_sum_3290525
	or	%r0, 1, %r8
sumarm_3290529:
nomatch_sum_3290526:
	or	%r0, 0, %r8
after_sum_3290525:
	ba	after_sum_3290467 ! delay slot empty
	nop
sumarm_3290517:
	ld	[%r10], %r8
	cmp	%r8, 11
	bne	sumarm_3290536
	nop
code_3307616:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290536:
	ld	[%r10], %r8
	cmp	%r8, 12
	bne	sumarm_3290540
	nop
code_3307618:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290540:
	ld	[%r10], %r8
	cmp	%r8, 13
	bne	sumarm_3290544
	nop
code_3307620:
	ba	after_sum_3290467
	or	%r0, 0, %r8
sumarm_3290544:
nomatch_sum_3290468:
	sethi	%hi(record_3270494), %r8
	or	%r8, %lo(record_3270494), %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3290467:
code_3307625:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_is_hnf_code_3263310,(.-Normalize_is_hnf_code_3263310)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_find_kind_equation_subst_code_3263315
 ! arguments : [$3263317,$8] [$3263318,$9] [$3233775,$10] [$3233776,$11] [$3233777,$12] 
 ! results    : [$3290423,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_find_kind_equation_subst_code_3263315:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307751
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307751:
	st	%r15, [%sp+92]
	st	%r10, [%sp+104]
	st	%r11, [%sp+96]
	st	%r12, [%sp+100]
code_3307628:
funtop_3290230:
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307629
	nop
code_3307630:
	call	GCFromML ! delay slot empty
	nop
needgc_3307629:
	sethi	%hi(exn_handler_3290233), %r8
	or	%r8, %lo(exn_handler_3290233), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 256, %r8
	st	%r8, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	sethi	%hi(strbindvar_r_find_kind_equation_3193977), %r8
	or	%r8, %lo(strbindvar_r_find_kind_equation_3193977), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3307748:
code_3307636:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307637
	nop
code_3307638:
	call	GCFromML ! delay slot empty
	nop
needgc_3307637:
	ba	exn_handler_after_3290234
	ld	[%r1+12], %r1
exn_handler_3290233:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	mov	%r15, %r8
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307643
	nop
code_3307644:
	call	GCFromML ! delay slot empty
	nop
needgc_3307643:
	or	%r0, 0, %r8
exn_handler_after_3290234:
sumarm_3290262:
	cmp	%r8, 0
	bne	sumarm_3290263
	nop
code_3307646:
	! making closure call
	sethi	%hi(_3233797), %r8
	or	%r8, %lo(_3233797), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307743:
code_3307649:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307650
	nop
code_3307651:
	call	GCFromML ! delay slot empty
	nop
needgc_3307650:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3290277
	nop
zero_case_3290276:
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3307750:
	mov	%r8, %r12
code_3307655:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307744:
	mov	%r8, %r9
code_3307662:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3307745:
	st	%r8, [%sp+96]
code_3307663:
	! done making normal call
	! making closure call
	sethi	%hi(strbindvar_r_find_kind_equation_3193977), %r8
	or	%r8, %lo(strbindvar_r_find_kind_equation_3193977), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3307746:
	mov	%r8, %r10
code_3307666:
	! done making normal call
sumarm_3290329:
	cmp	%r10, 0
	bne	sumarm_3290330
	nop
code_3307667:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307747:
code_3307670:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307671
	nop
code_3307672:
	call	GCFromML ! delay slot empty
	nop
needgc_3307671:
	sethi	%hi(type_3201808), %r9
	or	%r9, %lo(type_3201808), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3290350
	nop
code_3307676:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3290351
	nop
code_3307677:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3290350
	nop
code_3307678:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3290350
	nop
code_3307679:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3290350
	nop
dynamic_nobox_3290351:
	ba	xinject_sum_dyn_after_3290344
	mov	%r8, %r9
dynamic_box_3290350:
	or	%r0, 9, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307684
	nop
code_3307685:
	or	%r0, 0, %r9
cmpui_3307684:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 1-record
	st	%r11, [%r4]
	st	%r8, [%r4+4]
	add	%r4, 4, %r8
	add	%r4, 8, %r4
	! done allocating 1 record
	mov	%r8, %r9
xinject_sum_dyn_after_3290344:
	! allocating 2-record
	sethi	%hi(gctag_3201817), %r8
	ld	[%r8+%lo(gctag_3201817)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290326 ! delay slot empty
	nop
sumarm_3290330:
	sethi	%hi(type_3199327), %r8
	or	%r8, %lo(type_3199327), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3290379
	nop
code_3307690:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3290380
	nop
code_3307691:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3290379
	nop
code_3307692:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3290379
	nop
code_3307693:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3290379
	nop
dynamic_nobox_3290380:
	ba	projsum_single_after_3290376
	st	%r10, [%sp+96]
dynamic_box_3290379:
	ld	[%r10], %r16
	st	%r16, [%sp+96]
projsum_single_after_3290376:
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307749:
code_3307698:
	! done making normal call
	add	%r4, 20, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307699
	nop
code_3307700:
	call	GCFromML ! delay slot empty
	nop
needgc_3307699:
	sethi	%hi(type_3201808), %r9
	or	%r9, %lo(type_3201808), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3290398
	nop
code_3307704:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3290399
	nop
code_3307705:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3290398
	nop
code_3307706:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3290398
	nop
code_3307707:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3290398
	nop
dynamic_nobox_3290399:
	ba	xinject_sum_dyn_after_3290392
	mov	%r8, %r9
dynamic_box_3290398:
	or	%r0, 9, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307712
	nop
code_3307713:
	or	%r0, 0, %r9
cmpui_3307712:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 1-record
	st	%r11, [%r4]
	st	%r8, [%r4+4]
	add	%r4, 4, %r8
	add	%r4, 8, %r4
	! done allocating 1 record
	mov	%r8, %r9
xinject_sum_dyn_after_3290392:
	! allocating 2-record
	sethi	%hi(gctag_3201844), %r8
	ld	[%r8+%lo(gctag_3201844)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290326 ! delay slot empty
	nop
sumarm_3290367:
after_sum_3290326:
	ba	after_zeroone_3290278 ! delay slot empty
	nop
one_case_3290277:
	! allocating 2-record
	sethi	%hi(gctag_3201864), %r8
	ld	[%r8+%lo(gctag_3201864)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
after_zeroone_3290278:
	ba	after_sum_3290259 ! delay slot empty
	nop
sumarm_3290263:
	sethi	%hi(type_3201808), %r9
	or	%r9, %lo(type_3201808), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3290436
	nop
code_3307721:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3290437
	nop
code_3307722:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3290436
	nop
code_3307723:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3290436
	nop
code_3307724:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3290436
	nop
dynamic_nobox_3290437:
	ba	xinject_sum_dyn_after_3290430
	ld	[%sp+96], %r11
dynamic_box_3290436:
	or	%r0, 9, %r11
	sethi	%hi(type_3193047), %r9
	or	%r9, %lo(type_3193047), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307729
	nop
code_3307730:
	or	%r0, 0, %r9
cmpui_3307729:
	sll	%r9, 8, %r9
	add	%r9, %r0, %r9
	or	%r9, %r11, %r11
	! allocating 1-record
	st	%r11, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r9
	add	%r4, 8, %r4
	! done allocating 1 record
	mov	%r9, %r11
xinject_sum_dyn_after_3290430:
	sethi	%hi(type_3199327), %r9
	or	%r9, %lo(type_3199327), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3290455
	nop
code_3307733:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3290456
	nop
code_3307734:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3290455
	nop
code_3307735:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3290455
	nop
code_3307736:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3290455
	nop
dynamic_nobox_3290456:
	ba	projsum_single_after_3290452
	mov	%r8, %r9
dynamic_box_3290455:
	ld	[%r8], %r9
projsum_single_after_3290452:
	! allocating 2-record
	sethi	%hi(gctag_3201844), %r8
	ld	[%r8+%lo(gctag_3201844)], %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3290259 ! delay slot empty
	nop
sumarm_3290424:
after_sum_3290259:
code_3307742:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_find_kind_equation_subst_code_3263315,(.-Normalize_find_kind_equation_subst_code_3263315)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307629
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3307637
	.word 0x001c000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3245080
		! -------- label,sizes,reg
	.long needgc_3307643
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307743
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3307650
	.word 0x001c000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3307744
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307745
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307746
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307747
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long needgc_3307671
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307699
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307748
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003f0000
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3307749
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3245079
		! -------- label,sizes,reg
	.long code_3307750
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3245079
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3263325
 ! arguments : [$3263327,$8] [$3263328,$9] [$3047796,$10] 
 ! results    : [$3290220,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263325:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307821
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3307821:
	st	%r15, [%sp+92]
	st	%r9, [%sp+120]
code_3307752:
funtop_3290012:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307753
	nop
code_3307754:
	call	GCFromML ! delay slot empty
	nop
needgc_3307753:
	ld	[%r10], %r16
	st	%r16, [%sp+116]
	ld	[%r10+4], %r9
	ld	[%r10+8], %r16
	st	%r16, [%sp+112]
	ld	[%r10+12], %r11
	ld	[%r10+16], %r12
	ld	[%r10+20], %r16
	st	%r16, [%sp+108]
	ld	[%r10+24], %r16
	st	%r16, [%sp+104]
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+112], %r10
code_3307816:
	mov	%r8, %r9
code_3307756:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307757
	nop
code_3307758:
	call	GCFromML ! delay slot empty
	nop
needgc_3307757:
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r8
	ld	[%r8+%lo(gctag_3197849)], %r8
	st	%r8, [%r4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(_3227170), %r8
	or	%r8, %lo(_3227170), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3307817:
code_3307764:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307765
	nop
code_3307766:
	call	GCFromML ! delay slot empty
	nop
needgc_3307765:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3290081
	nop
zero_case_3290080:
	ba	after_zeroone_3290082
	or	%r0, 0, %r8
one_case_3290081:
	! allocating 1-record
	or	%r0, 9, %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 8, %r4
	! done allocating 1 record
	! making closure call
	sethi	%hi(_3223755), %r8
	or	%r8, %lo(_3223755), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307818:
	mov	%r8, %r12
code_3307772:
	! done making normal call
	sethi	%hi(eq_var_3193326), %r8
	or	%r8, %lo(eq_var_3193326), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(eq_opt_3244148), %r8
	or	%r8, %lo(eq_opt_3244148), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r11
code_3307813:
code_3307777:
	! done making normal call
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307778
	nop
code_3307779:
	call	GCFromML ! delay slot empty
	nop
needgc_3307778:
after_zeroone_3290082:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3290123
	nop
zero_case_3290122:
	! allocating 3-record
	sethi	%hi(gctag_3197912), %r8
	ld	[%r8+%lo(gctag_3197912)], %r8
	st	%r8, [%r4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(debug_3194017), %r8
	or	%r8, %lo(debug_3194017), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3307820:
code_3307788:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3290154
	nop
zero_case_3290153:
	ba	after_zeroone_3290155
	or	%r0, 256, %r8
one_case_3290154:
	! making closure call
	sethi	%hi(_3227254), %r8
	or	%r8, %lo(_3227254), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3307819:
	mov	%r8, %r9
code_3307793:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3307814:
	mov	%r8, %r9
code_3307794:
	! done making normal call
sumarm_3290183:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3290181
	nop
code_3307795:
	sethi	%hi(string_3269287), %r8
	or	%r8, %lo(string_3269287), %r10
	! making closure call
	sethi	%hi(_3194113), %r8
	or	%r8, %lo(_3194113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307815:
code_3307799:
	! done making normal call
	ba	after_sum_3290180 ! delay slot empty
	nop
sumarm_3290184:
nomatch_sum_3290181:
	or	%r0, 256, %r8
after_sum_3290180:
after_zeroone_3290155:
	! making closure call
	sethi	%hi(addr_3193298), %r8
	or	%r8, %lo(addr_3193298), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+120], %r10
	ld	[%sp+112], %r11
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3307812:
	mov	%r8, %r9
code_3307803:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307804
	nop
code_3307805:
	call	GCFromML ! delay slot empty
	nop
needgc_3307804:
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_zeroone_3290124 ! delay slot empty
	nop
one_case_3290123:
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
after_zeroone_3290124:
code_3307811:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263325,(.-Normalize_anonfun_code_3263325)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307812
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3307753
	.word 0x00200009
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30000000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307757
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x3cf10000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000003
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3307765
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x3cf40000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3307813
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cf40000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307778
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x3cf40000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3307814
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30050000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307815
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30050000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3307804
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307816
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cf10000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307817
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cf40000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307818
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3cf50000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3247284
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307819
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30050000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3307820
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30050000
		! worddata
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_con_reduce_letfun_inner_code_3263320
 ! arguments : [$3263322,$8] [$3263323,$9] [$3234231,$10] [$3234232,$11] 
 ! results    : [$3290007,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_con_reduce_letfun_inner_code_3263320:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307833
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307833:
	st	%r15, [%sp+92]
code_3307822:
funtop_3289995:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307823
	nop
code_3307824:
	call	GCFromML ! delay slot empty
	nop
needgc_3307823:
	! allocating 1 closures
	or	%r0, 537, %r10
	sethi	%hi(type_3193047), %r8
	or	%r8, %lo(type_3193047), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307828
	nop
code_3307829:
	or	%r0, 0, %r8
cmpui_3307828:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263325), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263325), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3307832:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_reduce_letfun_inner_code_3263320,(.-Normalize_con_reduce_letfun_inner_code_3263320)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307823
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_record_temp_code_3263332
 ! arguments : [$3263334,$8] [$3263335,$9] [$3234725,$10] [$3234726,$11] [$3234727,$12] 
 ! results    : [$3289991,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_record_temp_code_3263332:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307841
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307841:
	st	%r15, [%sp+92]
code_3307834:
funtop_3289979:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307835
	nop
code_3307836:
	call	GCFromML ! delay slot empty
	nop
needgc_3307835:
	! allocating 3-record
	sethi	%hi(record_gctag_3228784), %r8
	ld	[%r8+%lo(record_gctag_3228784)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3307840:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3263332,(.-Normalize_record_temp_code_3263332)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307835
	.word 0x0018000b
	.word 0x00170000
	.word 0xbffc2000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_record_temp_code_3263337
 ! arguments : [$3263339,$8] [$3263340,$9] [$3234909,$10] [$3234910,$11] [$3234911,$12] 
 ! results    : [$3289975,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_record_temp_code_3263337:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307849
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307849:
	st	%r15, [%sp+92]
code_3307842:
funtop_3289963:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307843
	nop
code_3307844:
	call	GCFromML ! delay slot empty
	nop
needgc_3307843:
	! allocating 3-record
	sethi	%hi(record_gctag_3228784), %r8
	ld	[%r8+%lo(record_gctag_3228784)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3307848:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3263337,(.-Normalize_record_temp_code_3263337)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307843
	.word 0x0018000b
	.word 0x00170000
	.word 0xbffc2000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3248996
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3263342
 ! arguments : [$3263344,$8] [$3263345,$9] [$3048222,$10] 
 ! results    : [$3289959,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_anonfun_code_3263342:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307857
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3307857:
	st	%r15, [%sp+92]
code_3307850:
funtop_3289953:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307851
	nop
code_3307852:
	call	GCFromML ! delay slot empty
	nop
needgc_3307851:
	! allocating 2-record
	sethi	%hi(gctag_3203302), %r8
	ld	[%r8+%lo(gctag_3203302)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3307856:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263342,(.-Normalize_anonfun_code_3263342)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3307851
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc3c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_anonfun_code_3263362
 ! arguments : [$3263364,$8] [$3263365,$9] [$3048751,$10] 
 ! results    : [$3289853,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263362:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307940
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307940:
	st	%r15, [%sp+92]
	mov	%r10, %r11
code_3307858:
funtop_3289723:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307859
	nop
code_3307860:
	call	GCFromML ! delay slot empty
	nop
needgc_3307859:
	ld	[%r9], %r16
	st	%r16, [%sp+104]
	ld	[%r9+4], %r10
	ld	[%r9+8], %r16
	st	%r16, [%sp+96]
sumarm_3289740:
	cmp	%r11, 0
	bne	sumarm_3289741
	nop
code_3307862:
	! making closure call
	sethi	%hi(_3222617), %r8
	or	%r8, %lo(_3222617), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3307929:
	st	%r8, [%sp+100]
code_3307865:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3307930:
	st	%r8, [%sp+96]
code_3307872:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(profile_3193128), %r8
	or	%r8, %lo(profile_3193128), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3307931:
code_3307878:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3289786
	nop
zero_case_3289785:
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(local_profile_3193131), %r8
	or	%r8, %lo(local_profile_3193131), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	jmpl	%r11, %r15
	mov	%r12, %r8
code_3307938:
code_3307885:
	! done making normal call
	ba	after_zeroone_3289787 ! delay slot empty
	nop
one_case_3289786:
	or	%r0, 1, %r8
after_zeroone_3289787:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3289807
	nop
zero_case_3289806:
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307939:
code_3307888:
	! done making normal call
	ba	after_zeroone_3289808 ! delay slot empty
	nop
one_case_3289807:
	sethi	%hi(string_3265382), %r8
	or	%r8, %lo(string_3265382), %r10
	! making closure call
	sethi	%hi(_3243902), %r8
	or	%r8, %lo(_3243902), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3307937:
	mov	%r8, %r12
code_3307893:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307932:
	mov	%r8, %r9
code_3307900:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3307933:
code_3307901:
	! done making normal call
after_zeroone_3289808:
	ba	after_sum_3289737 ! delay slot empty
	nop
sumarm_3289741:
	ld	[%r11], %r8
	ld	[%r11+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8], %r11
	ld	[%r8+4], %r8
	! allocating 2-record
	sethi	%hi(gctag_3201026), %r9
	ld	[%r9+%lo(gctag_3201026)], %r9
	st	%r9, [%r4]
	sethi	%hi(_c_3044472), %r9
	or	%r9, %lo(_c_3044472), %r12
	ld	[%r2+804], %r9
	add	%r12, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3307906
	nop
code_3307907:
	or	%r0, 0, %r9
cmpui_3307906:
	cmp	%r9, 0
	be,pn	%icc,else_case_3289904
	nop
code_3307908:
	sethi	%hi(match_exn_3205371), %r9
	or	%r9, %lo(match_exn_3205371), %r12
	ld	[%r2+804], %r9
	add	%r12, %r9, %r9
	ba	after_ite_3289905
	ld	[%r9], %r9
else_case_3289904:
	sethi	%hi(match_exn_3205371), %r9
	ld	[%r9+%lo(match_exn_3205371)], %r9
after_ite_3289905:
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 8, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r12
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(addr_3205389), %r8
	or	%r8, %lo(addr_3205389), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	jmpl	%r13, %r15
	ld	[%r9+8], %r9
code_3307928:
	mov	%r8, %r10
code_3307915:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3307934:
	mov	%r8, %r12
code_3307916:
	! done making normal call
	sethi	%hi(type_3236396), %r8
	or	%r8, %lo(type_3236396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307935:
	mov	%r8, %r9
code_3307923:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3307924:
	! done making tail call
	ba	after_sum_3289737 ! delay slot empty
	nop
sumarm_3289854:
after_sum_3289737:
code_3307927:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263362,(.-Normalize_anonfun_code_3263362)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307928
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000d0000
		! worddata
	.word 0x80000000
	.long type_3236396
		! -------- label,sizes,reg
	.long needgc_3307859
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3253153
		! -------- label,sizes,reg
	.long code_3307929
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307930
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00340000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307931
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00350000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307932
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307933
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3307934
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3236396
		! -------- label,sizes,reg
	.long code_3307935
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3236396
		! -------- label,sizes,reg
	.long code_3307937
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307938
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00350000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307939
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_loop_code_3263357
 ! arguments : [$3263359,$8] [$3263360,$9] [$3048749,$10] 
 ! results    : [$3289722,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_loop_code_3263357:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307970
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307970:
	st	%r15, [%sp+92]
code_3307941:
funtop_3289650:
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307942
	nop
code_3307943:
	call	GCFromML ! delay slot empty
	nop
needgc_3307942:
	ld	[%r9], %r13
	ld	[%r9+4], %r12
	! allocating 1 closures
	or	%r0, 1049, %r11
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307947
	nop
code_3307948:
	or	%r0, 0, %r8
cmpui_3307947:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	sethi	%hi(type_3222613), %r8
	or	%r8, %lo(type_3222613), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307951
	nop
code_3307952:
	or	%r0, 0, %r8
cmpui_3307951:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	! allocating 3-record
	st	%r11, [%r4]
	st	%r13, [%r4+4]
	st	%r10, [%r4+8]
	st	%r12, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263362), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263362), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3222681), %r8
	or	%r8, %lo(type_3222681), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	sethi	%hi(_c_3253154), %r9
	or	%r9, %lo(_c_3253154), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	! Proj_c at label var_TYC
	ld	[%r9], %r11
	sethi	%hi(_c_3044472), %r9
	or	%r9, %lo(_c_3044472), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	! Proj_c at label con_TYC
	ld	[%r9+4], %r10
	! allocating 4-record
	or	%r0, 3105, %r9
	st	%r9, [%r4]
	or	%r0, 5, %r9
	st	%r9, [%r4+4]
	or	%r0, 2, %r9
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	st	%r10, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	ld	[%r8], %r10
	jmpl	%r10, %r15
	ld	[%r8+4], %r8
code_3307968:
	mov	%r8, %r12
code_3307960:
	! done making constructor call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3307969:
code_3307965:
	! done making normal call
code_3307967:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_loop_code_3263357,(.-Normalize_loop_code_3263357)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307968
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3307942
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3222613
		! -------- label,sizes,reg
	.long code_3307969
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3263352
 ! arguments : [$3263354,$8] [$3263355,$9] [$3048746,$10] 
 ! results    : [$3289649,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263352:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3307998
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3307998:
	st	%r15, [%sp+92]
	st	%r9, [%sp+100]
code_3307971:
funtop_3289588:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3307972
	nop
code_3307973:
	call	GCFromML ! delay slot empty
	nop
needgc_3307972:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_loop_code_3263357), %r8
	or	%r8, %lo(Normalize_loop_code_3263357), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	or	%r0, 258, %r8
	st	%r8, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 529, %r11
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3307978
	nop
code_3307979:
	or	%r0, 0, %r8
cmpui_3307978:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	! allocating 2-record
	st	%r11, [%r4]
	st	%r10, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ld	[%sp+96], %r17
	st	%r8, [%r17+8]
	! done allocating 1 closures
	! making closure polycall
	sethi	%hi(empty_3205416), %r8
	or	%r8, %lo(empty_3205416), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3307994:
	mov	%r8, %r10
code_3307982:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3307995:
	mov	%r8, %r12
code_3307983:
	! done making normal call
	sethi	%hi(type_3236396), %r8
	or	%r8, %lo(type_3236396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3307996:
	mov	%r8, %r9
code_3307990:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 112, %sp
code_3307991:
	! done making tail call
code_3307993:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263352,(.-Normalize_anonfun_code_3263352)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3307994
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000d0000
		! worddata
	.word 0x80000000
	.long reify_3253153
		! -------- label,sizes,reg
	.long needgc_3307972
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3253153
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3307995
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3253153
		! -------- label,sizes,reg
	.long code_3307996
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long reify_3253153
	.text
	.align 8
	.global Normalize_removeDependence_inner_code_3263347
 ! arguments : [$3263349,$8] [$3263350,$9] [$3048741,$10] 
 ! results    : [$3289587,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_removeDependence_inner_code_3263347:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308018
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308018:
	st	%r15, [%sp+92]
	mov	%r10, %r11
code_3307999:
funtop_3289554:
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308000
	nop
code_3308001:
	call	GCFromML ! delay slot empty
	nop
needgc_3308000:
	! allocating 1 closures
	or	%r0, 537, %r10
	sethi	%hi(reify_3253153), %r8
	or	%r8, %lo(reify_3253153), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3308005
	nop
code_3308006:
	or	%r0, 0, %r8
cmpui_3308005:
	sll	%r8, 10, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 3-record
	st	%r10, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263352), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263352), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308017:
code_3308014:
	! done making normal call
code_3308016:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_removeDependence_inner_code_3263347,(.-Normalize_removeDependence_inner_code_3263347)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308017
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3308000
	.word 0x00180009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3253153
	.text
	.align 8
	.global Normalize_anonfun_code_3263377
 ! arguments : [$3263379,$8] [$3263380,$9] [$3049198,$10] 
 ! results    : [$3289550,$8] 
 ! destroys   :  $10 $9 $8
 ! modifies   :  $10 $9 $8
Normalize_anonfun_code_3263377:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308026
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308026:
	st	%r15, [%sp+92]
code_3308019:
funtop_3289544:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308020
	nop
code_3308021:
	call	GCFromML ! delay slot empty
	nop
needgc_3308020:
	! allocating 2-record
	sethi	%hi(gctag_3203302), %r8
	ld	[%r8+%lo(gctag_3203302)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308025:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263377,(.-Normalize_anonfun_code_3263377)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308020
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3800
	.word 0xbffc3c00
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_type_of_switch_inner_code_3263382
 ! arguments : [$3263384,$8] [$3263385,$9] [$3237765,$10] [$3237766,$11] 
 ! results    : [$3289519,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_type_of_switch_inner_code_3263382:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308040
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308040:
	st	%r15, [%sp+92]
code_3308027:
funtop_3289504:
sumarm_3289511:
	ld	[%r11], %r8
	cmp	%r8, 0
	bne	sumarm_3289512
	nop
code_3308028:
	ld	[%r11+4], %r8
	ba	after_sum_3289508
	ld	[%r8+4], %r8
sumarm_3289512:
	ld	[%r11], %r8
	cmp	%r8, 2
	bne	sumarm_3289520
	nop
code_3308030:
	ld	[%r11+4], %r8
	ba	after_sum_3289508
	ld	[%r8+8], %r8
sumarm_3289520:
	ld	[%r11], %r8
	cmp	%r8, 3
	bne	sumarm_3289527
	nop
code_3308032:
	ld	[%r11+4], %r8
	ba	after_sum_3289508
	ld	[%r8+4], %r8
sumarm_3289527:
	ld	[%r11], %r8
	cmp	%r8, 4
	bne	sumarm_3289534
	nop
code_3308034:
	ld	[%r11+4], %r8
	ba	after_sum_3289508
	ld	[%r8+4], %r8
sumarm_3289534:
nomatch_sum_3289509:
	sethi	%hi(record_3270494), %r8
	or	%r8, %lo(record_3270494), %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3289508:
code_3308039:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_type_of_switch_inner_code_3263382,(.-Normalize_type_of_switch_inner_code_3263382)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_type_of_fbnd_inner_code_3263387
 ! arguments : [$3263389,$8] [$3263390,$9] [$3237843,$10] [$3237844,$11] [$3237845,$12] [$3237846,$13] 
 ! results    : [$3289501,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_type_of_fbnd_inner_code_3263387:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308093
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308093:
	st	%r15, [%sp+92]
	st	%r10, [%sp+108]
	st	%r11, [%sp+96]
	mov	%r13, %r10
code_3308041:
funtop_3289380:
	! making closure call
	sethi	%hi(_3237909), %r8
	or	%r8, %lo(_3237909), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308092:
	mov	%r8, %r10
code_3308044:
	! done making normal call
	! making closure call
	sethi	%hi(_3237962), %r8
	or	%r8, %lo(_3237962), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308083:
code_3308047:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3237981), %r8
	or	%r8, %lo(_3237981), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308084:
	mov	%r8, %r10
code_3308050:
	! done making normal call
	! making closure call
	sethi	%hi(_3207467), %r8
	or	%r8, %lo(_3207467), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308085:
	mov	%r8, %r12
code_3308053:
	! done making normal call
	sethi	%hi(type_3237960), %r8
	or	%r8, %lo(type_3237960), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308086:
	mov	%r8, %r9
code_3308060:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3308087:
	st	%r8, [%sp+96]
code_3308061:
	! done making normal call
	! making closure call
	sethi	%hi(_3229651), %r8
	or	%r8, %lo(_3229651), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3308088:
	mov	%r8, %r12
code_3308064:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3225895), %r8
	or	%r8, %lo(type_3225895), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308089:
	mov	%r8, %r9
code_3308071:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308090:
	st	%r8, [%sp+96]
code_3308072:
	! done making normal call
	! making closure call
	sethi	%hi(strbindvar_r_insert_con_list_3207482), %r8
	or	%r8, %lo(strbindvar_r_insert_con_list_3207482), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+108], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3308091:
	mov	%r8, %r10
code_3308075:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308076
	nop
code_3308077:
	call	GCFromML ! delay slot empty
	nop
needgc_3308076:
	! allocating 2-record
	sethi	%hi(gctag_3207516), %r8
	ld	[%r8+%lo(gctag_3207516)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207531), %r8
	ld	[%r8+%lo(gctag_3207531)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308082:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_type_of_fbnd_inner_code_3263387,(.-Normalize_type_of_fbnd_inner_code_3263387)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308083
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308084
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3237960
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308085
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3237960
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308086
	.word 0x001c000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00fc0000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3237960
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308087
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cc0000
		! worddata
	.word 0x80000000
	.long type_3229448
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308088
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308089
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long type_3248940
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308090
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c00000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308091
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3225895
		! -------- label,sizes,reg
	.long needgc_3308076
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3225895
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308092
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00c30000
		! worddata
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_anonfun_code_3263392
 ! arguments : [$3263394,$8] [$3263395,$9] [$3238224,$10] [$3238225,$11] [$3238226,$12] [$3238227,$13] 
 ! results    : [$3238225,$8] 
 ! destroys   :  $13 $12 $10 $9 $8
 ! modifies   :  $13 $12 $10 $9 $8
Normalize_anonfun_code_3263392:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308097
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308097:
	st	%r15, [%sp+92]
	mov	%r11, %r8
code_3308094:
funtop_3289377:
code_3308096:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263392,(.-Normalize_anonfun_code_3263392)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_record_temp_code_3263397
 ! arguments : [$3263399,$8] [$3263400,$9] [$3049564,$10] 
 ! results    : [$3289367,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_record_temp_code_3263397:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308108
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308108:
	st	%r15, [%sp+92]
	mov	%r10, %r11
code_3308098:
funtop_3289362:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308099
	nop
code_3308100:
	call	GCFromML ! delay slot empty
	nop
needgc_3308099:
	or	%r0, 17, %r10
	sethi	%hi(reify_3252120), %r8
	or	%r8, %lo(reify_3252120), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3308104
	nop
code_3308105:
	or	%r0, 0, %r8
cmpui_3308104:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308107:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3263397,(.-Normalize_record_temp_code_3263397)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308099
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3252120
	.text
	.align 8
	.global Normalize_record_temp_code_3263402
 ! arguments : [$3263404,$8] [$3263405,$9] [$3049575,$10] 
 ! results    : [$3289352,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_record_temp_code_3263402:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308119
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308119:
	st	%r15, [%sp+92]
	mov	%r10, %r11
code_3308109:
funtop_3289347:
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308110
	nop
code_3308111:
	call	GCFromML ! delay slot empty
	nop
needgc_3308110:
	or	%r0, 17, %r10
	sethi	%hi(reify_3252120), %r8
	or	%r8, %lo(reify_3252120), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3308115
	nop
code_3308116:
	or	%r0, 0, %r8
cmpui_3308115:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 4, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308118:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_record_temp_code_3263402,(.-Normalize_record_temp_code_3263402)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308110
	.word 0x00180009
	.word 0x00170000
	.word 0xbffc3000
	.word 0xbffc3800
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3252120
	.text
	.align 8
	.global Normalize_mapper_inner_code_3263495
 ! arguments : [$3263497,$8] [$3263498,$9] [$3233927,$10] [$3233928,$11] 
 ! results    : [$3289343,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_mapper_inner_code_3263495:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308133
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308133:
	st	%r15, [%sp+92]
	st	%r9, [%sp+100]
code_3308120:
funtop_3289306:
	ld	[%r11], %r16
	st	%r16, [%sp+96]
	addcc	%r10, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3308121:
	! making closure call
	sethi	%hi(generate_tuple_label_3201496), %r8
	or	%r8, %lo(generate_tuple_label_3201496), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308132:
	mov	%r8, %r9
code_3308124:
	! done making normal call
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308125
	nop
code_3308126:
	call	GCFromML ! delay slot empty
	nop
needgc_3308125:
	! allocating 2-record
	sethi	%hi(gctag_3201969), %r8
	ld	[%r8+%lo(gctag_3201969)], %r8
	st	%r8, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 10, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198680), %r8
	ld	[%r8+%lo(gctag_3198680)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308131:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_mapper_inner_code_3263495,(.-Normalize_mapper_inner_code_3263495)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308132
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3308125
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_expandMuType_inner_code_3263487
 ! arguments : [$3263489,$8] [$3263490,$9] [$3233864,$10] [$3233865,$11] 
 ! results    : [$3289275,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_expandMuType_inner_code_3263487:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308233
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3308233:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3308134:
funtop_3289022:
	ld	[%r9], %r11
	ld	[%r9+4], %r9
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3308229:
	mov	%r8, %r9
code_3308135:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3308213:
code_3308136:
	! done making normal call
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
sumarm_3289054:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 10
	bne	sumarm_3289055
	nop
code_3308137:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+112]
	ld	[%r8+4], %r9
sumarm_3289068:
	ld	[%sp+112], %r17
	ld	[%r17], %r8
	cmp	%r8, 8
	bne	sumarm_3289069
	nop
code_3308138:
	ld	[%r9], %r10
	ld	[%r9+4], %r11
	! making closure call
	sethi	%hi(lab2int_3047391), %r8
	or	%r8, %lo(lab2int_3047391), %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3308214:
	st	%r8, [%sp+96]
code_3308140:
	! done making normal call
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(_3234128), %r8
	or	%r8, %lo(_3234128), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3308215:
	mov	%r8, %r10
code_3308143:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r11
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3308216:
	st	%r8, [%sp+108]
code_3308144:
	! done making normal call
	sethi	%hi(string_3272455), %r8
	or	%r8, %lo(string_3272455), %r10
	! making closure call
	sethi	%hi(fresh_named_var_3193329), %r8
	or	%r8, %lo(fresh_named_var_3193329), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308217:
	st	%r8, [%sp+104]
code_3308148:
	! done making normal call
	! making closure call
	sethi	%hi(_3229179), %r8
	or	%r8, %lo(_3229179), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3308218:
	st	%r8, [%sp+96]
code_3308151:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308152
	nop
code_3308153:
	call	GCFromML ! delay slot empty
	nop
needgc_3308152:
	! allocating 2-record
	or	%r0, 17, %r8
	st	%r8, [%r4]
	or	%r0, 13, %r8
	st	%r8, [%r4+4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_mapper_inner_code_3263495), %r8
	or	%r8, %lo(Normalize_mapper_inner_code_3263495), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(_3202016), %r8
	or	%r8, %lo(_3202016), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308230:
	mov	%r8, %r12
code_3308158:
	! done making normal call
	sethi	%hi(type_3224280), %r8
	or	%r8, %lo(type_3224280), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(reify_3248997), %r8
	or	%r8, %lo(reify_3248997), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3308219:
	mov	%r8, %r9
code_3308165:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308220:
	mov	%r8, %r10
code_3308166:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308167
	nop
code_3308168:
	call	GCFromML ! delay slot empty
	nop
needgc_3308167:
	! allocating 2-record
	sethi	%hi(gctag_3202030), %r8
	ld	[%r8+%lo(gctag_3202030)], %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	ld	[%sp+108], %r17
	subcc	%r17, 1, %r11
	bvs,pn	%icc,localOverflowFromML
	nop
code_3308172:
	! making closure call
	sethi	%hi(_3202069), %r8
	or	%r8, %lo(_3202069), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+96], %r10
code_3308221:
code_3308175:
	! done making normal call
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3234025), %r8
	or	%r8, %lo(_3234025), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3308222:
	mov	%r8, %r12
code_3308178:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308223:
	mov	%r8, %r9
code_3308185:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308224:
code_3308186:
	! done making normal call
	ba	after_sum_3289065 ! delay slot empty
	nop
sumarm_3289069:
nomatch_sum_3289066:
	sethi	%hi(string_3272599), %r8
	or	%r8, %lo(string_3272599), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308232:
code_3308191:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308225:
code_3308194:
	! done making normal call
	sethi	%hi(string_3272657), %r8
	or	%r8, %lo(string_3272657), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3308198:
	! done making tail call
after_sum_3289065:
	ba	after_sum_3289051 ! delay slot empty
	nop
sumarm_3289055:
nomatch_sum_3289052:
	sethi	%hi(string_3272599), %r8
	or	%r8, %lo(string_3272599), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308231:
code_3308203:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308227:
code_3308206:
	! done making normal call
	sethi	%hi(string_3272657), %r8
	or	%r8, %lo(string_3272657), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3308210:
	! done making tail call
after_sum_3289051:
code_3308212:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_expandMuType_inner_code_3263487,(.-Normalize_expandMuType_inner_code_3263487)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308213
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308214
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308215
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x030d0000
		! worddata
	.word 0x80000000
	.long reify_3245937
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308216
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x030c0000
		! worddata
	.word 0x80000000
	.long reify_3245937
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308217
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x030c0000
		! worddata
	.word 0x80000000
	.long reify_3245937
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308218
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3308152
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308219
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308220
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3308167
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x03030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248997
		! -------- label,sizes,reg
	.long code_3308221
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
		! -------- label,sizes,reg
	.long code_3308222
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308223
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308224
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308225
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308227
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308229
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308230
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308231
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308232
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.text
	.align 8
	.global Normalize_expandMuType_r_code_3263407
 ! arguments : [$3263409,$8] [$3047638,$9] [$3263410,$10] [$3047639,$11] 
 ! results    : [$3289017,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_expandMuType_r_code_3263407:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308241
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308241:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3308234:
funtop_3289003:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308235
	nop
code_3308236:
	call	GCFromML ! delay slot empty
	nop
needgc_3308235:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_expandMuType_inner_code_3263487), %r8
	or	%r8, %lo(Normalize_expandMuType_inner_code_3263487), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3308240:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_expandMuType_r_code_3263407,(.-Normalize_expandMuType_r_code_3263407)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308235
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_con_reduce_letfun_r_code_3263412
 ! arguments : [$3263414,$8] [$3202193,$9] [$3263415,$10] [$3202194,$11] 
 ! results    : [$3289002,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_con_reduce_letfun_r_code_3263412:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308246
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308246:
	st	%r15, [%sp+92]
code_3308242:
funtop_3288999:
	sethi	%hi(con_reduce_letfun_inner_3050302), %r8
	or	%r8, %lo(con_reduce_letfun_inner_3050302), %r8
code_3308245:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_reduce_letfun_r_code_3263412,(.-Normalize_con_reduce_letfun_r_code_3263412)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3263515
 ! arguments : [$3263517,$8] [$3263518,$9] [$3047891,$10] 
 ! results    : [$3287751,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263515:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 144, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308570
	nop
	add	%sp, 144, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 144, %sp
code_3308570:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	st	%r10, [%sp+100]
code_3308247:
funtop_3287722:
	add	%r4, 188, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308248
	nop
code_3308249:
	call	GCFromML ! delay slot empty
	nop
needgc_3308248:
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8+8], %r9
	ld	[%r8+12], %r16
	st	%r16, [%sp+136]
	ld	[%r8+16], %r16
	st	%r16, [%sp+132]
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
sumarm_3287747:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 0
	bne	sumarm_3287748
	nop
code_3308252:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3287748:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 1
	bne	sumarm_3287752
	nop
code_3308254:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308534:
	mov	%r8, %r12
code_3308255:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308535:
	mov	%r8, %r9
code_3308262:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3308263:
	! done making tail call
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3287752:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 2
	bne	sumarm_3287790
	nop
code_3308265:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308537:
	mov	%r8, %r12
code_3308266:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3308538:
	mov	%r8, %r9
code_3308273:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308539:
	mov	%r8, %r9
code_3308274:
	! done making normal call
	add	%r4, 64, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308275
	nop
code_3308276:
	call	GCFromML ! delay slot empty
	nop
needgc_3308275:
	ld	[%r9], %r8
	ld	[%r9+4], %r10
	ld	[%r9+8], %r9
sumarm_3287841:
	cmp	%r8, 2
	bne	sumarm_3287842
	nop
code_3308278:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3287838 ! delay slot empty
	nop
sumarm_3287842:
nomatch_sum_3287839:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	or	%r0, 1, %r10
	! making closure call
	sethi	%hi(_3234507), %r8
	or	%r8, %lo(_3234507), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308563:
	mov	%r8, %r12
code_3308285:
	! done making normal call
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224508), %r8
	or	%r8, %lo(type_3224508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308540:
	mov	%r8, %r9
code_3308292:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+136], %r10
code_3308541:
	mov	%r8, %r12
code_3308293:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3223454), %r8
	or	%r8, %lo(type_3223454), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308542:
	mov	%r8, %r9
code_3308300:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308543:
	mov	%r8, %r9
code_3308301:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308302
	nop
code_3308303:
	call	GCFromML ! delay slot empty
	nop
needgc_3308302:
	ld	[%r9], %r8
	ld	[%r9+4], %r9
	cmp	%r8, 0
	bne,pn	%icc,one_case_3287944
	nop
zero_case_3287943:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_zeroone_3287945 ! delay slot empty
	nop
one_case_3287944:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
after_zeroone_3287945:
after_sum_3287838:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3287790:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 3
	bne	sumarm_3287965
	nop
code_3308310:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308544:
	mov	%r8, %r12
code_3308311:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308545:
	mov	%r8, %r9
code_3308318:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308546:
code_3308319:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308320
	nop
code_3308321:
	call	GCFromML ! delay slot empty
	nop
needgc_3308320:
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198487), %r8
	ld	[%r8+%lo(gctag_3198487)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3287965:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 4
	bne	sumarm_3288031
	nop
code_3308326:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288031:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 5
	bne	sumarm_3288034
	nop
code_3308328:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288034:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 6
	bne	sumarm_3288037
	nop
code_3308330:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288037:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 7
	bne	sumarm_3288040
	nop
code_3308332:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r10
	ld	[%r8+8], %r16
	st	%r16, [%sp+96]
sumarm_3288059:
	cmp	%r10, 0
	bne	sumarm_3288060
	nop
code_3308333:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288056 ! delay slot empty
	nop
sumarm_3288060:
nomatch_sum_3288057:
	! making closure call
	sethi	%hi(_3234632), %r8
	or	%r8, %lo(_3234632), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308564:
	mov	%r8, %r9
code_3308338:
	! done making normal call
	add	%r4, 104, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308339
	nop
code_3308340:
	call	GCFromML ! delay slot empty
	nop
needgc_3308339:
sumarm_3288090:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3288088
	nop
code_3308342:
	ld	[%r9], %r10
	ld	[%r9+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3288087 ! delay slot empty
	nop
sumarm_3288091:
nomatch_sum_3288088:
	sethi	%hi(record_3270494), %r8
	or	%r8, %lo(record_3270494), %r8
	mov	%r8, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
after_sum_3288087:
	ld	[%r8], %r10
	ld	[%r8+4], %r8
sumarm_3288137:
	ld	[%r10], %r9
	cmp	%r9, 0
	bne	sumarm_3288138
	nop
code_3308347:
	ld	[%r10+4], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r11
	ld	[%r9+8], %r10
	! allocating 7-record
	sethi	%hi(gctag_3198662), %r9
	ld	[%r9+%lo(gctag_3198662)], %r9
	st	%r9, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	sethi	%hi(record_temp_3048034), %r9
	or	%r9, %lo(record_temp_3048034), %r9
	st	%r9, [%r4+8]
	st	%r12, [%r4+12]
	st	%r11, [%r4+16]
	st	%r10, [%r4+20]
	st	%r8, [%r4+24]
	ld	[%sp+96], %r17
	st	%r17, [%r4+28]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 32, %r4
	! done allocating 7 record
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308547:
	mov	%r8, %r9
code_3308350:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3308351:
	! done making tail call
	ba	after_sum_3288134 ! delay slot empty
	nop
sumarm_3288138:
	ld	[%r10], %r9
	cmp	%r9, 1
	bne	sumarm_3288175
	nop
code_3308353:
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r9
	ld	[%r9+%lo(gctag_3197849)], %r9
	st	%r9, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	ld	[%r10+4], %r8
	ld	[%r8], %r11
	ld	[%r8+4], %r12
	! making closure call
	sethi	%hi(addr_3193298), %r8
	or	%r8, %lo(addr_3193298), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+132], %r10
code_3308549:
	mov	%r8, %r9
code_3308357:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308358
	nop
code_3308359:
	call	GCFromML ! delay slot empty
	nop
needgc_3308358:
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288134 ! delay slot empty
	nop
sumarm_3288175:
	ld	[%r10+4], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r11
	ld	[%r9+8], %r10
	! allocating 7-record
	sethi	%hi(gctag_3198662), %r9
	ld	[%r9+%lo(gctag_3198662)], %r9
	st	%r9, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	sethi	%hi(record_temp_3048074), %r9
	or	%r9, %lo(record_temp_3048074), %r9
	st	%r9, [%r4+8]
	st	%r12, [%r4+12]
	st	%r11, [%r4+16]
	st	%r10, [%r4+20]
	st	%r8, [%r4+24]
	ld	[%sp+96], %r17
	st	%r17, [%r4+28]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 32, %r4
	! done allocating 7 record
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308567:
	mov	%r8, %r9
code_3308365:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3308366:
	! done making tail call
	ba	after_sum_3288134 ! delay slot empty
	nop
sumarm_3288216:
after_sum_3288134:
after_sum_3288056:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288040:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 8
	bne	sumarm_3288252
	nop
code_3308369:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288252:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 9
	bne	sumarm_3288255
	nop
code_3308371:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r11
sumarm_3288268:
	or	%r0, 255, %r9
	cmp	%r12, %r9
	bleu	nomatch_sum_3288266
	nop
code_3308372:
	ld	[%r12], %r9
	cmp	%r9, 5
	bne	sumarm_3288269
	nop
code_3308373:
	ld	[%r12+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+128]
	ld	[%r9+4], %r16
	st	%r16, [%sp+124]
sumarm_3288287:
	or	%r0, 255, %r9
	cmp	%r11, %r9
	bleu	nomatch_sum_3288285
	nop
code_3308374:
	ld	[%r11], %r16
	st	%r16, [%sp+120]
	ld	[%r11+4], %r11
sumarm_3288324:
	or	%r0, 255, %r9
	cmp	%r11, %r9
	bleu	nomatch_sum_3288322
	nop
code_3308375:
	ld	[%r11], %r16
	st	%r16, [%sp+116]
	ld	[%r11+4], %r9
sumarm_3288361:
	cmp	%r9, 0
	bne	sumarm_3288362
	nop
code_3308376:
	! allocating 2-record
	sethi	%hi(gctag_3203192), %r8
	ld	[%r8+%lo(gctag_3203192)], %r8
	st	%r8, [%r4]
	ld	[%sp+128], %r17
	st	%r17, [%r4+4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+112]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203302), %r8
	ld	[%r8+%lo(gctag_3203302)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203338), %r8
	ld	[%r8+%lo(gctag_3203338)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r9
	ld	[%r9+%lo(gctag_3198455)], %r9
	st	%r9, [%r4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+108]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r9
	ld	[%r9+%lo(gctag_3198455)], %r9
	st	%r9, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r9
	ld	[%r9+%lo(gctag_3198155)], %r9
	st	%r9, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 9, %r9
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 7-record
	sethi	%hi(gctag_3203379), %r9
	ld	[%r9+%lo(gctag_3203379)], %r9
	st	%r9, [%r4]
	ld	[%sp+128], %r17
	st	%r17, [%r4+4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+8]
	ld	[%sp+116], %r17
	st	%r17, [%r4+12]
	st	%r8, [%r4+16]
	or	%r0, 0, %r8
	st	%r8, [%r4+20]
	or	%r0, 0, %r8
	st	%r8, [%r4+24]
	or	%r0, 0, %r8
	st	%r8, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+104]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	ld	[%sp+104], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308551:
	mov	%r8, %r12
code_3308385:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3308552:
	mov	%r8, %r9
code_3308392:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3308553:
	mov	%r8, %r10
code_3308393:
	! done making normal call
	add	%r4, 52, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308394
	nop
code_3308395:
	call	GCFromML ! delay slot empty
	nop
needgc_3308394:
	ld	[%r10], %r9
	ld	[%r10+4], %r8
	ld	[%r10+8], %r10
sumarm_3288507:
	cmp	%r9, 0
	bne	sumarm_3288508
	nop
sumarm_3288515:
	ld	[%r10], %r8
	cmp	%r8, 9
	bne	sumarm_3288516
	nop
code_3308398:
	ld	[%r10+4], %r8
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
sumarm_3288529:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3288527
	nop
code_3308399:
	ld	[%r9], %r8
	cmp	%r8, 3
	bne	sumarm_3288530
	nop
code_3308400:
	ld	[%r9+4], %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3235075), %r8
	or	%r8, %lo(_3235075), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308554:
	mov	%r8, %r10
code_3308403:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308404
	nop
code_3308405:
	call	GCFromML ! delay slot empty
	nop
needgc_3308404:
	sethi	%hi(flattenThreshold_3193125), %r8
	or	%r8, %lo(flattenThreshold_3193125), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	cmp	%r10, %r8
	or	%r0, 1, %r8
	bg	cmpsi_3308409
	nop
code_3308410:
	or	%r0, 0, %r8
cmpsi_3308409:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3288558
	nop
zero_case_3288557:
	sethi	%hi(anonfun_3048221), %r8
	or	%r8, %lo(anonfun_3048221), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3203486), %r8
	or	%r8, %lo(_3203486), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308569:
	mov	%r8, %r12
code_3308416:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3253680), %r8
	or	%r8, %lo(type_3253680), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3308555:
	mov	%r8, %r9
code_3308423:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3308556:
	mov	%r8, %r9
code_3308424:
	! done making normal call
	add	%r4, 60, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308425
	nop
code_3308426:
	call	GCFromML ! delay slot empty
	nop
needgc_3308425:
	! allocating 7-record
	sethi	%hi(gctag_3203379), %r8
	ld	[%r8+%lo(gctag_3203379)], %r8
	st	%r8, [%r4]
	ld	[%sp+128], %r17
	st	%r17, [%r4+4]
	ld	[%sp+124], %r17
	st	%r17, [%r4+8]
	ld	[%sp+116], %r17
	st	%r17, [%r4+12]
	st	%r9, [%r4+16]
	or	%r0, 0, %r8
	st	%r8, [%r4+20]
	or	%r0, 0, %r8
	st	%r8, [%r4+24]
	or	%r0, 0, %r8
	st	%r8, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_zeroone_3288559
	mov	%r8, %r9
one_case_3288558:
	ld	[%sp+104], %r9
after_zeroone_3288559:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288526 ! delay slot empty
	nop
sumarm_3288530:
nomatch_sum_3288527:
	ld	[%sp+96], %r8
after_sum_3288526:
	ba	after_sum_3288512 ! delay slot empty
	nop
sumarm_3288516:
nomatch_sum_3288513:
	ld	[%sp+96], %r8
after_sum_3288512:
	ba	after_sum_3288504 ! delay slot empty
	nop
sumarm_3288508:
	cmp	%r9, 1
	bne	sumarm_3288632
	nop
code_3308434:
	! making closure call
	sethi	%hi(strbindvar_r_find_kind_equation_3193977), %r8
	or	%r8, %lo(strbindvar_r_find_kind_equation_3193977), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3308557:
	mov	%r8, %r10
code_3308437:
	! done making normal call
	add	%r4, 68, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308438
	nop
code_3308439:
	call	GCFromML ! delay slot empty
	nop
needgc_3308438:
sumarm_3288653:
	cmp	%r10, 0
	bne	sumarm_3288654
	nop
code_3308441:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288650 ! delay slot empty
	nop
sumarm_3288654:
	sethi	%hi(type_3199327), %r8
	or	%r8, %lo(type_3199327), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3288678
	nop
code_3308446:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3288679
	nop
code_3308447:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3288678
	nop
code_3308448:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3288678
	nop
code_3308449:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3288678
	nop
dynamic_nobox_3288679:
	ba	projsum_single_after_3288675
	mov	%r10, %r9
dynamic_box_3288678:
	ld	[%r10], %r9
projsum_single_after_3288675:
	! allocating 2-record
	sethi	%hi(gctag_3203651), %r8
	ld	[%r8+%lo(gctag_3203651)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203666), %r8
	ld	[%r8+%lo(gctag_3203666)], %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288650 ! delay slot empty
	nop
sumarm_3288666:
after_sum_3288650:
	ba	after_sum_3288504 ! delay slot empty
	nop
sumarm_3288632:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r9
	ld	[%r9+%lo(gctag_3198455)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r9
	ld	[%r9+%lo(gctag_3198155)], %r9
	st	%r9, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 9, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r9
	ld	[%r9+%lo(gctag_3202466)], %r9
	st	%r9, [%r4]
	or	%r0, 2, %r9
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288504 ! delay slot empty
	nop
sumarm_3288717:
after_sum_3288504:
	ba	after_sum_3288358 ! delay slot empty
	nop
sumarm_3288362:
nomatch_sum_3288359:
after_sum_3288358:
	ba	after_sum_3288321 ! delay slot empty
	nop
sumarm_3288325:
nomatch_sum_3288322:
after_sum_3288321:
	ba	after_sum_3288284 ! delay slot empty
	nop
sumarm_3288288:
nomatch_sum_3288285:
after_sum_3288284:
	ba	after_sum_3288265 ! delay slot empty
	nop
sumarm_3288269:
nomatch_sum_3288266:
after_sum_3288265:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288255:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 10
	bne	sumarm_3288761
	nop
code_3308466:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r9
	ld	[%r9], %r16
	st	%r16, [%sp+96]
	ld	[%r9+4], %r16
	st	%r16, [%sp+100]
sumarm_3288774:
	ld	[%sp+96], %r17
	ld	[%r17], %r9
	cmp	%r9, 8
	bne	sumarm_3288775
	nop
code_3308467:
	ba	after_sum_3288771 ! delay slot empty
	nop
sumarm_3288775:
nomatch_sum_3288772:
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r9
	ld	[%sp+136], %r10
	jmpl	%r12, %r15
	ld	[%sp+132], %r11
code_3308565:
	mov	%r8, %r12
code_3308469:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308558:
	mov	%r8, %r9
code_3308476:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308559:
	mov	%r8, %r9
code_3308477:
	! done making normal call
	add	%r4, 64, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308478
	nop
code_3308479:
	call	GCFromML ! delay slot empty
	nop
needgc_3308478:
	ld	[%r9], %r8
	ld	[%r9+4], %r10
	ld	[%r9+8], %r9
sumarm_3288822:
	cmp	%r8, 2
	bne	sumarm_3288823
	nop
code_3308481:
	! allocating 2-record
	sethi	%hi(gctag_3199100), %r8
	ld	[%r8+%lo(gctag_3199100)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 10, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3202466), %r8
	ld	[%r8+%lo(gctag_3202466)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r10, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288819 ! delay slot empty
	nop
sumarm_3288823:
nomatch_sum_3288820:
	! allocating 2-record
	sethi	%hi(gctag_3199100), %r8
	ld	[%r8+%lo(gctag_3199100)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 10, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	sethi	%hi(beta_conrecordPRIME_3223448), %r8
	or	%r8, %lo(beta_conrecordPRIME_3223448), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308566:
	mov	%r8, %r9
code_3308487:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308488
	nop
code_3308489:
	call	GCFromML ! delay slot empty
	nop
needgc_3308488:
	ld	[%r9], %r8
	ld	[%r9+4], %r9
	cmp	%r8, 0
	bne,pn	%icc,one_case_3288874
	nop
zero_case_3288873:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_zeroone_3288875 ! delay slot empty
	nop
one_case_3288874:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
after_zeroone_3288875:
after_sum_3288819:
after_sum_3288771:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288761:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 11
	bne	sumarm_3288895
	nop
code_3308496:
	sethi	%hi(string_3273092), %r8
	or	%r8, %lo(string_3273092), %r10
	! making closure call
	sethi	%hi(_3203923), %r8
	or	%r8, %lo(_3203923), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 144, %sp
code_3308500:
	! done making tail call
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288895:
	ld	[%sp+100], %r17
	ld	[%r17], %r11
	cmp	%r11, 12
	bne	sumarm_3288908
	nop
code_3308502:
	sethi	%hi(type_3194501), %r8
	or	%r8, %lo(type_3194501), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r8
	ld	[%sp+100], %r17
	ld	[%r17+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+136], %r10
code_3308561:
	mov	%r8, %r9
code_3308505:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308506
	nop
code_3308507:
	call	GCFromML ! delay slot empty
	nop
needgc_3308506:
	! allocating 3-record
	sethi	%hi(gctag_3203946), %r8
	ld	[%r8+%lo(gctag_3203946)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288908:
	ld	[%sp+100], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3227254), %r8
	or	%r8, %lo(_3227254), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+132], %r10
code_3308568:
	mov	%r8, %r9
code_3308513:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3308562:
	mov	%r8, %r10
code_3308514:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308515
	nop
code_3308516:
	call	GCFromML ! delay slot empty
	nop
needgc_3308515:
sumarm_3288960:
	cmp	%r10, 0
	bne	sumarm_3288961
	nop
code_3308518:
	! allocating 3-record
	sethi	%hi(gctag_3202658), %r8
	ld	[%r8+%lo(gctag_3202658)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	ld	[%sp+100], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288957 ! delay slot empty
	nop
sumarm_3288961:
	sethi	%hi(type_3199336), %r8
	or	%r8, %lo(type_3199336), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3288989
	nop
code_3308523:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3288990
	nop
code_3308524:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3288989
	nop
code_3308525:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3288989
	nop
code_3308526:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3288989
	nop
dynamic_nobox_3288990:
	ba	projsum_single_after_3288986
	mov	%r10, %r9
dynamic_box_3288989:
	ld	[%r10], %r9
projsum_single_after_3288986:
	! allocating 3-record
	sethi	%hi(gctag_3203996), %r8
	ld	[%r8+%lo(gctag_3203996)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+132], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3288957 ! delay slot empty
	nop
sumarm_3288973:
after_sum_3288957:
	ba	after_sum_3287744 ! delay slot empty
	nop
sumarm_3288932:
after_sum_3287744:
code_3308533:
	ld	[%sp+92], %r15
	retl
	add	%sp, 144, %sp
	.size Normalize_anonfun_code_3263515,(.-Normalize_anonfun_code_3263515)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308248
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308534
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308535
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308537
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000003c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308538
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x0000003c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308539
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000003c
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3308275
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000003c
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308540
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000003c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308541
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308542
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308543
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308302
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308544
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308545
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308546
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3308320
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x00000000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3308339
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000003c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3248997
		! -------- label,sizes,reg
	.long code_3308547
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308549
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3308358
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308551
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfd550000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308552
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfd550000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308553
	.word 0x00240014
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfd550000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3308394
	.word 0x00240014
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xfd550000
	.word 0x0000003f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308554
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcc1c0000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308404
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcc1c0000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308555
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcc0c0000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308556
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcc000000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308425
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0xcc000000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3253680
		! -------- label,sizes,reg
	.long code_3308557
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x01440000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308438
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x01440000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3245080
		! -------- label,sizes,reg
	.long code_3308558
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
	.word 0x0000000c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308559
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308478
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308488
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308561
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308506
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3308562
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000000c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308515
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000000c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3227252
		! -------- label,sizes,reg
	.long code_3308563
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x0000003c
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308564
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x001f0000
	.word 0x0000003c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3197841
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308565
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00070000
	.word 0x0000000c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308566
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x0000000c
		! worddata
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308567
	.word 0x00240008
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308568
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
	.word 0x0000000c
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308569
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0xcc0c0000
	.word 0x0000000f
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_con_reduce_inner_code_3263506
 ! arguments : [$3263508,$8] [$3263509,$9] [$3234372,$10] [$3234373,$11] 
 ! results    : [$3287721,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_con_reduce_inner_code_3263506:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308598
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3308598:
	st	%r15, [%sp+92]
	st	%r8, [%sp+112]
	mov	%r9, %r8
	st	%r10, [%sp+104]
	st	%r11, [%sp+108]
code_3308571:
funtop_3287647:
	ld	[%r8], %r16
	st	%r16, [%sp+116]
	ld	[%r8+4], %r9
	ld	[%r8+8], %r16
	st	%r16, [%sp+96]
	ld	[%r8+12], %r16
	st	%r16, [%sp+100]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+112], %r9
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3308597:
	st	%r8, [%sp+120]
code_3308572:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r12
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r10
	ld	[%sp+112], %r9
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3308596:
	mov	%r8, %r9
code_3308573:
	! done making normal call
	add	%r4, 40, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308574
	nop
code_3308575:
	call	GCFromML ! delay slot empty
	nop
needgc_3308574:
	! allocating 1 closures
	or	%r0, 1833, %r8
	sethi	%hi(type_3193048), %r10
	or	%r10, %lo(type_3193048), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3308579
	nop
code_3308580:
	or	%r0, 0, %r10
cmpui_3308579:
	sll	%r10, 11, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	sethi	%hi(type_3193047), %r10
	or	%r10, %lo(type_3193047), %r11
	ld	[%r2+804], %r10
	add	%r11, %r10, %r10
	ld	[%r10], %r10
	cmp	%r10, 3
	or	%r0, 1, %r10
	bgu	cmpui_3308583
	nop
code_3308584:
	or	%r0, 0, %r10
cmpui_3308583:
	sll	%r10, 12, %r10
	add	%r10, %r0, %r10
	or	%r10, %r8, %r8
	! allocating 5-record
	st	%r8, [%r4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+8]
	st	%r9, [%r4+12]
	ld	[%sp+104], %r17
	st	%r17, [%r4+16]
	ld	[%sp+108], %r17
	st	%r17, [%r4+20]
	add	%r4, 4, %r9
	add	%r4, 24, %r4
	! done allocating 5 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263515), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263515), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(_c_3044472), %r8
	or	%r8, %lo(_c_3044472), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! Proj_c at label con_TYC
	ld	[%r8+4], %r18
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308595:
code_3308592:
	! done making normal call
code_3308594:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_con_reduce_inner_code_3263506,(.-Normalize_con_reduce_inner_code_3263506)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308595
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308596
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x14f00000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long needgc_3308574
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x14f00000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
		! -------- label,sizes,reg
	.long code_3308597
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x05f50000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3193047
	.text
	.align 8
	.global Normalize_con_reduce_r_code_3263417
 ! arguments : [$3263419,$8] [$3202587,$9] [$3263420,$10] [$3202588,$11] 
 ! results    : [$3287631,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_con_reduce_r_code_3263417:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308606
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308606:
	st	%r15, [%sp+92]
	mov	%r11, %r12
code_3308599:
funtop_3287621:
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308600
	nop
code_3308601:
	call	GCFromML ! delay slot empty
	nop
needgc_3308600:
	ld	[%r10], %r11
	ld	[%r10+4], %r10
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_con_reduce_inner_code_3263506), %r8
	or	%r8, %lo(Normalize_con_reduce_inner_code_3263506), %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	or	%r0, 258, %r8
	st	%r8, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 4-record
	or	%r0, 3873, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	st	%r10, [%r4+12]
	st	%r12, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	st	%r8, [%r9+8]
	! done allocating 1 closures
code_3308605:
	mov	%r9, %r8
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_con_reduce_r_code_3263417,(.-Normalize_con_reduce_r_code_3263417)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308600
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3600
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3263555
 ! arguments : [$3263557,$8] [$3263558,$9] [$3235742,$10] [$3235743,$11] [$3235744,$12] 
 ! results    : [$3287478,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263555:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 144, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308757
	nop
	add	%sp, 144, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 144, %sp
code_3308757:
	st	%r15, [%sp+92]
	st	%r10, [%sp+112]
	st	%r11, [%sp+108]
	st	%r12, [%sp+128]
code_3308607:
funtop_3287221:
	ld	[%r9], %r16
	st	%r16, [%sp+124]
	ld	[%r9+4], %r16
	st	%r16, [%sp+120]
	ld	[%r9+8], %r16
	st	%r16, [%sp+104]
	ld	[%r9+12], %r8
	ld	[%r9+16], %r16
	st	%r16, [%sp+100]
	ld	[%r9+20], %r16
	st	%r16, [%sp+116]
	ld	[%r9+24], %r16
	st	%r16, [%sp+96]
	cmp	%r8, 0
	bne,pn	%icc,one_case_3287240
	nop
zero_case_3287239:
	ba	after_zeroone_3287241
	or	%r0, 256, %r8
one_case_3287240:
	sethi	%hi(string_3273204), %r8
	or	%r8, %lo(string_3273204), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308753:
code_3308613:
	! done making normal call
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3308732:
	mov	%r8, %r12
code_3308615:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r11
	ld	[%r2+804], %r8
	add	%r11, %r8, %r8
	ld	[%r8], %r11
	ld	[%r11], %r13
	ld	[%r11+4], %r8
	jmpl	%r13, %r15
	ld	[%r11+8], %r11
code_3308733:
	mov	%r8, %r9
code_3308622:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3308734:
	mov	%r8, %r10
code_3308623:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308735:
code_3308626:
	! done making normal call
	sethi	%hi(string_3266199), %r8
	or	%r8, %lo(string_3266199), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308736:
code_3308630:
	! done making normal call
	sethi	%hi(string_3273239), %r8
	or	%r8, %lo(string_3273239), %r10
	! making closure call
	sethi	%hi(_3194113), %r8
	or	%r8, %lo(_3194113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308737:
code_3308634:
	! done making normal call
after_zeroone_3287241:
	ld	[%sp+100], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3287318
	nop
zero_case_3287317:
	ba	after_zeroone_3287319
	or	%r0, 0, %r8
one_case_3287318:
	or	%r0, 1000, %r11
	! making closure call
	sethi	%hi(imod_3194088), %r8
	or	%r8, %lo(imod_3194088), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r10
code_3308754:
code_3308639:
	! done making normal call
	cmp	%r8, 0
	or	%r0, 1, %r8
	be	cmpui_3308640
	nop
code_3308641:
	or	%r0, 0, %r8
cmpui_3308640:
after_zeroone_3287319:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3287340
	nop
zero_case_3287339:
	ba	after_zeroone_3287341
	or	%r0, 256, %r8
one_case_3287340:
	sethi	%hi(string_3273265), %r8
	or	%r8, %lo(string_3273265), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308755:
code_3308647:
	! done making normal call
	! making closure call
	sethi	%hi(toString_3194100), %r8
	or	%r8, %lo(toString_3194100), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3308738:
	mov	%r8, %r10
code_3308650:
	! done making normal call
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308739:
code_3308653:
	! done making normal call
	sethi	%hi(string_3273267), %r8
	or	%r8, %lo(string_3273267), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308740:
code_3308657:
	! done making normal call
after_zeroone_3287341:
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3308730:
	mov	%r8, %r12
code_3308658:
	! done making normal call
	sethi	%hi(type_3193062), %r8
	or	%r8, %lo(type_3193062), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3202396), %r8
	or	%r8, %lo(type_3202396), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3308741:
	mov	%r8, %r9
code_3308665:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3308742:
	mov	%r8, %r9
code_3308666:
	! done making normal call
	ld	[%r9], %r8
	ld	[%r9+4], %r16
	st	%r16, [%sp+104]
	ld	[%r9+8], %r16
	st	%r16, [%sp+112]
sumarm_3287426:
	cmp	%r8, 0
	bne	sumarm_3287427
	nop
code_3308667:
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3308743:
	mov	%r8, %r12
code_3308669:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308744:
	mov	%r8, %r9
code_3308676:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3308745:
	mov	%r8, %r10
code_3308677:
	! done making normal call
	! making closure call
	sethi	%hi(_3224705), %r8
	or	%r8, %lo(_3224705), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308746:
	mov	%r8, %r9
code_3308680:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308681
	nop
code_3308682:
	call	GCFromML ! delay slot empty
	nop
needgc_3308681:
	! allocating 3-record
	sethi	%hi(gctag_3204616), %r8
	ld	[%r8+%lo(gctag_3204616)], %r8
	st	%r8, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+128], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3287423 ! delay slot empty
	nop
sumarm_3287427:
	cmp	%r8, 1
	bne	sumarm_3287479
	nop
code_3308686:
	! making closure call
	sethi	%hi(find_kind_equation_subst_3047584), %r8
	or	%r8, %lo(find_kind_equation_subst_3047584), %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+104], %r11
	jmpl	%r13, %r15
	ld	[%sp+112], %r12
code_3308747:
code_3308688:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308689
	nop
code_3308690:
	call	GCFromML ! delay slot empty
	nop
needgc_3308689:
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
sumarm_3287506:
	cmp	%r10, 0
	bne	sumarm_3287507
	nop
code_3308692:
	! allocating 3-record
	sethi	%hi(gctag_3204653), %r8
	ld	[%r8+%lo(gctag_3204653)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	ld	[%sp+128], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	ba	after_sum_3287503 ! delay slot empty
	nop
sumarm_3287507:
	sethi	%hi(type_3201808), %r8
	or	%r8, %lo(type_3201808), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3287531
	nop
code_3308697:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3287532
	nop
code_3308698:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3287531
	nop
code_3308699:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3287531
	nop
code_3308700:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3287531
	nop
dynamic_nobox_3287532:
	ba	projsum_single_after_3287528
	st	%r10, [%sp+100]
dynamic_box_3287531:
	ld	[%r10], %r16
	st	%r16, [%sp+100]
projsum_single_after_3287528:
	ld	[%sp+120], %r17
	addcc	%r17, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3308703:
	! making closure call
	ld	[%sp+124], %r17
	ld	[%r17], %r11
	ld	[%sp+124], %r17
	ld	[%r17+4], %r8
	ld	[%sp+124], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3308748:
	st	%r8, [%sp+96]
code_3308704:
	! done making normal call
	ld	[%sp+116], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3287544
	nop
zero_case_3287543:
	ba	after_zeroone_3287545
	ld	[%sp+128], %r12
one_case_3287544:
	! making closure call
	sethi	%hi(anonfun_3222552), %r8
	or	%r8, %lo(anonfun_3222552), %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3308756:
	mov	%r8, %r12
code_3308708:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3308749:
	mov	%r8, %r9
code_3308715:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3308750:
	mov	%r8, %r9
code_3308716:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308717
	nop
code_3308718:
	call	GCFromML ! delay slot empty
	nop
needgc_3308717:
	! allocating 2-record
	sethi	%hi(gctag_3204675), %r8
	ld	[%r8+%lo(gctag_3204675)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+128], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r12
after_zeroone_3287545:
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r13
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+108], %r11
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 144, %sp
code_3308721:
	! done making tail call
	ba	after_sum_3287503 ! delay slot empty
	nop
sumarm_3287519:
after_sum_3287503:
	ba	after_sum_3287423 ! delay slot empty
	nop
sumarm_3287479:
	ld	[%sp+120], %r17
	addcc	%r17, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3308724:
	! making closure call
	ld	[%sp+124], %r17
	ld	[%r17], %r11
	ld	[%sp+124], %r17
	ld	[%r17+4], %r8
	ld	[%sp+124], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3308751:
	mov	%r8, %r9
code_3308725:
	! done making normal call
	! making closure call
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+112], %r11
	ld	[%sp+128], %r12
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 144, %sp
code_3308726:
	! done making tail call
	ba	after_sum_3287423 ! delay slot empty
	nop
sumarm_3287601:
after_sum_3287423:
code_3308729:
	ld	[%sp+92], %r15
	retl
	add	%sp, 144, %sp
	.size Normalize_anonfun_code_3263555,(.-Normalize_anonfun_code_3263555)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308730
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x44c30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308732
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308733
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308734
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308735
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308736
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308737
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308738
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308739
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308740
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308741
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x44c30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308742
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x44030000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308743
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
	.word 0x00000003
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308744
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03000000
	.word 0x00000003
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308745
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308746
	.word 0x0024000a
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long needgc_3308681
	.word 0x0024000c
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3235731
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308747
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47300000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long needgc_3308689
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47300000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308748
	.word 0x00240012
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x07fc0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3223121
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3222555
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308749
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03cd0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3223121
	.word 0x80000000
	.long type_3222555
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308750
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00cd0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3223121
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long needgc_3308717
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00cd0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3223121
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3235731
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3308751
	.word 0x0024000e
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03300000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193047
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308753
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d70000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308754
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308755
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x47d30000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193047
	.word 0x80000000
	.long type_3235731
		! -------- label,sizes,reg
	.long code_3308756
	.word 0x00240010
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03cd0000
	.word 0x00000003
		! worddata
	.word 0x80000000
	.long type_3223121
	.word 0x80000000
	.long type_3222555
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3235731
	.text
	.align 8
	.global Normalize_loop_code_3263550
 ! arguments : [$3263552,$8] [$3263553,$9] [$3048567,$10] 
 ! results    : [$3287215,$8] 
 ! destroys   :  $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_loop_code_3263550:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308773
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308773:
	st	%r15, [%sp+92]
code_3308758:
funtop_3287177:
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308759
	nop
code_3308760:
	call	GCFromML ! delay slot empty
	nop
needgc_3308759:
	ld	[%r9], %r21
	ld	[%r9+4], %r20
	ld	[%r9+8], %r19
	ld	[%r9+12], %r18
	sethi	%hi(10000), %r8
	or	%r8, %lo(10000), %r8
	cmp	%r10, %r8
	or	%r0, 1, %r13
	bg	cmpsi_3308762
	nop
code_3308763:
	or	%r0, 0, %r13
cmpsi_3308762:
	cmp	%r10, 0
	or	%r0, 1, %r12
	bg	cmpsi_3308764
	nop
code_3308765:
	or	%r0, 0, %r12
cmpsi_3308764:
	! allocating 1 closures
	sethi	%hi(15673), %r11
	or	%r11, %lo(15673), %r11
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3308768
	nop
code_3308769:
	or	%r0, 0, %r8
cmpui_3308768:
	sll	%r8, 14, %r8
	add	%r8, %r0, %r8
	or	%r8, %r11, %r11
	! allocating 7-record
	st	%r11, [%r4]
	st	%r21, [%r4+4]
	st	%r10, [%r4+8]
	st	%r20, [%r4+12]
	st	%r13, [%r4+16]
	st	%r12, [%r4+20]
	st	%r19, [%r4+24]
	st	%r18, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263555), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263555), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3308772:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_loop_code_3263550,(.-Normalize_loop_code_3263550)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308759
	.word 0x00180007
	.word 0x00170000
	.word 0xbfc00200
	.word 0xbfc00000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3263545
 ! arguments : [$3263547,$8] [$3263548,$9] [$3235736,$10] [$3235737,$11] 
 ! results    : [$3287176,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263545:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308793
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308793:
	st	%r15, [%sp+92]
	st	%r11, [%sp+100]
code_3308774:
funtop_3287123:
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308775
	nop
code_3308776:
	call	GCFromML ! delay slot empty
	nop
needgc_3308775:
	ld	[%r9], %r8
	ld	[%r9+4], %r18
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r9
	st	%r9, [%r4]
	sethi	%hi(Normalize_loop_code_3263550), %r9
	or	%r9, %lo(Normalize_loop_code_3263550), %r9
	st	%r9, [%r4+4]
	or	%r0, 256, %r9
	st	%r9, [%r4+8]
	or	%r0, 258, %r9
	st	%r9, [%r4+12]
	add	%r4, 4, %r13
	add	%r4, 16, %r4
	! done allocating 3 record
	or	%r0, 1825, %r12
	sethi	%hi(type_3193048), %r9
	or	%r9, %lo(type_3193048), %r11
	ld	[%r2+804], %r9
	add	%r11, %r9, %r9
	ld	[%r9], %r9
	cmp	%r9, 3
	or	%r0, 1, %r9
	bgu	cmpui_3308781
	nop
code_3308782:
	or	%r0, 0, %r9
cmpui_3308781:
	sll	%r9, 11, %r9
	add	%r9, %r0, %r9
	or	%r9, %r12, %r12
	! allocating 4-record
	st	%r12, [%r4]
	st	%r13, [%r4+4]
	st	%r8, [%r4+8]
	st	%r18, [%r4+12]
	st	%r10, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	st	%r8, [%r13+8]
	! done allocating 1 closures
	or	%r0, 0, %r10
	! making closure call
	ld	[%r13], %r11
	ld	[%r13+4], %r8
	jmpl	%r11, %r15
	ld	[%r13+8], %r9
code_3308790:
	st	%r8, [%sp+96]
code_3308783:
	! done making normal call
	! making closure polycall
	sethi	%hi(empty_3193292), %r8
	or	%r8, %lo(empty_3193292), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r10
	ld	[%r9+4], %r8
	jmpl	%r10, %r15
	ld	[%r9+8], %r9
code_3308791:
	mov	%r8, %r10
code_3308786:
	! done making normal call
	or	%r0, 0, %r12
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r13
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	ld	[%sp+100], %r11
	ld	[%sp+92], %r15
	jmpl	%r13, %r0
	add	%sp, 112, %sp
code_3308787:
	! done making tail call
code_3308789:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_anonfun_code_3263545,(.-Normalize_anonfun_code_3263545)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308790
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long needgc_3308775
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3308791
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000d0000
		! worddata
	.word 0x80000000
	.long type_3222555
	.text
	.align 8
	.global Normalize_reduce_hnf_listPRIME_inner_code_3263537
 ! arguments : [$3263539,$8] [$3263540,$9] [$3048560,$10] 
 ! results    : [$3287117,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_reduce_hnf_listPRIME_inner_code_3263537:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308803
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308803:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
code_3308794:
funtop_3287091:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3308802:
	mov	%r8, %r9
code_3308795:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308796
	nop
code_3308797:
	call	GCFromML ! delay slot empty
	nop
needgc_3308796:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263545), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263545), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3308801:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_reduce_hnf_listPRIME_inner_code_3263537,(.-Normalize_reduce_hnf_listPRIME_inner_code_3263537)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308796
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3308802
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3193138
	.text
	.align 8
	.global Normalize_reduce_hnf_listPRIME_r_code_3263422
 ! arguments : [$3263424,$8] [$3204469,$9] [$3263425,$10] [$3204470,$11] 
 ! results    : [$3287090,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_reduce_hnf_listPRIME_r_code_3263422:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308818
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308818:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3308804:
funtop_3287057:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308805
	nop
code_3308806:
	call	GCFromML ! delay slot empty
	nop
needgc_3308805:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_reduce_hnf_listPRIME_inner_code_3263537), %r8
	or	%r8, %lo(Normalize_reduce_hnf_listPRIME_inner_code_3263537), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r12
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(record_3273168), %r8
	or	%r8, %lo(record_3273168), %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308817:
code_3308814:
	! done making normal call
code_3308816:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_reduce_hnf_listPRIME_r_code_3263422,(.-Normalize_reduce_hnf_listPRIME_r_code_3263422)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308805
	.word 0x00180007
	.word 0x00170000
	.word 0x00001c00
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308817
	.word 0x00180007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_reduce_hnf_inner_code_3263584
 ! arguments : [$3263586,$8] [$3263587,$9] [$3236114,$10] [$3236115,$11] 
 ! results    : [$3287054,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_reduce_hnf_inner_code_3263584:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308839
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308839:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
code_3308819:
funtop_3286998:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3308838:
	mov	%r8, %r12
code_3308820:
	! done making normal call
	sethi	%hi(type_3193138), %r8
	or	%r8, %lo(type_3193138), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(record_3273168), %r8
	or	%r8, %lo(record_3273168), %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308835:
	mov	%r8, %r9
code_3308826:
	! done making normal call
	or	%r0, 0, %r10
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3308836:
	mov	%r8, %r9
code_3308827:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3308837:
code_3308828:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308829
	nop
code_3308830:
	call	GCFromML ! delay slot empty
	nop
needgc_3308829:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3194531), %r8
	ld	[%r8+%lo(gctag_3194531)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
code_3308834:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_reduce_hnf_inner_code_3263584,(.-Normalize_reduce_hnf_inner_code_3263584)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308835
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3308836
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3308837
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3308829
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000100
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308838
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3222555
	.text
	.align 8
	.global Normalize_reduce_hnf_r_code_3263427
 ! arguments : [$3263429,$8] [$3204870,$9] [$3263430,$10] [$3204871,$11] 
 ! results    : [$3286993,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_reduce_hnf_r_code_3263427:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308847
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308847:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3308840:
funtop_3286979:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308841
	nop
code_3308842:
	call	GCFromML ! delay slot empty
	nop
needgc_3308841:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_reduce_hnf_inner_code_3263584), %r8
	or	%r8, %lo(Normalize_reduce_hnf_inner_code_3263584), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3308846:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_reduce_hnf_r_code_3263427,(.-Normalize_reduce_hnf_r_code_3263427)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308841
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_projectTuple_inner_code_3263596
 ! arguments : [$3263598,$8] [$3263599,$9] [$3236334,$10] [$3236335,$11] [$3236336,$12] 
 ! results    : [$3286977,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_projectTuple_inner_code_3263596:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308861
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308861:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	st	%r10, [%sp+100]
	mov	%r11, %r18
code_3308848:
funtop_3286930:
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308849
	nop
code_3308850:
	call	GCFromML ! delay slot empty
	nop
needgc_3308849:
	ld	[%r9], %r10
	ld	[%r9+4], %r11
	! allocating 2-record
	sethi	%hi(gctag_3199100), %r8
	ld	[%r8+%lo(gctag_3199100)], %r8
	st	%r8, [%r4]
	st	%r18, [%r4+4]
	st	%r12, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 10, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r10], %r12
	ld	[%r10+4], %r8
	ld	[%r10+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3308860:
	mov	%r8, %r9
code_3308853:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3308859:
code_3308854:
	! done making normal call
	ld	[%r8], %r9
	ld	[%r8+4], %r8
	cmp	%r9, 0
	bne,pn	%icc,one_case_3286974
	nop
zero_case_3286973:
	ba	after_zeroone_3286975 ! delay slot empty
	nop
one_case_3286974:
after_zeroone_3286975:
code_3308858:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_projectTuple_inner_code_3263596,(.-Normalize_projectTuple_inner_code_3263596)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308849
	.word 0x001c000b
	.word 0x00170000
	.word 0x00003200
	.word 0x00040000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3308859
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3308860
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_projectTuple_r_code_3263432
 ! arguments : [$3263434,$8] [$3205199,$9] [$3263435,$10] [$3205200,$11] 
 ! results    : [$3286925,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_projectTuple_r_code_3263432:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308869
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308869:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3308862:
funtop_3286911:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308863
	nop
code_3308864:
	call	GCFromML ! delay slot empty
	nop
needgc_3308863:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_projectTuple_inner_code_3263596), %r8
	or	%r8, %lo(Normalize_projectTuple_inner_code_3263596), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3308868:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_projectTuple_r_code_3263432,(.-Normalize_projectTuple_r_code_3263432)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308863
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_removeDependence_r_code_3263437
 ! arguments : [$3263439,$8] [$3205292,$9] [$3263440,$10] [$3205293,$11] 
 ! results    : [$3286908,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_removeDependence_r_code_3263437:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308875
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3308875:
	st	%r15, [%sp+92]
code_3308870:
funtop_3286905:
	sethi	%hi(removeDependence_inner_3050312), %r8
	or	%r8, %lo(removeDependence_inner_3050312), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
code_3308874:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_removeDependence_r_code_3263437,(.-Normalize_removeDependence_r_code_3263437)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_anonfun_code_3263622
 ! arguments : [$3263624,$8] [$3263625,$9] [$3048830,$10] 
 ! results    : [$3286757,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263622:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308926
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3308926:
	st	%r15, [%sp+92]
	mov	%r10, %r11
code_3308876:
funtop_3286724:
	ld	[%r9], %r16
	st	%r16, [%sp+116]
	ld	[%r9+4], %r10
	ld	[%r9+8], %r16
	st	%r16, [%sp+108]
	ld	[%r9+12], %r16
	st	%r16, [%sp+112]
sumarm_3286743:
	cmp	%r11, 0
	bne	sumarm_3286744
	nop
code_3308877:
	sethi	%hi(string_3273689), %r8
	or	%r8, %lo(string_3273689), %r10
	! making closure call
	sethi	%hi(_3205508), %r8
	or	%r8, %lo(_3205508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3308881:
	! done making tail call
	ba	after_sum_3286740 ! delay slot empty
	nop
sumarm_3286744:
	ld	[%r11], %r8
	ld	[%r11+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8], %r11
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
	ld	[%r8+8], %r16
	st	%r16, [%sp+100]
	! making closure call
	sethi	%hi(eq_label_3193328), %r8
	or	%r8, %lo(eq_label_3193328), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	jmpl	%r12, %r15
	ld	[%r9+8], %r9
code_3308924:
code_3308885:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308886
	nop
code_3308887:
	call	GCFromML ! delay slot empty
	nop
needgc_3308886:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3286812
	nop
zero_case_3286811:
	! allocating 2-record
	sethi	%hi(gctag_3205602), %r8
	ld	[%r8+%lo(gctag_3205602)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3205617), %r8
	ld	[%r8+%lo(gctag_3205617)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r11
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3308925:
	mov	%r8, %r12
code_3308892:
	! done making normal call
	sethi	%hi(type_3236668), %r8
	or	%r8, %lo(type_3236668), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308918:
	mov	%r8, %r9
code_3308899:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3308900:
	! done making tail call
	ba	after_zeroone_3286813 ! delay slot empty
	nop
one_case_3286812:
	! making closure call
	sethi	%hi(_3236807), %r8
	or	%r8, %lo(_3236807), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3308923:
	mov	%r8, %r10
code_3308904:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r11
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	jmpl	%r11, %r15
	ld	[%r17+8], %r9
code_3308920:
	mov	%r8, %r12
code_3308905:
	! done making normal call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3308921:
	mov	%r8, %r9
code_3308912:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+100], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3308913:
	! done making tail call
after_zeroone_3286813:
	ba	after_sum_3286740 ! delay slot empty
	nop
sumarm_3286758:
after_sum_3286740:
code_3308916:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_anonfun_code_3263622,(.-Normalize_anonfun_code_3263622)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3308886
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x0d7c0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3236668
	.word 0x80000000
	.long reify_3253153
	.word 0x80000000
	.long type_3193138
		! -------- label,sizes,reg
	.long code_3308918
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3236668
		! -------- label,sizes,reg
	.long code_3308920
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308921
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000c0000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308923
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x010c0000
		! worddata
	.word 0x80000000
	.long type_3193062
		! -------- label,sizes,reg
	.long code_3308924
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d7c0000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3236668
	.word 0x80000000
	.long reify_3253153
		! -------- label,sizes,reg
	.long code_3308925
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3236668
	.text
	.align 8
	.global Normalize_loop_code_3263617
 ! arguments : [$3263619,$8] [$3263620,$9] [$3048828,$10] 
 ! results    : [$3286723,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_loop_code_3263617:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3308954
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3308954:
	st	%r15, [%sp+92]
	mov	%r10, %r18
code_3308927:
funtop_3286649:
	add	%r4, 60, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308928
	nop
code_3308929:
	call	GCFromML ! delay slot empty
	nop
needgc_3308928:
	ld	[%r9], %r13
	ld	[%r9+4], %r12
	ld	[%r9+8], %r11
	! allocating 1 closures
	or	%r0, 3617, %r10
	sethi	%hi(reify_3253153), %r8
	or	%r8, %lo(reify_3253153), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3308933
	nop
code_3308934:
	or	%r0, 0, %r8
cmpui_3308933:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 4-record
	st	%r10, [%r4]
	st	%r18, [%r4+4]
	st	%r13, [%r4+8]
	st	%r12, [%r4+12]
	st	%r11, [%r4+16]
	add	%r4, 4, %r9
	add	%r4, 20, %r4
	! done allocating 4 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_anonfun_code_3263622), %r8
	or	%r8, %lo(Normalize_anonfun_code_3263622), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! start making constructor call
	sethi	%hi(type_3222681), %r8
	or	%r8, %lo(type_3222681), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	sethi	%hi(_c_3253154), %r9
	or	%r9, %lo(_c_3253154), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	! Proj_c at label var_TYC
	ld	[%r9], %r12
	sethi	%hi(_c_3044472), %r9
	or	%r9, %lo(_c_3044472), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	! Proj_c at label con_TYC
	ld	[%r9+4], %r11
	! allocating 5-record
	sethi	%hi(7209), %r9
	or	%r9, %lo(7209), %r9
	st	%r9, [%r4]
	or	%r0, 5, %r9
	st	%r9, [%r4+4]
	or	%r0, 3, %r9
	st	%r9, [%r4+8]
	sethi	%hi(type_3194543), %r9
	or	%r9, %lo(type_3194543), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	st	%r9, [%r4+12]
	st	%r12, [%r4+16]
	st	%r11, [%r4+20]
	add	%r4, 4, %r9
	add	%r4, 24, %r4
	! done allocating 5 record
	ld	[%r8], %r10
	jmpl	%r10, %r15
	ld	[%r8+4], %r8
code_3308952:
	mov	%r8, %r12
code_3308944:
	! done making constructor call
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(vararg_INT), %r8
	or	%r8, %lo(vararg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3308953:
code_3308949:
	! done making normal call
code_3308951:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_loop_code_3263617,(.-Normalize_loop_code_3263617)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3308952
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3308928
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000200
	.word 0x00040000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long reify_3253153
		! -------- label,sizes,reg
	.long code_3308953
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_projectRecordType_inner_code_3263608
 ! arguments : [$3263610,$8] [$3263611,$9] [$3236601,$10] [$3236602,$11] [$3236603,$12] 
 ! results    : [$3286608,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_projectRecordType_inner_code_3263608:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309101
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3309101:
	st	%r15, [%sp+92]
	st	%r8, [%sp+104]
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+100]
	st	%r12, [%sp+120]
code_3308955:
funtop_3286268:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+108]
	ld	[%r8+8], %r16
	st	%r16, [%sp+112]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+104], %r9
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3309096:
	st	%r8, [%sp+116]
code_3308956:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r10
	ld	[%sp+104], %r9
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3309076:
	st	%r8, [%sp+104]
code_3308957:
	! done making normal call
	! making closure call
	ld	[%sp+116], %r17
	ld	[%r17], %r12
	ld	[%sp+116], %r17
	ld	[%r17+4], %r8
	ld	[%sp+116], %r17
	ld	[%r17+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3309077:
code_3308958:
	! done making normal call
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
sumarm_3286309:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 9
	bne	sumarm_3286310
	nop
code_3308959:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+112]
sumarm_3286323:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3286321
	nop
code_3308960:
	ld	[%r9], %r8
	cmp	%r8, 3
	bne	sumarm_3286324
	nop
code_3308961:
	ld	[%r9+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+108]
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
sumarm_3286342:
	or	%r0, 255, %r8
	ld	[%sp+96], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3286340
	nop
code_3308962:
	sethi	%hi(type_3236396), %r8
	or	%r8, %lo(type_3236396), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3222557), %r8
	or	%r8, %lo(type_3222557), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r12
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	mov	%r12, %r10
	jmpl	%r13, %r15
	ld	[%sp+104], %r12
code_3309078:
	mov	%r8, %r10
code_3308969:
	! done making normal call
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3308970
	nop
code_3308971:
	call	GCFromML ! delay slot empty
	nop
needgc_3308970:
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_loop_code_3263617), %r8
	or	%r8, %lo(Normalize_loop_code_3263617), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	or	%r0, 258, %r8
	st	%r8, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1817, %r9
	st	%r9, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	st	%r9, [%r8+8]
	! done allocating 1 closures
	sethi	%hi(type_3198950), %r9
	or	%r9, %lo(type_3198950), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r9
	ld	[%r9+16], %r9
	cmp	%r9, 4
	bleu,pn	%icc,dynamic_box_3286391
	nop
code_3308976:
	cmp	%r9, 255
	bleu,pn	%icc,dynamic_nobox_3286392
	nop
code_3308977:
	ld	[%r9], %r9
	cmp	%r9, 12
	be,pn	%icc,dynamic_box_3286391
	nop
code_3308978:
	cmp	%r9, 4
	be,pn	%icc,dynamic_box_3286391
	nop
code_3308979:
	cmp	%r9, 8
	be,pn	%icc,dynamic_box_3286391
	nop
dynamic_nobox_3286392:
	ld	[%sp+96], %r16
	ba	projsum_single_after_3286388
	st	%r16, [%sp+96]
dynamic_box_3286391:
	ld	[%sp+96], %r17
	ld	[%r17], %r16
	st	%r16, [%sp+96]
projsum_single_after_3286388:
	or	%r0, 0, %r12
	! making closure call
	ld	[%r8], %r11
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	jmpl	%r11, %r15
	mov	%r12, %r10
code_3309100:
	st	%r8, [%sp+100]
code_3308982:
	! done making normal call
	! making closure call
	sethi	%hi(_3236999), %r8
	or	%r8, %lo(_3236999), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3309079:
	mov	%r8, %r12
code_3308985:
	! done making normal call
	sethi	%hi(type_3224221), %r8
	or	%r8, %lo(type_3224221), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3236997), %r8
	or	%r8, %lo(type_3236997), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309080:
	mov	%r8, %r9
code_3308992:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309081:
	mov	%r8, %r12
code_3308993:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3236996), %r8
	or	%r8, %lo(type_3236996), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309082:
	mov	%r8, %r9
code_3309000:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3309083:
	st	%r8, [%sp+96]
code_3309001:
	! done making normal call
	sethi	%hi(type_3236668), %r8
	or	%r8, %lo(type_3236668), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r12
	sethi	%hi(type_3222555), %r8
	or	%r8, %lo(type_3222555), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	mov	%r12, %r9
	jmpl	%r13, %r15
	ld	[%sp+100], %r12
code_3309084:
	mov	%r8, %r9
code_3309008:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309009:
	! done making tail call
	ba	after_sum_3286339 ! delay slot empty
	nop
sumarm_3286343:
nomatch_sum_3286340:
	! making closure call
	sethi	%hi(_3228506), %r8
	or	%r8, %lo(_3228506), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+108], %r10
code_3309099:
	mov	%r8, %r12
code_3309013:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3244904), %r8
	or	%r8, %lo(type_3244904), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309086:
	mov	%r8, %r9
code_3309020:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+112], %r10
code_3309087:
	mov	%r8, %r12
code_3309021:
	! done making normal call
	sethi	%hi(eq_label_3193328), %r8
	or	%r8, %lo(eq_label_3193328), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3205711), %r8
	or	%r8, %lo(_3205711), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+120], %r11
code_3309088:
	mov	%r8, %r10
code_3309026:
	! done making normal call
sumarm_3286538:
	cmp	%r10, 0
	bne	sumarm_3286539
	nop
code_3309027:
	sethi	%hi(string_3273689), %r8
	or	%r8, %lo(string_3273689), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309031:
	! done making tail call
	ba	after_sum_3286535 ! delay slot empty
	nop
sumarm_3286539:
	sethi	%hi(type_3195690), %r8
	or	%r8, %lo(type_3195690), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+16], %r8
	cmp	%r8, 4
	bleu,pn	%icc,dynamic_box_3286565
	nop
code_3309035:
	cmp	%r8, 255
	bleu,pn	%icc,dynamic_nobox_3286566
	nop
code_3309036:
	ld	[%r8], %r8
	cmp	%r8, 12
	be,pn	%icc,dynamic_box_3286565
	nop
code_3309037:
	cmp	%r8, 4
	be,pn	%icc,dynamic_box_3286565
	nop
code_3309038:
	cmp	%r8, 8
	be,pn	%icc,dynamic_box_3286565
	nop
dynamic_nobox_3286566:
	ba	projsum_single_after_3286562
	mov	%r10, %r8
dynamic_box_3286565:
	ld	[%r10], %r8
projsum_single_after_3286562:
	ba	after_sum_3286535 ! delay slot empty
	nop
sumarm_3286553:
after_sum_3286535:
after_sum_3286339:
	ba	after_sum_3286320 ! delay slot empty
	nop
sumarm_3286324:
nomatch_sum_3286321:
	sethi	%hi(string_3273526), %r8
	or	%r8, %lo(string_3273526), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309098:
code_3309046:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309090:
code_3309049:
	! done making normal call
	sethi	%hi(string_3273267), %r8
	or	%r8, %lo(string_3273267), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309091:
code_3309053:
	! done making normal call
	sethi	%hi(string_3273587), %r8
	or	%r8, %lo(string_3273587), %r10
	! making closure call
	sethi	%hi(_3205508), %r8
	or	%r8, %lo(_3205508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309057:
	! done making tail call
after_sum_3286320:
	ba	after_sum_3286306 ! delay slot empty
	nop
sumarm_3286310:
nomatch_sum_3286307:
	sethi	%hi(string_3273526), %r8
	or	%r8, %lo(string_3273526), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309097:
code_3309062:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309093:
code_3309065:
	! done making normal call
	sethi	%hi(string_3273267), %r8
	or	%r8, %lo(string_3273267), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309094:
code_3309069:
	! done making normal call
	sethi	%hi(string_3273587), %r8
	or	%r8, %lo(string_3273587), %r10
	! making closure call
	sethi	%hi(_3205508), %r8
	or	%r8, %lo(_3205508), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309073:
	! done making tail call
after_sum_3286306:
code_3309075:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_projectRecordType_inner_code_3263608,(.-Normalize_projectRecordType_inner_code_3263608)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3309076
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x140f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309077
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x10100000
		! -------- label,sizes,reg
	.long code_3309078
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x13c30000
		! worddata
	.word 0x80000000
	.long reify_3245561
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long needgc_3308970
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000400
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x13c30000
		! worddata
	.word 0x80000000
	.long reify_3245561
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309079
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03070000
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309080
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03070000
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309081
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03040000
		! worddata
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309082
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03040000
		! worddata
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309083
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00040000
		! -------- label,sizes,reg
	.long code_3309084
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3236996
		! -------- label,sizes,reg
	.long code_3309086
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x13000000
		! worddata
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309087
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x10000000
		! -------- label,sizes,reg
	.long code_3309088
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309090
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309091
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309093
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309094
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309096
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x115f0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309097
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309098
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309099
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x13000000
		! worddata
	.word 0x80000000
	.long reify_3248560
		! -------- label,sizes,reg
	.long code_3309100
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x03c30000
		! worddata
	.word 0x80000000
	.long type_3224221
	.word 0x80000000
	.long type_3226630
	.word 0x80000000
	.long reify_3248560
	.text
	.align 8
	.global Normalize_projectRecordType_r_code_3263442
 ! arguments : [$3263444,$8] [$3205439,$9] [$3263445,$10] [$3205440,$11] 
 ! results    : [$3286263,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_projectRecordType_r_code_3263442:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309109
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309109:
	st	%r15, [%sp+92]
	mov	%r9, %r12
	mov	%r10, %r8
code_3309102:
funtop_3286244:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309103
	nop
code_3309104:
	call	GCFromML ! delay slot empty
	nop
needgc_3309103:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_projectRecordType_inner_code_3263608), %r8
	or	%r8, %lo(Normalize_projectRecordType_inner_code_3263608), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3309108:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_projectRecordType_r_code_3263442,(.-Normalize_projectRecordType_r_code_3263442)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309103
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3900
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_projectSumType_inner_code_3263644
 ! arguments : [$3263646,$8] [$3263647,$9] [$3237467,$10] [$3237468,$11] [$3237469,$12] 
 ! results    : [$3286203,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_projectSumType_inner_code_3263644:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309267
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3309267:
	st	%r15, [%sp+92]
	st	%r8, [%sp+100]
	mov	%r9, %r8
	st	%r10, [%sp+120]
	st	%r11, [%sp+112]
	st	%r12, [%sp+116]
code_3309110:
funtop_3285859:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8+8], %r16
	st	%r16, [%sp+108]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+100], %r9
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3309260:
	st	%r8, [%sp+96]
code_3309111:
	! done making normal call
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r10
	ld	[%sp+100], %r9
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3309240:
	st	%r8, [%sp+108]
code_3309112:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r12
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r12, %r15
	ld	[%sp+112], %r11
code_3309241:
code_3309113:
	! done making normal call
	ld	[%r8+4], %r16
	st	%r16, [%sp+96]
sumarm_3285900:
	ld	[%sp+96], %r17
	ld	[%r17], %r8
	cmp	%r8, 9
	bne	sumarm_3285901
	nop
code_3309114:
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
sumarm_3285914:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3285912
	nop
code_3309115:
	ld	[%r9], %r8
	cmp	%r8, 4
	bne	sumarm_3285915
	nop
code_3309116:
	ld	[%r9+4], %r8
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(ult_3206201), %r8
	or	%r8, %lo(ult_3206201), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3309242:
code_3309119:
	! done making normal call
	cmp	%r8, 0
	bne,pn	%icc,one_case_3285937
	nop
zero_case_3285936:
	! making closure call
	sethi	%hi(uminus_3206214), %r8
	or	%r8, %lo(uminus_3206214), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3309264:
	mov	%r8, %r10
code_3309123:
	! done making normal call
	! making closure call
	sethi	%hi(toInt_3206213), %r8
	or	%r8, %lo(toInt_3206213), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309243:
	st	%r8, [%sp+96]
code_3309126:
	! done making normal call
	! making closure call
	sethi	%hi(uminus_3206214), %r8
	or	%r8, %lo(uminus_3206214), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+116], %r10
	jmpl	%r12, %r15
	ld	[%sp+100], %r11
code_3309244:
	mov	%r8, %r10
code_3309129:
	! done making normal call
	! making closure call
	sethi	%hi(toInt_3206213), %r8
	or	%r8, %lo(toInt_3206213), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309245:
	st	%r8, [%sp+100]
code_3309132:
	! done making normal call
	add	%r4, 56, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309133
	nop
code_3309134:
	call	GCFromML ! delay slot empty
	nop
needgc_3309133:
	ld	[%sp+96], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3285980
	nop
zero_case_3285979:
	sethi	%hi(string_3274095), %r8
	or	%r8, %lo(string_3274095), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309140:
	! done making tail call
	ba	after_zeroone_3285981 ! delay slot empty
	nop
one_case_3285980:
intarm_3285997:
	ld	[%sp+96], %r17
	cmp	%r17, 1
	bne	intarm_3285998
	nop
code_3309142:
	ld	[%sp+100], %r17
	cmp	%r17, 0
	bne,pn	%icc,one_case_3286002
	nop
zero_case_3286001:
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309146:
	! done making tail call
	ba	after_zeroone_3286003 ! delay slot empty
	nop
one_case_3286002:
	or	%r0, 9, %r10
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309150
	nop
code_3309151:
	or	%r0, 0, %r8
cmpui_3309150:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 1-record
	st	%r10, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r11
	add	%r4, 8, %r4
	! done allocating 1 record
	sethi	%hi(exn_handler_3286016), %r8
	or	%r8, %lo(exn_handler_3286016), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3309238:
	st	%r8, [%sp+96]
code_3309156:
	! done making normal call
	ld	[%sp+100], %r17
	addcc	%r17, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3309157:
	! making closure call
	sethi	%hi(generate_tuple_label_3201496), %r8
	or	%r8, %lo(generate_tuple_label_3201496), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309246:
	mov	%r8, %r12
code_3309160:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r13
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r13, %r15
	ld	[%sp+96], %r11
code_3309247:
code_3309161:
	! done making normal call
	ba	exn_handler_after_3286017
	ld	[%r1+12], %r1
exn_handler_3286016:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	ld	[%r8], %r16
	st	%r16, [%sp+120]
	st	%r15, [%sp+96]
	sethi	%hi(string_3274063), %r8
	or	%r8, %lo(string_3274063), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309258:
code_3309168:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3309248:
code_3309171:
	! done making normal call
	ld	[%sp+96], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3286017:
after_zeroone_3286003:
	ba	after_intcase_3285996 ! delay slot empty
	nop
intarm_3285998:
	or	%r0, 9, %r10
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309176
	nop
code_3309177:
	or	%r0, 0, %r8
cmpui_3309176:
	sll	%r8, 8, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 1-record
	st	%r10, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	add	%r4, 4, %r11
	add	%r4, 8, %r4
	! done allocating 1 record
	sethi	%hi(exn_handler_3286084), %r8
	or	%r8, %lo(exn_handler_3286084), %r10
	ld	[%r2+808], %r8
	sub	%sp, %r8, %r9
	! allocating 4-record
	or	%r0, 3105, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	st	%r1, [%r4+16]
	add	%r4, 4, %r8
	add	%r4, 20, %r4
	! done allocating 4 record
	mov	%r8, %r1
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3309239:
	st	%r8, [%sp+96]
code_3309182:
	! done making normal call
	ld	[%sp+100], %r17
	addcc	%r17, 1, %r10
	bvs,pn	%icc,localOverflowFromML
	nop
code_3309183:
	! making closure call
	sethi	%hi(generate_tuple_label_3201496), %r8
	or	%r8, %lo(generate_tuple_label_3201496), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309249:
	mov	%r8, %r12
code_3309186:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r13
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r9
	ld	[%sp+120], %r10
	jmpl	%r13, %r15
	ld	[%sp+96], %r11
code_3309250:
code_3309187:
	! done making normal call
	ba	exn_handler_after_3286085
	ld	[%r1+12], %r1
exn_handler_3286084:
	ld	[%r1+8], %r8
	ld	[%r1+12], %r1
	ld	[%r8], %r16
	st	%r16, [%sp+120]
	st	%r15, [%sp+96]
	sethi	%hi(string_3274063), %r8
	or	%r8, %lo(string_3274063), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309259:
code_3309194:
	! done making normal call
	! making closure call
	sethi	%hi(_3223113), %r8
	or	%r8, %lo(_3223113), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+120], %r10
code_3309251:
code_3309197:
	! done making normal call
	ld	[%sp+96], %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r8
	add	%sp, %r8, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r8
exn_handler_after_3286085:
after_intcase_3285996:
after_zeroone_3285981:
	ba	after_zeroone_3285938 ! delay slot empty
	nop
one_case_3285937:
	sethi	%hi(string_3274133), %r8
	or	%r8, %lo(string_3274133), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309203:
	! done making tail call
after_zeroone_3285938:
	ba	after_sum_3285911 ! delay slot empty
	nop
sumarm_3285915:
nomatch_sum_3285912:
	sethi	%hi(string_3273915), %r8
	or	%r8, %lo(string_3273915), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309262:
code_3309208:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309252:
code_3309211:
	! done making normal call
	sethi	%hi(string_3273267), %r8
	or	%r8, %lo(string_3273267), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309253:
code_3309215:
	! done making normal call
	sethi	%hi(string_3273954), %r8
	or	%r8, %lo(string_3273954), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309219:
	! done making tail call
after_sum_3285911:
	ba	after_sum_3285897 ! delay slot empty
	nop
sumarm_3285901:
nomatch_sum_3285898:
	sethi	%hi(string_3273915), %r8
	or	%r8, %lo(string_3273915), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309261:
code_3309224:
	! done making normal call
	! making closure call
	sethi	%hi(_3223132), %r8
	or	%r8, %lo(_3223132), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309255:
code_3309227:
	! done making normal call
	sethi	%hi(string_3273267), %r8
	or	%r8, %lo(string_3273267), %r10
	! making closure call
	sethi	%hi(print), %r8
	or	%r8, %lo(print), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309256:
code_3309231:
	! done making normal call
	sethi	%hi(string_3273954), %r8
	or	%r8, %lo(string_3273954), %r10
	! making closure call
	sethi	%hi(_3195284), %r8
	or	%r8, %lo(_3195284), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 128, %sp
code_3309235:
	! done making tail call
after_sum_3285897:
code_3309237:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_projectSumType_inner_code_3263644,(.-Normalize_projectSumType_inner_code_3263644)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3309238
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30400000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309239
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30400000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309240
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x33010000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309241
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30400000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309242
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309243
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309244
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309245
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3309133
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309246
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30430000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309247
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309248
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3309249
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30430000
		! worddata
	.word 0x80000000
	.long type_3193062
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309250
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309251
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long code_3309252
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309253
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309255
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309256
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309258
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30010000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309259
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30010000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309260
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x33540000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309261
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309262
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000002
	.long _c_3044472
		! -------- label,sizes,reg
	.long code_3309264
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x30700000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_projectSumType_r_code_3263447
 ! arguments : [$3263449,$8] [$3206100,$9] [$3263450,$10] [$3206101,$11] 
 ! results    : [$3285854,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_projectSumType_r_code_3263447:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309275
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309275:
	st	%r15, [%sp+92]
	mov	%r9, %r12
	mov	%r10, %r8
code_3309268:
funtop_3285835:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309269
	nop
code_3309270:
	call	GCFromML ! delay slot empty
	nop
needgc_3309269:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_projectSumType_inner_code_3263644), %r8
	or	%r8, %lo(Normalize_projectSumType_inner_code_3263644), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3309274:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_projectSumType_r_code_3263447,(.-Normalize_projectSumType_r_code_3263447)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309269
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3900
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_reduce_vararg_inner_code_3263659
 ! arguments : [$3263661,$8] [$3263662,$9] [$3237626,$10] [$3237627,$11] [$3237628,$12] [$3237629,$13] [$3237630,$18] 
 ! results    : [$3285823,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_reduce_vararg_inner_code_3263659:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309332
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3309332:
	st	%r15, [%sp+92]
	mov	%r8, %r19
	st	%r10, [%sp+104]
	st	%r11, [%sp+120]
	st	%r12, [%sp+116]
	st	%r13, [%sp+108]
	st	%r18, [%sp+112]
code_3309276:
funtop_3285581:
	add	%r4, 140, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309277
	nop
code_3309278:
	call	GCFromML ! delay slot empty
	nop
needgc_3309277:
	ld	[%r9], %r8
	ld	[%r9+4], %r11
	! allocating 2-record
	sethi	%hi(gctag_3203192), %r9
	ld	[%r9+%lo(gctag_3203192)], %r9
	st	%r9, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 5, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r12
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r9
	ld	[%r9+%lo(gctag_3198455)], %r9
	st	%r9, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r9
	ld	[%r9+%lo(gctag_3198455)], %r9
	st	%r9, [%r4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r9
	ld	[%r9+%lo(gctag_3198155)], %r9
	st	%r9, [%r4]
	st	%r12, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 9, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203302), %r9
	ld	[%r9+%lo(gctag_3203302)], %r9
	st	%r9, [%r4]
	or	%r0, 0, %r9
	st	%r9, [%r4+4]
	ld	[%sp+108], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203338), %r9
	ld	[%r9+%lo(gctag_3203338)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 7-record
	sethi	%hi(gctag_3203379), %r9
	ld	[%r9+%lo(gctag_3203379)], %r9
	st	%r9, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	ld	[%sp+112], %r17
	st	%r17, [%r4+12]
	st	%r10, [%r4+16]
	or	%r0, 0, %r9
	st	%r9, [%r4+20]
	or	%r0, 0, %r9
	st	%r9, [%r4+24]
	or	%r0, 0, %r9
	st	%r9, [%r4+28]
	add	%r4, 4, %r10
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r9
	st	%r9, [%r4]
	or	%r0, 0, %r9
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+100]
	add	%r4, 12, %r4
	! done allocating 2 record
	! making closure call
	ld	[%r8], %r12
	ld	[%r8+4], %r9
	ld	[%r8+8], %r10
	mov	%r9, %r8
	jmpl	%r12, %r15
	mov	%r19, %r9
code_3309330:
	mov	%r8, %r9
code_3309287:
	! done making normal call
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3309326:
code_3309288:
	! done making normal call
	ld	[%r8], %r10
	ld	[%r8+4], %r9
sumarm_3285707:
	ld	[%r9], %r8
	cmp	%r8, 9
	bne	sumarm_3285708
	nop
code_3309289:
	ld	[%r9+4], %r8
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
sumarm_3285721:
	or	%r0, 255, %r8
	cmp	%r9, %r8
	bleu	nomatch_sum_3285719
	nop
code_3309290:
	ld	[%r9], %r8
	cmp	%r8, 3
	bne	sumarm_3285722
	nop
code_3309291:
	ld	[%r9+4], %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3235075), %r8
	or	%r8, %lo(_3235075), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309327:
	mov	%r8, %r10
code_3309294:
	! done making normal call
	sethi	%hi(flattenThreshold_3193125), %r8
	or	%r8, %lo(flattenThreshold_3193125), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	! int sub start
	ld	[%r8], %r8
	! int sub end
	cmp	%r10, %r8
	or	%r0, 1, %r8
	bg	cmpsi_3309297
	nop
code_3309298:
	or	%r0, 0, %r8
cmpsi_3309297:
	cmp	%r8, 0
	bne,pn	%icc,one_case_3285750
	nop
zero_case_3285749:
	sethi	%hi(anonfun_3049197), %r8
	or	%r8, %lo(anonfun_3049197), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(_3203486), %r8
	or	%r8, %lo(_3203486), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309331:
	mov	%r8, %r12
code_3309304:
	! done making normal call
	sethi	%hi(type_3248940), %r8
	or	%r8, %lo(type_3248940), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	sethi	%hi(type_3253680), %r8
	or	%r8, %lo(type_3253680), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r18
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r10
	ld	[%r2+804], %r8
	add	%r10, %r8, %r8
	ld	[%r8], %r10
	ld	[%r10], %r13
	ld	[%r10+4], %r8
	ld	[%r10+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r10
code_3309328:
	mov	%r8, %r9
code_3309311:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+104], %r10
code_3309329:
	mov	%r8, %r9
code_3309312:
	! done making normal call
	add	%r4, 44, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309313
	nop
code_3309314:
	call	GCFromML ! delay slot empty
	nop
needgc_3309313:
	! allocating 7-record
	sethi	%hi(gctag_3203379), %r8
	ld	[%r8+%lo(gctag_3203379)], %r8
	st	%r8, [%r4]
	ld	[%sp+120], %r17
	st	%r17, [%r4+4]
	ld	[%sp+116], %r17
	st	%r17, [%r4+8]
	ld	[%sp+112], %r17
	st	%r17, [%r4+12]
	st	%r9, [%r4+16]
	or	%r0, 0, %r8
	st	%r8, [%r4+20]
	or	%r0, 0, %r8
	st	%r8, [%r4+24]
	or	%r0, 0, %r8
	st	%r8, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_zeroone_3285751 ! delay slot empty
	nop
one_case_3285750:
	ld	[%sp+100], %r8
after_zeroone_3285751:
	ba	after_sum_3285718 ! delay slot empty
	nop
sumarm_3285722:
nomatch_sum_3285719:
sumarm_3285817:
	cmp	%r10, 1
	bne	sumarm_3285818
	nop
code_3309319:
	ba	after_sum_3285814
	ld	[%sp+100], %r8
sumarm_3285818:
nomatch_sum_3285815:
	ld	[%sp+96], %r8
after_sum_3285814:
after_sum_3285718:
	ba	after_sum_3285704 ! delay slot empty
	nop
sumarm_3285708:
nomatch_sum_3285705:
sumarm_3285829:
	cmp	%r10, 1
	bne	sumarm_3285830
	nop
code_3309322:
	ba	after_sum_3285826
	ld	[%sp+100], %r8
sumarm_3285830:
nomatch_sum_3285827:
	ld	[%sp+96], %r8
after_sum_3285826:
after_sum_3285704:
code_3309325:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_reduce_vararg_inner_code_3263659,(.-Normalize_reduce_vararg_inner_code_3263659)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309277
	.word 0x00200011
	.word 0x00170000
	.word 0x00080200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3ff00000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3309326
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f050000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3309327
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f340000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3309328
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f300000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3309329
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long needgc_3309313
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x3f000000
		! worddata
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.word 0x80000000
	.long type_3253680
		! -------- label,sizes,reg
	.long code_3309330
	.word 0x00200011
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3ff50000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000002
	.long _c_3044472
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
		! -------- label,sizes,reg
	.long code_3309331
	.word 0x0020000f
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x3f300000
		! worddata
	.word 0x80000000
	.long reify_3248560
	.word 0x80000002
	.long _c_3044472
	.word 0x80000000
	.long type_3198371
	.word 0x80000000
	.long type_3197340
	.text
	.align 8
	.global Normalize_reduce_vararg_r_code_3263452
 ! arguments : [$3263454,$8] [$3206328,$9] [$3263455,$10] [$3206329,$11] 
 ! results    : [$3285576,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_reduce_vararg_r_code_3263452:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309340
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309340:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3309333:
funtop_3285562:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309334
	nop
code_3309335:
	call	GCFromML ! delay slot empty
	nop
needgc_3309334:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_reduce_vararg_inner_code_3263659), %r8
	or	%r8, %lo(Normalize_reduce_vararg_inner_code_3263659), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3309339:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_reduce_vararg_r_code_3263452,(.-Normalize_reduce_vararg_r_code_3263452)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309334
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_type_of_switch_r_code_3263457
 ! arguments : [$3263459,$8] [$3206758,$9] [$3263460,$10] [$3206759,$11] 
 ! results    : [$3285561,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_type_of_switch_r_code_3263457:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309345
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309345:
	st	%r15, [%sp+92]
code_3309341:
funtop_3285558:
	sethi	%hi(type_of_switch_inner_3050317), %r8
	or	%r8, %lo(type_of_switch_inner_3050317), %r8
code_3309344:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_type_of_switch_r_code_3263457,(.-Normalize_type_of_switch_r_code_3263457)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_type_of_value_inner_code_3263671
 ! arguments : [$3263673,$8] [$3263674,$9] [$3237772,$10] [$3237773,$11] 
 ! results    : [$3285286,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_type_of_value_inner_code_3263671:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309400
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3309400:
	st	%r15, [%sp+92]
	mov	%r8, %r13
	mov	%r9, %r8
	st	%r10, [%sp+100]
	st	%r11, [%sp+104]
code_3309346:
funtop_3285197:
	ld	[%r8], %r9
	ld	[%r8+4], %r11
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	jmpl	%r12, %r15
	mov	%r13, %r9
code_3309399:
	st	%r8, [%sp+96]
code_3309347:
	! done making normal call
	add	%r4, 216, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309348
	nop
code_3309349:
	call	GCFromML ! delay slot empty
	nop
needgc_3309348:
sumarm_3285229:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 0
	bne	sumarm_3285230
	nop
code_3309351:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285230:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 1
	bne	sumarm_3285287
	nop
code_3309355:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r11
	or	%r0, 17, %r10
	sethi	%hi(Prim_STR_c_INT), %r8
	or	%r8, %lo(Prim_STR_c_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+12], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309358
	nop
code_3309359:
	or	%r0, 0, %r8
cmpui_3309358:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 1, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285287:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 2
	bne	sumarm_3285331
	nop
code_3309362:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r11
	or	%r0, 17, %r10
	sethi	%hi(Prim_STR_c_INT), %r8
	or	%r8, %lo(Prim_STR_c_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309365
	nop
code_3309366:
	or	%r0, 0, %r8
cmpui_3309365:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285331:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 3
	bne	sumarm_3285375
	nop
code_3309369:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r12
	sethi	%hi(type_3193068), %r8
	or	%r8, %lo(type_3193068), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	or	%r0, 0, %r10
	! making direct call 
	sethi	%hi(polySub_INT), %r8
	ld	[%r8+%lo(polySub_INT)], %r11
	mov	%r9, %r8
	jmpl	%r11, %r15
	mov	%r12, %r9
code_3309397:
	mov	%r8, %r11
code_3309373:
	! done making normal call
	! making closure call
	ld	[%sp+96], %r17
	ld	[%r17], %r12
	ld	[%sp+96], %r17
	ld	[%r17+4], %r8
	ld	[%sp+96], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+100], %r10
code_3309398:
	mov	%r8, %r9
code_3309374:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309375
	nop
code_3309376:
	call	GCFromML ! delay slot empty
	nop
needgc_3309375:
	! allocating 2-record
	sethi	%hi(gctag_3207133), %r8
	ld	[%r8+%lo(gctag_3207133)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285375:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 4
	bne	sumarm_3285424
	nop
code_3309381:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285424:
	ld	[%sp+104], %r17
	ld	[%r17], %r8
	cmp	%r8, 5
	bne	sumarm_3285469
	nop
code_3309385:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r11
	or	%r0, 17, %r10
	sethi	%hi(Prim_STR_c_INT), %r8
	or	%r8, %lo(Prim_STR_c_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309388
	nop
code_3309389:
	or	%r0, 0, %r8
cmpui_3309388:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285469:
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 5, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3285226 ! delay slot empty
	nop
sumarm_3285513:
after_sum_3285226:
code_3309396:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_type_of_value_inner_code_3263671,(.-Normalize_type_of_value_inner_code_3263671)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309348
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003d0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3249421
		! -------- label,sizes,reg
	.long code_3309397
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x000d0000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309398
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long needgc_3309375
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long code_3309399
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3249421
	.text
	.align 8
	.global Normalize_type_of_value_r_code_3263462
 ! arguments : [$3263464,$8] [$3206852,$9] [$3263465,$10] [$3206853,$11] 
 ! results    : [$3285192,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_type_of_value_r_code_3263462:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309408
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309408:
	st	%r15, [%sp+92]
	mov	%r9, %r12
code_3309401:
funtop_3285178:
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309402
	nop
code_3309403:
	call	GCFromML ! delay slot empty
	nop
needgc_3309402:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_type_of_value_inner_code_3263671), %r8
	or	%r8, %lo(Normalize_type_of_value_inner_code_3263671), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3309407:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_type_of_value_r_code_3263462,(.-Normalize_type_of_value_r_code_3263462)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309402
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3c00
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_type_of_fbnd_r_code_3263467
 ! arguments : [$3263469,$8] [$3207363,$9] [$3263470,$10] [$3207364,$11] 
 ! results    : [$3285177,$8] 
 ! destroys   :  $11 $10 $9 $8
 ! modifies   :  $11 $10 $9 $8
Normalize_type_of_fbnd_r_code_3263467:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309413
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309413:
	st	%r15, [%sp+92]
code_3309409:
funtop_3285174:
	sethi	%hi(type_of_fbnd_inner_3050319), %r8
	or	%r8, %lo(type_of_fbnd_inner_3050319), %r8
code_3309412:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_type_of_fbnd_r_code_3263467,(.-Normalize_type_of_fbnd_r_code_3263467)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_folder_code_3263692
 ! arguments : [$3263694,$8] [$3263695,$9] [$3238142,$10] [$3238143,$11] 
 ! results    : [$3284996,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_folder_code_3263692:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 112, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309502
	nop
	add	%sp, 112, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 112, %sp
code_3309502:
	st	%r15, [%sp+92]
	st	%r11, [%sp+104]
code_3309414:
funtop_3284848:
	add	%r4, 140, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309415
	nop
code_3309416:
	call	GCFromML ! delay slot empty
	nop
needgc_3309415:
	ld	[%r9], %r8
	ld	[%r9+4], %r13
sumarm_3284859:
	ld	[%r10], %r9
	cmp	%r9, 0
	bne	sumarm_3284860
	nop
code_3309418:
	ld	[%r10+4], %r8
	ld	[%r8+4], %r10
	! allocating 2-record
	sethi	%hi(gctag_3197820), %r8
	ld	[%r8+%lo(gctag_3197820)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207929), %r9
	ld	[%r9+%lo(gctag_3207929)], %r9
	st	%r9, [%r4]
	or	%r0, 0, %r9
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r16
	st	%r16, [%sp+96]
	add	%r4, 12, %r4
	! done allocating 2 record
sumarm_3284892:
	ld	[%r10], %r9
	cmp	%r9, 0
	bne	sumarm_3284893
	nop
code_3309421:
	ld	[%r10+4], %r9
	ld	[%r9], %r11
	! allocating 2-record
	or	%r0, 17, %r9
	st	%r9, [%r4]
	or	%r0, 13, %r9
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r9
	ld	[%r9+%lo(gctag_3197849)], %r9
	st	%r9, [%r4]
	or	%r0, 1, %r9
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198680), %r8
	ld	[%r8+%lo(gctag_3198680)], %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284889 ! delay slot empty
	nop
sumarm_3284893:
	ld	[%r10], %r9
	cmp	%r9, 1
	bne	sumarm_3284927
	nop
code_3309425:
	ld	[%r10+4], %r8
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 2-record
	sethi	%hi(gctag_3198680), %r8
	ld	[%r8+%lo(gctag_3198680)], %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284889 ! delay slot empty
	nop
sumarm_3284927:
	ld	[%r10+4], %r9
	ld	[%r9], %r11
	! allocating 2-record
	or	%r0, 17, %r9
	st	%r9, [%r4]
	or	%r0, 13, %r9
	st	%r9, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	sethi	%hi(gctag_3197849), %r9
	ld	[%r9+%lo(gctag_3197849)], %r9
	st	%r9, [%r4]
	or	%r0, 1, %r9
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	st	%r10, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 7, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198680), %r8
	ld	[%r8+%lo(gctag_3198680)], %r8
	st	%r8, [%r4]
	st	%r11, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284889 ! delay slot empty
	nop
sumarm_3284942:
after_sum_3284889:
	ld	[%r8], %r11
	ld	[%r8+4], %r12
	! making closure call
	sethi	%hi(strbindvar_r_insert_equation_3193981), %r8
	or	%r8, %lo(strbindvar_r_insert_equation_3193981), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r13, %r15
	ld	[%sp+104], %r10
code_3309492:
	mov	%r8, %r9
code_3309433:
	! done making normal call
	add	%r4, 12, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309434
	nop
code_3309435:
	call	GCFromML ! delay slot empty
	nop
needgc_3309434:
	! allocating 2-record
	sethi	%hi(gctag_3207944), %r8
	ld	[%r8+%lo(gctag_3207944)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284856 ! delay slot empty
	nop
sumarm_3284860:
	ld	[%r10], %r9
	cmp	%r9, 1
	bne	sumarm_3284997
	nop
code_3309439:
	ld	[%r10+4], %r8
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r11
	! making closure call
	ld	[%r13], %r12
	ld	[%r13+4], %r8
	ld	[%r13+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+104], %r10
code_3309493:
	st	%r8, [%sp+96]
code_3309440:
	! done making normal call
	! making closure call
	sethi	%hi(strbindvar_r_insert_con_3193976), %r8
	or	%r8, %lo(strbindvar_r_insert_con_3193976), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	ld	[%sp+100], %r11
	jmpl	%r13, %r15
	ld	[%sp+96], %r12
code_3309494:
code_3309443:
	! done making normal call
	add	%r4, 48, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309444
	nop
code_3309445:
	call	GCFromML ! delay slot empty
	nop
needgc_3309444:
	! allocating 2-record
	sethi	%hi(gctag_3207971), %r9
	ld	[%r9+%lo(gctag_3207971)], %r9
	st	%r9, [%r4]
	ld	[%sp+100], %r17
	st	%r17, [%r4+4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207998), %r9
	ld	[%r9+%lo(gctag_3207998)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207929), %r9
	ld	[%r9+%lo(gctag_3207929)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	or	%r0, 0, %r9
	st	%r9, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207944), %r9
	ld	[%r9+%lo(gctag_3207944)], %r9
	st	%r9, [%r4]
	st	%r10, [%r4+4]
	st	%r8, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284856 ! delay slot empty
	nop
sumarm_3284997:
	ld	[%r10], %r9
	cmp	%r9, 2
	bne	sumarm_3285057
	nop
code_3309452:
	ld	[%r10+4], %r8
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(_3238221), %r8
	or	%r8, %lo(_3238221), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309495:
	st	%r8, [%sp+96]
code_3309455:
	! done making normal call
	sethi	%hi(anonfun_3049548), %r8
	or	%r8, %lo(anonfun_3049548), %r10
	! making closure call
	sethi	%hi(_3208097), %r8
	or	%r8, %lo(_3208097), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309496:
	mov	%r8, %r12
code_3309459:
	! done making normal call
	sethi	%hi(type_3252291), %r8
	or	%r8, %lo(type_3252291), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3224280), %r8
	or	%r8, %lo(type_3224280), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309497:
	mov	%r8, %r9
code_3309466:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309498:
	st	%r8, [%sp+96]
code_3309467:
	! done making normal call
	! making closure call
	sethi	%hi(strbindvar_r_insert_con_list_3207482), %r8
	or	%r8, %lo(strbindvar_r_insert_con_list_3207482), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+104], %r10
	jmpl	%r12, %r15
	ld	[%sp+96], %r11
code_3309499:
	mov	%r8, %r10
code_3309470:
	! done making normal call
	add	%r4, 24, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309471
	nop
code_3309472:
	call	GCFromML ! delay slot empty
	nop
needgc_3309471:
	! allocating 2-record
	sethi	%hi(gctag_3207929), %r8
	ld	[%r8+%lo(gctag_3207929)], %r8
	st	%r8, [%r4]
	ld	[%sp+96], %r17
	st	%r17, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3207944), %r8
	ld	[%r8+%lo(gctag_3207944)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	st	%r10, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284856 ! delay slot empty
	nop
sumarm_3285057:
	ld	[%r10], %r9
	cmp	%r9, 3
	bne	sumarm_3285130
	nop
code_3309477:
	sethi	%hi(type_3199943), %r9
	or	%r9, %lo(type_3199943), %r11
	ld	[%r2+804], %r9
	add	%r11, %r9, %r9
	ld	[%r9], %r9
	ld	[%r10+4], %r13
	or	%r0, 1, %r11
	sethi	%hi(record_temp_3049563), %r9
	or	%r9, %lo(record_temp_3049563), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r12
	! making closure call
	ld	[%r8], %r18
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r18, %r0
	add	%sp, 112, %sp
code_3309482:
	! done making tail call
	ba	after_sum_3284856 ! delay slot empty
	nop
sumarm_3285130:
	sethi	%hi(type_3199943), %r9
	or	%r9, %lo(type_3199943), %r11
	ld	[%r2+804], %r9
	add	%r11, %r9, %r9
	ld	[%r9], %r9
	ld	[%r10+4], %r13
	or	%r0, 2, %r11
	sethi	%hi(record_temp_3049574), %r9
	or	%r9, %lo(record_temp_3049574), %r10
	ld	[%r2+804], %r9
	add	%r10, %r9, %r9
	ld	[%r9], %r12
	! making closure call
	ld	[%r8], %r18
	ld	[%r8+4], %r10
	ld	[%r8+8], %r9
	mov	%r10, %r8
	ld	[%sp+104], %r10
	ld	[%sp+92], %r15
	jmpl	%r18, %r0
	add	%sp, 112, %sp
code_3309488:
	! done making tail call
	ba	after_sum_3284856 ! delay slot empty
	nop
sumarm_3285152:
after_sum_3284856:
code_3309491:
	ld	[%sp+92], %r15
	retl
	add	%sp, 112, %sp
	.size Normalize_folder_code_3263692,(.-Normalize_folder_code_3263692)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3309492
	.word 0x001c0007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! -------- label,sizes,reg
	.long needgc_3309415
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000001
	.long _c_3044472
		! -------- label,sizes,reg
	.long needgc_3309434
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00010000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309493
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309494
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3222555
		! -------- label,sizes,reg
	.long needgc_3309444
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000100
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3222555
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309495
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309496
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3252291
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309497
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3252291
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309498
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309499
	.word 0x001c0009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3224280
		! -------- label,sizes,reg
	.long needgc_3309471
	.word 0x001c000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000400
		! stacktrace
	.word 0x00000000
	.word 0x00030000
		! worddata
	.word 0x80000000
	.long type_3224280
	.word 0x80000000
	.long type_3193048
	.text
	.align 8
	.global Normalize_type_of_bnds_inner_code_3263683
 ! arguments : [$3263685,$8] [$3263686,$9] [$3238133,$10] [$3238134,$11] 
 ! results    : [$3284845,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_type_of_bnds_inner_code_3263683:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 128, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309554
	nop
	add	%sp, 128, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 128, %sp
code_3309554:
	st	%r15, [%sp+92]
	st	%r8, [%sp+100]
	mov	%r9, %r8
	st	%r10, [%sp+96]
	st	%r11, [%sp+116]
code_3309503:
funtop_3284707:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	ld	[%r8+8], %r16
	st	%r16, [%sp+108]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+100], %r9
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3309552:
	st	%r8, [%sp+112]
code_3309504:
	! done making normal call
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r10
	ld	[%sp+100], %r9
	jmpl	%r12, %r15
	ld	[%sp+108], %r11
code_3309544:
	mov	%r8, %r9
code_3309505:
	! done making normal call
	add	%r4, 28, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309506
	nop
code_3309507:
	call	GCFromML ! delay slot empty
	nop
needgc_3309506:
	! allocating 1 closures
	! allocating 2-record
	or	%r0, 785, %r8
	st	%r8, [%r4]
	ld	[%sp+112], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_folder_code_3263692), %r8
	or	%r8, %lo(Normalize_folder_code_3263692), %r8
	st	%r8, [%r4+4]
	or	%r0, 256, %r8
	st	%r8, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r10
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
	! making closure call
	sethi	%hi(_3208275), %r8
	or	%r8, %lo(_3208275), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309553:
	mov	%r8, %r12
code_3309512:
	! done making normal call
	sethi	%hi(type_3193048), %r8
	or	%r8, %lo(type_3193048), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3238587), %r8
	or	%r8, %lo(type_3238587), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309545:
	mov	%r8, %r9
code_3309519:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+96], %r10
code_3309546:
	mov	%r8, %r12
code_3309520:
	! done making normal call
	sethi	%hi(type_3231391), %r8
	or	%r8, %lo(type_3231391), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r18
	sethi	%hi(type_3238586), %r8
	or	%r8, %lo(type_3238586), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r10
	! making closure call
	sethi	%hi(onearg_INT), %r8
	or	%r8, %lo(onearg_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r13
	ld	[%r9+4], %r8
	ld	[%r9+8], %r11
	jmpl	%r13, %r15
	mov	%r18, %r9
code_3309547:
	mov	%r8, %r9
code_3309527:
	! done making normal call
	! making closure call
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+116], %r10
code_3309548:
code_3309528:
	! done making normal call
	ld	[%r8], %r10
	ld	[%r8+4], %r16
	st	%r16, [%sp+104]
	! making closure call
	sethi	%hi(_3238677), %r8
	or	%r8, %lo(_3238677), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309549:
code_3309531:
	! done making normal call
	ld	[%r8], %r16
	st	%r16, [%sp+100]
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(_3238713), %r8
	or	%r8, %lo(_3238713), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	jmpl	%r11, %r15
	ld	[%r9+8], %r9
code_3309550:
	st	%r8, [%sp+96]
code_3309534:
	! done making normal call
	! making closure call
	sethi	%hi(_3238749), %r8
	or	%r8, %lo(_3238749), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+100], %r10
code_3309551:
	mov	%r8, %r9
code_3309537:
	! done making normal call
	add	%r4, 16, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309538
	nop
code_3309539:
	call	GCFromML ! delay slot empty
	nop
needgc_3309538:
	! allocating 3-record
	sethi	%hi(gctag_3208332), %r8
	ld	[%r8+%lo(gctag_3208332)], %r8
	st	%r8, [%r4]
	ld	[%sp+104], %r17
	st	%r17, [%r4+4]
	st	%r9, [%r4+8]
	ld	[%sp+96], %r17
	st	%r17, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
code_3309543:
	ld	[%sp+92], %r15
	retl
	add	%sp, 128, %sp
	.size Normalize_type_of_bnds_inner_code_3263683,(.-Normalize_type_of_bnds_inner_code_3263683)

	.section	".rodata"
		! -------- label,sizes,reg
	.long code_3309544
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long needgc_3309506
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000200
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0d030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3309545
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3309546
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c000000
		! worddata
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3309547
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c000000
		! worddata
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3309548
	.word 0x00200007
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
		! -------- label,sizes,reg
	.long code_3309549
	.word 0x00200009
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00300000
		! worddata
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309550
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x003c0000
		! worddata
	.word 0x80000000
	.long type_3238672
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long code_3309551
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3227168
	.word 0x80000000
	.long type_3193048
		! -------- label,sizes,reg
	.long needgc_3309538
	.word 0x0020000d
	.word 0x00170000
	.word 0x00000000
	.word 0x00000200
		! stacktrace
	.word 0x00000000
	.word 0x00330000
		! worddata
	.word 0x80000000
	.long type_3227168
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long type_3252392
		! -------- label,sizes,reg
	.long code_3309552
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c570000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
		! -------- label,sizes,reg
	.long code_3309553
	.word 0x0020000b
	.word 0x00170000
	.word 0x00000000
	.word 0x00000000
		! stacktrace
	.word 0x00000000
	.word 0x0c030000
		! worddata
	.word 0x80000000
	.long type_3193048
	.word 0x80000000
	.long reify_3250107
	.text
	.align 8
	.global Normalize_type_of_bnds_r_code_3263472
 ! arguments : [$3263474,$8] [$3207584,$9] [$3263475,$10] [$3207585,$11] 
 ! results    : [$3284702,$8] 
 ! destroys   :  $12 $11 $10 $9 $8
 ! modifies   :  $12 $11 $10 $9 $8
Normalize_type_of_bnds_r_code_3263472:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309562
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309562:
	st	%r15, [%sp+92]
	mov	%r9, %r12
	mov	%r10, %r8
code_3309555:
funtop_3284683:
	add	%r4, 32, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309556
	nop
code_3309557:
	call	GCFromML ! delay slot empty
	nop
needgc_3309556:
	ld	[%r8], %r10
	ld	[%r8+4], %r9
	! allocating 1 closures
	! allocating 3-record
	or	%r0, 1817, %r8
	st	%r8, [%r4]
	st	%r10, [%r4+4]
	st	%r9, [%r4+8]
	st	%r11, [%r4+12]
	add	%r4, 4, %r9
	add	%r4, 16, %r4
	! done allocating 3 record
	! allocating 3-record
	or	%r0, 1561, %r8
	st	%r8, [%r4]
	sethi	%hi(Normalize_type_of_bnds_inner_code_3263683), %r8
	or	%r8, %lo(Normalize_type_of_bnds_inner_code_3263683), %r8
	st	%r8, [%r4+4]
	st	%r12, [%r4+8]
	st	%r9, [%r4+12]
	add	%r4, 4, %r8
	add	%r4, 16, %r4
	! done allocating 3 record
	! done allocating 1 closures
code_3309561:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_type_of_bnds_r_code_3263472,(.-Normalize_type_of_bnds_r_code_3263472)

	.section	".rodata"
		! -------- label,sizes,reg
	.long needgc_3309556
	.word 0x00180007
	.word 0x00170000
	.word 0xbffc3900
	.word 0xbffc2000
		! stacktrace
	.word 0x00000000
	.word 0x00000000
	.text
	.align 8
	.global Normalize_anonfun_code_3263720
 ! arguments : [$3263722,$8] [$3263723,$9] [$3049929,$10] 
 ! results    : [$3284682,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_anonfun_code_3263720:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 96, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309568
	nop
	add	%sp, 96, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 96, %sp
code_3309568:
	st	%r15, [%sp+92]
	mov	%r9, %r8
	mov	%r10, %r11
code_3309563:
funtop_3284669:
	ld	[%r8], %r9
	ld	[%r8+4], %r10
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 96, %sp
code_3309564:
	! done making tail call
code_3309566:
	ld	[%sp+92], %r15
	retl
	add	%sp, 96, %sp
	.size Normalize_anonfun_code_3263720,(.-Normalize_anonfun_code_3263720)

	.section	".rodata"
	.text
	.align 8
	.global Normalize_type_of_prim_inner_code_3263707
 ! arguments : [$3263709,$8] [$3263710,$9] [$3238752,$10] [$3238753,$11] [$3238754,$12] [$3238755,$13] 
 ! results    : [$3283831,$8] 
 ! destroys   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
 ! modifies   :  $f58 $f56 $f54 $f52 $f50 $f48 $f46 $f44 $f42 $f40 $f38 $f36 $f34 $f32 $f30 $f28 $f26 $f24 $f22 $f20 $f18 $f16 $f14 $f12 $f10 $f8 $f6 $f4 $f2 $f0 $31 $29 $28 $27 $26 $25 $24 $23 $22 $21 $20 $19 $18 $13 $12 $11 $10 $9 $8
Normalize_type_of_prim_inner_code_3263707:
	.proc   07
	mov	%sp, %fp
	sub	%sp, 160, %sp
	ld	[%r2+800], %r16
	cmp	%sp, %r16
	bgu	code_3309823
	nop
	add	%sp, 160, %sp
	or	%r0, 0, %r16
	mov	%r15, %r17
	call	NewStackletFromML ! delay slot empty
	nop
	sub	%sp, 160, %sp
code_3309823:
	st	%r15, [%sp+92]
	st	%r8, [%sp+96]
	mov	%r9, %r8
	st	%r10, [%sp+148]
	st	%r11, [%sp+144]
	st	%r12, [%sp+140]
	st	%r13, [%sp+136]
code_3309569:
funtop_3283749:
	ld	[%r8], %r9
	ld	[%r8+4], %r16
	st	%r16, [%sp+100]
	ld	[%r8+8], %r16
	st	%r16, [%sp+104]
	ld	[%r8+12], %r16
	st	%r16, [%sp+108]
	ld	[%r8+16], %r16
	st	%r16, [%sp+112]
	ld	[%r8+20], %r16
	st	%r16, [%sp+116]
	ld	[%r8+24], %r16
	st	%r16, [%sp+120]
	! making closure call
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309821:
	st	%r8, [%sp+124]
code_3309570:
	! done making normal call
	! making closure call
	ld	[%sp+100], %r17
	ld	[%r17], %r12
	ld	[%sp+100], %r17
	ld	[%r17+4], %r8
	ld	[%sp+100], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309789:
	st	%r8, [%sp+132]
code_3309571:
	! done making normal call
	! making closure call
	ld	[%sp+104], %r17
	ld	[%r17], %r12
	ld	[%sp+104], %r17
	ld	[%r17+4], %r8
	ld	[%sp+104], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309790:
	st	%r8, [%sp+128]
code_3309572:
	! done making normal call
	! making closure call
	ld	[%sp+108], %r17
	ld	[%r17], %r12
	ld	[%sp+108], %r17
	ld	[%r17+4], %r8
	ld	[%sp+108], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309791:
	st	%r8, [%sp+108]
code_3309573:
	! done making normal call
	! making closure call
	ld	[%sp+112], %r17
	ld	[%r17], %r12
	ld	[%sp+112], %r17
	ld	[%r17+4], %r8
	ld	[%sp+112], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309792:
	st	%r8, [%sp+104]
code_3309574:
	! done making normal call
	! making closure call
	ld	[%sp+116], %r17
	ld	[%r17], %r12
	ld	[%sp+116], %r17
	ld	[%r17+4], %r8
	ld	[%sp+116], %r17
	ld	[%r17+8], %r10
	ld	[%sp+96], %r9
	jmpl	%r12, %r15
	ld	[%sp+120], %r11
code_3309793:
	st	%r8, [%sp+100]
code_3309575:
	! done making normal call
	add	%r4, 216, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309576
	nop
code_3309577:
	call	GCFromML ! delay slot empty
	nop
needgc_3309576:
sumarm_3283814:
	ld	[%sp+144], %r17
	cmp	%r17, 0
	bne	sumarm_3283815
	nop
code_3309579:
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 2, %r8
	st	%r8, [%r4+4]
	ld	[%sp+140], %r17
	st	%r17, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283815:
	ld	[%sp+144], %r17
	cmp	%r17, 1
	bne	sumarm_3283832
	nop
code_3309582:
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309794:
	mov	%r8, %r9
code_3309585:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309586
	nop
code_3309587:
	call	GCFromML ! delay slot empty
	nop
needgc_3309586:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283832:
	ld	[%sp+144], %r17
	cmp	%r17, 2
	bne	sumarm_3283871
	nop
code_3309592:
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309795:
	mov	%r8, %r9
code_3309595:
	! done making normal call
	add	%r4, 36, %r16
	ld	[%r2+20], %r5
	cmp	%r16, %r5
	bleu	needgc_3309596
	nop
code_3309597:
	call	GCFromML ! delay slot empty
	nop
needgc_3309596:
	! allocating 2-record
	sethi	%hi(gctag_3198455), %r8
	ld	[%r8+%lo(gctag_3198455)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	or	%r0, 3, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283871:
	ld	[%sp+144], %r17
	cmp	%r17, 3
	bne	sumarm_3283910
	nop
code_3309602:
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+140], %r10
	ld	[%sp+92], %r15
	jmpl	%r11, %r0
	add	%sp, 160, %sp
code_3309605:
	! done making tail call
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283910:
	ld	[%sp+144], %r17
	cmp	%r17, 4
	bne	sumarm_3283922
	nop
code_3309607:
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309797:
	mov	%r8, %r11
code_3309610:
	! done making normal call
	! making closure call
	ld	[%sp+124], %r17
	ld	[%r17], %r12
	ld	[%sp+124], %r17
	ld	[%r17+4], %r8
	ld	[%sp+124], %r17
	ld	[%r17+8], %r9
	ld	[%sp+148], %r10
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 160, %sp
code_3309611:
	! done making tail call
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283922:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309613:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 0
	bne	sumarm_3283941
	nop
code_3309614:
	sethi	%hi(type_3208644), %r8
	or	%r8, %lo(type_3208644), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%sp+144], %r17
	ld	[%r17+4], %r11
	or	%r0, 17, %r10
	sethi	%hi(Prim_STR_c_INT), %r8
	or	%r8, %lo(Prim_STR_c_INT), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r8
	ld	[%r8+12], %r8
	cmp	%r8, 3
	or	%r0, 1, %r8
	bgu	cmpui_3309619
	nop
code_3309620:
	or	%r0, 0, %r8
cmpui_3309619:
	sll	%r8, 9, %r8
	add	%r8, %r0, %r8
	or	%r8, %r10, %r10
	! allocating 2-record
	st	%r10, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	mov	%r8, %r9
	! allocating 2-record
	sethi	%hi(gctag_3198155), %r8
	ld	[%r8+%lo(gctag_3198155)], %r8
	st	%r8, [%r4]
	st	%r9, [%r4+4]
	or	%r0, 0, %r8
	st	%r8, [%r4+8]
	add	%r4, 4, %r9
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 9, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283941:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309623:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 1
	bne	sumarm_3283977
	nop
code_3309624:
	sethi	%hi(record_3275003), %r8
	ba	after_sum_3283811
	or	%r8, %lo(record_3275003), %r8
sumarm_3283977:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309627:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 2
	bne	sumarm_3283982
	nop
code_3309628:
	ld	[%sp+144], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309799:
	mov	%r8, %r11
code_3309631:
	! done making normal call
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+148], %r10
code_3309800:
code_3309632:
	! done making normal call
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(convert_sum_to_special_3208449), %r8
	or	%r8, %lo(convert_sum_to_special_3208449), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 160, %sp
code_3309635:
	! done making tail call
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3283982:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309637:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 3
	bne	sumarm_3284019
	nop
code_3309638:
	ld	[%sp+144], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309802:
	mov	%r8, %r11
code_3309641:
	! done making normal call
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+148], %r10
code_3309803:
code_3309642:
	! done making normal call
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(convert_sum_to_special_3208449), %r8
	or	%r8, %lo(convert_sum_to_special_3208449), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 160, %sp
code_3309645:
	! done making tail call
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3284019:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309647:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 4
	bne	sumarm_3284055
	nop
code_3309648:
	ld	[%sp+144], %r17
	ld	[%r17+4], %r16
	st	%r16, [%sp+96]
	! making closure call
	sethi	%hi(_3237549), %r8
	or	%r8, %lo(_3237549), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r11
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	jmpl	%r11, %r15
	ld	[%sp+140], %r10
code_3309805:
	mov	%r8, %r11
code_3309651:
	! done making normal call
	! making closure call
	ld	[%sp+132], %r17
	ld	[%r17], %r12
	ld	[%sp+132], %r17
	ld	[%r17+4], %r8
	ld	[%sp+132], %r17
	ld	[%r17+8], %r9
	jmpl	%r12, %r15
	ld	[%sp+148], %r10
code_3309806:
code_3309652:
	! done making normal call
	ld	[%r8+4], %r10
	! making closure call
	sethi	%hi(convert_sum_to_special_3208449), %r8
	or	%r8, %lo(convert_sum_to_special_3208449), %r9
	ld	[%r2+804], %r8
	add	%r9, %r8, %r8
	ld	[%r8], %r9
	ld	[%r9], %r12
	ld	[%r9+4], %r8
	ld	[%r9+8], %r9
	ld	[%sp+96], %r11
	ld	[%sp+92], %r15
	jmpl	%r12, %r0
	add	%sp, 160, %sp
code_3309655:
	! done making tail call
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3284055:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309657:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 5
	bne	sumarm_3284091
	nop
code_3309658:
	ld	[%sp+144], %r17
	ld	[%r17+4], %r8
	ld	[%r8], %r9
	ld	[%r8+4], %r8
sumarm_3284109:
	or	%r0, 255, %r10
	ld	[%sp+140], %r17
	cmp	%r17, %r10
	bleu	nomatch_sum_3284107
	nop
code_3309659:
	ld	[%sp+140], %r17
	ld	[%r17], %r13
	ld	[%sp+140], %r17
	ld	[%r17+4], %r12
sumarm_3284146:
	or	%r0, 255, %r10
	cmp	%r12, %r10
	bleu	nomatch_sum_3284144
	nop
code_3309660:
	ld	[%r12], %r11
	ld	[%r12+4], %r10
sumarm_3284183:
	cmp	%r10, 0
	bne	sumarm_3284184
	nop
code_3309661:
	! allocating 2-record
	sethi	%hi(gctag_3198487), %r10
	ld	[%r10+%lo(gctag_3198487)], %r10
	st	%r10, [%r4]
	st	%r13, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r10
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3284180 ! delay slot empty
	nop
sumarm_3284184:
nomatch_sum_3284181:
	sethi	%hi(record_3270494), %r10
	or	%r10, %lo(record_3270494), %r10
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r10
	add	%sp, %r10, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r10
after_sum_3284180:
	ba	after_sum_3284143 ! delay slot empty
	nop
sumarm_3284147:
nomatch_sum_3284144:
	sethi	%hi(record_3270494), %r10
	or	%r10, %lo(record_3270494), %r10
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r10
	add	%sp, %r10, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r10
after_sum_3284143:
	ba	after_sum_3284106 ! delay slot empty
	nop
sumarm_3284110:
nomatch_sum_3284107:
	sethi	%hi(record_3270494), %r10
	or	%r10, %lo(record_3270494), %r10
	mov	%r10, %r15
	ld	[%r1], %r17
	ld	[%r1+4], %sp
	ld	[%r2+808], %r10
	add	%sp, %r10, %sp
	mov	%r17, %r16
	jmpl	%r17, %r0 ! delay slot empty
	nop
	or	%r0, 0, %r10
after_sum_3284106:
	ld	[%r10], %r11
	ld	[%r10+4], %r12
	! allocating 2-record
	sethi	%hi(gctag_3203302), %r10
	ld	[%r10+%lo(gctag_3203302)], %r10
	st	%r10, [%r4]
	or	%r0, 0, %r10
	st	%r10, [%r4+4]
	st	%r11, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 2-record
	sethi	%hi(gctag_3203338), %r10
	ld	[%r10+%lo(gctag_3203338)], %r10
	st	%r10, [%r4]
	st	%r11, [%r4+4]
	or	%r0, 0, %r10
	st	%r10, [%r4+8]
	add	%r4, 4, %r11
	add	%r4, 12, %r4
	! done allocating 2 record
	! allocating 7-record
	sethi	%hi(gctag_3203379), %r10
	ld	[%r10+%lo(gctag_3203379)], %r10
	st	%r10, [%r4]
	st	%r9, [%r4+4]
	st	%r8, [%r4+8]
	st	%r12, [%r4+12]
	st	%r11, [%r4+16]
	or	%r0, 0, %r8
	st	%r8, [%r4+20]
	or	%r0, 0, %r8
	st	%r8, [%r4+24]
	or	%r0, 0, %r8
	st	%r8, [%r4+28]
	add	%r4, 4, %r9
	add	%r4, 32, %r4
	! done allocating 7 record
	! allocating 2-record
	or	%r0, 529, %r8
	st	%r8, [%r4]
	or	%r0, 0, %r8
	st	%r8, [%r4+4]
	st	%r9, [%r4+8]
	add	%r4, 4, %r8
	add	%r4, 12, %r4
	! done allocating 2 record
	ba	after_sum_3283811 ! delay slot empty
	nop
sumarm_3284091:
	or	%r0, 255, %r8
	ld	[%sp+144], %r17
	cmp	%r17, %r8
	bleu	nomatch_sum_3283812
	nop
code_3309676:
	ld	[%sp+144], %r17
	ld	[%r17], %r8
	cmp	%r8, 6
	bne	sumarm_3284250
	nop
code_3309677:
	ld	[%sp+144], %r17
	ld	[%r17+4], %r8
	nop

