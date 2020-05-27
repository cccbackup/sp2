	.file	"hack2x86asm.c"
	.globl	_D
	.bss
	.align 2
_D:
	.space 2
	.globl	_A
	.align 2
_A:
	.space 2
	.comm	_m, 65536, 5
	.text
	.globl	_test
	.def	_test;	.scl	2;	.type	32;	.endef
_test:
	pushl	%ebp
	movl	%esp, %ebp
	movw	$1, _D
	movzwl	_A, %eax
	addl	$1, %eax
	movw	%ax, _D
	movzwl	_D, %edx
	movzwl	_A, %eax
	andl	%edx, %eax
	movw	%ax, _A
	movzwl	_A, %eax
	cwtl
	movzwl	_D, %edx
	movw	%dx, _m(%eax,%eax)
	movzwl	_A, %eax
	cwtl
	movzwl	_m(%eax,%eax), %eax
	subl	$1, %eax
	movw	%ax, _D
	nop
	popl	%ebp
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
