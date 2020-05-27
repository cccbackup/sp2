
```
root@localhost:~/riscv#  sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev g
awk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Note, selecting 'libexpat1-dev' instead of 'libexpat-dev'
autoconf is already the newest version (2.69-11).
automake is already the newest version (1:1.15.1-3ubuntu2).
autotools-dev is already the newest version (20180224.1).
bc is already the newest version (1.07.1-2).
bison is already the newest version (2:3.0.4.dfsg-1build1).
build-essential is already the newest version (12.4ubuntu1).
flex is already the newest version (2.6.4-6).
gawk is already the newest version (1:4.1.4+dfsg-1build1).
libgmp-dev is already the newest version (2:6.1.2+dfsg-2).
libmpc-dev is already the newest version (1.1.0-1).
libmpfr-dev is already the newest version (4.0.1-1).
libtool is already the newest version (2.4.6-2).
patchutils is already the newest version (0.3.4-2).
zlib1g-dev is already the newest version (1:1.2.11.dfsg-0ubuntu2).
gperf is already the newest version (3.1-1).
texinfo is already the newest version (6.5.0.dfsg.1-2).
curl is already the newest version (7.58.0-2ubuntu3.8).
libexpat1-dev is already the newest version (2.2.5-3ubuntu0.2).
0 upgraded, 0 newly installed, 0 to remove and 317 not upgraded.
```

## 

```
root@localhost:~/riscv/riscv-gnu-toolchain# ./configure --prefix=/usr/local
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for grep that handles long lines and -e... /bin/grep
checking for fgrep... /bin/grep -F
checking for grep that handles long lines and -e... (cached) /bin/grep
checking for bash... /bin/bash
checking for __gmpz_init in -lgmp... yes
checking for mpfr_init in -lmpfr... yes
checking for mpc_init2 in -lmpc... yes
checking for curl... /usr/bin/curl
checking for wget... /usr/bin/wget
checking for ftp... /usr/bin/ftp
configure: creating ./config.status
config.status: creating Makefile
config.status: creating scripts/wrapper/awk/awk
config.status: creating scripts/wrapper/sed/sed
```

## 

```
root@localhost:~/riscv/riscv-gnu-toolchain# riscv64-unknown-elf-gcc --version
riscv64-unknown-elf-gcc (GCC) 9.2.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

root@localhost:~/riscv/riscv-gnu-toolchain# qemu-system-riscv64 --version
QEMU emulator version 4.1.0
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
```



