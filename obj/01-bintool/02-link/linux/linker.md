# Linker

* [你所不知道的 C 語言：連結器和執行檔資訊](https://hackmd.io/@sysprog/c-prog/%2Fs%2FSysiUkgUV)
* [你所不知道的 C 語言: 執行階段程式庫 (CRT)](https://hackmd.io/@sysprog/c-prog/%2Fs%2FHkcr5cn97)
* [你所不知道的 C 語言：動態連結器篇](https://hackmd.io/@sysprog/c-dynamic-linkage)

## 示範

連結器會把段落合併：

a.o : text size  = 34      data size = 0   .rdata$zzz size = 14
b.o : text size  = 24      data size = 4   .rdata$zzz size = 14
ab.o : text size = 58      data size = 4   .rdata$zzz size = 28

兩個程式段合併後 34 + 24 = 58

```
PS D:\ccc\sp\code\c\05-obj\05-linker> gcc -c a.c b.c
PS D:\ccc\sp\code\c\05-obj\05-linker> objdump -h a.o

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

PS D:\ccc\sp\code\c\05-obj\05-linker> objdump -h b.o

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

PS D:\ccc\sp\code\c\05-obj\05-linker> ld -relocatable a.o b.o -o ab.o        

PS D:\ccc\sp\code\c\05-obj\05-linker> objdump -h ab.o

ab.o:     file format pe-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000058  00000000  00000000  000000b4  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000004  00000000  00000000  0000010c  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .rdata$zzz    00000028  00000000  00000000  00000110  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .bss          00000000  00000000  00000000  00000000  2**2
                  ALLOC

PS D:\ccc\sp\code\c\05-obj\05-linker> gcc a.o b.o -o ab
PS D:\ccc\sp\code\c\05-obj\05-linker> ./ab
PS D:\ccc\sp\code\c\05-obj\05-linker> objdump -h ab.exe

ab.exe:     file format pei-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000c84  00401000  00401000  00000400  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE, DATA
  1 .data         00000014  00402000  00402000  00001200  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .rdata        00000138  00403000  00403000  00001400  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .eh_frame     000003a0  00404000  00404000  00001600  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .bss          00000060  00405000  00405000  00000000  2**2
                  ALLOC
  5 .idata        00000364  00406000  00406000  00001a00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .CRT          00000018  00407000  00407000  00001e00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .tls          00000020  00408000  00408000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  8 .debug_aranges 00000018  00409000  00409000  00002200  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_info   00000dc5  0040a000  0040a000  00002400  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_abbrev 000000a9  0040b000  0040b000  00003200  2**0
                  CONTENTS, READONLY, DEBUGGING
 11 .debug_line   000000d1  0040c000  0040c000  00003400  2**0
                  CONTENTS, READONLY, DEBUGGING



ab.exe:     file format pei-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000c84  00401000  00401000  00000400  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE, DATA
  1 .data         00000014  00402000  00402000  00001200  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .rdata        00000138  00403000  00403000  00001400  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .eh_frame     000003a0  00404000  00404000  00001600  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .bss          00000060  00405000  00405000  00000000  2**2
                  ALLOC
  5 .idata        00000364  00406000  00406000  00001a00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .CRT          00000018  00407000  00407000  00001e00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .tls          00000020  00408000  00408000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  8 .debug_aranges 00000018  00409000  00409000  00002200  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_info   00000dc5  0040a000  0040a000  00002400  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_abbrev 000000a9  0040b000  0040b000  00003200  2**0
                  CONTENTS, READONLY, DEBUGGING
 11 .debug_line   000000d1  0040c000  0040c000  00003400  2**0
                  CONTENTS, READONLY, DEBUGGING
```
