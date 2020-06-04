	.file	"hack2x86asm2.c"
	.comm	_m, 65536, 5
	.text
	.globl	_test
	.def	_test;	.scl	2;	.type	32;	.endef
_test:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
L2:
	movl	$1, %ebx
	testw	%bx, %bx
	sete	%al
	movzbl	%al, %ebx
	movl	%ebx, %eax
	negl	%eax
	movl	%eax, %ebx
	movl	%ebx, %eax
	addl	$1, %eax
	movl	%eax, %esi
	andl	%esi, %ebx
	movswl	%si, %eax
	movw	%bx, _m(%eax,%eax)
	movswl	%si, %eax
	movzwl	_m(%eax,%eax), %eax
	subl	$1, %eax
	movl	%eax, %ebx
	testw	%bx, %bx
	jg	L3
	jmp	L2
L3:
	movswl	%si, %eax
	addl	$1, %eax
	testl	%eax, %eax
	jle	L5
	jmp	L2
L5:
	nop
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
