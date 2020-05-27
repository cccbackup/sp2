//
// File descriptors
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

/*
系统中所有的打开文件都存在于一个全局的文件表 `ftable` 中。这个文件表
有一个分配文件的函数（`filealloc`），有一个重复引用文件的函数（`filedup`），
释放对文件引用的函数（`fileclose`），读和写文件的函数（`fileread` 和 `filewrite` ）。

前三个的形式我们已经很熟悉了。`Filealloc` (5225)扫描整个文件表来寻找一个
没有被引用的文件（`file->ref == 0`)并且返回一个新的引用；`filedup` (5252)
增加引用计数；`fileclose` (5264)减少引用计数。当一个文件的引用计数变为0
的时候，`fileclose`就会释放掉当前的管道或者i 节点（根据文件类型的不同）。
*/
struct devsw devsw[NDEV];
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}

/*
函数`filestat`，`fileread`，`filewrite` 实现了对文件的 `stat`，`read`，`write` 
操作。`filestat` (5302)只允许作用在 i 节点上，它通过调用 `stati` 实现。
`fileread` 和 `filewrite` 检查这个操作被文件的打开属性所允许然后把执行让渡给 
i 节点的实现或者管道的实现。如果这个文件代表的是一个 i 节点，`fileread`和 
`filewrite` 就会把 i/o 偏移作为该操作的偏移并且往前移(5325-5326,5365-5366)。
管道没有偏移这个概念。回顾一下 i 节点的函数需要调用者来处理锁(5305-5307, 
5324-5327,5364-5378)。i 节点锁有一个方便的副作用那就是读写偏移会自动更新，
所以同时对一个文件写并不会覆盖各自的文件，但是写的顺序是不被保证的，因此写的
结果可能是交织的（在一个写操作的过程中插入了另一个写操作）。
*/
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
    // write a few blocks at a time to avoid exceeding
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}

