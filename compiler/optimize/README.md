# 編譯器優化

gcc 參數 -- https://blog.csdn.net/qq_31108501/article/details/51842166

* -O0 不優化 (預設)
* -O1 部分優化
* -O2 更多優化
* -O3 最高優化

文章
* [你所不知道的 C 語言：編譯器和最佳化原理篇](https://hackmd.io/@sysprog/c-prog/%2Fs%2FHy72937Me)
* https://www.cs.cmu.edu/~15745/handouts.html
* http://hackga.com/search/tag/compiler

參考

* https://en.wikipedia.org/wiki/Optimizing_compiler
* https://en.wikipedia.org/wiki/Loop_optimization
* https://en.wikipedia.org/wiki/Basic_block
* https://en.wikipedia.org/wiki/Static_single_assignment_form
* https://en.wikipedia.org/wiki/Control-flow_graph
* https://en.wikipedia.org/wiki/Interprocedural_optimization
* https://en.wikipedia.org/wiki/Object_code_optimizer
* https://en.wikipedia.org/wiki/Side_effect_(computer_science)
* https://en.wikipedia.org/wiki/Instruction_pipelining
* https://en.wikipedia.org/wiki/Inline_expansion

重要技巧 -- https://en.wikipedia.org/wiki/Optimizing_compiler

* https://en.wikipedia.org/wiki/Register_allocation
* https://en.wikipedia.org/wiki/Peephole_optimization
    * a multiplication of a value by 2 might be more efficiently executed by left-shifting the value or by adding the value to itself
    * Peephole optimization involves changing the small set of instructions to an equivalent set that has better performance. 
* Local optimizations
    * https://en.wikipedia.org/wiki/Basic_block
    * https://www.tutorialspoint.com/compiler_design/compiler_design_code_optimization.htm
    * https://www2.cs.arizona.edu/~collberg/Teaching/453/2009/Handouts/Handout-15.pdf

範例 -- Loop_optimization : https://en.wikipedia.org/wiki/Loop_optimization

* https://en.wikipedia.org/wiki/Loop_fission_and_fusion
* https://en.wikipedia.org/wiki/Induction_variable
* https://en.wikipedia.org/wiki/Loop_inversion
* https://en.wikipedia.org/wiki/Loop_interchange
* https://en.wikipedia.org/wiki/Loop-invariant_code_motion
* https://en.wikipedia.org/wiki/Loop_nest_optimization
* https://en.wikipedia.org/wiki/Loop_splitting
* https://en.wikipedia.org/wiki/Loop_unswitching
* https://en.wikipedia.org/wiki/Software_pipelining
* https://en.wikipedia.org/wiki/Automatic_parallelization

範例 -- Data-flow optimizations
* https://en.wikipedia.org/wiki/Common_subexpression_elimination
* https://en.wikipedia.org/wiki/Constant_folding
* https://en.wikipedia.org/wiki/Induction_variable

範例 -- Code generator optimizations
* https://en.wikipedia.org/wiki/Register_allocation
* https://en.wikipedia.org/wiki/Instruction_selection
* https://en.wikipedia.org/wiki/Instruction_scheduling
    * Avoid pipeline stalls by rearranging the order of instructions.
    * Avoid illegal or semantically ambiguous operations
* https://en.wikipedia.org/wiki/Branch_predictor

## 關鍵字

1. volatile : 告訴編譯器該變數為揮發性，避免編譯器過度優化
2. register : 請將變數儲存在暫存器

## loop_invariant.c

```
$ gcc -fverbose-asm -S -O0 loop_invariant.c -o loop_invariant_O0.s
$ gcc -fverbose-asm -S -O3 loop_invariant.c -o loop_invariant_O3.s
```

結果: loop_invariant_O3.s

```
  .file  "loop_invariant.c"
  .section  .text.unlikely,"x"
LCOLDB0:
  .text
LHOTB0:
  .p2align 4,,15
  .globl  _fsum
  .def  _fsum;  .scl  2;  .type  32;  .endef
_fsum:
  pushl  %esi   #                   # 保留 n
  pushl  %ebx   #                   # 保留 x
  movl  12(%esp), %esi   # n, n     # esi = n
  movl  16(%esp), %ebx   # x, x     # ebx = x
  testl  %esi, %esi   # n           # if esi <= 0
  jle  L4   #,                      #     goto L4
  imull  %ebx, %ebx   # x, D.1502   # ebx = x*x
  xorl  %edx, %edx   # i            # i = edx = 0
  xorl  %eax, %eax   # s            # s = eax = 0
  .p2align 4,,10
L3:
  movl  %edx, %ecx   # i, D.1502    # ecx = edx = i
  imull  %edx, %ecx   # i, D.1502   # ecx = i*i
  addl  $1, %edx   #, i             # i += 1
  addl  %ebx, %ecx   # D.1502, D.1502 # ecx += x*x
  addl  %ecx, %eax   # D.1502, s    # s += x*x
  cmpl  %edx, %esi   # i, n         # if i != n
  jne  L3   #,                      #    goto L3
L2:
  popl  %ebx   #                    # 恢復 ebx
  popl  %esi   #                    # 恢復 esi
  ret
L4:
  xorl  %eax, %eax   # s
  jmp  L2   #
  .section  .text.unlikely,"x"
LCOLDE0:
  .text
LHOTE0:
  .ident  "GCC: (tdm-1) 5.1.0"

```

## volatile

```
$ gcc -fverbose-asm -S -O3 test_volatile.c -o test_volatile_O3.s
$ gcc -fverbose-asm -S -O3 test_novolatile.c -o test_novolatile_O3.s
```

test_novolatile_O3.s

```
	.section	.text.unlikely,"x"
LCOLDB0:
	.text
LHOTB0:
	.p2align 4,,15
	.globl	_read_stream
	.def	_read_stream;	.scl	2;	.type	32;	.endef
_read_stream:
	movl	_buffer_full, %eax	 # buffer_full,
	testl	%eax, %eax	 #
	jne	L2	 #,
L4:
	jmp	L4	 #                  # novolatile 版被優化掉，變成無窮迴圈了！
	.p2align 4,,10
L2:
	xorl	%eax, %eax	 #
	ret
	.section	.text.unlikely,"x"
LCOLDE0:
	.text
LHOTE0:
	.comm	_buffer_full, 4, 2
	.ident	"GCC: (tdm-1) 5.1.0"
```

```
	.section	.text.unlikely,"x"
LCOLDB0:
	.text
LHOTB0:
	.p2align 4,,15
	.globl	_read_stream
	.def	_read_stream;	.scl	2;	.type	32;	.endef
_read_stream:
	movl	_buffer_full, %eax	 # buffer_full, D.1499
	testl	%eax, %eax	 # D.1499
	jne	L4	 #,
	.p2align 4,,10
L3:
	movl	_buffer_full, %edx	 # buffer_full, D.1499
	addl	$1, %eax	 #, count
	testl	%edx, %edx	 # D.1499            # volatile 版會測試 _buffer_full
	je	L3	 #,
	rep ret
L4:
	xorl	%eax, %eax	 # count
	ret
	.section	.text.unlikely,"x"
LCOLDE0:
	.text
LHOTE0:
	.comm	_buffer_full, 4, 2
	.ident	"GCC: (tdm-1) 5.1.0"
```