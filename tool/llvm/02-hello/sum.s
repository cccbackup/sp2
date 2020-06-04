	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_sum                    ## -- Begin function sum
	.p2align	4, 0x90
_sum:                                   ## @sum
	.cfi_startproc
## %bb.0:
	movl	%edi, -4(%rsp)
	movl	$0, -8(%rsp)
	movl	$0, -12(%rsp)
	.p2align	4, 0x90
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	-12(%rsp), %eax
	cmpl	-4(%rsp), %eax
	jg	LBB0_3
## %bb.2:                               ##   in Loop: Header=BB0_1 Depth=1
	movl	-12(%rsp), %eax
	addl	%eax, -8(%rsp)
	incl	-12(%rsp)
	jmp	LBB0_1
LBB0_3:
	movl	-8(%rsp), %eax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$10, %edi
	callq	_sum
	movl	%eax, 4(%rsp)
	leaq	L_.str(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	_printf
	xorl	%eax, %eax
	popq	%rcx
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"sum(10)=%d\n"

.subsections_via_symbols
