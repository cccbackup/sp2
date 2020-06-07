# ObjFile

* [10 ways to analyze binary files on Linux](https://opensource.com/article/20/4/linux-binary-analysis) (讚!)

1. file
2. ldd
3. ltrace
4. Hexdump
5. strings
6. readelf
7. objdump
8. strace
9. nm
10. gdb

# ELF 目的檔

* [Linux CTF 逆向入門](https://kknews.cc/code/q4xmj6g.html)
* [Linux工具快速教程](https://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
    * [13. readelf elf文件格式分析](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/readelf.html)
* [Linux ELF 二進位檔案入門：搞懂兼分析](https://security-onigiri.github.io/2018/03/08/the-101-of-elf-binaries-on-linux-understanding-and-analysis.html)
* https://github.com/0intro/libelf/blob/master/README.md
* https://stackoverflow.com/questions/34960383/how-read-elf-header-in-c
* https://github.com/0intro/libelf


## 讀取 ELF 檔頭

```c
#include <elf.h>
#include <stdio.h>
#include <string.h>

void read_elf_header(const char* elfFile) {
  // switch to Elf32_Ehdr for x86 architecture.
  Elf64_Ehdr header;

  FILE* file = fopen(elfFile, "rb");
  if(file) {
    // read the header
    fread(&header, 1, sizeof(header), file);

    // check so its really an elf file
    if (memcmp(header.e_ident, ELFMAG, SELFMAG) == 0) {
       // this is a valid elf file
       printf("e_type=%d\n", header.e_type);
       printf("e_machine=%d\n", header.e_machine);
       printf("e_version=%d\n", header.e_version);
       printf("e_entry=%ld\n", header.e_entry);
       printf("e_phoff=%ld\n", header.e_phoff);
       printf("e_shoff=%ld\n", header.e_shoff);
       printf("e_flags=%d\n", header.e_flags);
       printf("e_ehsize=%d\n", header.e_ehsize);
       printf("e_phentsize=%d\n", header.e_phentsize);
       printf("e_phnum=%d\n", header.e_phnum);
       printf("e_shentsize=%d\n", header.e_shentsize);
       printf("e_shnum=%d\n", header.e_shnum);
       printf("e_shstrndx=%d\n", header.e_shstrndx);
    }

    // finally close the file
    fclose(file);
  }
}

int main() {
  read_elf_header("elf2");
}
```

執行結果

```
root@localhost:~/ccc/linux# ./elf2
e_type=3
e_machine=62
e_version=1
e_entry=1744
e_phoff=64
e_shoff=6712
e_flags=0
e_ehsize=64
e_phentsize=56
e_phnum=9
e_shentsize=64
e_shnum=29
e_shstrndx=28
root@localhost:~/ccc/linux# readelf -h elf2
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x6d0
  Start of program headers:          64 (bytes into file)
  Start of section headers:          6712 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         9
  Size of section headers:           64 (bytes)
  Number of section headers:         29
  Section header string table index: 28

```
