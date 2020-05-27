#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
// 行程表
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc; // 初始行程?

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable"); // 鎖定行程表
}

// Must be called with interrupts disabled
int
cpuid() { // 傳回 cpu 代號
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void) // 傳回 cpu 結構
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) { // 取得目前行程
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
/*
allocproc 会在 proc 的表中找到一个标记为 UNUSED的槽位。
当它找到这样一个未被使用的槽位后，allocproc 将其状态设置为 EMBRYO，
使其被标记为被使用的并给这个进程一个独有的 pid。
接下来，它尝试为进程的内核线程分配内核栈。
如果分配失败了，allocproc 会把这个槽位的状态恢复为 UNUSED 并返回0以标记失败。

allocproc 通过把 initproc 的 p->context->eip 设置为 forkret 使得 ret 开始执行 forkret 的代码。
第一次被使用（也就是这一次）时，forkret（2533）会调用一些初始化函数。
注意，我们不能在 main 中调用它们，因为它们必须在一个拥有自己的内核栈的普通进程中运行。
接下来 forkret 返回。由于 allocproc 的设计，目前栈上在 p->context 之后即将被弹出的字是 trapret，
因而接下来会运行 trapret，此时 %esp 保存着 p->tf。trapret用弹出指令从 trap frame中恢复寄存器，
就像 swtch 对内核上下文的操作一样： popal 恢复通用寄存器，popl 恢复 %gs，%fs，%es，%ds。
addl 跳过 trapno 和 errcode 两个数据，最后 iret 弹出 %cs，%eip，%flags，%esp，%ss。
trap frame 的内容已经转移到 CPU 状态中，所以处理器会从 trap frame 中 %eip 的值继续执行。
对于 initproc 来说，这个值就是虚拟地址0，即 initcode.S 的第一个指令。

这时 %eip 和 %esp 的值为0和4096，这是进程地址空间中的虚拟地址。处理器的分页硬件会把它们翻译为物理地址。
allocuvm 为进程建立了页表，所以现在虚拟地址0会指向为该进程分配的物理地址处。
allocuvm 还会设置标志位 PTE_U 来让分页硬件允许用户代码访问内存。userinit 设置了 %cs 的低位，
使得进程的用户代码运行在 CPL = 3 的情况下，这意味着用户代码只能使用带有 PTE_U 设置的页，
而且无法修改像 %cr3 这样的敏感的硬件寄存器。这样，处理器就受限只能使用自己的内存了。
*/
static struct proc*
allocproc(void) // 分配新行程
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) // 初始化第一個使用者行程
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes. // 擴大行程的記憶體 n bytes
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) // 分叉行程
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
/*
exit 首先要求获得 ptable.lock 然后唤醒当前进程的父进程（2376）。
这一步似乎为时过早，但由于 exit 这时还没有把当前进程标记为 ZOMBIE，
所以这样并不会出错：即使父进程已经是 RUNNABLE 的了，但在 exit 调用
 sched 以释放 ptable.lock 之前，wait 是无法运行其中的循环的。
 所以说只有在子进程被标记为 ZOMBIE(2388)之后， wait 才可能找到要退出
 的子进程。在退出并重新调度之前，exit 会把所有子进程交给 initproc（2378-2385）。
 最后，exit 调用 sched 来让出 CPU。

 退出进程的父进程本来是通过调用 wait（2439）处于睡眠状态中，不过现在
 它就可以被调度器调度了。对 sleep 的调用返回时仍持有 ptable.lock ；
 wait 接着会重新查看进程表并找到 state == ZOMBIE（2382）的已退出子进程。
 它会记录该子进程的 pid 然后清理其 struct proc，释放相关的内存空间（2418-2426）。

子进程在 exit 时已经做好了大部分的清理工作，但父进程一定要为其释放 
p->kstack 和 p->pgdir；当子进程运行 exit 时，它正在利用 p->kstack 
分配到的栈以及 p->pgdir 对应的页表。所以这两者只能在子进程结束运行后，
通过调用 sched 中的 swtch 被清理。这就是为什么调度器要运行在自己单独的栈上，
而不能运行在调用 sched 的线程的栈上。
*/
void
exit(void) // 離開行程
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
/*
sleep 和 wakeup 可以在很多需要等待一个可检查状态的情况中使用。如我们在第0章中所见，
父进程可以调用 wait 来等待一个子进程退出。在 xv6 中，当一个子进程要退出时它并不是
直接死掉，而是将状态转变为 ZOMBIE，然后当父进程调用 wait 时才能发现子进程可以退出了。
所以父进程要负责释放退出的子进程相关的内存空间，并修改对应的 struct proc 以便重用。
每个进程结构体都会在 p->parent 中保存指向其父进程的指针。如果父进程在子进程之前
退出了，初始进程 init 会接收其子进程并等待它们退出。我们必须这样做以保证可以为退出
的进程做好子进程的清理工作。另外，所有的进程结构都是被 ptable.lock 保护的。

wait 首先要求获得 ptable.lock，然后查看进程表中是否有子进程，如果找到了子进程，
并且没有一个子进程已经退出，那么就调用 sleep 等待其中一个子进程退出（2439），
然后不断循环。注意，这里 sleep 中释放的锁是 ptable.lock，也就是我们之前提到过的特殊情况。
*/
int
wait(void) // 等待子行程結束
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
/*
scheduler 会找到一个 p->state 为 RUNNABLE 的进程 initproc，
然后将 per-cpu 的变量 proc 指向该进程，接着调用 switchuvm 通知硬件开始使用目标进程的页表。
注意，由于 setupkvm 使得所有的进程的页表都有一份相同的映射，指向内核的代码和数据，
所以当内核运行时我们改变页表是没有问题的。switchuvm 同时还设置好任务状态段 SEG_TSS，
让硬件在进程的内核栈中执行系统调用与中断。我们将在第3章研究任务状态段。
scheduler 接着把进程的 p->state 设置为 RUNNING，调用 swtch，
切换上下文到目标进程的内核线程中。swtch 会保存当前的寄存器，
并把目标内核线程中保存的寄存器（proc->context）载入到 x86 的硬件寄存器中，
其中也包括栈指针和指令指针。当前的上下文并非是进程的，而是一个特殊的 per-cpu 调度器的上下文。
所以 scheduler 会让 swtch 把当前的硬件寄存器保存在 per-cpu 的存储（cpu->scheduler）中，
而非进程的内核线程上下文中。我们将在第5章讨论 swtch 的细节。最后的 ret 指令从栈中弹出目标进程的 %eip，
从而结束上下文切换工作。现在处理器就运行在进程 p 的内核栈上了。
*/
/*
scheduler（2458）运行了一个普通的循环：找到一个进程来运行，运行直到其停止，
然后继续循环。scheduler 大部分时间里都持有 ptable.lock，但在每次外层循环中
都要释放该锁（并显式地允许中断）。当 CPU 闲置（找不到 RUNNABLE 的进程）时
这样做十分有必要。如果一个闲置的调度器一直持有锁，那么其他 CPU 就不可能执行
上下文切换或任何和进程相关的系统调用了，也就更不可能将某个进程标记为 RUNNABLE 
然后让闲置的调度器能够跳出循环了。而之所以周期性地允许中断，则是因为可能进程都在
等待 I/O，从而找不到一个 RUNNABLE 的进程（例如 shell）；如果调度器一直不允许
中断，I/O 就永远无法到达了。
*/
/*
scheduler 不断循环寻找可运行，即 p->state == RUNNABLE 的进程。一旦它找到了这样的进程，
就将 per-cpu 的当前进程变量 proc 设为该进程，用 switchuvm 切换到该进程的页表，标记该
进程为 RUNNING，然后调用 swtch 切换到该进程中运行（2472-2478）。

下面我们来从另一个层面研究这段调度代码。对于每个进程，调度维护了进程的一系列固定状态，
并且保证当状态变化时必须持有锁 ptable.lock。第一个固定状态是，如果进程为 RUNNING 的，
那么必须确保使用时钟中断的 yield 时，能够无误地切换到其他进程；这就意味着 CPU 寄存器
必须保存着进程的寄存器值（这些寄存器值并非在 context 中），%cr3 必须指向进程的页表，
%esp 则要指向进程的内核栈，这样 swtch 才能正确地向栈中压入寄存器值，另外 proc 必须
指向进程的 proc[] 槽中。另一个固定状态是，如果进程是 RUNNABLE，必须保证调度器能够
无误地调度执行该进程；这意味着 p->context 必须保存着进程的内核线程变量，并且没有任何
 CPU 此时正在其内核栈上运行，没有任何 CPU 的 %cr3 寄存器指向进程的页表，也没有任何
  CPU 的 proc 指向该进程。

正是由于要坚持以上两个原则，所以 xv6 必须在一个线程中获得 ptable.lock（通常是在 yield 中），
然后在另一个线程中释放这个锁（在调度器线程或者其他内核线程中）。如果一段代码想要将
运行中进程的状态修改为 RUNNABLE，那么在恢复到固定状态中之前持有锁；最早的可以释放锁
的时机是在 scheduler 停止使用该进程页表并清空 proc 时。类似地，如果 scheduler 想把一个
可运行进程的状态修改为 RUNNING，在该进程的内核线程完全运行起来（swtch 之后，例如在 yield 中）
之前必须持有锁。

除此之外，ptable.lock 也保护了一些其他的状态：进程 ID 的分配，进程表槽的释放，exit 和 
wait 之间的互动，保证对进程的唤醒不会被丢失等等。我们应该思考一下 ptable.lock 有哪些不同
的功能可以分离，使之更为简洁高效。
*/
/*
xv6 所实现的调度算法非常朴素，仅仅是让每个进程轮流执行。这种算法被称作轮转法（round robin）。
真正的操作系统使用了更为复杂的算法，例如，让每个进程都有优先级。主要思想是优先处理高优先级的
可运行进程。但是由于要权衡多项指标，例如要保证公平性和高的吞吐量，调度算法往往很快变得复杂起来。
另外，复杂的调度算法还会无意中导致像*优先级倒转（priority inversion）和护航（convoy）*这样
的现象。优先级倒转是指当高优先级进程和低优先级进程共享一个锁时，如果锁已经被低优先级进程获得了，
高优先级进程就无法运行了。护航则是指当很多高优先级进程等待一个持有锁的低优先级进程的情况，
护航一旦发生，则可能持续很久。如果要避免这些问题，就必须在复杂的调度器中设计更多的机制。
*/
void
scheduler(void) // 創建某 cpu 的排程器
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
/*
代码：调度
上一节中我们查看了 swtch 的底层细节；现在让我们将 swtch 看做一个既有的功能，
来研究从进程到调度器然后再回到进程的切换过程中的一些约定。进程想要让出 CPU 
必须要获得进程表的锁 ptable.lock，并释放其拥有的其他锁，修改自己的状态
（proc->state），然后调用 sched。yield（2522）和 sleep exit 都遵循了这个
约定，我们稍后将会详细研究。sched 检查了两次状态（2507-2512），这里的状态表明
由于进程此时持有锁，所以 CPU 应该是在中断关闭的情况下运行的。最后，sched 调用
 swtch 把当前上下文保存在 proc->context 中然后切换到调度器上下文即 cpu->scheduler
  中。swtch 返回到调度器栈中，就像是调度器调用的 swtch 返回了一样（2478）。
  调度器继续其 for 循环，找到一个进程来运行，切换到该进程，然后继续轮转。

我们看到，在对 swtch 的调用的整个过程中，xv6 都持有锁 ptable.lock：
swtch 的调用者必须持有该锁，并将锁的控制权转移给切换代码。锁的这种使用方式
很少见，通常来说，持有锁的线程应该负责释放该锁，这样更容易让我们理解其正确性。
但对于上下文切换来说，我们必须使用这种方式，因为 ptable.lock 会保证进程的 
state 和 context 在运行 swtch 时保持不变。如果在 swtch 中没有持有 ptable.lock，
可能引发这样的问题：在 yield 将某个进程状态设置为 RUNNABLE 之后，但又是在 swtch 
让它停止在其内核栈上运行之前，有另一个 CPU 要运行该进程。其结果将是两个 CPU 都
运行在同一个栈上，这显然是不该发生的。

内核线程只可能在 sched 中让出处理器，在 scheduler 中切换回对应的地方，当然这里
 scheduler 也是通过 sched 切换到进程中的。所以，如果要写出 xv6 中切换线程的代码
 行号，我们会发现其执行规律是（2478），（2516），（2478），（2516），不断循环。
 以这种形式在两个线程之间切换的过程有时被称作共行程序（coroutines）；在此例中，
 sched 和 scheduler 就是彼此的共行程序。
*/
void
sched(void) // 安排下一個行程
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) // 讓出處理器
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()  // fork 後仔行程第一次被 scheduler() 排程時，
// will swtch here.  "Return" to user space.            // 會切換到 forkret，然後回到使用者空間。
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
/*
让我们来考虑一对调用 sleep 和 wakeup，其工作方式如下。sleep(chan) 让进程
在任意的 chan 上休眠，称之为等待队列（wait channel）。sleep 让调用进程休眠，
释放所占 CPU。wakeup(chan) 则唤醒在 chan 上休眠的所有进程，让他们的 sleep 
调用返回。如果没有进程在 chan 上等待唤醒，wakeup 就什么也不做。

接下来让我们看看 xv6 中 sleep 和 wakeup 的实现。总体思路是希望 sleep 将当前
进程转化为 SLEEPING 状态并调用 sched 以释放 CPU，而 wakeup 则寻找一个睡眠状态
的进程并把它标记为 RUNNABLE。

sleep 首先会进行几个必要的检查：必须存在当前进程（2555）并且 sleep 必须持有锁
（2558-2559）。接着 sleep 要求持有 ptable.lock（2568）。于是该进程就会同时
持有锁 ptable.lock 和 lk 了。调用者（例如 recv）是必须持有 lk 的，这样可以保证
其他进程（例如一个正在运行的 send）无法调用 wakeup(chan)。而如今 sleep 已经持有了
 ptable.lock，那么它现在就能安全地释放 lk 了：这样即使别的进程调用了 wakeup(chan)，
 wakeup 也不可能在没有持有 ptable.lock 的情况下运行，所以 wakeup 必须等待 sleep 
 让进程睡眠后才能运行。这样一来，wakeup 就不会错过 sleep 了。
*/
/*
这里有一个复杂一点的情况：即 lk 就是 ptable.lock 的时候，这样 sleep 在要求持有 
ptable.lock 然后又把它作为 lk 释放的时候会出现死锁。这种情况下，sleep 就会直接
跳过这两个步骤（2567）。例如，当 wait（2403）持有 &ptable.lock 时调用 sleep。

现在仅有该进程的 sleep 持有 ptable.lock，于是它通过记录睡眠队列，改变进程状态，
调用 sched（2573-2575）让进程进入睡眠。

稍后，进程会调用 wakeup(chan)。wakeup（2603）要求获得 ptable.lock 并调用 
wakeup1，其中，实际工作是由 wakeup1 完成的。对于 wakeup 来说持有 ptable.lock 
也是很重要的，因为它也要修改进程的状态并且要保证 sleep 和 wakeup 不会错过彼此。
而之所以要单独实现一个 wakeup1，是因为有时调度器会在持有 ptable.lock 的情况下
唤醒进程，稍后我们会看到这样的例子。当 wakeup 找到了对应 chan 中处于 SLEEPING 
的进程时，它将进程状态修改为 RUNNABLE。于是下一次调度器在运行时，就可以调度该进程了。
*/
void
sleep(void *chan, struct spinlock *lk) // 進入睡眠狀態
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan. // 喚醒 chan 上的所有行程
// The ptable lock must be held.           // 必須鎖定 ptable
/*
wackup 必须在有一个监视唤醒条件的锁的时候才能被调用: 在上面的例子中这个锁就是
 q->lock。至于为什么睡眠中的进程不会错过唤醒，则是因为从 sleep 检查进程状态之前，
 到进程进入睡眠之后，sleep 都持有进程状态的锁或者 ptable.lock 或者是两者兼有。
 由于 wakeup 必须在持有这两个锁的时候运行，所以它必须在 sleep 检查状态之前和
 一个进程已经完全进入睡眠后才能执行。

有些情况下可能有多个进程在同一队列中睡眠；例如，有多个进程想要从管道中读取数据时。
那么单独一个 wakeup 的调用就能将它们全部唤醒。他们的其中一个会首先运行并要求获得 
sleep 被调用时所持的锁，然后读取管道中的任何数据。而对于其他进程来说，即使被唤醒了，
它们也读不到任何数据，所以唤醒它们其实是徒劳的，它们还得接着睡。正是由于这个原因，
我们在一个检查状态的循环中不断调用 sleep。

sleep 和 wakeup 的调用者可以使用任何方便使用的数字作为队列号码；而实际上，xv6 
通常使用内核中和等待相关的数据结构的地址，譬如磁盘缓冲区。即使两组 sleep/wakeup 
使用了相同的队列号码，也是无妨的：对于那些无用的唤醒，它们会通过不断检查状态忽略之。
sleep/wakeup 的优点主要是其轻量级（不需另定义一个结构来作为睡眠队列），并且提供了
一层抽象（调用者不需要了解与之交互的是哪一个进程）。
*/
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan. // 喚醒 chan 上的所有行程
/*
sleep 和 wakeup 是非常普通但有效的同步方法，当然还有很多其他的同步方法。
同步要解决的第一个问题是本章开始我们看到的“丢失的唤醒”问题。原始的 Unix 
内核的 sleep 只是简单地屏蔽中断，由于 Unix 只在单处理器上运行，所以这样已经足够了。
但是由于 xv6 要在多处理器上运行，所以它给 sleep 增加了一个现实的锁。FreeBSD 的 
msleep 也使用了同样的方法。Plan 9 的 sleep 使用了一个回调函数，并在其返回到 sleep 
中之前持有调度用的锁；这个函数对睡眠状态作了最后检查，以避免丢失的唤醒。Linux 内核的 
sleep 用一个显式的进程队列代替 xv6 中的等待队列（wait channel）；而该队列本身内部还有锁。
*/
/*
在 wakeup 中遍历整个进程表来寻找对应 chan 的进程是非常低效的。更好的办法是用
另一个结构体代替 sleep 和 wakeup 中的 chan，该结构体中维护了一个睡眠进程的链表。
Plan 9 的 sleep 和 wakeup 把该结构体称为*集合点（rendezvous point）*或者 Rendez。
许多线程库都把相同的一个结构体作为一个状态变量；如果是这样的话，sleep 和 wakeup 操
作则被称为 wait 和 signal。所有此类机制都有同一个思想：使得睡眠状态可以被某种执行
原子操作的锁保护。

在 wakeup 的实现中，它唤醒了特定队列中的所有进程，而有可能很多进程都在同一个队列中
等待被唤醒。操作系统会调度这里的所有进程，它们会互相竞争以检查其睡眠状态。这样的一堆
进程被称作惊群（thundering herd），而我们最好是避免这种情况的发生。大多数的状态变量
都有两种不同的 wakeup，一种唤醒一个进程，即 signal；另一种唤醒所有进程，即 broadcast。
*/
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid. // 殺死刪除 pid 的行程
// Process won't exit until it returns
// to user space (see trap in trap.c).
/*
exit 让一个应用程序可以自我终结；kill（2625）则让一个应用程序可以终结其他进程。
在实现 kill 时有两个困难：1）被终结的进程可能正在另一个 CPU 上运行，所以它必须
在被终结之前把 CPU 让给调度器；2）被终结的进程可能正在 sleep 中，并持有内核资源。
kill 很轻松地解决了这两个难题：它在进程表中设置被终结的进程的 p->killed，如果
这个进程在睡眠中则唤醒之。如果被终结的进程正在另一个处理器上运行，它总会通过
系统调用或者中断（例如时钟中断）进入内核。当它离开内核时，trap 会检查它的 p->killed，
如果被设置了，该进程就会调用 exit，终结自己。

如果被终结的进程在睡眠中，调用 wakeup 会让被终结的进程开始运行并从 sleep 中返回。
此举有一些隐患，因为进程可能是在它等待的状态尚为假的时候就从 sleep 中返回了。
所以 xv6 谨慎地在调用 sleep 时使用了 while 循环，检查 p->killed 是否被设置了，
若是，则返回到调用者。调用者也必须再次检查 p->killed 是否被设置，若是，返回到
再上一级调用者，依此下去。最后进程的栈展开（unwind）到了 trap，trap 若检查到 
p->killed 被设置了，则调用 exit 终结自己。我们已经在管道的实现中（6087）看到了
在 sleep 外的 while 循环中检查 p->killed。
*/
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging. // 印出行程，除錯用
// Runs when user types ^P on console.                 // 當使用者按下 Ctrl-P 時會印
// No lock to avoid wedging a stuck machine further.   // 不會上鎖，免得卡住機器。
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
