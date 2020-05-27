#include "mmu.h"

# 当内陷发生时，处理器会做下面一些事。如果处理器在用户模式下运行，它会从任务段描述符中加载 %esp 和 %ss，
# 把老的 %ss 和 %esp 压入新的栈中。如果处理器在内核模式下运行，上面的事件就不会发生。处理器接下来会把 
# %eflags，%cs，%eip 压栈。对于某些内陷来说，处理器会压入一个错误字。而后，处理器从相应 IDT 表项中加载
# 新的 %eip 和 %cs。

# xv6 使用一个 perl 脚本 (vectors.pl) （2950）来产生 IDT 表项指向的中断处理函数入口点。每一个入口都会
# 压入一个错误码（如果 CPU 没有压入的话），压入中断号，然后跳转到 alltraps。
# Alltraps（3004）继续保存处理器的寄存器：它压入 %ds, %es, %fs, %gs, 以及通用寄存器（3005-3010)。
# 这么做使得内核栈上压入一个 trapframe（中断帧） 结构体，这个结构体包含了中断发生时处理器的寄存器状态（参见图3-2）。
# 处理器负责压入 %ss，%esp，%eflags，%cs 和 %eip。处理器或者中断入口会压入一个错误码，而alltraps负责压入剩余的。
# 中断帧包含了所有处理器从当前进程的内核态恢复到用户态需要的信息，所以处理器可以恰如中断开始时那样继续执行。
# 回顾一下第一章，userinit通过手动建立中断帧来达到这个目标（参见图1-3）

# 考虑第一个系统调用，被保存的 %eip 是 int 指令下一条指令的地址。%cs 是用户代码段选择符。%eflags 是执行 int 
# 指令时的 eflags 寄存器，alltraps 同时也保存 %eax，它存有系统调用号，内核在之后会使用到它。

# 现在用户态的寄存器都保存了，alltraps 可以完成对处理器的设置并开始执行内核的 C 代码。处理器在进入中断处理程序
# 之前设置选择符 %cs 和 %ss；alltraps 设置 %ds 和 %es（3013-3015）。它设置 %fs 和 %gs 来指向 SEG_KCPU
# （每个 CPU 数据段选择符）（3016-3018）。

# 一旦段设置好了，alltraps 就可以调用 C 中断处理程序 trap 了。它压入 %esp 作为 trap 的参数，%esp 指向刚在
# 栈上建立好的中断帧（3021）。然后它调用 trap（3022）。trap 返回后，alltraps 弹出栈上的参数（3023）然后执行
# 标号为 trapret 处的代码。我们在第一章阐述第一个用户进程的时候跟踪分析了这段代码，在那里第一个用户进程通过执行
# trapret 处的代码来退出到用户空间。同样地事情在这里也发生：弹出中断帧会恢复用户模式下的寄存器，然后执行 iret 
# 会跳回到用户空间。

# 现在我们讨论的是发生在用户模式下的中断，但是中断也可能发生在内核模式下。在那种情况下硬件不需要进行栈转换，
# 也不需要保存栈指针或栈的段选择符；除此之外的别的步骤都和发生在用户模式下的中断一样，执行的 xv6 中断处理程序的
# 代码也是一样的。而 iret 会恢复了一个内核模式下的 %cs，处理器也会继续在内核模式下执行。

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  pushl %es
  pushl %fs
  pushl %gs
  pushal
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
  movw %ax, %ds
  movw %ax, %es

  # Call trap(tf), where tf=%esp
  pushl %esp
  call trap
  addl $4, %esp

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  popl %gs
  popl %fs
  popl %es
  popl %ds
  addl $0x8, %esp  # trapno and errcode
  iret
