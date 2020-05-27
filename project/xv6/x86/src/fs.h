// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

/*
### i 节点

*i 节点*这个术语可以有两个意思。它可以指的是磁盘上的记录文件大小、
数据块扇区号的数据结构。也可以指内存中的一个 i 节点，它包含了一个
磁盘上 i 节点的拷贝，以及一些内核需要的附加信息。

所有的磁盘上的 i 节点都被打包在一个称为 i 节点块的连续区域中。
每一个 i 节点的大小都是一样的，所以对于一个给定的数字n，很容易找到
磁盘上对应的 i 节点。事实上这个给定的数字就是操作系统中 i 节点的编号。

磁盘上的 i 节点由结构体 `dinode`（3676）定义。`type` 域用来区分文件、
目录和特殊文件的 i 节点。如果 `type` 是0的话就意味着这是一个空闲的 
i 节点。`nlink` 域用来记录指向了这一个 i 节点的目录项，这是用于判断
一个 i 节点是否应该被释放的。`size` 域记录了文件的字节数。`addrs` 
数组用于这个文件的数据块的块号。
*/
/*
内核在内存中维护活动的 i 节点。结构体 `inode`（3762）是磁盘中的结构体 
`dinode` 在内存中的拷贝。内核只会在有 C 指针指向一个 i 节点的时候才会把
这个 i 节点保存在内存中。`ref` 域用于统计有多少个 C 指针指向它。
如果 `ref` 变为0，内核就会丢掉这个 i 节点。`iget` 和 `iput` 两个函数
申请和释放 i 节点指针，修改引用计数。i 节点指针可能从文件描述符产生，从
当前工作目录产生，也有可能从一些内核代码如 `exec` 中产生。
*/
// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) (b/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

/*
在xv6中，目录的实现和文件的实现过程很像。 目录的 i 节点的类型 `T_DIR`, 
它的数据是一系列的目录条目。每个条目是一个`struct dirent` (3700)结构体，
 包含一个名字和一个 i 节点编号。这个名字最多有 `DIRSIZ` (14)个字符；如果
 比较短，它将以 `NUL`（0）作为结尾字符。i 节点编号是0的条目都是可用的。
*/
struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

