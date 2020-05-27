/*
每个管道由一个结构体 struct pipe 表示，其中有一个锁 lock和内存缓冲区。
其中的域 nread 和 nwrite 表示从缓冲区读出和写入的字节数。pipe 对缓冲区
做了包装，使得虽然计数器继续增长，但实际上在 buf[PIPESIZE - 1] 之后写入
的字节存放在 buf[0]。这样就让我们可以区分一个满的缓冲区
（nwrite == nread + PIPESIZE）和一个空的缓冲区（nwrite == nread），
但这也意味着我们必须使用 buf[nread % PIPESIZE] 而不是 buf[nread] 来
读出/写入数据。现在假设 piperead 和 pipewrite 分别在两个 CPU 上连续执行。
*/
#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

#define PIPESIZE 512

struct pipe {
  struct spinlock lock;
  char data[PIPESIZE];
  uint nread;     // number of bytes read
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
}

//PAGEBREAK: 40
/*
pipewrite（6080）首先请求获得管道的锁，以保护计数器、数据以及相关不变量。
piperead（6101）接着也请求获得锁，结果当然是无法获得。于是它停在了 acquire（1474）
上等待锁的释放。与此同时，pipewrite 在循环中依次写入 addr[0], addr[1], ..., addr[n-1] 
并添加到管道中（6094）。在此循环中，缓冲区可能被写满（6086），这时 pipewrite 会调用 
wakeup 通知睡眠中的读者缓冲区中有数据可读，然后使得在 &p->nwrite 队列中睡眠的读者从缓冲区
中读出数据。注意，sleep 在让 pipewrite 的进程进入睡眠时还会释放 p->lock。
*/
int
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}

/*
现在 p->lock 被释放了，piperead 尝试获得该锁然后开始执行：此时它会检查到
 p->nread != p->nwrite（6106）（正是在 nwrite == nread + PIPESIZE （6086）
 的时候 pipewrite 进入了睡眠），于是 piperead 跳出 for 循环，将数据从管道
 中拷贝出来（6113-6117），然后将 nread 增加读取字节数。现在缓冲区又多出了
 很多可写的字节，所以 piperead 调用 wakeup（6118）唤醒睡眠中的写者，然后
 返回到调用者中。wakeup 会找到在 &p->nwrite 队列上睡眠的进程，正是该进程之前
 在运行 pipewrite 时由于缓冲区满而停止了。然后 wakeup 将该进程标记为 RUNNABLE。
*/
int
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
