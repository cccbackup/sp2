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
	movl	$0, -4(%rbp)
LBB0_1:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_2 Depth 2
	movq	_p@GOTPCREL(%rip), %rax
	movl	$16384, %ecx            ## imm = 0x4000
	movl	%ecx, %edx
	xorl	%ecx, %ecx
	movl	$65535, %esi            ## imm = 0xFFFF
	movl	$24576, %edi            ## imm = 0x6000
	movl	%edi, %r8d
	movw	(%r8), %r9w
	movswl	%r9w, %edi
	cmpl	$0, %edi
	sete	%r10b
	andb	$1, %r10b
	movzbl	%r10b, %edi
	movw	%di, %r9w
	movw	%r9w, -6(%rbp)
	movswl	-6(%rbp), %edi
	cmpl	$0, %edi
	cmovnel	%esi, %ecx
	movw	%cx, %r9w
	movw	%r9w, -8(%rbp)
	movq	%rdx, (%rax)
LBB0_2:                                 ##   Parent Loop BB0_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$24576, %eax            ## imm = 0x6000
	movl	%eax, %ecx
	movq	_p@GOTPCREL(%rip), %rdx
	cmpq	%rcx, (%rdx)
	jae	LBB0_7
## BB#3:                                ##   in Loop: Header=BB0_2 Depth=2
	cmpw	$0, -6(%rbp)
	je	LBB0_5
## BB#4:                                ##   in Loop: Header=BB0_2 Depth=2
	jmp	LBB0_6
LBB0_5:                                 ##   in Loop: Header=BB0_2 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movw	-8(%rbp), %cx
	movq	(%rax), %rax
	movw	%cx, (%rax)
LBB0_6:                                 ##   in Loop: Header=BB0_2 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movq	(%rax), %rcx
	addq	$2, %rcx
	movq	%rcx, (%rax)
	jmp	LBB0_2
LBB0_7:                                 ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_1
	.cfi_endproc

	.comm	_p,8,3                  ## @p

.subsections_via_symbols
