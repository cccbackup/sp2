#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

static void startothers(void);
static void mpmain(void)  __attribute__((noreturn));
extern pde_t *kpgdir;
extern char end[]; // first address after kernel loaded from ELF file

// Bootstrap processor starts running C code here.           // ??
// Allocate a real stack and switch to it, first             // 分配堆疊後進入主程式
// doing some setup required for memory allocator to work.   // ??
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator // 實體分頁配置器
  kvmalloc();      // kernel page table                 // 核心的分頁表 // entry 中建立的页表已经产生了足够多的映射来让内核的 C 代码正常运行，但内核建立的页表更加精巧地映射了内存空间
  mpinit();        // detect other processors           // 偵測是否有其他處理器
  lapicinit();     // interrupt controller              // 中斷控制器
  seginit();       // segment descriptors               // 段描述器
  picinit();       // disable pic                       // 關閉中斷控制器 The early boards had a simple programmable interrupt controler (called the PIC), and you can find the code to manage it in picirq.c.
  ioapicinit();    // another interrupt controller      // 關閉 IO 中斷控制器 The ioapic and apic are interrupt controllers, ioapic is responsible for I/O interrupts and apic for cpu specific interrupts. you can read more about them on http://www.cs.columbia.edu/~junfeng/11sp-w4118/lectures/trap.pdf
  consoleinit();   // console hardware                  // 啟動 console 控制台
  uartinit();      // serial port                       // 設定 uart (serial port)
  pinit();         // process table                     // 鎖定行程表
  tvinit();        // trap vectors                      // 設定中斷向量表
  binit();         // buffer cache                      // 設定緩衝區
  fileinit();      // file table                        // 設定檔案表
  ideinit();       // disk                              // 設定 IDE 磁碟機
  startothers();   // start other processors            // 啟動其他處理器
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers() // 啟動核心
  userinit();      // first user process                // 啟動第一個 user process
  mpmain();        // finish this processor's setup     // 完成本處理器的設定。
}

// Other CPUs jump here from entryother.S. // 其他處理器會從 entryother.S 跳到 mpenter()
static void
mpenter(void)
{
  switchkvm();
  seginit();
  lapicinit();
  mpmain();
}

// Common CPU setup code. // 共用的 CPU 起始程式碼
static void
mpmain(void)
{
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
  idtinit();       // load idt register                            // 載入中斷描述表 idt
  xchg(&(mycpu()->started), 1); // tell startothers() we're up     // 告訴 startothers 此處理器已啟動
  scheduler();     // start running processes                      // 啟動排程器
}

pde_t entrypgdir[];  // For entry.S // 第一個分頁表 (Entry Page Dir)

static void
startothers(void)
{
  extern uchar _binary_entryother_start[], _binary_entryother_size[];
  uchar *code;
  struct cpu *c;
  char *stack;

  // Write entry code to unused memory at 0x7000.          // 將進入點程式碼寫入 0x7000
  // The linker has placed the image of entryother.S in    // 連結器會將 entryother.S 放到 _binary_entryother_start
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == mycpu())  // We've started already. // 已經啟動了
      continue;

    // Tell entryother.S what stack to use, where to enter, and what     // 告訴 entryother.S 使用哪個堆疊，從哪裡進入，
    // pgdir to use. We cannot use kpgdir yet, because the AP processor  // 使用哪個分頁目錄。
    // is running in low  memory, so we use entrypgdir for the APs too.  // 因為核心分頁目錄 kpgdir 尚未建立，所以先用 entrypgdir
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}

// The boot page table used in entry.S and entryother.S.               //  boot page table
// Page directories (and page tables) must start on page boundaries, 
// hence the __aligned__ attribute.
// PTE_PS in a page directory entry enables 4Mbyte pages.

__attribute__((__aligned__(PGSIZE)))                                   // 以 PGSIZE 為單位對齊
pde_t entrypgdir[NPDENTRIES] = {
  // Map VA's [0, 4MB) to PA's [0, 4MB)                                // 映射虛擬位址 [0,4MB) 到實體位址 [0,4MB)
  [0] = (0) | PTE_P | PTE_W | PTE_PS,
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)                // 映射虛擬位址 [KERNBASE,4MB) 到實體位址 [0,4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
};

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

