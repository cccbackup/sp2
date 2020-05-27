// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.
//
// The implementation uses two state flags internally:
// * B_VALID: the buffer data has been read from the disk.
// * B_DIRTY: the buffer data has been modified
//     and needs to be written to disk.

/*
### 块缓冲层

块缓冲有两个任务：（1）同步对磁盘的访问，使得对于每一个块，同一时间
只有一份拷贝放在内存中并且只有一个内核线程使用这份拷贝；（2）缓存常用
的块以提升性能。代码参见 [bio.c] 。

块缓冲提供的的主要接口是 `bread` 和 `bwrite`；前者从磁盘中取出一块放入
缓冲区，后者把缓冲区中的一块写到磁盘上正确的地方。当内核处理完一个缓冲块
之后，需要调用 `brelse` 释放它。

块缓冲仅允许最多一个内核线程引用它，以此来同步对磁盘的访问，如果一个
内核线程引用了一个缓冲块，但还没有释放它，那么其他调用 `bread` 的进程
就会阻塞。文件系统的更高几层正是依赖块缓冲层的同步机制来保证其正确性。

块缓冲有固定数量的缓冲区，这意味着如果文件系统请求一个不在缓冲中的块，
必须换出一个已经使用的缓冲区。这里的置换策略是 LRU，因为我们假设最近
未使用的块近期内最不可能再被使用。
*/

#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;

/*
### 代码：块缓冲

块缓冲是缓冲区的双向链表。 `binit`（1231） 会从一个静态数组 `buf` 中构建出
一个有 `NBUF` 个元素的双向链表。所有对块缓冲的访问都通过链表而非静态数组。

一个缓冲区有三种状态：`B_VALID` 意味着这个缓冲区拥有磁盘块的有效内容。
`B_DIRTY` 意味着缓冲区的内容已经被改变并且需要写回磁盘。`B_BUSY` 意味着
有某个内核线程持有这个缓冲区且尚未释放。
*/
void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
/*
`bget`（4066）扫描缓冲区链表，通过给定的设备号和扇区号找到对应的缓冲区（4073-4084）。
如果存在这样一个缓冲区，并且它还不是处于 `B_BUSY` 状态，`bget` 就会设置它的 `B_BUSY` 
位并且返回。如果找到的缓冲区已经在使用中，`bget` 就会睡眠等待它被释放。当 `sleep` 
返回的时候，`bget` 并不能假设这块缓冲区现在可用了，事实上，`sleep` 时释放了 
`buf_table_lock`, 醒来后重新获取了它，这就不能保证 `b` 仍然是可用的缓冲区：
它有可能被用来缓冲另外一个扇区。`bget` 非常无奈，只能重新扫描一次（4082），希望这次
能够找到可用的缓冲区。

![figure6-3](../pic/f6-3.png)

如果 `bget` 中没有那句 `goto` 语句的话，那么就可能产生图6-3中的竞争。第1个进程有
一块缓冲了扇区3的缓冲区。现在另外两个进程来了，第1个进程 `get` 缓冲区3并且为之睡眠
（缓冲区3使用中）。第2个进程 `get` 缓冲区4，并且也可能在同一块缓冲区上睡眠，但这次
是在等待新分配的循环中睡眠的，因为已经没有空闲的缓冲区，而持有扇区3的缓冲区处于链表头，
因此被重用。第一个进程释放了这块缓冲区，`wakeup` 恰巧安排进程3先运行，而后它拿到
这块缓冲区后把扇区4读了进来。进程3之后也释放了缓冲区并且唤醒了进程2。如果没有 `goto` 
语句的话，进程2就会在把拿到的缓冲区标记为 `BUSY` 后从 `bget` 返回，但实际上这块缓冲区
装的是扇区4而不是3。这样的错误可能导致各种各样的麻烦，因为扇区3和4的内容是不同的；
实际上，xv6中它们存储着 i 节点。

如果所请求的扇区还未被缓冲，`bget` 必须分配一个缓冲区，可能是重用某一个缓冲区。它再次
扫描缓冲区列表，寻找一块不是忙状态的块，任何这样的块都可以被拿去使用。`bget` 修改这个块
的元数据来记录新的设备号和扇区号并且标记这个块为 `BUSY`，最后返回它（4091-4093）。
需要注意的是，对标记位的赋值（4089-4091）不仅设置了 `B_BUSY` 位，也清除了 `B_VALID` 位
和 `B_DIRTY` 位，用来保证 `bread` 会用磁盘的内容来填充缓冲区，而不是继续使用块之前的内容。

因为块缓冲是用于同步的，保证任何时候对于每一个扇区都只有一块缓冲区是非常重要的，`bget` 
第一个循环确认没有缓冲区已经加载了所需扇区的内容，并且在此之后 `bget` 都没有释放 
`buf_table_lock`，因此 `bget` 的操作是安全的。

如果所有的缓冲区都处于忙碌状态，那么就出问题了，`bget` 就会报错。不过一个更优雅的响应是
进入睡眠状态，直到有一块缓冲区变为空闲状态。虽然这有可能导致死锁。
*/
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->flags = 0;
      b->refcnt = 1;
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
/*
`bread`（4102） 调用 `bget` 获得指定扇区的缓冲区（4106）。如果缓冲区需要从磁盘中读出，
`bread` 会在返回缓冲区前调用 `iderw`。
*/
/*
一旦 `bread` 给自己的调用者返回了一块缓冲区，调用者就独占了这块缓冲区。如果调用者写了数据，
他必须调用 `bwrite`（4114）在释放缓冲区之前将修改了的数据写入磁盘，`bwrite` 设置 
`B_DIRTY` 位并且调用的 `iderw` 将缓冲区的内容写到磁盘。
*/
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
    iderw(b);
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
}

// Release a locked buffer.
// Move to the head of the MRU list.
/*
当调用者使用完了一块缓冲区，他必须调用 `brelse` 来释放它，（关于 `brelse` 
这个名字，它是 `b-release` 的缩写，它源自 Unix 并且在 BSD，Linux 和 
Solaris 中被广泛使用）。 `brelse`（4125）将一块缓冲区移动到链表的头部（4132-4137），
清除 `B_BUSY`，唤醒睡眠在这块缓冲区上的进程。移动缓冲区的作用 在于使得
链表按照最近被使用的情况排序，链表中的第一块是最近被用的，最后一块是最早
被用的。`bget` 中的两个循环就利用这一点：寻找已经存在的缓冲区在最坏情况下
必须遍历整个链表，但是由于数据局部性，从最近使用的块开始找（从 `bcache.head`
开始，然后用 `next` 指针遍历）会大大减少扫描的时间。反之，找一块可重用的
缓冲区是从链表头向前找，相当于从尾部往头部通过 `prev` 指针遍历，从而找到的
就是最近不被使用的块。
*/
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
}
//PAGEBREAK!
// Blank page.

