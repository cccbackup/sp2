// File system implementation.  Five layers:
//   + Blocks: allocator for raw disk blocks.
//   + Log: crash recovery for multi-step updates.
//   + Files: inode allocator, reading, writing, metadata.
//   + Directories: inode with special contents (list of other inodes!)
//   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
//
// This file contains the low-level file system manipulation
// routines.  The (higher-level) system call implementations
// are in sysfile.c.
/*
xv6 的文件系统中使用了类似 Unix 的文件，文件描述符，目录和路经名（请参阅第零章），
并且把数据存储到一块 IDE 磁盘上（请参阅第三章）。这个文件系统解决了几大难题：

* 该文件系统需要磁盘上数据结构来表示目录树和文件，记录每个文件用于存储数据的块，以及磁盘上哪些区域是空闲的。
* 该文件系统必须支持*崩溃恢复*，也就是说，如果系统崩溃了（比如掉电了），文件系统必须保证在重启后仍能正常工作。问题在于一次系统崩溃可能打断一连串的更新操作，从而使得磁盘上的数据结构变得不一致（例如：有的块同时被标记为使用中和空闲）。
* 不同的进程可能同时操作文件系统，要保证这种并行不会破坏文件系统的正常工作。
* 访问磁盘比访问内存要慢几个数量级，所以文件系统必须要维护一个内存内的 cache 用于缓存常被访问的块。
*/
/*
xv6 的文件系统分6层实现，如图6-1所示。最下面一层通过块缓冲读写 IDE 硬盘，它同步了对磁盘的访问，
保证同时只有一个内核进程可以修改磁盘块。第二层使得更高层的接口可以将对磁盘的更新按会话打包，
通过会话的方式来保证这些操作是原子操作（要么都被应用，要么都不被应用）。第三层提供无名文件，
每一个这样的文件由一个 i 节点和一连串的数据块组成。第四层将目录实现为一种特殊的  i 节点，
它的内容是一连串的目录项，每一个目录项包含一个文件名和对应的 i 节点。第五层提供了层次路经名
（如/usr/rtm/xv6/fs.c这样的），这一层通过递归的方式来查询路径对应的文件。最后一层将许多 UNIX 
的资源（如管道，设备，文件等）抽象为文件系统的接口，极大地简化了程序员的工作。

![figure6-2](../pic/f6-2.png)

文件系统必须设计好在磁盘上的什么地方放置 i 节点和数据块。xv6 把磁盘划分为几个区块，如图6-2所示。
文件系统不使用第0块（第0块存有 bootloader）。第1块叫做*超级块*；它包含了文件系统的元信息
（如文件系统的总块数，数据块块数，i 节点数，以及日志的块数）。从第2块开始存放 i 节点，每一块
能够存放多个 i 节点。接下来的块存放空闲块位图。剩下的大部分块是数据块，它们保存了文件和目录
的内容。在磁盘的最后是日志块，它们是会话层的一部分，将在后面详述。
*/

#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "file.h"

#define min(a, b) ((a) < (b) ? (a) : (b))
static void itrunc(struct inode*);
// there should be one superblock per disk device, but we run with
// only one device
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
}

// Zero a block.
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
  memset(bp->data, 0, BSIZE);
  log_write(bp);
  brelse(bp);
}

// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
        log_write(bp);
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
/*
`bfree`（4481） 找到了空闲的块之后就会清空位图中对应的位。
同样，`bread` 和 `brelse` 的块的互斥使用使得无需再特意加锁。
*/
static void
bfree(int dev, uint b)
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
  log_write(bp);
  brelse(bp);
}

// Inodes.
//
// An inode describes a single unnamed file.
// The inode disk structure holds metadata: the file's type,
// its size, the number of links referring to it, and the
// list of blocks holding the file's content.
//
// The inodes are laid out sequentially on disk at
// sb.startinode. Each inode has a number, indicating its
// position on the disk.
//
// The kernel keeps a cache of in-use inodes in memory
// to provide a place for synchronizing access
// to inodes used by multiple processes. The cached
// inodes include book-keeping information that is
// not stored on disk: ip->ref and ip->valid.
//
// An inode and its in-memory representation go through a
// sequence of states before they can be used by the
// rest of the file system code.
//
// * Allocation: an inode is allocated if its type (on disk)
//   is non-zero. ialloc() allocates, and iput() frees if
//   the reference and link counts have fallen to zero.
//
// * Referencing in cache: an entry in the inode cache
//   is free if ip->ref is zero. Otherwise ip->ref tracks
//   the number of in-memory pointers to the entry (open
//   files and current directories). iget() finds or
//   creates a cache entry and increments its ref; iput()
//   decrements ref.
//
// * Valid: the information (type, size, &c) in an inode
//   cache entry is only correct when ip->valid is 1.
//   ilock() reads the inode from
//   the disk and sets ip->valid, while iput() clears
//   ip->valid if ip->ref has fallen to zero.
//
// * Locked: file system code may only examine and modify
//   the information in an inode and its content if it
//   has first locked the inode.
//
// Thus a typical sequence is:
//   ip = iget(dev, inum)
//   ilock(ip)
//   ... examine and modify ip->xxx ...
//   iunlock(ip)
//   iput(ip)
//
// ilock() is separate from iget() so that system calls can
// get a long-term reference to an inode (as for an open file)
// and only lock it for short periods (e.g., in read()).
// The separation also helps avoid deadlock and races during
// pathname lookup. iget() increments ip->ref so that the inode
// stays cached and pointers to it remain valid.
//
// Many internal file system functions expect the caller to
// have locked the inodes involved; this lets callers create
// multi-step atomic operations.
//
// The icache.lock spin-lock protects the allocation of icache
// entries. Since ip->ref indicates whether an entry is free,
// and ip->dev and ip->inum indicate which i-node an entry
// holds, one must hold icache.lock while using any of those fields.
//
// An ip->lock sleep-lock protects all ip-> fields other than ref,
// dev, and inum.  One must hold ip->lock in order to
// read or write that inode's ip->valid, ip->size, ip->type, &c.

struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}

static struct inode* iget(uint dev, uint inum);

//PAGEBREAK!
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
/*
### 代码：i 节点

要申请一个新的 i 节点（比如创建文件的时候），xv6 会调用 `ialloc`（4603）。
`ialloc` 同 `balloc` 类似：它逐块遍历磁盘上的 i 节点数据结构，寻找一个标记
为空闲的 i 节点。当它找到一个时，就会把它的 `type` 修改掉（变为非0），最后
调用 `iget`（4620)使得它从 i 节点缓存中返回。由于每个时刻只有一个进程能访问
 `bp`，`ialloc` 可以保证其他进程不会同时认为这个 i 节点是可用的并且获取到它。
*/

struct inode*
ialloc(uint dev, short type)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}

// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
/*
持有 `iget` 返回的 i 节点的指针将保证这个 i 节点会留在缓存中，不会被删掉
（特别地不会被用于缓存另一个文件）。因此 `iget` 返回的指针相当一种较弱的锁，
虽然它并不要求持有者真的锁上这个 i 节点。文件系统的许多部分都依赖于这个特性，
一方面是为了长期地持有对 i 节点的引用（比如打开的文件和当前目录），一方面
是在操纵多个 i 节点的程序中避免竞争和死锁（比如路径名查找）。
*/
/*

`iget`（4654）遍历 i 节点缓存寻找一个指定设备和 i 节点号的活动中的项
（`ip->ref > 0`)。如果它找到一项，它就返回对这个 i 节点的引用（4663-4667）。
在 `iget` 扫描的时候，它会记录扫描到的第一个空槽（4668-4669），之后如果需要
可以用这个空槽来分配一个新的缓存项。

*/
static struct inode*
iget(uint dev, uint inum)
{
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
  ip->ref++;
  release(&icache.lock);
  return ip;
}

// Lock the given inode.
// Reads the inode from disk if necessary.
/*
`iget` 返回 i 节点可能没有任何有用的内容。为了保证它持有一个磁盘上 i 节点
的有效拷贝，程序必须调用`ilock`。它会锁住 i 节点（从而其他进程就无法使用它）
并从磁盘中读出 i 节点的信息（如果它还没有被读出的话）。`iunlock` 释放 i 节点
上的锁。把对i 节点指针的获取和 i 节点的锁分开避免了某些情况下的死锁，比如在
目录查询的例子中，数个进程都可以通过 `iget` 获得一个 i 节点的 C 指针，只有
一个进程可以锁住一个 i 节点。
*/
/*

调用者在读写 i 节点的元数据或内容之前必须用 `ilock `锁住 i 节点。`ilock`（4703）
用一个类似的睡眠循环（这种循环在 `bget` 中见过）来等待 `ip->flag` 的 `I_BUSY`
 位被清除，而后由自己再设置它（4712-4714）。一旦 `ilock` 拥有了对 i 节点的独占，
 他可以根据需要从磁盘中读取出 i 节点的元数据。函数 `iunlock`（4735）清除 `I_BUSY` 
 位并且唤醒睡眠在 `ilock` 中的其他进程。
*/
void
ilock(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
}

// Drop a reference to an in-memory inode.
// If that was the last reference, the inode cache entry can
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
/*
`iput`（4756）释放指向 i 节点的 C 指针，实际上就是将引用计数减1。如果减到了0，
那么 i 节点缓存中的这个 i 节点槽就会变为空闲状态，并且可以被另一个 i 节点重用。

如果 `iput` 发现没有指针指向一个 i 节点并且也没有任何目录项指向它（不在目录中
出现的一个文件），那么这个 i 节点和它关联的数据块都应该被释放。`iput`重新锁上
这个 i 节点，调用 `itrunc` 来把文件截断为0字节，释放掉数据块；把 i 节点的类型
设置为0（未分配）；把变化写到磁盘中；最后解锁 i 节点（4759-4771）。

`iput` 中对锁的使用方法值得我们研究。第一个值得研究的地方是当锁上 `ip` 的时候，
 `put` 简单地认为它是没有被锁过的，而非使用一个睡眠循环。这种情况是正常的，因为
 调用者被要求在调用 `iput` 之前解锁 `ip` ，而调用者拥有对它的唯一引用
 （`ip->ref == 1`)。第二个值得研究的部分是 `iput` 临时释放后又重新获取了缓存
 的锁（4764）。这是必要的因为 `itrunc` 和 `iupdate` 可能会在磁盘 i/o 中睡眠，
 但是我们必须考虑在没有锁的这段时间都发生了什么。例如，一旦 `iupdate` 结束了，
 磁盘上的数据结构就被标注为可用的，而并发的一个 `ialloc` 的调用就可能找到它并且
 重新分配它，而这一切都在 `iput` 结束之前发生。`ialloc` 会通过调用 `iget` 返回
 对这一块的引用，而 `iget` 此时找到了 `ip`，但看见它的 `I_BUSY` 位是设置了的，
 从而睡眠。现在内存中的 i 节点就和磁盘上的不同步了：`ialloc` 重新初始化了磁盘上
 的版本，但需要其他的调用者通过 `ilock` 来将它调入内存，可是 `iget` 因为现在的
  `ip` 的 `I_BUSY` 位被设置而进入了睡眠。为了保证这件事发生，`iput` 必须在释放锁
  之前把 `I_BUSY` 和 `I_VALID` 位都清除，所以它将 `flags` 清零（4769）。
*/
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
}

//PAGEBREAK!
// Inode content
//
// The content (data) associated with each inode is stored
// in blocks on the disk. The first NDIRECT block numbers
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
/*
函数 `bmap` 负责这层表示使得高层的像 `readi` 和 `writei` 这样的接口
更易于编写，我们马上就会看到这一点。 `bmap` 返回 i 节点 `ip` 中的
第 `bn` 个数据块，如果 `ip` 还没有这样一个数据块，`bmap` 就会分配一个。

![figure6-4](../pic/f6-4.png)

函数 `bmap`（4810）从最简单的情况开始：前面的 `NDIRECT` 个块的数据
就在 i 节点本身中（4815-4819）。后面的 `NINDIRECT` 个块在 `ip->addrs[NDIRECT]` 
指向的间接块中（4826）。`bmap` 读出间接块然后再从正确的位置读出一个块号（4827）。
如果这个块号超出了`NDIRECT+NINDRECT`，`bmap`就报错：调用者要负责不访问越界的块号。

当需要的时候，`bmap` 分配块。未申请的块用块号0表示。当 `bmap`遇到0的时候，它就
把它们替换为新的块号（4816-4817, 4824-4825）。

`bmap` 随着 i 节点的增长按需分配块，而 `itrunc` 释放它们。它把 i 节点的大小
重新设置为0。`itrunc` （4856）从直接块开始释放（4862-4867），然后开始释放间接块中
列出的块（4872-4875），最后释放间接块本身（4877-4878）。

`bmap` 使得书写需要访问 i 节点数据流的函数变得非常轻松，比如 `readi` 和 `writei`。
`readi`（4902）从 i 节点中读出数据。它最开始要保证给定的偏移和读出的量没有超出文件的
末尾。从超出文件末尾的地方读会直接返回错误（4913-4914），如果是读的过程当中超出了文件
末尾就会返回比请求的数据量少的数据（4915-4916）（从读开始的地方到文件末尾的数据，这是
所有的能返回的数据）。一个循环处理文件的每一块，从缓冲区中拷贝数据到 `dst` 中。函数 
`writei`（4952）和 `readi` 几乎是一样的，只有三个不同：1) 从文件超出文件末尾的地方
开始的写或者写的过程中超出文件末尾的话会增长这个文件，直到达到最大的文件大小（4965-4966）。
2) 这个循环把数据写入缓冲区而非拷出缓冲区（4971）。3) 如果写操作延伸了这个文件，`writei` 
必须更新它的大小（4976-4979）。
*/
static uint
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}

// Truncate inode (discard contents).
// Only called when the inode has no links
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
}

// Copy stat information from inode.
// Caller must hold ip->lock.
/*
函数 `stati`（4887）把 i 节点的元数据拷贝到 `stat` 结构体中，这个结构体
可通过系统调用 `stat` 暴露给用户程序。
*/
void
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  st->size = ip->size;
}

//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
/*
`readi` 和 `writei` 最初都会检查 `ip->type == T_DEV`。这是为了处理
一些数据不存在文件系统中的特殊设备；我们会在文件描述符层重新回到这个问题。

*/
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}

// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}

//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
}

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
/*
函数`dirlookup`（5011）用于查找目录中指定名字的条目。如果找到，它将返回一个
指向相关 i 节点的指针，未被锁的，并设置目录内条目的字节偏移`*poff` ，从而
用于调用者编辑。如果`dirlookup`正好找到对应名字的一个条目，它会更新`*poff`，
释放块，并通过`iget`返回一个未被锁的i节点。`dirlookup`是`iget`返回未被锁的 
i 节点的原因。调用者已经对`dp`上锁，如果查找`.`，当前目录的别名，并在返回之前
尝试去锁上该 i 节点会导致二次锁上`dp`的可能并造成死锁。（`.`不是唯一的问题，
还有很多更复杂的死锁问题，比如多进程和`..`，当前目录的父目录的别名。）调用者
会先解锁`dp`然后锁上`ip`，以保证每次只能维持一个锁。 
*/
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
        *poff = off;
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
}

// Write a new directory entry (name, inum) into the directory dp.
/*
函数`dirlink`（5052）会写入一个新的目录条目到目录`dp`下，用指定的名字和 i 节点编号。
如果这个名字已经存在，`dirlink`会返回`error`（5058-5062）。循环的主体是读取目录条目
以查找尚未分配的条目。当找到一个未分配的条目后，循环会提前退出（5022-5023），并设置
可用条目的偏移`off`。否则，循环以设置`dp->size`的`off`方式结束。无论哪种方式，
`dirlink`之后会通过写入偏移`off`来给目录添加一个新的条目。
*/
int
dirlink(struct inode *dp, char *name, uint inum)
{
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");

  return 0;
}

//PAGEBREAK!
// Paths

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  return path;
}

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
/*
`namex`（5154）会计算路径解析从什么地方开始。如果路径以反斜杠开始，解析就会从
根目录开始；其他情况下则会从当前目录开始（5161）。然后它使用 `skipelem` 来
依次考虑路径中的每一个部分（5163）。每一次循环迭代都必须在当前的 i 节点 `ip`
 中找 `name`。循环的开始会把 `ip` 锁住，然后检查它是否确然是一个目录。如果
 它不是目录的话，查询就宣告失败。（锁住 `ip` 是必须的，不是因为 `ip->type` 
 随时有可能变（事实上它不会变），而是因为如果不调用 `ilock` 的话，`ip->type` 
 可能还没有从磁盘中加载出来）。如果是调用 `nameiparent` 而且这是最后一个路径
 元素，那么循环就直接结束了。因为最后一个路径元素已经拷贝到了 `name` 中，所以
  `namex` 只需要返回解锁的 `ip`（5169-5173）。最后，循环用 `dirlookup` 寻找
  路径元素并且令 `ip=next`，准备下一次的循环（5174-5179）。当循环处理了每一个
  路径元素后，它返回 `ip`。
*/
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}

struct inode*
namei(char *path)
{
  char name[DIRSIZ];
  return namex(path, 0, name);
}

/*
### 代码：路径名

路径名查询会对每一个路径的每一个元素调用 `dirlookup`。`namei`（5189）
解析 `path` 并返回对应的i 节点。函数 `nameiparent` 是一个变种；它在
最后一个元素之前停止，返回上级目录的 i 节点并且把最后一个元素拷贝到 
`name` 中。这两个函数都使用 `namex` 来实现。
*/
struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
}
