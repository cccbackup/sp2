# xv6: a simple, Unix-like teaching operating system

    Russ Cox , Frans Kaashoek , Robert Morris

    October 27, 2019

## Contents

- 1 Operating system interfaces
   - 1.1 Processes and memory
   - 1.2 I/O and File descriptors
   - 1.3 Pipes
   - 1.4 File system
   - 1.5 Real world
   - 1.6 Exercises
- 2 Operating system organization
   - 2.1 Abstracting physical resources
   - 2.2 User mode, supervisor mode, and system calls
   - 2.3 Kernel organization
   - 2.4 Code: xv6 organization
   - 2.5 Process overview
   - 2.6 Code: starting xv6 and the first process
   - 2.7 Real world
   - 2.8 Exercises
- 3 Page tables
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
- 4 Traps and device drivers
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
- 5 Locking
   - 5.1 Race conditions
   - 5.2 Code: Locks
   - 5.3 Code: Using locks
   - 5.4 Deadlock and lock ordering
   - 5.5 Locks and interrupt handlers
   - 5.6 Instruction and memory ordering
   - 5.7 Sleep locks
   - 5.8 Real world
   - 5.9 Exercises
- 6 Scheduling
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
- 7 File system
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
- 8 Concurrency revisited
   - 8.1 Locking patterns
   - 8.2 Lock-like patterns
   - 8.3 No locks at all
   - 8.4 Parallelism
   - 8.5 Exercises
- 9 Summary

## Foreword and acknowledgements

This is a draft text intended for a class on operating systems. It explains the main concepts of operating systems by studying an example kernel, named xv6. xv6 is a re-implementation of Dennis Ritchie’s and Ken Thompson’s Unix Version 6 (v6) [10]. xv6 loosely follows the structure and style of v6, but is implemented in ANSI C [5] for a multicore RISC-V [9].

This text should be read along with the source code for xv6, an approach inspired by John Lions’s Commentary on UNIX 6th Edition [7]. See https://pdos.csail.mit.edu/6.828 for pointers to on-line resources for v6 and xv6, including several hands-on homework assignments using xv6.

We have used this text in 6.828, the operating systems class at MIT. We thank the faculty, teaching assistants, and students of 6.828 who have all directly or indirectly contributed to xv6.

In particular, we would like to thank Austin Clements and Nickolai Zeldovich. Finally, we would like to thank people who emailed us bugs in the text or suggestions for improvements: Abutalib,Aghayev, Sebastian Boehm, Anton Burtsev, Raphael Carvalho, Tej Chajed, Rasit Eskicioglu, Color Fuzzy, Giuseppe, Tao Guo, Robert Hilderman, Wolfgang Keller, Austin Liew, Pavan Maddamsetti, Jacek Masiulaniec, Michael McConville, miguelgvieira, Mark Morrissey, Harry Pan, Askar Safin, Salman Shah, Ruslan Savchenko, Pawel Szczurko, Warren Toomey, tyfkda, tzerbib, Xi Wang, and Zou Chang Wei.

If you spot errors or have suggestions for improvement, please send email to Frans Kaashoek and Robert Morris (kaashoek,rtm@csail.mit.edu).
