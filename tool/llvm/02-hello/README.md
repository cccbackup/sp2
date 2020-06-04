# LLVM use

目前我安裝的版本是 clang-10 lldb-10 lld-10

## Linux 使用

```
guest@localhost:~/sp/code/c/12-compiler3/llvm/02-hello$ clang-10 hello.c -o hello
guest@localhost:~/sp/code/c/12-compiler3/llvm/02-hello$ ./hello
hello!
```


## windows 

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/09-toolchain2/llvm/01-hello
$ clang hello.c -o hello

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/09-toolchain2/llvm/01-hello
$ ./hello
hello!

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/09-toolchain2/llvm/01-hello
$ clang sum.c -o sum

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/09-toolchain2/llvm/01-hello
$ ./sum
sum(10)=55

```

## 使用 中間碼

mac 上的操作

```
mac020:02-hello mac020$ clang -S -emit-llvm sum.c
mac020:02-hello mac020$ llc sum.ll
mac020:02-hello mac020$ clang sum.s -o sum
mac020:02-hello mac020$ ./sum
sum(10)=55
```

然後你可以看到 sum.ll 如下

```
; ModuleID = 'sum.c'
source_filename = "sum.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@.str = private unnamed_addr constant [12 x i8] c"sum(10)=%d\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @sum(i32) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  store i32 0, i32* %3, align 4
  store i32 0, i32* %4, align 4
  br label %5

; <label>:5:                                      ; preds = %13, %1
  %6 = load i32, i32* %4, align 4
  %7 = load i32, i32* %2, align 4
  %8 = icmp sle i32 %6, %7
  br i1 %8, label %9, label %16

; <label>:9:                                      ; preds = %5
  %10 = load i32, i32* %3, align 4
  %11 = load i32, i32* %4, align 4
  %12 = add nsw i32 %10, %11
  store i32 %12, i32* %3, align 4
  br label %13

; <label>:13:                                     ; preds = %9
  %14 = load i32, i32* %4, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, i32* %4, align 4
  br label %5

; <label>:16:                                     ; preds = %5
  %17 = load i32, i32* %3, align 4
  ret i32 %17
}

; Function Attrs: noinline nounwind ssp uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = call i32 @sum(i32 10)
  store i32 %2, i32* %1, align 4
  %3 = load i32, i32* %1, align 4
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0), i32 %3)
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

attributes #0 = { noinline nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"Apple LLVM version 9.0.0 (clang-900.0.39.2)"}
```

## 抽象語法樹

```
guest@localhost:~/sp/code/c/12-compiler3/llvm/02-hello$ clang-10 -c -Xclang -ast-dump hello.c > hello.ast
guest@localhost:~/sp/code/c/12-compiler3/llvm/02-hello$ cat hello.ast | more
TranslationUnitDecl 0x1f9b868 <<invalid sloc>> <invalid sloc>
|-TypedefDecl 0x1f9c100 <<invalid sloc>> <invalid sloc> implicit
 __int128_t '__int128'
| `-BuiltinType 0x1f9be00 '__int128'
|-TypedefDecl 0x1f9c170 <<invalid sloc>> <invalid sloc> implicit
 __uint128_t 'unsigned __int128'
| `-BuiltinType 0x1f9be20 'unsigned __int128'
|-TypedefDecl 0x1f9c478 <<invalid sloc>> <invalid sloc> implicit
 __NSConstantString 'struct __NSConstantString_tag'
| `-RecordType 0x1f9c250 'struct __NSConstantString_tag'
|   `-Record 0x1f9c1c8 '__NSConstantString_tag'
|-TypedefDecl 0x1f9c510 <<invalid sloc>> <invalid sloc> implicit
 __builtin_ms_va_list 'char *'
| `-PointerType 0x1f9c4d0 'char *'
|   `-BuiltinType 0x1f9b900 'char'
|-TypedefDecl 0x1f9c808 <<invalid sloc>> <invalid sloc> implicit refere
nced __builtin_va_list 'struct __va_list_tag [1]'
| `-ConstantArrayType 0x1f9c7b0 'struct __va_list_tag [1]' 1

```

## 包含套件

```
Install
(stable branch)
To retrieve the archive signature:
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421


To install just clang, lld and lldb (10 release):
apt-get install clang-10 lldb-10 lld-10


To install all key packages:
# LLVM
apt-get install libllvm-10-ocaml-dev libllvm10 llvm-10 llvm-10-dev llvm-10-doc llvm-10-examples llvm-10-runtime
# Clang and co
apt-get install clang-10 clang-tools-10 clang-10-doc libclang-common-10-dev libclang-10-dev libclang1-10 clang-format-10 python-clang-10 clangd-10
# libfuzzer
apt-get install libfuzzer-10-dev
# lldb
apt-get install lldb-10
# lld (linker)
apt-get install lld-10
# libc++
apt-get install libc++-10-dev libc++abi-10-dev
# OpenMP
apt-get install libomp-10-dev
```
