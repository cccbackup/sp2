#include "asm.h"
#include "memlayout.h"
#include "mmu.h"

# Start the first CPU: switch to 32-bit protected mode, jump into C.    // 切到 32-bit 保護模式，跳入 C。
# The BIOS loads this code from the first sector of the hard disk into  // BIOS 會將此段程式從第一磁區載入到 0X7C00
# memory at physical address 0x7c00 and starts executing in real mode   // 並以真實模式執行 (cs=0, ip=7c00)
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode // 接下來為 16-bits 組合語言
.globl start
start:
  cli                         # BIOS enabled interrupts; disable // 禁止中斷

  # Zero data segment registers DS, ES, and SS. // 清零 ds = es = ss = 0
  xorw    %ax,%ax             # Set %ax to zero
  movw    %ax,%ds             # -> Data Segment
  movw    %ax,%es             # -> Extra Segment
  movw    %ax,%ss             # -> Stack Segment

  # Physical address line A20 is tied to zero so that the first PCs // 解除記憶體 1MB 限制
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy 
  testb   $0x2,%al
  jnz     seta20.1

  movb    $0xd1,%al               # 0xd1 -> port 0x64
  outb    %al,$0x64

seta20.2:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.2

  movb    $0xdf,%al               # 0xdf -> port 0x60
  outb    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes // 從實體模式開始，企圖進入保護模式
  # virtual addresses map directly to physical addresses so that the // 設定 GDT 將虛擬記憶體直接映射為實體記憶體
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
  movl    %cr0, %eax
  orl     $CR0_PE, %eax
  movl    %eax, %cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32     # // 跳轉進入 32-bit 保護模式

.code32  # Tell assembler to generate 32-bit code now. // 以下為 32-bit 的組合語言 (以上為 16-bit)
start32:
  # Set up the protected-mode data segment registers // 設定保護模式的段暫存器 ds, es, ss, fs=0, gs=0
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
  movw    %ax, %ds                # -> DS: Data Segment
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %ss                # -> SS: Stack Segment
  movw    $0, %ax                 # Zero segments not ready for use
  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS

  # Set up the stack pointer and call into C. // 設定 C 語言堆疊區
  movl    $start, %esp
  call    bootmain

  # If bootmain returns (it shouldn't), trigger a Bochs // 如果 call bootmain() 發生錯誤，進入無窮迴圈！
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
  movw    %ax, %dx
  outw    %ax, %dx
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
  outw    %ax, %dx
spin:
  jmp     spin

# Bootstrap GDT
.p2align 2                                # force 4 byte alignment // 32 位元(4-bytes 對齊法)
gdt:                                      # // 這個 gdt 表只有程式段和資料段 (kernel mode)
  SEG_NULLASM                             # null seg // null 段
  SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)   # code seg // code 段，可讀可執行
  SEG_ASM(STA_W, 0x0, 0xffffffff)         # data seg // data 段，可寫

gdtdesc:                                  # 42 行的 lgdt 會載入這個 gdtdesc
  .word   (gdtdesc - gdt - 1)             # sizeof(gdt) - 1 // gdt 的大小
  .long   gdt                             # address gdt // gdt 的位置 (上面的 gdt 表: 80 行)

