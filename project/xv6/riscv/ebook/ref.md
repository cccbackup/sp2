# Bibliography

[1] The RISC-V instruction set manual: privileged architecture. https://content.riscv.org/wp-content/uploads/2017/05/riscv-privileged-v1.10.pdf, 2017.
[2] The RISC-V instruction set manual: user-level ISA.https://content.riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf, 2017.
[3] Hans-J Boehm. Threads cannot be implemented as a library.ACM PLDI Conference, 2005.
[4] Edsger Dijkstra. Cooperating sequential processes. https://www.cs.utexas.edu/users/EWD/transcriptions/EWD01xx/EWD123.html, 1965.
[5] Brian W. Kernighan. The C Programming Language. Prentice Hall Professional Technical Reference, 2nd edition, 1988.
[6] Donald Knuth.Fundamental Algorithms. The Art of Computer Programming. (Second ed.), volume 1. 1997.
[7] John Lions.Commentary on UNIX 6th Edition. Peer to Peer Communications, 2000.
[8] Martin Michael and Daniel Durich. The NS16550A: UART design and application consid-erations. http://bitsavers.trailing-edge.com/components/national/_appNotes/AN-0491.pdf, 1987.
[9] David Patterson and Andrew Waterman. The RISC-V Reader: an open architecture Atlas. Strawberry Canyon, 2017.
[10] Dennis M. Ritchie and Ken Thompson. The UNIX time-sharing system. Commun. ACM, 17(7):365–375, July 1974.


# Index

., 86, 88
.., 86, 88
/init, 28, 37
_entry, 27
absorption, 80
acquire, 54, 57
address space, 25
argc, 37
argv, 37
atomic, 54
balloc, 81, 83
batching, 79
bcache.head, 77
begin_op, 80
bfree, 81
bget, 77
binit, 77
bmap, 85
bread, 76, 78
brelse, 76, 78
BSIZE, 85
buf, 76
busy waiting, 66
bwrite, 76, 78, 80
chan, 66, 68
child process, 10
commit, 78
concurrency, 51
concurrency control, 51
condition lock, 67
conditional synchronization, 65
conflict, 54
contention, 54
contexts, 62
convoys, 72
copyinstr, 47
copyout, 37
coroutines, 63
CPU, 21
cpu->scheduler, 62, 63
crash recovery, 75
create, 88
critical section, 53
current directory, 17
deadlock, 56
direct blocks, 85
direct memory access (DMA), 49
dirlink, 86
dirlookup, 85, 86, 88
DIRSIZ, 85
disk, 77
driver, 47
dup, 87
ecall, 23, 26
ELF format, 36
ELF_MAGIC, 37
end_op, 80
exception, 41
exec, 12, 14, 28, 37, 46
exit, 11, 64, 70
file descriptor, 13
filealloc, 87
fileclose, 87
filedup, 87
fileread, 87, 90
filestat, 87
filewrite, 81, 87, 90
fork, 10, 12, 14, 87
forkret, 63
freerange, 34
fsck, 89
fsinit, 80
ftable, 87
getcmd, 12
group commit, 79
guard page, 32
hartid, 64
ialloc, 83, 88
iget, 82, 83, 86
ilock, 82, 83, 86
indirect block, 85
initcode.S, 28, 46
initlog, 80 
inode, 17, 76, 81
install_trans, 80
interface design, 9
interrupt, 41
iput, 82, 83
isolation, 21
itrunc, 83, 85
iunlock, 83
kalloc, 35
kernel, 9, 23
kernel space, 9, 23
kfree, 34
kinit, 34
kvminit, 33
kvminithart, 33
kvmmap, 33
links, 17
loadseg, 37
lock, 51
log, 78
log_write, 80
lost wake-up, 66
machine mode, 23
main, 33, 34, 77
malloc, 12
mappages, 33
memory barrier, 58
memory model, 58
memory-mapped, 31
microkernel, 24
mkdev, 88
mkdir, 88
mkfs, 76
monolithic kernel, 21, 23
multi-core, 21
multiplexing, 61
multiprocessor, 21
mutual exclusion, 53
mycpu, 64
myproc, 65
namei, 36, 88
nameiparent, 86, 88
namex, 86
NBUF, 77
NDIRECT, 84, 85
NINDIRECT, 85
O_CREATE, 88
open, 87, 88
p->context, 64
p->killed, 71, 95
p->kstack, 26
p->lock, 63, 64, 68
p->pagetable, 27
p->state, 27
p->tf, 26, 46
p->xxx, 26
page, 29
page table entries (PTEs), 29
parent process, 10
path, 17
persistence, 75
PGROUNDUP, 34
physical address, 26
PHYSTOP, 33, 34
pid, 10
pipe, 15
piperead, 69
pipewrite, 69
polling, 49, 66
pop_off, 57
printf, 11
priority inversion, 72
privileged instructions, 23
proc_pagetable, 37
process, 9, 24
procinit, 34
programmed I/O, 49
PTE_R, 30
PTE_U, 30
PTE_V, 30
PTE_W, 30
PTE_X, 30
push_off, 57
race condition, 53
read, 87
readi, 37, 85
recover_from_log, 80
release, 55, 57
root, 17
round robin, 71
RUNNABLE, 64, 68, 70
satp, 30
sbrk, 12
sched, 62, 63, 68
scheduler, 63, 64
semaphore, 65
sequence coordination, 65
serializing, 53
sfence.vma, 34
shell, 10 
signal, 72
skipelem, 86
sleep, 66–68
sleep-locks, 59
SLEEPING, 68
sret, 27
stat, 85, 87
stati, 85, 87
struct context, 62
struct cpu, 64
struct dinode, 81, 84
struct dirent, 85
struct elfhdr, 36
struct file, 87
struct inode, 82
struct pipe, 69
struct proc, 26
struct run, 34
struct spinlock, 54
superblock, 76
supervisor mode, 23
swtch, 62–64
SYS_exec, 46
sys_link, 88
sys_mkdir, 88
sys_mknod, 88
sys_open, 88
sys_pipe , 89
sys_sleep, 57
sys_unlink, 88
Syscall, 46
system call, 9
T_DEV, 85
T_DIR, 85
T_FILE, 88
thread, 26
thundering herd, 72
ticks, 57
tickslock, 57
time-share, 10, 21
TRAMPOLINE, 44
trampoline, 26, 44
transaction, 75
Translation Look-aside Buffer (TLB), 34
trap, 41
trapframe, 26
type cast, 35
UART, 47
unlink, 79
user memory, 26
user mode, 23
user space, 9, 23
usertrap, 62
ustack, 37
uvmalloc, 37
valid, 77
virtio_disk_rw, 77, 78
virtual address, 25
wait, 11, 64, 70
wait channel, 66
wakeup, 56, 66, 68
walk, 33
walkaddr, 37
write, 79, 87
write-through, 82
writei, 81, 85
yield, 62–64