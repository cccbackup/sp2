#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

/*
exec 是创建地址空间中用户部分的系统调用。它根据文件系统中保存的某个文件来初始化用户部分。
exec（5910）通过 namei（5920）打开二进制文件，这一点将在第 6 章进行解释。
然后，它读取 ELF 头。xv6 应用程序以通行的 ELF 格式来描述，该格式在 elf.h 中定义。
一个 ELF 二进制文件包括了一个 ELF 头，即结构体 struct elfhdr（0955），然后是连续几个程序段的头，
即结构体 struct proghdr（0974）。每个 proghdr 都描述了需要载入到内存中的程序段。
xv6 中的程序只有一个程序段的头，但其他操作系统中可能有多个。

exec 第一步是检查文件是否包含 ELF 二进制代码。一个 ELF 二进制文件是以4个“魔法数字”开头的，
即 0x7F，“E”，“L”，“F”，或者写为宏 ELF_MAGIC（0952）。如果 ELF 头中包含正确的魔法数字，
exec 就会认为该二进制文件的结构是正确的。

exec 通过 setupkvm（5931）分配了一个没有用户部分映射的页表，再通过 allocuvm（5943）为每个 
ELF 段分配内存，然后通过 loaduvm（5945）把段的内容载入内存中。
allocuvm 会检查请求分配的虚拟地址是否是在 KERNBASE 之下。 
loaduvm（1818） 通过 walkpgdir 来找到写入 ELF 段的内存的物理地址；通过 readi 来将段的内容从文件中读出。

程序段头中的 filesz 可能比 memsz 小，这表示中间相差的地方应该用 0 填充（对于 C 的全局变量）而不是继续从文件中读数据。
对于 /init，filesz 是 2240 字节而 memsz 是 2252 字节。所以 allocuvm 会分配足够的内存来装 2252 字节的内容，
但只从文件 /init 中读取 2240 字节的内容。

现在 exec 要分配以及初始化用户栈了。它只为栈分配一页内存。exec 一次性把参数字符串拷贝到栈顶，
然后把指向它们的指针保存在 ustack 中。它还会在 main 参数列表 argv 的最后放一个空指针。
这样，ustack 中的前三项就是伪造的返回 PC，argc 和 argv 指针了。

exec 会在栈的页下方放一个无法访问的页，这样当程序尝试使用超过一个页的栈时就会出错。
另外，这个无法访问的页也让 exec 能够处理那些过于庞大的参数；当参数过于庞大时，
exec 用于将参数拷贝到栈上的函数 copyout 会发现目标页无法访问，并且返回 -1。

在创建新的内存映像时，如果 exec 发现了错误，比如一个无效的程序段，它就会跳转到标记 bad 处，
释放这段内存映像，然后返回 -1。exec 必须在确认该调用可以成功后才能释放原来的内存映像，
否则，若原来的内存映像被释放，exec 甚至都无法向它返回 -1 了。
exec 中的错误只可能发生在新建内存映像时。一旦新的内存映像建立完成，exec 就能装载新映像（5989）
而把旧映像释放（5990）。最后，exec 成功地返回 0。
*/

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
