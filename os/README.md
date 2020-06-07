# 作業系統

這個資料夾內的程式請都在 msys2 裡用 msys 環境執行 (不能用 mingw64/mingw32 環境)。

或者在 Linux 裏執行也沒問題！



## 實作

* [xv6 作業系統](../project/xv6)
    * https://github.com/nathan-chin/xv6-riscv-os/tree/master/book

## RISCV OS

* https://github.com/cksystemsteaching/selfie (自我編譯的 C* 語言, 基本上沒有 ＯＳ）
* https://github.com/moratorium08/osmium/
    * [Writing an OS in Rust to run on RISC-V](https://gist.github.com/cb372/5f6bf16ca0682541260ae52fc11ea3bb)
* https://github.com/wm4/dingleberry-os
* https://github.com/fractalclone/zephyr-riscv

## Rust

* https://www.redox-os.org/

## 書籍

* [Advanced Linux Programming](http://discourse-production.oss-cn-shanghai.aliyuncs.com/original/3X/f/4/f4c905949ecd71ab2889b4fd10b1e11910b67460.pdf)
* [Operating Systems: Three Easy Pieces (Book)](http://pages.cs.wisc.edu/~remzi/OSTEP/)
    * [中文版](https://github.com/remzi-arpacidusseau/ostep-translations/tree/master/chinese)


# 參考文獻

* [Linux工具快速教程](https://linuxtools-rst.readthedocs.io/zh_CN/latest/index.html)
    * [13. readelf elf文件格式分析](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/readelf.html)
* https://github.com/0intro/libelf

## 程式

* https://github.com/skuhl/sys-prog-examples (讚!)
    * fork : https://github.com/ccc-c/sys-prog-examples
    * 安裝 -- apt-get install libreadline-dev
    * 進 simple-code 執行 make

## 關注範例:

* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/asm.c
* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/backtrace.c
* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/color-tty.c
* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/fork-basics.c
* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/mmap.c
* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/endianness.c

```
guest@localhost:~/sp/ccc/sys-prog-examples/simple-examples$ ./endianness
Hex of the four bytes: deadbeef
Writing 4 bytes, 1 byte at a time
Note: If you are on a little-endian machine, this actually wrote: 0xefbeadde to the file! Run 'hexdump -C endianness.temp' or 'xxd endianness.temp' to convince yourself of that!
Reading 4 bytes.
We read the same thing that we wrote.
Reading 4 bytes into an array.
0xef was the first byte in the array

We created the file 'endianness.temp'. You can safely delete it.

```

* https://github.com/skuhl/sys-prog-examples/blob/master/simple-examples/chroot.c

```
current working directory: /home/guest/sp/ccc/sys-prog-examples/simple-examples
stat(/Makefile): No such file or directory
current working directory: /
found /Makefile
Breaking out of chroot....
current working directory (escape part 1): (unreachable)/home/guest/sp/ccc/sys-prog-examples/simple-examples
current working directory (escape part 2): (unreachable)/
current working directory (escape part 3): /
listing of files in this directory
bin   home            lib32       media  root  srv  var
boot  initrd.img      lib64       mnt    run   sys  vmlinuz
dev   initrd.img.old  libx32      opt    sbin  tmp  vmlinuz.old
etc   lib             lost+found  proc   snap  usr

```