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
