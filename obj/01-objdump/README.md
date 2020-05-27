## objdump 反組譯目的檔

編譯為目的檔

```
$ gcc -c add.c -o add.o
```

傾印目的檔

```
$ objdump -s add.o

add.o:     file format pe-i386

Contents of section .text:
 0000 5589e58b 55088b45 0c01d05d c3909090  U...U..E...]....
Contents of section .rdata$zzz:
 0000 4743433a 20287464 6d2d3129 20352e31  GCC: (tdm-1) 5.1
 0010 2e300000                             .0..
```

反組譯目的檔

```
$ objdump -d add.o

add.o:     file format pe-i386


Disassembly of section .text:

00000000 <_add>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   8b 55 08                mov    0x8(%ebp),%edx
   6:   8b 45 0c                mov    0xc(%ebp),%eax
   9:   01 d0                   add    %edx,%eax
   b:   5d                      pop    %ebp
   c:   c3                      ret
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop
```

## 表頭

```
PS D:\ccc\sp\code\c\05-obj\01-objdump> objdump -h add.o

add.o:     file format pe-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000001c  00000000  00000000  000000b4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .data         00000000  00000000  00000000  00000000  2**2
                  ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  00000000  2**2
                  ALLOC
  3 .rdata$zzz    00000014  00000000  00000000  000000d0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
```