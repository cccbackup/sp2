# binutils

二進位工具 -- 包含 as, ld, objdump, nm, strings, ar, objcopy, readelf, strip

* https://zh.wikipedia.org/zh-tw/GNU_Binutils

## nm (name mangling 名稱修飾)

印出符號表

```
$ gcc -c test.c -o test.o
$ nm test.o
00000000 b .bss
00000000 d .data
00000000 i .drectve
00000000 r .rdata
00000000 r .rdata$zzz
00000000 t .text
00000000 D _a
00000004 C _b
00000004 C _c
00000000 T _foo
         U _printf
00000004 D _str
```

## strings

```
$ strings test.o
 -aligncomm:"_b",2 -aligncomm:"_c",2
foo %d %s
GCC: (tdm-1) 5.1.0
```

## size

```
PS D:\ccc\sp\code\c\05-objfile\04-binutils> size test.o       
   text    data     bss     dec     hex filename
     76      44       0     120      78 test.o
```

## strip (中文:脫衣)

```
$ nm test.o
00000000 b .bss
00000000 d .data
00000000 i .drectve
00000000 r .rdata
00000000 r .rdata$zzz
00000000 t .text
00000000 D _a
00000004 C _b
00000004 C _c
00000000 T _foo
         U _printf
00000004 D _str

PS D:\ccc\sp\code\c\05-objfile\04-binutils> strip test.o      

PS D:\ccc\sp\code\c\05-objfile\04-binutils> nm test.o
D:\install\CodeBlocksPortable\App\CodeBlocks\MinGW\bin\nm.exe: test.o: no symbols


```