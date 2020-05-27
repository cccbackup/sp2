// Per-CPU state // 處理器狀態
struct cpu {
  uchar apicid;                // Local APIC ID                             // 中斷控制器代號
  struct context *scheduler;   // swtch() here to enter scheduler           // ??
  struct taskstate ts;         // Used by x86 to find stack for interrupt   // 中斷堆疊
  struct segdesc gdt[NSEGS];   // x86 global descriptor table               // gdt
  volatile uint started;       // Has the CPU started?                      // CPU 是否已啟動?
  int ncli;                    // Depth of pushcli nesting.                 // ??
  int intena;                  // Were interrupts enabled before pushcli?   // 在 pushcli 之前是否已經允許中斷
  struct proc *proc;           // The process running on this cpu or null   // 在此 cpu 跑的行程列表
};

extern struct cpu cpus[NCPU]; // 所有處理器 cpus[]
extern int ncpu;              // 處理器數量?

//PAGEBREAK: 17
// Saved registers for kernel context switches.                           // context switch 時要儲存的暫存器為 edi, esi, ebx, ebp, eip
// Don't need to save all the segment registers (%cs, etc),               // 不是所有段暫存器都得儲存
// because they are constant across kernel contexts.                      // 因為很多段暫存器為固定值
// Don't need to save %eax, %ecx, %edx, because the                       // eax, ecx, edx 也不用儲存
// x86 convention is that the caller has saved them.                      // x86 規定是呼叫者要自行儲存
// Contexts are stored at the bottom of the stack they                    // context 存在堆疊底部
// describe; the stack pointer is the address of the context.             // ，堆疊指標指向 context 的位址??
// The layout of the context matches the layout of the stack in swtch.S   // ??
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,    // ??
// but it is on the stack and allocproc() manipulates it.                 // ??
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE }; // 行程狀態

// Per-process state                                                          // 行程的儲存結構
struct proc {
  uint sz;                     // Size of process memory (bytes)              // 行程記憶體大小
  pde_t* pgdir;                // Page table                                  // 分頁表 // p->pgdir 以 x86 硬件要求的格式保存了进程的页表。xv6 让分页硬件在进程运行时使用 p->pgdir。进程的页表还记录了保存进程内存的物理页的地址。
  char *kstack;                // Bottom of kernel stack for this process     // 行程的堆疊底部
  enum procstate state;        // Process state                               // 行程狀態 
  int pid;                     // Process ID                                  // 行程代號
  struct proc *parent;         // Parent process                              // 父行程
  struct trapframe *tf;        // Trap frame for current syscall              // 目前系統呼叫的中斷框架 ?
  struct context *context;     // swtch() here to run process                 // 行程 context
  void *chan;                  // If non-zero, sleeping on chan               // 行程在 chan ? 睡眠中
  int killed;                  // If non-zero, have been killed               // 行程是否已被殺死
  struct file *ofile[NOFILE];  // Open files                                  // 打開的檔案
  struct inode *cwd;           // Current directory                           // 目前目錄
  char name[16];               // Process name (debugging)                    // 行程名稱
};

// Process memory is laid out contiguously, low addresses first: // 行程記憶體連續配置，從低位址開始，依次是
//   text                                                        //      text (code)
//   original data and bss                                       //      bss
//   fixed-size stack                                            //      stack (固定大小)
//   expandable heap                                             //      heap
