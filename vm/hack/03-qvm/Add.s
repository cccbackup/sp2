	.text
	.globl	_hcode
	.def	_hcode;	.scl	2;	.type	32;	.endef
_hcode:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$48, %esp
L0: # @2
	movw $2, %ax
L1: # D=A
	movw %ax, %bx
	movw %bx, %dx
L2: # @3
	movw $3, %ax
L3: # D=D+A
	movw %dx, %bx
	addw %ax, %bx
	movw %bx, %dx
L4: # @0
	movw $0, %ax
L5: # M=D
	movw %dx, %bx
	movw %bx, _m(%eax,%eax)
	movw	%ax, _A
	movw	%dx, _D
	nop
	leave
	ret
ToLA:
# +printf
	movl	%edx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	movl  4(%esp), %eax
	movl  8(%esp), %ebx
	movl  12(%esp), %ecx
	movl  16(%esp), %edx
# -printf
	movl %eax, %ecx
	sall $2, %ecx
	addl $JumpTable, %ecx
	movl (%ecx), %ecx
	jmp *%ecx
.section .rdata,"dr"
LC0:
	.ascii "eax=%d ebx=%d ecx=%d edx=%d\12\0"
	.align 4
JumpTable:
	.long L0
	.long L1
	.long L2
	.long L3
	.long L4
	.long L5
	.text
