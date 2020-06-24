# ld 連結器

* 參考 https://www.slideshare.net/jserv/helloworld-internals 32 頁開始！

但是在 Windows 中連結會失敗，可能要改用 Linux ...

* 失敗原因參考 -- https://stackoverflow.com/questions/32164478/when-using-ld-to-link-undefined-reference-to-main

```
PS D:\ccc\book\sp\code\c\05-gnuTool\06-ld> gcc -c a.c b.c
PS D:\ccc\book\sp\code\c\05-gnuTool\06-ld> ld a.o b.o -e main -o ab
C:\Program Files (x86)\CodeBlocks\MinGW\bin\ld.exe: warning: cannot find entry symbol main; defaulting to 00401000


PS D:\ccc\book\sp\code\c\05-gnuTool\06-ld> objdump -h a.o

a.o:     file format pe-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000034  00000000  00000000  000000b4  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000000  00000000  00000000  00000000  2**2
                  ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  00000000  2**2
                  ALLOC
  3 .rdata$zzz    00000014  00000000  00000000  000000e8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
PS D:\ccc\book\sp\code\c\05-gnuTool\06-ld> objdump -h b.o

b.o:     file format pe-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000024  00000000  00000000  000000b4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000004  00000000  00000000  000000d8  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  00000000  2**2
                  ALLOC
  3 .rdata$zzz    00000014  00000000  00000000  000000dc  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
```

## linux 也失敗

```
guest@localhost:~/sp2/obj/elf/01-ld$ gcc -c a.c b.c
guest@localhost:~/sp2/obj/elf/01-ld$ ld a.o. b.o -e main -o ab
ld: cannot find a.o.: No such file or directory
guest@localhost:~/sp2/obj/elf/01-ld$ ls
a.c  a.o  a.s  b.c  b.o  b.s  README.md
guest@localhost:~/sp2/obj/elf/01-ld$ ld a.o b.o -e main -o ab
a.o: In function `main':
a.c:(.text+0x46): undefined reference to `__stack_chk_fail'
guest@localhost:~/sp2/obj/elf/01-ld$ gcc -m32 -c a.c b.c
guest@localhost:~/sp2/obj/elf/01-ld$ ld -m32 a.o b.o -e main -o ab
ld: unrecognised emulation mode: 32
Supported emulations: elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu i386linux elf_l1om elf_k1om i386pep i386pe
guest@localhost:~/sp2/obj/elf/01-ld$ ld a.o b.o -e main -o ab
ld: i386 architecture of input file `a.o' is incompatible with i386:x86-64 output
ld: i386 architecture of input file `b.o' is incompatible with i386:x86-64 output
a.o: In function `main':
a.c:(.text+0x18): undefined reference to `_GLOBAL_OFFSET_TABLE_'
a.c:(.text+0x59): undefined reference to `__stack_chk_fail_local'
b.o: In function `swap':
b.c:(.text+0xc): undefined reference to `_GLOBAL_OFFSET_TABLE_'
ld: ab: hidden symbol `__stack_chk_fail_local' isn't defined
ld: final link failed: Bad value
guest@localhost:~/sp2/obj/elf/01-ld$ ld -m elf_i386 a.o b.o -e main -o ab
a.o: In function `main':
a.c:(.text+0x59): undefined reference to `__stack_chk_fail_local'
ld: ab: hidden symbol `__stack_chk_fail_local' isn't defined
ld: final link failed: Bad value
```
