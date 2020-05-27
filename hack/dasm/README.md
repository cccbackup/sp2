## Hack CPU 的反組譯器

```
PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hdasm> gcc hdasm.c -o hdasm

PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hdasm> ./hdasm Add.bin
@2
D=A
@3
D=D+A
@0
M=D

PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hdasm> ./hdasm sum.bin
@10
D=A
@0
M=D
@16
M=1
@17
M=0
@16
D=M
@0
D=D-M
@22
D;JGT
@16
D=M
@17
M=D+M
@16
M=M+1
@8
0;JMP
@17
D=M
@1
M=D
```