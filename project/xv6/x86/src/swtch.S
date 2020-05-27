# Context switch
#
#   void swtch(struct context **old, struct context *new);
# 
# Save the current registers on the stack, creating
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

# swtch 并不了解线程，它只是简单地保存和恢复寄存器集合，即上下文。
# 当进程让出 CPU 时，进程的内核线程调用 swtch 来保存自己的上下文
# 然后返回到调度器的上下文中。每个上下文都是以结构体 struct context* 
# 表示的，这实际上是一个保存在内核栈中的指针。swtch 有两个参数：
# struct context **old、struct context *new。它将当前 CPU 的寄存器
# 压入栈中并将栈指针保存在 *old 中。然后 swtch 将 new 拷贝到 %esp 中，
# 弹出之前保存的寄存器，然后返回。

# swtch（2702）一开始从栈中弹出参数，放入寄存器 %eax 和 %edx（2709-2710）中；
# swtch 必须在改变栈指针以及无法获得 %esp 前完成这些事情。然后 swtch 压入寄存器，
# 在当前栈上建立一个新的上下文结构。仅有被调用者保存的寄存器此时需要被保存；
# 按照 x86 的惯例即 %ebp %ebx %esi %edi %esp。swtch 显式地压入前四个寄存器（2713-2716）；
# 最后一个则是在 struct context* 被写入 old（2719）时隐式地保存的。要注意，
# 还有一个重要的寄存器，即程序计数器 %eip，该寄存器在使用 call 调用 swtch 时就
# 保存在栈中 %ebp 之上的位置上了。保存了旧寄存器后，swtch 就准备要恢复新的寄存器了。
# 它将指向新上下文的指针放入栈指针中（2720）。新的栈结构和旧的栈相同，因为新的上下文其实是
# 之前某次的切换中的旧上下文。所以 swtch 就能颠倒一下保存旧上下文的顺序来恢复新上下文。
# 它弹出 %edi %esi %ebx %ebp 然后返回（2723-2727）。由于 swtch 改变了栈指针，所以这时恢复
# 的寄存器就是新上下文中的寄存器值。

# 在我们的例子中，sched 调用 swtch 切换到 cpu->scheduler，即 per-cpu 的调度器上下文。
# 这个上下文是在之前 scheduler 调用 swtch（2478）时保存的。当 swtch 返回时，它不会返回到 
# sched 中，而是返回到 scheduler，其栈指针指向了当前 CPU 的调度器的栈，而非 initproc 的内核栈。

.globl swtch
swtch:
  movl 4(%esp), %eax
  movl 8(%esp), %edx

  # Save old callee-saved registers
  pushl %ebp
  pushl %ebx
  pushl %esi
  pushl %edi

  # Switch stacks
  movl %esp, (%eax)
  movl %edx, %esp

  # Load new callee-saved registers
  popl %edi
  popl %esi
  popl %ebx
  popl %ebp
  ret
