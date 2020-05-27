	.file	"vm.c"
	.globl	_imTop
	.bss
	.align 4
_imTop:
	.space 4
	.comm	_im, 65536, 5
	.comm	_m, 131072, 5
	.section .rdata,"dr"
LC0:
	.ascii "exit program !\0"
LC1:
	.ascii "PC=%04X I=%04X\0"
LC2:
	.ascii "vm.c\0"
LC3:
	.ascii "0\0"
LC4:
	.ascii " A=%04X D=%04X m[A]=%04X\0"
LC5:
	.ascii " a=%X c=%02X d=%X j=%X\0"
	.text
	.globl	_run
	.def	_run;	.scl	2;	.type	32;	.endef
_run:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$68, %esp
	movw	$0, -10(%ebp)
	movw	$0, -12(%ebp)
	movw	$0, -14(%ebp)
	movw	$0, -28(%ebp)
L48:
	movw	$0, -24(%ebp)
	movw	$0, -26(%ebp)
	movswl	-14(%ebp), %edx
	movl	_imTop, %eax
	cmpl	%eax, %edx
	jl	L2
	movl	$LC0, (%esp)
	call	_puts
	jmp	L49
L2:
	movswl	-14(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movw	%ax, -28(%ebp)
	movzwl	-28(%ebp), %edx
	movswl	-14(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movzwl	-14(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -14(%ebp)
	movzwl	-28(%ebp), %eax
	testw	%ax, %ax
	js	L4
	movzwl	-28(%ebp), %eax
	movw	%ax, -12(%ebp)
	jmp	L5
L4:
	movzwl	-28(%ebp), %eax
	andl	$4096, %eax
	sarl	$12, %eax
	movw	%ax, -16(%ebp)
	movzwl	-28(%ebp), %eax
	andl	$4032, %eax
	sarl	$6, %eax
	movw	%ax, -18(%ebp)
	movzwl	-28(%ebp), %eax
	andl	$56, %eax
	sarl	$3, %eax
	movw	%ax, -20(%ebp)
	movzwl	-28(%ebp), %eax
	andl	$7, %eax
	movw	%ax, -22(%ebp)
	cmpw	$0, -16(%ebp)
	jne	L6
	movzwl	-12(%ebp), %eax
	movw	%ax, -26(%ebp)
	jmp	L7
L6:
	movswl	-12(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movw	%ax, -26(%ebp)
L7:
	movzwl	-18(%ebp), %eax
	cmpl	$63, %eax
	ja	L8
	movl	L10(,%eax,4), %eax
	jmp	*%eax
	.section .rdata,"dr"
	.align 4
L10:
	.long	L9
	.long	L8
	.long	L11
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L12
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L13
	.long	L14
	.long	L15
	.long	L16
	.long	L8
	.long	L8
	.long	L8
	.long	L17
	.long	L8
	.long	L18
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L19
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L20
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L21
	.long	L22
	.long	L23
	.long	L24
	.long	L8
	.long	L8
	.long	L8
	.long	L25
	.long	L8
	.long	L8
	.long	L26
	.long	L8
	.long	L8
	.long	L8
	.long	L8
	.long	L27
	.text
L20:
	movw	$0, -24(%ebp)
	jmp	L28
L27:
	movw	$1, -24(%ebp)
	jmp	L28
L26:
	movw	$-1, -24(%ebp)
	jmp	L28
L13:
	movzwl	-10(%ebp), %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L21:
	movzwl	-26(%ebp), %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L14:
	movzwl	-10(%ebp), %eax
	notl	%eax
	movw	%ax, -24(%ebp)
	jmp	L28
L22:
	movzwl	-26(%ebp), %eax
	notl	%eax
	movw	%ax, -24(%ebp)
	jmp	L28
L16:
	movzwl	-10(%ebp), %eax
	negl	%eax
	movw	%ax, -24(%ebp)
	jmp	L28
L24:
	movzwl	-26(%ebp), %eax
	negl	%eax
	movw	%ax, -24(%ebp)
	jmp	L28
L19:
	movzwl	-10(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L25:
	movzwl	-26(%ebp), %eax
	addl	$1, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L15:
	movzwl	-10(%ebp), %eax
	subl	$1, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L23:
	movzwl	-26(%ebp), %eax
	subl	$1, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L11:
	movzwl	-10(%ebp), %edx
	movzwl	-26(%ebp), %eax
	addl	%edx, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L17:
	movzwl	-10(%ebp), %edx
	movzwl	-26(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L12:
	movzwl	-26(%ebp), %edx
	movzwl	-10(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movw	%ax, -24(%ebp)
	jmp	L28
L9:
	movzwl	-10(%ebp), %eax
	andw	-26(%ebp), %ax
	movw	%ax, -24(%ebp)
	jmp	L28
L18:
	movzwl	-10(%ebp), %eax
	orw	-26(%ebp), %ax
	movw	%ax, -24(%ebp)
	jmp	L28
L8:
	movl	$53, 8(%esp)
	movl	$LC2, 4(%esp)
	movl	$LC3, (%esp)
	call	__assert
L28:
	movzwl	-20(%ebp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	L29
	movzwl	-24(%ebp), %eax
	movw	%ax, -12(%ebp)
L29:
	movzwl	-20(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	L30
	movzwl	-24(%ebp), %eax
	movw	%ax, -10(%ebp)
L30:
	movzwl	-20(%ebp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	L31
	movswl	-12(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movzwl	-24(%ebp), %eax
	movw	%ax, (%edx)
L31:
	movzwl	-22(%ebp), %eax
	cmpl	$7, %eax
	ja	L5
	movl	L33(,%eax,4), %eax
	jmp	*%eax
	.section .rdata,"dr"
	.align 4
L33:
	.long	L50
	.long	L34
	.long	L35
	.long	L36
	.long	L37
	.long	L38
	.long	L39
	.long	L40
	.text
L34:
	cmpw	$0, -24(%ebp)
	jle	L51
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L51
L35:
	cmpw	$0, -24(%ebp)
	jne	L52
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L52
L36:
	cmpw	$0, -24(%ebp)
	js	L53
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L53
L37:
	cmpw	$0, -24(%ebp)
	jns	L54
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L54
L38:
	cmpw	$0, -24(%ebp)
	je	L55
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L55
L39:
	cmpw	$0, -24(%ebp)
	jg	L56
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L56
L40:
	movzwl	-12(%ebp), %eax
	movw	%ax, -14(%ebp)
	jmp	L5
L50:
	nop
	jmp	L5
L51:
	nop
	jmp	L5
L52:
	nop
	jmp	L5
L53:
	nop
	jmp	L5
L54:
	nop
	jmp	L5
L55:
	nop
	jmp	L5
L56:
	nop
L5:
	movswl	-12(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movswl	%ax, %ecx
	movswl	-10(%ebp), %edx
	movswl	-12(%ebp), %eax
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC4, (%esp)
	call	_printf
	movzwl	-28(%ebp), %eax
	testw	%ax, %ax
	jns	L47
	movzwl	-22(%ebp), %ebx
	movzwl	-20(%ebp), %ecx
	movzwl	-18(%ebp), %edx
	movzwl	-16(%ebp), %eax
	movl	%ebx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC5, (%esp)
	call	_printf
L47:
	movl	$10, (%esp)
	call	_putchar
	jmp	L48
L49:
	nop
	addl	$68, %esp
	popl	%ebx
	popl	%ebp
	ret
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC6:
	.ascii "rb\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, 28(%esp)
	movl	$LC6, 4(%esp)
	movl	28(%esp), %eax
	movl	%eax, (%esp)
	call	_fopen
	movl	%eax, 24(%esp)
	movl	24(%esp), %eax
	movl	%eax, 12(%esp)
	movl	$32768, 8(%esp)
	movl	$2, 4(%esp)
	movl	$_im, (%esp)
	call	_fread
	movl	%eax, _imTop
	movl	24(%esp), %eax
	movl	%eax, (%esp)
	call	_fclose
	movl	$_m, 4(%esp)
	movl	$_im, (%esp)
	call	_run
	movl	$0, %eax
	leave
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	__assert;	.scl	2;	.type	32;	.endef
	.def	_putchar;	.scl	2;	.type	32;	.endef
	.def	_fopen;	.scl	2;	.type	32;	.endef
	.def	_fread;	.scl	2;	.type	32;	.endef
	.def	_fclose;	.scl	2;	.type	32;	.endef
