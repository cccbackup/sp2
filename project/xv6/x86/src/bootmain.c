// Boot loader. 啟動載入器
//
// Part of the boot block, along with bootasm.S, which calls bootmain(). // bootasm.S 會呼叫 bootmain()
// bootasm.S has put the processor into protected 32-bit mode.           // bootasm.S 已進入 32-bit 模式
// bootmain() loads an ELF kernel image from the disk starting at        // bootmain() 會載入 kernel 的 ELF
// sector 1 and then jumps to the kernel entry routine.                  // 然後開始執行 kernel

#include "types.h"
#include "elf.h"
#include "x86.h"
#include "memlayout.h"

#define SECTSIZE  512

void readseg(uchar*, uint, uint);

void
bootmain(void)                                     // C 語言的 bootmain() 啟動程式
{
  struct elfhdr *elf;
  struct proghdr *ph, *eph;
  void (*entry)(void);
  uchar* pa;
  // 引导加载器的 C 语言部分 bootmain.c（8500）目的是在磁盘的第二个扇区开头找到内核程序。如我们在第2章所见，内核是 ELF 格式的二进制文件。为了读取 ELF 头，bootmain 载入 ELF 文件的前4096字节（8514），并将其拷贝到内存中 0x10000 处。
  elf = (struct elfhdr*)0x10000;  // scratch spacex

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0); // 讀取 elf 的前 4K 表頭

  // Is this an ELF executable? // 若不是可執行的 ELF 檔，直接失敗返回！
  if(elf->magic != ELF_MAGIC)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags). // 載入所有程式段，
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    pa = (uchar*)ph->paddr;
    readseg(pa, ph->filesz, ph->off);
    if(ph->memsz > ph->filesz) // 尚未
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
}

void
waitdisk(void)
{
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    ;
}

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
  uchar* epa;

  epa = pa + count;

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
}
