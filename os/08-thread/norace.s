	.file	"norace.c"
	.text
	.globl	mutex1
	.data
	.align 8
mutex1:
	.quad	19
	.globl	counter
	.bss
	.align 4
counter:
	.space 4
	.text
	.globl	inc
	.def	inc;	.scl	2;	.type	32;	.endef
	.seh_proc	inc
inc:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	leaq	mutex1(%rip), %rcx
	call	pthread_mutex_lock
	movl	counter(%rip), %eax
	addl	$1, %eax
	movl	%eax, counter(%rip)
	leaq	mutex1(%rip), %rcx
	call	pthread_mutex_unlock
	addl	$1, -4(%rbp)
.L2:
	cmpl	$99999, -4(%rbp)
	jle	.L3
	movl	$0, %eax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.globl	dec
	.def	dec;	.scl	2;	.type	32;	.endef
	.seh_proc	dec
dec:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$0, -4(%rbp)
	jmp	.L6
.L7:
	leaq	mutex1(%rip), %rcx
	call	pthread_mutex_lock
	movl	counter(%rip), %eax
	subl	$1, %eax
	movl	%eax, counter(%rip)
	leaq	mutex1(%rip), %rcx
	call	pthread_mutex_unlock
	addl	$1, -4(%rbp)
.L6:
	cmpl	$99999, -4(%rbp)
	jle	.L7
	movl	$0, %eax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC0:
	.ascii "counter=%d\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	call	__main
	leaq	-8(%rbp), %rax
	movl	$0, %r9d
	leaq	inc(%rip), %r8
	movl	$0, %edx
	movq	%rax, %rcx
	call	pthread_create
	leaq	-16(%rbp), %rax
	movl	$0, %r9d
	leaq	dec(%rip), %r8
	movl	$0, %edx
	movq	%rax, %rcx
	call	pthread_create
	movq	-8(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rcx
	call	pthread_join
	movq	-16(%rbp), %rax
	movl	$0, %edx
	movq	%rax, %rcx
	call	pthread_join
	movl	counter(%rip), %eax
	movl	%eax, %edx
	leaq	.LC0(%rip), %rcx
	call	printf
	movl	$0, %eax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (GNU) 9.1.0"
	.def	pthread_mutex_lock;	.scl	2;	.type	32;	.endef
	.def	pthread_mutex_unlock;	.scl	2;	.type	32;	.endef
	.def	pthread_create;	.scl	2;	.type	32;	.endef
	.def	pthread_join;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
