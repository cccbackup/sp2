/*
### 日志设计

日志存在于磁盘末端已知的固定区域。它包含了一个起始块，紧接着一连串的数据块。
起始块包含了一个扇区号的数组，每一个对应于日志中的数据块，起始块还包含了
日志数据块的计数。xv6 在提交后修改日志的起始块，而不是之前，并且在将日志中的
数据块都拷贝到文件系统之后将数据块计数清0。提交之后，清0之前的崩溃就会导致
一个非0的计数值。

每一个系统调用都可能包含一个必须从头到尾原子完成的写操作序列，我们称这样的
一个序列为一个会话，虽然他比数据库中的会话要简单得多。任何时候只能有一个进程
在一个会话之中，其他进程必须等待当前会话中的进程结束。因此同一时刻日志最多
只记录一次会话。

xv6 不允许并发会话，目的是为了避免下面几种问题。假设会话 X 把一个对 i 节点
的修改写入了会话中。并发的会话 Y 从同一块中读出了另一个 i 节点，更新了它，
把 i 节点块写入了日志并且提交。这就会导致可怕的后果：Y 的提交导致被 X 修改过的
 i 节点块被写入磁盘，而 X 此时并没有提交它的修改。如果这时候发生崩溃会使得
  X 的修改只应用了一部分而不是全部，从而打破会话是原子的这一性质。有一些复杂
  的办法可以解决这个问题，但 xv6 直接通过不允许并行的会话来回避这个问题。

xv6 允许只读的系统调用在一次会话中并发执行。i 节点锁会使得会话对只读系统调用
看上去是原子性的。

xv6 使用固定量的磁盘空间来保存日志。系统调用写入日志的块的总大小不能大于日志
的总大小。对于大多数系统调用来说这都不是个问题，但是其中两个可能会写大量的块：
`write` 和 `unlink`。写一个大文件可能会写很多的数据块、位图块，以及 i 节点块。
移除对一个大文件的链接可能会写很多的位图块以及一个 i 节点块。xv6 的写系统调用
将大的写操作拆分成几个小的写操作，使得被修改的块能放入日志中。`unlink` 不会导致
问题因为实际上 xv6 只使用一个位图块。
*/
/*
`filewrite`（5352） 中有一个使用了日志的例子：

```C
begin_trans();
ilock(f->ip);
r = writei(f->ip, ...);
iunlock(f->ip);
commit_trans();
```

我们在一个用于将一次大的写操作拆分成一些会话的循环中找到了这段代码，
在每一次会话中这段只会写部分块，因为日志的大小是有限固定的。对 `writei` 
的调用会在一次会话中写很多的块：文件的 i 节点，一个或多个位图块，以及
一些数据块。在 `begin_trans` 之后再执行 `ilock` 是一种避免死锁的办法：
因为每次会话都已经有一个锁保护了，因此在持有两个锁的时候，要保证一定的加锁顺序。
*/
#include "types.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

// Simple logging that allows concurrent FS system calls.
//
// A log transaction contains the updates of multiple FS system
// calls. The logging system only commits when there are
// no FS system calls active. Thus there is never
// any reasoning required about whether a commit might
// write an uncommitted system call's updates to disk.
//
// A system call should call begin_op()/end_op() to mark
// its start and end. Usually begin_op() just increments
// the count of in-progress FS system calls and returns.
// But if it thinks the log is close to running out, it
// sleeps until the last outstanding end_op() commits.
//
// The log is a physical re-do log containing disk blocks.
// The on-disk log format:
//   header block, containing block #s for block A, B, C, ...
//   block A
//   block B
//   block C
//   ...
// Log appends are synchronous.

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged block# before commit.
struct logheader {
  int n;
  int block[LOGSIZE];
};

struct log {
  struct spinlock lock;
  int start;
  int size;
  int outstanding; // how many FS sys calls are executing.
  int committing;  // in commit(), please wait.
  int dev;
  struct logheader lh;
};
struct log log;

static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
  brelse(buf);
}

/*
`recover_from_log`（4268） 在 `initlog`（4205） 中被调用，而 `initlog` 
在第一个用户进程开始前的引导过程中被调用。它读取日志的起始块，如果起始块说
日志中有一个提交了的会话，它就会仿照 `commit_trans` 的行为执行，从而从错误中恢复。
*/
static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
  log.lh.n = 0;
  write_head(); // clear the log
}

// called at the start of each FS system call.
/*
`begin_trans`（4277） 会一直等到它独占了日志的使用权后返回。
*/
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
}

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}

/*
`commit_trans`（4301） 将日志的起始块写到磁盘上，这样在这个时间点之后的
系统崩溃就能够恢复，只需将磁盘中的内容用日志中的内容改写。`commit_trans` 
调用 `install_trans`（4221） 来从日志中逐块的读并把他们写到文件系统中
合适的地方。最后 `commit_trans` 会把日志起始块中的计数改为0，这样在下次
会话之前的系统崩溃就会使得恢复代码忽略日志。
*/
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    install_trans(); // Now install writes to home locations
    log.lh.n = 0;
    write_head();    // Erase the transaction from the log
  }
}

// Caller has modified b->data and is done with the buffer.
// Record the block number and pin in the cache with B_DIRTY.
// commit()/write_log() will do the disk write.
//
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
/*
`log_write`（4325） 像是 `bwrite` 的一个代理；它把块中新的内容记录到日志中，
并且把块的扇区号记录在内存中。`log_write` 仍将修改后的块留在内存中的缓冲区中，
因此相继的本会话中对这一块的读操作都会返回已修改的内容。`log_write` 能够知道
在一次会话中对同一块进行了多次读写，并且覆盖之前同一块的日志。
*/
void
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
}

