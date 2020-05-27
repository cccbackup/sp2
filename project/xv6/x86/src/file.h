/*
### 文件描述符层

UNIX 接口很爽的一点就是大多数的资源都可以用文件来表示，包括终端
这样的设备、管道，当然，还有真正的文件。文件描述符层就是实现这种
统一性的一层。

xv6 给每个进程都有一个自己的打开文件表，正如我们在第零章中所见。
每一个打开文件都由结构体 `file`(3750)表示，它是一个对 i 节点或者
管道和文件偏移的封装。每次调用 `open` 都会创建一个新的打开文件
（一个新的 `file`结构体）。如果多个进程相互独立地打开了同一个文件，
不同的实例将拥有不同的 i/o 偏移。另一方面，同一个文件可以
（同一个file结构体）可以在一个进程的文件表中多次出现，同时也可以在
多个进程的文件表中出现。当一个进程用 `open` 打开了一个文件而后使用 
`dup`，或者把这个文件和子进程共享就会导致这一点发生。对每一个打开的
文件都有一个引用计数，一个文件可以被打开用于读、写或者二者。
`readable`域和`writable`域记录这一点。
*/
struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};

/*
### 代码：i 节点内容
磁盘上的 i 节点结构，结构体 `dinode`，记录了 i 节点的大小和数据块
的块号数组（见图6-4）。i 节点数据能够在`dinode` 的 `adddrs` 数组
中被找到。最开始的 `NDIRECT` 个块存在于这个数组的前 `NDIRECT`个项；
这些块被称作直接块。接下来的 `NINDIRECT` 个块的数据在 i 节点中列了
出来但并没有直接存在 i 节点中，它们存在于一个叫做间接块的数据块中。
`addrs` 数组的最后一项就是间接块的地址。因此一个文件的前 6KB
（`NDIRECT * BSIZE`）个自己可以直接从 i 节点中取出，而后 64KB
（`NINDRECT*BSIZE`）只能在访问了间接块后取出。在磁盘上这样保存是
一种比较好的表示方法，但对于用户来说显得复杂了一些。函数 `bmap` 
负责这层表示使得高层的像 `readi` 和 `writei` 这样的接口更易于编写，
我们马上就会看到这一点。 `bmap` 返回 i 节点 `ip` 中的第 `bn` 个
数据块，如果 `ip` 还没有这样一个数据块，`bmap` 就会分配一个。

![figure6-4](../pic/f6-4.png)
*/
// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  struct sleeplock lock; // protects everything below here
  int valid;          // inode has been read from disk?

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};

// table mapping major device number to
// device functions
struct devsw {
  int (*read)(struct inode*, char*, int);
  int (*write)(struct inode*, char*, int);
};

extern struct devsw devsw[];

#define CONSOLE 1
