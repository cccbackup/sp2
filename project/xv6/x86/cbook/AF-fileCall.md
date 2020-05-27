# 檔案、呼叫、定義與資料結構 -- 列表

## 檔案

檔案                          | 說明
------------------------------|------------------------------------------------------------------
*.S                           | 組合語言
[bootasm.S](bootasm.S)        | 啟動程式 , Start the first CPU: switch to 32-bit protected mode, jump into C.
[entry.S](entry.S)            | 啟動進入點, The xv6 kernel starts executing in this file. This file is linked with the kernel C code, so it can refer to kernel symbols such as main().
[entryother.S](entryother.S)  | 非啟動處理器, Each non-boot CPU ("AP") is started up in response to a STARTUP IPI from the boot CPU. 
[initcode.S](initcode.S)      | Initial process execs /init. This code runs in user space.
[swtch.S](swtch.S)            | 內文切換, void swtch(struct context **old, struct context *new)
[trapasm.S](trapasm.S)        | 中斷處理程式, vectors.S sends all traps here.
[usys.S](usys.S)              | 中斷呼叫 (會呼叫中斷表 vectors.S)
*.h                           | 檔頭宣告
[asm.h](asm.h)                | 組合語言
[buf.h](buf.h)                | struct buf
[date.h](date.h)              | struct rtcdate
[defs.h](defs.h)              | 所有函數原型
[elf.h](elf.h)                | ELF 格式 (struct elfhdr, proghdr, )
[fcntl.h](fcntl.h)            | 檔案控制位元 (O_RDONLY, O_CREATE, ...)
[file.h](file.h)              | 檔案結構 (struct file, inode, devsw ...)
[fs.h](fs.h)                  | 檔案系統 (struct superblock, dinode, dirent)
[kbd.h](kbd.h)                | 鍵盤 (各按鍵的對應)
[memlayout.h](memlayout.h)    | Memory layout (EXTMEM, ..., KERNBASE, ..., V2P, P2V, ...)
[mmu.h](mmu.h)                | mmu 記憶管理單元
[mp.h](mp.h)                  | 多處理器 (MultiProcessor) (struct mp, mpconf, mpproc, mpioapic, ...)
[param.h](param.h)            | 參數 (常數定義)
[proc.h](proc.h)              | 行程 (struct cpu, context, proc)
[sleeplock.h](sleeplock.h)    | 沉睡鎖 (struct sleeplock)
[spinlock.h](spinlock.h)      | 旋轉鎖 (struct spinlock)
[stat.h](stat.h)              | 檔案類型 (struct stat) (Directory/File/Device)
[syscall.h](syscall.h)        | 系統呼叫
[traps.h](traps.h)            | 中斷代號定義, x86 trap and interrupt constants.
[types.h](types.h)            | 型態 (uint, ushort, uchar, pde_t)
[user.h](user.h)              | 使用者可呼叫函數 (系統呼叫和 ulib 中的函數)
[x86.h](x86.h)                | 內嵌組合語言 define, Routines to let C code use special x86 instructions.
*.c                           | C 語言
[bio.c](bio.c)                | buffered IO 緩衝區快取
[bootmain.c](bootmain.c)      | boot loader 啟動程式
[cat.c](cat.c)                | cat 指令 -- 列出檔案內容
[console.c](console.c)        | console 控制台
[echo.c](echo.c)              | echo 指令 -- 回應訊息
[exec.c](exec.c)              | exec 系統呼叫
[file.c](file.c)              | 檔案描述子 file descriptors
[forktest.c](forktest.c)      | 測試連續 fork 會如何的程式
[fs.c](fs.c)                  | 檔案系統
[grep.c](grep.c)              | grep 指令 -- 每行比對
[ide.c](ide.c)                | IDE 驅動程式
[init.c](init.c)              | 第一個程式，會啟動 shell
[ioapic.c](ioapic.c)          | 硬體中斷管理 The I/O APIC manages hardware interrupts for an SMP system. http://www.intel.com/design/chipsets/datashts/29056601.pdf See also picirq.c.
[kalloc.c](kalloc.c)          | kalloc 動態記憶體分配
[kbd.c](kbd.c)                | 鍵盤
[kill.c](kill.c)              | kill 指令 -- 殺死行程
[lapic.c](lapic.c)            | local APIC manages internal (non-I/O) interrupts. See Chapter 8 & Appendix C of Intel processor manual volume 3.
[ln.c](ln.c)                  | ln 指令 -- 硬連結
[log.c](log.c)                | 日誌紀錄
[ls.c](ls.c)                  | ls 指令 -- 列出檔案
[main.c](main.c)              | 主程式 main
[memide.c](memide.c)          | Fake IDE disk; stores blocks in memory. Useful for running kernel without scratch disk.
[mkdir.c](mkdir.c)            | mkdir 指令 -- 創建資料夾
[mkfs.c](mkfs.c)              | 創建檔案系統 fs.img 的程式
[mp.c](mp.c)                  | Multiprocessor support. Search memory for MP description structures. http://developer.intel.com/design/pentium/datashts/24201606.pdf
[picirq.c](picirq.c)          | Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
[pipe.c](pipe.c)              | pipe 管線
[printf.c](printf.c)          | printf 列印函數
[proc.c](proc.c)              | 行程管理 : 含 Scheduler, fork, exit, wait ...
[rm.c](rm.c)                  | rm 指令 -- 移除檔案
[sh.c](sh.c)                  | shell 交談畫面
[sleeplock.c](sleeplock.c)    | sleeplock
[spinlock.c](spinlock.c)      | 旋轉鎖 Mutual exclusion spin locks.
[stressfs.c](stressfs.c)      | Demonstrate that moving the "acquire" in iderw after the loop that appends to the idequeue results in a race.
[string.c](string.c)          | 字串函式庫 -- strncpy, memcmp, ....
[syscall.c](syscall.c)        | 系統呼叫
[sysfile.c](sysfile.c)        | 檔案系統的呼叫 -- sys_read, sys_write, sys_link, ....
[sysproc.c](sysproc.c)        | 系統行程 -- sys_fork, sys_exit, sys_kill ....
[trap.c](trap.c)              | trap 陷阱 (含中斷表) -- 讓行程陷入系統
[uart.c](uart.c)              | UART 傳送接收介面 (Intel 8250 serial port)
[ulib.c](ulib.c)              | ulib 基本函式庫 (strcpy, strcmp, gets, ...)
[umalloc.c](umalloc.c)        | Memory allocator by Kernighan and Ritchie. The C programming Language, 2nd ed.  Section 8.7.
[usertests.c](usertests.c)    | 系統測試程式 test
[vm.c](vm.c)                  | 虛擬記憶體 (分頁表配置..) (setupkvm, kvmalloc)
[wc.c](wc.c)                  | wc 指令 -- 計算字詞數
[zombie.c](zombie.c)          | 殭屍行程範例。
*.pl                          | perl 檔案
[pr.pl](pr.pl)                | 創建程式行號源碼的文件
[sign.pl](sign.pl)            | 和 boot block 有關
[vectors.pl](vectors.pl)      | 創建中斷表 vectors.S 的程式 (共有 256 個中斷，寫成 C 程式會太長, 所以用產生的)

## 系統呼叫

系統呼叫定義在 [syscall.c](syscall.c), [sysfile.c](sysfile), [sysproc.c](sysproc.c) 裏，最後這些呼叫透過 [usys.S](usys.S) 裏的下列程式匯出為 API。

```
#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret
SYSCALL(fork)
SYSCALL(exit)
```

範例: SYSCALL(fork)

```
#define SYSCALL(fork) \
  .globl fork; \
  fork: \
    movl $SYS_fork, %eax; \
    int $T_SYSCALL; \
    ret
SYSCALL(fork)
SYSCALL(exit)
```

這些呼叫都是系統呼叫，透過 vectors.S 定義在中斷向量表裏。

檔案: [vectors.pl](vectors.pl)


```
...
# sample output:
#   # handlers
#   .globl alltraps
#   .globl vector0
#   vector0:
#     pushl $0
#     pushl $0
#     jmp alltraps
#   ...
#   
#   # vector table
#   .data
#   .globl vectors
#   vectors:
#     .long vector0
#     .long vector1
#     .long vector2
#   ...
```

而這些呼叫的 sys_* 版定義通常在在 [syscall.c](syscall.c), [sysfile.c](sysfile.c), [sysproc.c](sysproc.c) 裏。

```c
...
static int (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
};

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
...
```


## 非系統呼叫的函數列表

檔案: [defs.h](defs.h)

```c
struct buf;
struct context;
struct file;
struct inode;
struct pipe;
struct proc;
struct rtcdate;
struct spinlock;
struct sleeplock;
struct stat;
struct superblock;

// bio.c
void            binit(void);
struct buf*     bread(uint, uint);
void            brelse(struct buf*);
void            bwrite(struct buf*);

// console.c
void            consoleinit(void);
void            cprintf(char*, ...);
void            consoleintr(int(*)(void));
void            panic(char*) __attribute__((noreturn));

// exec.c
int             exec(char*, char**);

// file.c
struct file*    filealloc(void);
void            fileclose(struct file*);
struct file*    filedup(struct file*);
void            fileinit(void);
int             fileread(struct file*, char*, int n);
int             filestat(struct file*, struct stat*);
int             filewrite(struct file*, char*, int n);

// fs.c
void            readsb(int dev, struct superblock *sb);
int             dirlink(struct inode*, char*, uint);
struct inode*   dirlookup(struct inode*, char*, uint*);
struct inode*   ialloc(uint, short);
struct inode*   idup(struct inode*);
void            iinit(int dev);
void            ilock(struct inode*);
void            iput(struct inode*);
void            iunlock(struct inode*);
void            iunlockput(struct inode*);
void            iupdate(struct inode*);
int             namecmp(const char*, const char*);
struct inode*   namei(char*);
struct inode*   nameiparent(char*, char*);
int             readi(struct inode*, char*, uint, uint);
void            stati(struct inode*, struct stat*);
int             writei(struct inode*, char*, uint, uint);

// ide.c
void            ideinit(void);
void            ideintr(void);
void            iderw(struct buf*);

// ioapic.c
void            ioapicenable(int irq, int cpu);
extern uchar    ioapicid;
void            ioapicinit(void);

// kalloc.c
char*           kalloc(void);
void            kfree(char*);
void            kinit1(void*, void*);
void            kinit2(void*, void*);

// kbd.c
void            kbdintr(void);

// lapic.c
void            cmostime(struct rtcdate *r);
int             lapicid(void);
extern volatile uint*    lapic;
void            lapiceoi(void);
void            lapicinit(void);
void            lapicstartap(uchar, uint);
void            microdelay(int);

// log.c
void            initlog(int dev);
void            log_write(struct buf*);
void            begin_op();
void            end_op();

// mp.c
extern int      ismp;
void            mpinit(void);

// picirq.c
void            picenable(int);
void            picinit(void);

// pipe.c
int             pipealloc(struct file**, struct file**);
void            pipeclose(struct pipe*, int);
int             piperead(struct pipe*, char*, int);
int             pipewrite(struct pipe*, char*, int);

//PAGEBREAK: 16
// proc.c
int             cpuid(void);
void            exit(void);
int             fork(void);
int             growproc(int);
int             kill(int);
struct cpu*     mycpu(void);
struct proc*    myproc();
void            pinit(void);
void            procdump(void);
void            scheduler(void) __attribute__((noreturn));
void            sched(void);
void            setproc(struct proc*);
void            sleep(void*, struct spinlock*);
void            userinit(void);
int             wait(void);
void            wakeup(void*);
void            yield(void);

// swtch.S
void            swtch(struct context**, struct context*);

// spinlock.c
void            acquire(struct spinlock*);
void            getcallerpcs(void*, uint*);
int             holding(struct spinlock*);
void            initlock(struct spinlock*, char*);
void            release(struct spinlock*);
void            pushcli(void);
void            popcli(void);

// sleeplock.c
void            acquiresleep(struct sleeplock*);
void            releasesleep(struct sleeplock*);
int             holdingsleep(struct sleeplock*);
void            initsleeplock(struct sleeplock*, char*);

// string.c
int             memcmp(const void*, const void*, uint);
void*           memmove(void*, const void*, uint);
void*           memset(void*, int, uint);
char*           safestrcpy(char*, const char*, int);
int             strlen(const char*);
int             strncmp(const char*, const char*, uint);
char*           strncpy(char*, const char*, int);

// syscall.c
int             argint(int, int*);
int             argptr(int, char**, int);
int             argstr(int, char**);
int             fetchint(uint, int*);
int             fetchstr(uint, char**);
void            syscall(void);

// timer.c
void            timerinit(void);

// trap.c
void            idtinit(void);
extern uint     ticks;
void            tvinit(void);
extern struct spinlock tickslock;

// uart.c
void            uartinit(void);
void            uartintr(void);
void            uartputc(int);

// vm.c
void            seginit(void);
void            kvmalloc(void);
pde_t*          setupkvm(void);
char*           uva2ka(pde_t*, char*);
int             allocuvm(pde_t*, uint, uint);
int             deallocuvm(pde_t*, uint, uint);
void            freevm(pde_t*);
void            inituvm(pde_t*, char*, uint);
int             loaduvm(pde_t*, char*, struct inode*, uint, uint);
pde_t*          copyuvm(pde_t*, uint);
void            switchuvm(struct proc*);
void            switchkvm(void);
int             copyout(pde_t*, uint, void*, uint);
void            clearpteu(pde_t *pgdir, char *uva);

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
```
