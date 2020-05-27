	.file	"b.c"
	.globl	_shared
	.data
	.align 4
_shared:
	.long	1
	.text
	.globl	_swap
	.def	_swap;	.scl	2;	.type	32;	.endef
_swap:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	%edx, (%eax)
	nop
	leave
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
