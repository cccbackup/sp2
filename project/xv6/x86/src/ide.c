// Simple PIO-based (non-DMA) IDE driver code.
/*
## 驱动程序
驱动程序是操作系统中用于管理某个设备的代码：它提供设备相关的中断处理程序，操纵设备完成操作，
操纵设备产生中断，等等。驱动程序可能会非常难写，因为它和它管理的设备同时在并发地运行着。
另外，驱动程序必须要理解设备的接口（例如，哪一个 I/O 端口是做什么的），而设备的接口又有可能
非常复杂并且文档稀缺。

xv6 的硬盘驱动程序给我们提供了一个良好的例子。磁盘驱动程序从磁盘上拷出和拷入数据。磁盘硬件
一般将磁盘上的数据表示为一系列的 512 字节的块（亦称扇区）：扇区 0 是最初的 512 字节，
扇区 1 是下一个，以此类推。为了表示磁盘扇区，操作系统也有一个数据结构与之对应。这个结构中
存储的数据往往和磁盘上的不同步：可能还没有从磁盘中读出（磁盘正在读数据但是还没有完全读出），
或者它可能已经被更新但还没有写出到磁盘。磁盘驱动程序必须保证 xv6 的其他部分不会因为不同步
的问题而产生错误。

## 代码：磁盘驱动程序
通过 IDE 设备可以访问连接到 PC 标准 IDE 控制器上的磁盘。IDE 现在不如 SCSI 和 SATA 流行，
但是它的接口比较简单使得我们可以专注于驱动程序的整体结构而不是硬件的某个特别部分的细节。

磁盘驱动程序用结构体 buf（称为缓冲区）（3500）来表示一个磁盘扇区。每一个缓冲区表示磁盘设备
上的一个扇区。域 dev 和 sector 给出了设备号和扇区号，域 data 是该磁盘扇区数据的内存中的拷贝。

域 flags 记录了内存和磁盘的联系：B_VALID 位代表数据已经被读入，B_DIRTY 位代表数据需要被
写出。B_BUSY 位是一个锁；它代表某个进程正在使用这个缓冲区，其他进程必须等待。当一个缓冲区
的 B_BUSY 位被设置，我们称这个缓冲区被锁住。
*/
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

#define SECTOR_SIZE   512
#define IDE_BSY       0x80
#define IDE_DRDY      0x40
#define IDE_DF        0x20
#define IDE_ERR       0x01

#define IDE_CMD_READ  0x20
#define IDE_CMD_WRITE 0x30
#define IDE_CMD_RDMUL 0xc4
#define IDE_CMD_WRMUL 0xc5

// idequeue points to the buf now being read/written to the disk.
// idequeue->qnext points to the next buf to be processed.
// You must hold idelock while manipulating queue.

static struct spinlock idelock;
static struct buf *idequeue;

static int havedisk1;
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
    return -1;
  return 0;
}

/*
内核在启动时通过调用 main（1234）中的 ideinit（3851）初始化磁盘驱动程序。
ideinit 调用 picenable 和 ioapicenable 来打开 IDE_IRQ 中断（3856-3857）。
调用 picenable 打开单处理器的中断；ioapicenable 打开多处理器的中断，但只是打开
最后一个 CPU 的中断（ncpu-1）：在一个双处理器系统上，CPU 1 专门处理磁盘中断。

接下来，ideinit 检查磁盘硬件。它最初调用 idewait（3858）来等待磁盘接受命令。
PC 主板通过 I/O 端口 0x1f7 来表示磁盘硬件的状态位。idewait（3833）获取状态位，
直到 busy 位（IDE_BSY）被清除，以及 ready 位（IDE_DRDY)被设置。

现在磁盘控制器已经就绪，ideinit 可以检查有多少磁盘。它假设磁盘 0 是存在的，因为
启动加载器和内核都是从磁盘 0 加载的，但它必须检查磁盘 1。它通过写 I/O 端口 0x1f6 
来选择磁盘 1 然后等待一段时间，获取状态位来查看磁盘是否就绪（3860-3867）。
如果不就绪，ideinit 认为磁盘不存在。
*/
void
ideinit(void)
{
  int i;

  initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
    if(inb(0x1f7) != 0){
      havedisk1 = 1;
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  int sector = b->blockno * sector_per_block;
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}

// Interrupt handler.
/*
由于 xv6 本身比较简单，它使用的锁也很简单，所以 xv6 几乎没有锁的使用链。最长的锁链也就只有两个锁。
例如，`ideintr` 在调用 `wakeup` 时持有 ide 锁，而 `wakeup` 又需要获得 `ptable.lock`。还有很多
使用 `sleep`/`wakeup` 的例子，它们要考虑锁的顺序是因为 `sleep` 和 `wakeup` 中有比较复杂的不变量，
我们会在第5章讨论。文件系统中有很多两个锁的例子，例如文件系统在删除一个文件时必须持有该文件及其所在
文件夹的锁。xv6 总是首先获得文件夹的锁，然后再获得文件的锁。
*/
void
ideintr(void)
{
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
    return;
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  wakeup(b);

  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}

//PAGEBREAK!
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
/*
ideinit 之后，就只能通过块高速缓冲（buffer cache）调用 iderw，iderw 根据标志位
更新一个锁住的缓冲区。如果 B_DIRTY 被设置，iderw 将缓冲区的内容写到磁盘；如果 
B_VALID 没有被设置，iderw 从磁盘中读出数据到缓冲区。

磁盘访问耗时在毫秒级，对于处理器来说是很漫长的。引导加载器发出磁盘读命令并反复读
磁盘状态位直到数据就绪。这种轮询或者忙等待的方法对于引导加载器来说是可以接受的，
因为没有更好的事儿可做。但是在操作系统中，更有效的方法是让其他进程占有 CPU 并且
在磁盘操作完成时接受一个中断。iderw 采用的就是后一种方法，维护一个等待中的磁盘
请求队列，然后用中断来指明哪一个请求已经完成。虽然 iderw 维护了一个请求的队列，
简单的 IDE 磁盘控制器每次只能处理一个操作。磁盘驱动程序的原则是：它已将队首的
缓冲区送至磁盘硬件；其他的只是在等待他们被处理。

iderw（3954）将缓冲区 b 送到队列的末尾（3967-3971）。如果这个缓冲区在队首，
iderw 通过 idestart 将它送到磁盘上（3924-3926）；在其他情况下，一个缓冲区
被开始处理当且仅当它前面的缓冲区被处理完毕。

idestart 发出关于缓冲区所在设备和扇区的读或者写操作，根据标志位的情况不同。
如果操作是一个写操作，idestart 必须提供数据（3889）而在写出到磁盘完成后会
发出一个中断。如果操作是一个读操作，则发出一个代表数据就绪的中断，然后中断
处理程序会读出数据。注意 iderw 有一些关于 IDE 设备的细节，并且在几个特殊
的端口进行读写。如果任何一个 outb 语句错误了，IDE 就会做一些我们意料之外的事。
保证这些细节正确也是写设备驱动程序的一大挑战。

iderw 已经将请求添加到了队列中，并且会在必要的时候开始处理，iderw 还必须等待结果。
就像我们之前讨论的，轮询并不是有效的利用 CPU 的办法。相反，iderw 睡眠，等待
中断处理程序在操作完成时更新缓冲区的标志位（3978-3979）。当这个进程睡眠时，
xv6 会调度其他进程来保持 CPU 处于工作状态。

最终，磁盘会完成自己的操作并且触发一个中断。trap 会调用 ideintr 来处理它（3124）。
ideintr（3902）查询队列中的第一个缓冲区，看正在发生什么操作。如果该缓冲区正在被读入
并且磁盘控制器有数据在等待，ideintr 就会调用 insl 将数据读入缓冲区（3915-3917）。
现在缓冲区已经就绪了：ideintr 设置 B_VALID，清除 B_DIRTY，唤醒任何一个睡眠在这个
缓冲区上的进程（3919-3922）。最终，ideintr 将下一个等待中的缓冲区传递给磁盘（3924-3926）。

用户在读一个文件的时候，这个文件的数据将会被拷贝两次。第一次是由驱动从硬盘拷贝到内核内存，
之后通过 read 系统调用，从内核内存拷贝到用户内存。同理当在网络上发送数据的时候，数据也是
被拷贝了两次：先是从用户内存到内核空间，然后是从内核空间拷贝到网络设备。

xv6 非常谨慎地使用锁来避免竞争条件。一个简单的例子就是 IDE 驱动（3800）。就像本章开篇提到
的一样，`iderw`（3954）有一个磁盘请求的队列，处理器可能会并发地向队列中加入新请求（3969）。
为了保护链表以及驱动中的其他不变量，`iderw` 会请求获得锁 `idelock`（3965）并在函数末尾
释放锁。练习1中研究了如何通过把 `acquire` 移动到队列操作之后来触发竞争条件。我们很有必要
做这个练习，它会让我们了解到想要触发竞争并不容易，也就是说很难找到竞争条件。 也许xv6 的
代码中就潜藏着一些竞争。
*/
/*
有一处的 while 没有检查 p->killed。ide 驱动（3979）直接重新调用了 sleep。
之所以可以确保能被唤醒，是因为它在等待一个磁盘中断。如果它不是在等待磁盘中断的话，
xv6 就搞不清楚它在做什么了。如果有第二个进程在中断之前调用了 iderw，ideintr 会唤醒
该进程（第二个），而非原来等待中断的那一个（第一个）进程。第二个进程会认为它收到了
它正在等待的数据，但实际上它收到的是第一个进程想要读的数据。
*/
void
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
}
