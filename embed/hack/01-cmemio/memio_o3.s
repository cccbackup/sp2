	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
Lcfi3:
	.cfi_offset %rbx, -24
	movq	_p@GOTPCREL(%rip), %rbx
	jmp	LBB0_2
	.p2align	4, 0x90
LBB0_1:                                 ##   in Loop: Header=BB0_2 Depth=1
	movq	%rax, (%rbx)
LBB0_2:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_4 Depth 2
	cmpw	$0, 24576
	je	LBB0_2
## BB#3:                                ##   in Loop: Header=BB0_2 Depth=1
	movq	$16384, (%rbx)          ## imm = 0x4000
	movl	$16384, %edi            ## imm = 0x4000
	movl	$255, %esi
	movl	$8192, %edx             ## imm = 0x2000
	callq	_memset
	movl	$16384, %eax            ## imm = 0x4000
	.p2align	4, 0x90
LBB0_4:                                 ##   Parent Loop BB0_2 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	addq	$16, %rax
	cmpq	$24576, %rax            ## imm = 0x6000
	jb	LBB0_4
	jmp	LBB0_1
	.cfi_endproc

	.comm	_p,8,3                  ## @p

.subsections_via_symbols
