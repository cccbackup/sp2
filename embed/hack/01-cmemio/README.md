# 記憶體映射輸出入 -- 以 hackComputer 的配置為例

```
$ gcc -S memio.c -o memio.s
```

## memio.s

```
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
                                        ##     Child Loop BB0_4 Depth 2
	movl	$24576, %eax
	movl	%eax, %ecx
	movw	(%rcx), %dx ## 說明：dx = MEM[rcx] = MEM[ecx] = MEM[24576]
	movswl	%dx, %eax
	cmpl	$0, %eax
	jne	LBB0_3
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_1
LBB0_3:                                 ##   in Loop: Header=BB0_1 Depth=1
	movq	_p@GOTPCREL(%rip), %rax
	movl	$16384, %ecx
	movl	%ecx, %edx
	movq	%rdx, (%rax)
LBB0_4:                                 ##   Parent Loop BB0_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$24576, %eax            ## imm = 0x6000
	movl	%eax, %ecx
	movq	_p@GOTPCREL(%rip), %rdx
	cmpq	%rcx, (%rdx)
	jae	LBB0_7
## BB#5:                                ##   in Loop: Header=BB0_4 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movw	$-1, (%rax)
## BB#6:                                ##   in Loop: Header=BB0_4 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movq	(%rax), %rcx
	addq	$2, %rcx
	movq	%rcx, (%rax)
	jmp	LBB0_4
LBB0_7:                                 ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_1
	.cfi_endproc

	.comm	_p,8,3                  ## @p

.subsections_via_symbols

```


```
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
                                        ##     Child Loop BB0_4 Depth 2
	movl	$24576, %eax            ## imm = 0x6000
	movl	%eax, %ecx
	movswl	(%rcx), %eax
	cmpl	$0, %eax
	jne	LBB0_3
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_1
LBB0_3:                                 ##   in Loop: Header=BB0_1 Depth=1
	movq	_p@GOTPCREL(%rip), %rax
	movl	$16384, %ecx ## 說明：ecx = 16384
	movl	%ecx, %edx   ## 
	movq	%rdx, (%rax)
LBB0_4:                                 ##   Parent Loop BB0_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	$24576, %eax            ## imm = 0x6000
	movl	%eax, %ecx
	movq	_p@GOTPCREL(%rip), %rdx
	cmpq	%rcx, (%rdx)
	jae	LBB0_7
## BB#5:                                ##   in Loop: Header=BB0_4 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movw	$-1, (%rax)
## BB#6:                                ##   in Loop: Header=BB0_4 Depth=2
	movq	_p@GOTPCREL(%rip), %rax
	movq	(%rax), %rcx
	addq	$2, %rcx
	movq	%rcx, (%rax)
	jmp	LBB0_4
LBB0_7:                                 ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_1
	.cfi_endproc

	.comm	_p,8,3                  ## @p

.subsections_via_symbols

```

