#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
/*
argint 调用 fetchint 从用户内存地址读取值到 *ip。fetchint 可以简单地将这个地址直接
转换成一个指针，因为用户和内核共享同一个页表，但是内核必须检验这个指针的确指向的是用户
内存空间的一部分。内核已经设置好了页表来保证本进程无法访问它的私有地址以外的内存：如果
一个用户尝试读或者写高于（包含）p->sz的地址，处理器会产生一个段中断，这个中断会杀死此进程，
正如我们之前所见。但是现在，我们在内核态中执行，用户提供的任何地址都是有权访问的，因此
必须要检查这个地址是在 p->sz 之下的。
*/
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}

/*
如何获得系统调用的参数。工具函数 argint、argptr 和 argstr 获得第 n 个系统调用参数，
他们分别用于获取整数，指针和字符串起始地址。argint 利用用户空间的 %esp 寄存器定位
第 n 个参数：%esp 指向系统调用结束后的返回地址。参数就恰好在 %esp 之上（%esp+4）。
因此第 n 个参数就在 %esp+4+4*n。


*/
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
/*
`argptr` 和 `argint` 的目标是相似的：它解析第 n 个系统调用参数。`argptr` 
调用 `argint` 来把第 n 个参数当做是整数来获取，然后把这个整数看做指针，
检查它的确指向的是用户地址空间。注意 `argptr` 的源码中有两次检查。首先，
用户的栈指针在获取参数的时候被检查。然后这个获取到得参数作为用户指针又经过
了一次检查。
*/
int
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
/*
`argstr` 是最后一个用于获取系统调用参数的函数。它将第 n 个系统调用参数解析为指针。
它确保这个指针是一个 NUL 结尾的字符串并且整个完整的字符串都在用户地址空间中。
*/
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);

static int (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
};

/*
对于系统调用，trap 调用 syscall（3375）。syscall 从中断帧中读出系统调用号，
中断帧也包括被保存的 %eax，以及到系统调用函数表的索引。对第一个系统调用而言，
%eax 保存的是 SYS_exec（3207），并且 syscall 会调用第 SYS_exec 个系统调用
函数表的表项，相应地也就调用了 sys_exec。

syscall 在 %eax 保存系统调用函数的返回值。当 trap 返回用户空间时，它会从
 cp->tf 中加载其值到寄存器中。因此，当 exec 返回时，它会返回系统调用处理函数
 返回的返回值（3381）。系统调用按照惯例会在发生错误的时候返回一个小于 0 的数，
 成功执行时返回正数。如果系统调用号是非法的，syscall 会打印错误并且返回 -1。

系统调用的实现（例如，[sysproc.c] 和 [sysfile.c]）仅仅是封装而已：他们用 
`argint`，`argptr` 和 `argstr` 来解析参数，然后调用真正的实现。在第一章，
`sys_exec` 利用这些函数来获取参数。
*/
void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
