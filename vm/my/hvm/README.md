# hvm -- Hack CPU VM based on hack2x86

```
PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm> ./compile

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>gcc hack2x86.c -o hack2x86 
```

## Add

```
PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm> ./run Add       
D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>hack2x86 Add
@2
D=A
@3
D=D+A
@0
M=D

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>gcc main.c Add.s -o Add

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>Add
A=0 D=5
```

## sum

```
PS D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm> ./run sum

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>hack2x86 sum
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

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>gcc main.c sum.s -o sum

D:\ccc\course\sp\code\c\07-asmVm2\hack\hvm>sum
eax=8 ebx=2949120 ecx=10 edx=1
eax=8 ebx=2949120 ecx=4194314 edx=2
eax=8 ebx=2949120 ecx=4194314 edx=3
eax=8 ebx=2949120 ecx=4194314 edx=4
eax=8 ebx=2949120 ecx=4194314 edx=5
eax=8 ebx=2949120 ecx=4194314 edx=6
eax=8 ebx=2949120 ecx=4194314 edx=7
eax=8 ebx=2949120 ecx=4194314 edx=8
eax=8 ebx=2949120 ecx=4194314 edx=9
eax=8 ebx=2949120 ecx=4194314 edx=10
eax=22 ebx=2949121 ecx=4194314 edx=1
A=1 D=55
```
