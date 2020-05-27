	.file	"a.c"
	.def	___main;	.scl	2;	.type	32;	.endef
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	$100, 28(%esp)
	movl	$_shared, 4(%esp)
	leal	28(%esp), %eax
	movl	%eax, (%esp)
	call	_swap
	movl	$0, %eax
	leave
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
	.def	_swap;	.scl	2;	.type	32;	.endef
