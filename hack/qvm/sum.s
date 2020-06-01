	.text
	.globl	_hcode
	.def	_hcode;	.scl	2;	.type	32;	.endef
_hcode:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$48, %esp
L0: # @10
	movw $10, %ax
L1: # D=A
	movw %ax, %bx
	movw %bx, %dx
L2: # @0
	movw $0, %ax
L3: # M=D
	movw %dx, %bx
	movw %bx, _m(%eax,%eax)
L4: # @16
	movw $16, %ax
L5: # M=1
	movw $1, %bx
	movw %bx, _m(%eax,%eax)
L6: # @17
	movw $17, %ax
L7: # M=0
	movw $0, %bx
	movw %bx, _m(%eax,%eax)
L8: # @16
	movw $16, %ax
L9: # D=M
	movw _m(%eax,%eax), %bx
	movw %bx, %dx
L10: # @0
	movw $0, %ax
L11: # D=D-M
	movw %dx, %bx
	movw _m(%eax,%eax), %cx
	subw %cx, %bx
	movw %bx, %dx
L12: # @22
	movw $22, %ax
L13: # D;JGT
	movw %dx, %bx
	cmpw $0, %bx
	jg ToLA
L14: # @16
	movw $16, %ax
L15: # D=M
	movw _m(%eax,%eax), %bx
	movw %bx, %dx
L16: # @17
	movw $17, %ax
L17: # M=D+M
	movw _m(%eax,%eax), %bx
	addw %dx, %bx
	movw %bx, _m(%eax,%eax)
L18: # @16
	movw $16, %ax
L19: # M=M+1
	movw _m(%eax,%eax), %bx
	addw $1, %bx
	movw %bx, _m(%eax,%eax)
L20: # @8
	movw $8, %ax
L21: # 0;JMP
	movw $0, %bx
	jmp ToLA
L22: # @17
	movw $17, %ax
L23: # D=M
	movw _m(%eax,%eax), %bx
	movw %bx, %dx
L24: # @1
	movw $1, %ax
L25: # M=D
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
	.long L6
	.long L7
	.long L8
	.long L9
	.long L10
	.long L11
	.long L12
	.long L13
	.long L14
	.long L15
	.long L16
	.long L17
	.long L18
	.long L19
	.long L20
	.long L21
	.long L22
	.long L23
	.long L24
	.long L25
	.text
