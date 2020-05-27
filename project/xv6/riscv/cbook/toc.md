# xv6: 一個像 UNIX 的簡單教學用作業系統 (a simple, Unix-like teaching operating system)

    Russ Cox , Frans Kaashoek , Robert Morris

    October 27, 2019

## Contents

- [1 Operating system interfaces](ch01.md)
   - 1.1 Processes and memory
   - 1.2 I/O and File descriptors
   - 1.3 Pipes
   - 1.4 File system
   - 1.5 Real world
   - 1.6 Exercises
- [2 Operating system organization](ch02.md)
   - 2.1 Abstracting physical resources
   - 2.2 User mode, supervisor mode, and system calls
   - 2.3 Kernel organization
   - 2.4 Code: xv6 organization
   - 2.5 Process overview
   - 2.6 Code: starting xv6 and the first process
   - 2.7 Real world
   - 2.8 Exercises
- 3 [Page tables](ch03.md)
   - 3.1 Paging hardware
   - 3.2 Kernel address space
   - 3.3 Code: creating an address space
   - 3.4 Physical memory allocation
   - 3.5 Code: Physical memory allocator
   - 3.6 Process address space
   - 3.7 Code: sbrk
   - 3.8 Code: exec
   - 3.9 Real world
   - 3.10 Exercises
- 4 [Traps and device drivers](ch04.md)
   - 4.1 RISC-V trap machinery
   - 4.2 Traps from kernel space
   - 4.3 Traps from user space
   - 4.4 Timer interrupts
   - 4.5 Code: Calling system calls
   - 4.6 Code: System call arguments
   - 4.7 Device drivers
   - 4.8 Code: The console driver
   - 4.9 Real world
   - 4.10 Exercises
- 5 [Locking](ch05.md)
   - 5.1 Race conditions
   - 5.2 Code: Locks
   - 5.3 Code: Using locks
   - 5.4 Deadlock and lock ordering
   - 5.5 Locks and interrupt handlers
   - 5.6 Instruction and memory ordering
   - 5.7 Sleep locks
   - 5.8 Real world
   - 5.9 Exercises
- 6 [Scheduling](ch06.md)
   - 6.1 Multiplexing
   - 6.2 Code: Context switching
   - 6.3 Code: Scheduling
   - 6.4 Code: mycpu and myproc
   - 6.5 Sleep and wakeup
   - 6.6 Code: Sleep and wakeup
   - 6.7 Code: Pipes
   - 6.8 Code: Wait, exit, and kill
   - 6.9 Real world
   - 6.10 Exercises
- 7 [File system](ch07.md)
   - 7.1 Overview
   - 7.2 Buffer cache layer
   - 7.3 Code: Buffer cache
   - 7.4 Logging layer
   - 7.5 Log design
   - 7.6 Code: logging
   - 7.7 Code: Block allocator
   - 7.8 Inode layer
   - 7.9 Code: Inodes
   - 7.10 Code: Inode content
   - 7.11 Code: directory layer
   - 7.12 Code: Path names
   - 7.13 File descriptor layer
   - 7.14 Code: System calls
   - 7.15 Real world
   - 7.16 Exercises
- 8 [Concurrency revisited](ch08.md)
   - 8.1 Locking patterns
   - 8.2 Lock-like patterns
   - 8.3 No locks at all
   - 8.4 Parallelism
   - 8.5 Exercises
- 9 [Summary](ch09.md)

## 前言和答谢

这是一篇针对操作系统课程的草稿文本。它通过研究一个名为xv6的示例内核来解释操作系统的主要概念。xv6是Dennis Ritchie和Ken Thompson的Unix version6(V6)[10]的重新实现。xv6松散地遵循v6的结构和风格，但在ANSIC[5]中针对多核RISC-V[9]实现。

本文应该与xv6的源代码一起阅读，这种方法的灵感来自John Lions对UNIX第6版的评论[7]。有关v6和xv6的在线资源的链接，请参见https://pdos.csail.mit.edu/6.828，其中包括几个使用xv6的实践作业。

我们已经在麻省理工学院的操作系统课程6.828中使用过这篇课文。我们感谢6.828届的教职员工、助教和学生，他们都为xv6做出了直接或间接的贡献。

我们要特别感谢奥斯汀·克莱门茨和尼克莱·泽尔多维奇。最后，我们要感谢通过电子邮件给我们发送文本错误或改进建议的人：阿布塔利布、阿加耶夫、塞巴斯蒂安·博姆、安东·伯采夫、拉斐尔·卡瓦略、泰伊·查吉德、拉希特·埃斯基奥格鲁、颜色模糊、朱塞佩、郭涛、罗伯特·希尔德曼、沃尔夫冈·凯勒、奥斯汀·刘、帕万·马达姆塞蒂、雅切克·马苏拉涅克、迈克尔·麦康维尔、。

如果您发现错误或有改进建议，请发送电子邮件至Frans Kaashoek和Robert Morris(kaashoek，rtm@csail.mit.edu)。