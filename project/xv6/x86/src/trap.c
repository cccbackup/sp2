#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

/*
x86 有四个特权级，从 0（特权最高）编号到 3（特权最低）。在实际使用中，大多数的操作系统都使用两个特权级，0 和 3，
他们被称为内核模式和用户模式。当前执行指令的特权级存在于 %cs 寄存器中的 CPL 域中。

在 x86 中，中断处理程序的入口在中断描述符表（IDT）中被定义。这个表有256个表项，每一个都提供了相应的 %cs 和 %eip。

一个程序要在 x86 上进行一个系统调用，它需要调用 int n 指令，这里 n 就是 IDT 的索引。int 指令进行下面一些步骤：

从 IDT 中获得第 n 个描述符，n 就是 int 的参数。
检查 %cs 的域 CPL <= DPL，DPL 是描述符中记录的特权级。
如果目标段选择符的 PL < CPL，就在 CPU 内部的寄存器中保存 %esp 和 %ss 的值。

1. 从一个任务段描述符中加载 %ss 和 %esp。
2. 将 %ss 压栈。
3. 将 %esp 压栈。
4. 将 %eflags 压栈。
5. 将 %cs 压栈。
6. 将 %eip 压栈。
7. 清除 %eflags 的一些位。
8. 设置 %cs 和 %eip 为描述符中的值。

int 指令是一个非常复杂的指令，可能有人会问是不是所有的这些操作都是必要的。
检查 CPL <= DPL 使得内核可以禁止一些特权级系统调用。例如，如果用户成功执行了 int 指令，
那么 DPL 必须是 3。如果用户程序没有合适的特权级，那么 int 指令就会触发 int 13，
这是一个通用保护错误。再举一个例子，int 指令不能使用用户栈来保存值，
因为用户可能还没有建立一个合适的栈，因此硬件会使用任务段中指定的栈（这个栈在内核模式中建立）。

xv6 必须设置硬件在遇到 int 指令时进行一些特殊的操作，这些操作会使处理器产生一个中断。
x86 允许 256 个不同的中断。中断 0-31 被定义为软件异常，比如除 0 错误和访问非法的内存页。
xv6 将中断号 32-63 映射给硬件中断，并且用 64 作为系统调用的中断号。

*/

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

/*
Tvinit (3067) 在 main 中被调用，它设置了 idt 表中的 256 个表项。中断 i 被位于 vectors[i] 的代码处理。
每一个中断处理程序的入口点都是不同的，因为 x86 并未把中断号传递给中断处理程序，
使用 256 个不同的处理程序是区分这 256 种情况的唯一办法。

Tvinit 处理 T_SYSCALL，用户系统会调用 trap，特别地：它通过传递第二个参数值为 1 来指定这是一个陷阱门。
陷阱门不会清除 FL 位，这使得在处理系统调用的时候也接受其他中断。

同时也设置系统调用门的权限为 DPL_USER，这使得用户程序可以通过 int 指令产生一个内陷。
xv6 不允许进程用 int 来产生其他中断（比如设备中断）；如果它们这么做了，就会抛出通用保护异常，也就是发出 13 号中断。

*/

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

/*
xv6 在 idtinit（1265）中设置时钟中断触发中断向量 32（xv6 使用它来处理 IRQ 0）。
中断向量 32 和中断向量 64（用于实现系统调用）的唯一区别就是 32 是一个中断门，
而 64 是一个陷阱门。中断门会清除 IF，所以被中断的处理器在处理当前中断的时候不会
接受其他中断。从这儿开始直到 trap 为止，中断执行和系统调用或异常处理相同的代码——
建立中断帧。

当因时钟中断而调用 trap 时，trap 只完成两个任务：递增时钟变量的值（3064），并且
调用 wakeup。我们将在第 5 章看到后者可能会使得中断返回到一个不同的进程。
*/
void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
/*
我们在上一节中看到每一个处理程序会建立一个中断帧然后调用 C 函数 trap。trap（3101）查看硬件中断号 tf->trapno 
来判断自己为什么被调用以及应该做些什么。如果中断是 T_SYSCALL，trap 调用系统调用处理程序 syscall。我们会在第五章
再来讨论这里的两个 cp->killed 检查。

当检查完是否是系统调用，trap 会继续检查是否是硬件中断（我们会在下面讨论）。中断可能来自硬件设备的正常中断，
也可能来自异常的、未预料到的硬件中断。

如果中断不是一个系统调用也不是一个硬件主动引发的中断，trap 就认为它是一个发生中断前的一段代码中的错误行为导致
的中断（如除零错误）。如果产生中断的代码来自用户程序，xv6 就打印错误细节并且设置 cp->killed 使之待会被清除掉。
我们会在第五章看看 xv6 是怎样进行清除的。

如果是内核程序正在执行，那就出现了一个内核错误：trap 打印错误细节并且调用 panic。
*/
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
