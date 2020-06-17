# QEMU 

* [QEMU 跨平台虛擬機原理解析](qemuStudy.md)
* [使用 qemu 執行 xv6 作業系統](xv6) !

## 安裝

* https://www.qemu.org/download/#windows

安裝後位置:
1. windows : C:\Program Files\qemu

## 參考文獻

* [QEMU, a Fast and Portable Dynamic Translator (PDF)](http://archives.cse.iitd.ernet.in/~sbansal/csl862-virt/2010/readings/bellard.pdf) -- Fabrice Bellard
* [跨平台虛擬機 - QEMU](http://sp1.wikidot.com/qemu) -- 陳鍾誠。
* [QEMU-IMG入门教程](https://blog.gavinzh.com/2017/08/02/qemu-img-tutorial-commands/)
* [使用qemu安装虚拟机](https://blog.csdn.net/RichardYSteven/article/details/54645328) (讚!)
* [QEMU (正體中文)](https://wiki.archlinux.org/index.php/QEMU_(%E6%AD%A3%E9%AB%94%E4%B8%AD%E6%96%87))
* [QEMU 1: 使用QEMU创建虚拟机](https://my.oschina.net/kelvinxupt/blog/265108)
* [一文读懂 Qemu 模拟器](https://www.jianshu.com/p/db8c20aa6a69)
* [五分鐘開始玩 qemu-kvm 虛擬機](https://newtoypia.blogspot.com/2015/02/qemu-kvm.html)

* [QEMU Emulator User Documentation](http://people.redhat.com/pbonzini/qemu-test-doc/_build/html/index.html)
* https://www.qemu.org/docs/

* https://askubuntu.com/questions/138140/how-do-i-install-qemu

# QEMU

* [QEMU-IMG入门教程](https://blog.gavinzh.com/2017/08/02/qemu-img-tutorial-commands/)
* [使用qemu安装虚拟机](https://blog.csdn.net/RichardYSteven/article/details/54645328) (讚!)
* [QEMU (正體中文)](https://wiki.archlinux.org/index.php/QEMU_(%E6%AD%A3%E9%AB%94%E4%B8%AD%E6%96%87))
* [QEMU 1: 使用QEMU创建虚拟机](https://my.oschina.net/kelvinxupt/blog/265108)
* [一文读懂 Qemu 模拟器](https://www.jianshu.com/p/db8c20aa6a69)
* [五分鐘開始玩 qemu-kvm 虛擬機](https://newtoypia.blogspot.com/2015/02/qemu-kvm.html)

* [QEMU Emulator User Documentation](http://people.redhat.com/pbonzini/qemu-test-doc/_build/html/index.html)
* https://www.qemu.org/docs/

* https://askubuntu.com/questions/138140/how-do-i-install-qemu

## Install

```
root@localhost:/home/guest/spMore# sudo apt-get install qemu
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  cpu-checker libxen-4.9 libxenstore3.0 libyajl2 msr-tools qemu-block-extra
  qemu-slof qemu-system qemu-system-common qemu-system-mips qemu-system-ppc
  qemu-system-s390x qemu-system-sparc qemu-system-x86 qemu-user
  qemu-user-binfmt qemu-utils
Suggested packages:
  qemu-user-static samba vde2 openbios-ppc openhackware openbios-sparc sgabios
  ovmf debootstrap
The following NEW packages will be installed:
  cpu-checker libxen-4.9 libxenstore3.0 libyajl2 msr-tools qemu qemu-slof
  qemu-system qemu-system-mips qemu-system-ppc qemu-system-s390x
  qemu-system-sparc qemu-system-x86
The following packages will be upgraded:
  qemu-block-extra qemu-system-common qemu-user qemu-user-binfmt qemu-utils
5 upgraded, 13 newly installed, 0 to remove and 314 not upgraded.
Need to get 9,160 kB/36.7 MB of archives.
After this operation, 129 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-utils amd64 1:2.11+dfsg-1ubuntu7.23 [871 kB]
Get:2 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-system-common amd64 1:2.11+dfsg-1ubuntu7.23 [672 kB]
Get:3 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-block-extra amd64 1:2.11+dfsg-1ubuntu7.23 [39.6 kB]
Get:4 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu-user-binfmt amd64 1:2.11+dfsg-1ubuntu7.23 [2,568 B]
Get:5 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu-user amd64 1:2.11+dfsg-1ubuntu7.23 [7,359 kB]
Get:6 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu amd64 1:2.11+dfsg-1ubuntu7.23 [215 kB]
Fetched 9,160 kB in 0s (54.6 MB/s)
(Reading database ... 156084 files and directories currently installed.)
Preparing to unpack .../00-qemu-utils_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-utils (1:2.11+dfsg-1ubuntu7.23) over (1:2.11+dfsg-1ubuntu7.21) ...
Preparing to unpack .../01-qemu-system-common_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-common (1:2.11+dfsg-1ubuntu7.23) over (1:2.11+dfsg-1ubuntu7.21) ...
Preparing to unpack .../02-qemu-block-extra_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-block-extra:amd64 (1:2.11+dfsg-1ubuntu7.23) over (1:2.11+dfsg-1ubuntu7.21) ...
Selecting previously unselected package msr-tools.
Preparing to unpack .../03-msr-tools_1.3-2build1_amd64.deb ...
Unpacking msr-tools (1.3-2build1) ...
Selecting previously unselected package cpu-checker.
Preparing to unpack .../04-cpu-checker_0.7-0ubuntu7_amd64.deb ...
Unpacking cpu-checker (0.7-0ubuntu7) ...
Selecting previously unselected package libxenstore3.0:amd64.
Preparing to unpack .../05-libxenstore3.0_4.9.2-0ubuntu1_amd64.deb ...
Unpacking libxenstore3.0:amd64 (4.9.2-0ubuntu1) ...
Selecting previously unselected package libyajl2:amd64.
Preparing to unpack .../06-libyajl2_2.1.0-2build1_amd64.deb ...
Unpacking libyajl2:amd64 (2.1.0-2build1) ...
Selecting previously unselected package libxen-4.9:amd64.
Preparing to unpack .../07-libxen-4.9_4.9.2-0ubuntu1_amd64.deb ...
Unpacking libxen-4.9:amd64 (4.9.2-0ubuntu1) ...
Selecting previously unselected package qemu-system-mips.
Preparing to unpack .../08-qemu-system-mips_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-mips (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-slof.
Preparing to unpack .../09-qemu-slof_20170724+dfsg-1ubuntu1_all.deb ...
Unpacking qemu-slof (20170724+dfsg-1ubuntu1) ...
Selecting previously unselected package qemu-system-ppc.
Preparing to unpack .../10-qemu-system-ppc_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-ppc (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-sparc.
Preparing to unpack .../11-qemu-system-sparc_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-sparc (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-x86.
Preparing to unpack .../12-qemu-system-x86_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-x86 (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-s390x.
Preparing to unpack .../13-qemu-system-s390x_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-s390x (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system.
Preparing to unpack .../14-qemu-system_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system (1:2.11+dfsg-1ubuntu7.23) ...
Preparing to unpack .../15-qemu-user-binfmt_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-user-binfmt (1:2.11+dfsg-1ubuntu7.23) over (1:2.11+dfsg-1ubuntu7.21) ...
Preparing to unpack .../16-qemu-user_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-user (1:2.11+dfsg-1ubuntu7.23) over (1:2.11+dfsg-1ubuntu7.21) ...
Selecting previously unselected package qemu.
Preparing to unpack .../17-qemu_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-user (1:2.11+dfsg-1ubuntu7.23) ...
Setting up libxenstore3.0:amd64 (4.9.2-0ubuntu1) ...
Setting up msr-tools (1.3-2build1) ...
Setting up qemu-block-extra:amd64 (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-slof (20170724+dfsg-1ubuntu1) ...
Setting up qemu-utils (1:2.11+dfsg-1ubuntu7.23) ...
Setting up libyajl2:amd64 (2.1.0-2build1) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...
Setting up cpu-checker (0.7-0ubuntu7) ...
Setting up qemu-user-binfmt (1:2.11+dfsg-1ubuntu7.23) ...
Processing triggers for man-db (2.8.3-2) ...
Setting up libxen-4.9:amd64 (4.9.2-0ubuntu1) ...
Setting up qemu-system-common (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-mips (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-ppc (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-s390x (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-x86 (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-sparc (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu (1:2.11+dfsg-1ubuntu7.23) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...

root@localhost:/home/guest/spMore# ls /usr/bin/qemu*
/usr/bin/qemu-aarch64         /usr/bin/qemu-system-alpha
/usr/bin/qemu-alpha           /usr/bin/qemu-system-arm
/usr/bin/qemu-arm             /usr/bin/qemu-system-cris
/usr/bin/qemu-armeb           /usr/bin/qemu-system-i386
/usr/bin/qemu-cris            /usr/bin/qemu-system-lm32
/usr/bin/qemu-hppa            /usr/bin/qemu-system-m68k
/usr/bin/qemu-i386            /usr/bin/qemu-system-microblaze
/usr/bin/qemu-img             /usr/bin/qemu-system-microblazeel
/usr/bin/qemu-io              /usr/bin/qemu-system-mips
/usr/bin/qemu-m68k            /usr/bin/qemu-system-mips64
/usr/bin/qemu-microblaze      /usr/bin/qemu-system-mips64el
/usr/bin/qemu-microblazeel    /usr/bin/qemu-system-mipsel
/usr/bin/qemu-mips            /usr/bin/qemu-system-moxie
/usr/bin/qemu-mips64          /usr/bin/qemu-system-nios2
/usr/bin/qemu-mips64el        /usr/bin/qemu-system-or1k
/usr/bin/qemu-mipsel          /usr/bin/qemu-system-ppc
/usr/bin/qemu-mipsn32         /usr/bin/qemu-system-ppc64
/usr/bin/qemu-mipsn32el       /usr/bin/qemu-system-ppc64le
/usr/bin/qemu-nbd             /usr/bin/qemu-system-ppcemb
/usr/bin/qemu-nios2           /usr/bin/qemu-system-s390x
/usr/bin/qemu-or1k            /usr/bin/qemu-system-sh4
/usr/bin/qemu-ppc             /usr/bin/qemu-system-sh4eb
/usr/bin/qemu-ppc64           /usr/bin/qemu-system-sparc
/usr/bin/qemu-ppc64abi32      /usr/bin/qemu-system-sparc64
/usr/bin/qemu-ppc64le         /usr/bin/qemu-system-tricore
/usr/bin/qemu-s390x           /usr/bin/qemu-system-unicore32
/usr/bin/qemu-sh4             /usr/bin/qemu-system-x86_64
/usr/bin/qemu-sh4eb           /usr/bin/qemu-system-xtensa
/usr/bin/qemu-sparc           /usr/bin/qemu-system-xtensaeb
/usr/bin/qemu-sparc32plus     /usr/bin/qemu-tilegx
/usr/bin/qemu-sparc64         /usr/bin/qemu-x86_64
/usr/bin/qemu-system-aarch64

```


## KVM

* [Kvm教程](https://wiki.ubuntu.org.cn/Kvm%E6%95%99%E7%A8%8B)

```
root@localhost:/home/guest/spMore/mini-arm-os/00-HelloWorld# sudo apt-get install qemu-system
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  cpp-7-riscv64-linux-gnu cpp-riscv64-linux-gnu gcc-7-cross-base-ports
  gcc-7-riscv64-linux-gnu-base gcc-8-cross-base-ports libatomic1-riscv64-cross
  libc6-dev-riscv64-cross libc6-riscv64-cross libgcc-7-dev-riscv64-cross
  libgcc1-riscv64-cross libgomp1-riscv64-cross linux-libc-dev-riscv64-cross
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  cpu-checker libxen-4.9 libxenstore3.0 libyajl2 msr-tools qemu-slof
  qemu-system-mips qemu-system-ppc qemu-system-s390x qemu-system-sparc
  qemu-system-x86
Suggested packages:
  qemu samba vde2 qemu-block-extra openbios-ppc openhackware openbios-sparc
  sgabios ovmf
The following NEW packages will be installed:
  cpu-checker libxen-4.9 libxenstore3.0 libyajl2 msr-tools qemu-slof
  qemu-system qemu-system-mips qemu-system-ppc qemu-system-s390x
  qemu-system-sparc qemu-system-x86
0 upgraded, 12 newly installed, 0 to remove and 323 not upgraded.
Need to get 27.5 MB of archives.
After this operation, 129 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://mirrors.linode.com/ubuntu bionic/main amd64 msr-tools amd64 1.3-2build1 [9,760 B]
Get:2 http://mirrors.linode.com/ubuntu bionic/main amd64 cpu-checker amd64 0.7-0ubuntu7 [6,862 B]
Get:3 http://mirrors.linode.com/ubuntu bionic/main amd64 libxenstore3.0 amd64 4.9.2-0ubuntu1 [19.7 kB]
Get:4 http://mirrors.linode.com/ubuntu bionic/main amd64 libyajl2 amd64 2.1.0-2build1 [20.0 kB]
Get:5 http://mirrors.linode.com/ubuntu bionic/main amd64 libxen-4.9 amd64 4.9.2-0ubuntu1 [399 kB]
Get:6 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu-system-mips amd64 1:2.11+dfsg-1ubuntu7.23 [9,491 kB]
Get:7 http://mirrors.linode.com/ubuntu bionic/main amd64 qemu-slof all 20170724+dfsg-1ubuntu1 [172 kB]
Get:8 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-system-ppc amd64 1:2.11+dfsg-1ubuntu7.23 [7,549 kB]
Get:9 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu-system-sparc amd64 1:2.11+dfsg-1ubuntu7.23 [2,770 kB]
Get:10 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-system-x86 amd64 1:2.11+dfsg-1ubuntu7.23 [5,202 kB]
Get:11 http://mirrors.linode.com/ubuntu bionic-updates/main amd64 qemu-system-s390x amd64 1:2.11+dfsg-1ubuntu7.23 [1,852 kB]
Get:12 http://mirrors.linode.com/ubuntu bionic-updates/universe amd64 qemu-system amd64 1:2.11+dfsg-1ubuntu7.23 [12.2 kB]
Fetched 27.5 MB in 0s (63.4 MB/s)
Selecting previously unselected package msr-tools.
(Reading database ... 157578 files and directories currently installed.)
Preparing to unpack .../00-msr-tools_1.3-2build1_amd64.deb ...
Unpacking msr-tools (1.3-2build1) ...
Selecting previously unselected package cpu-checker.
Preparing to unpack .../01-cpu-checker_0.7-0ubuntu7_amd64.deb ...
Unpacking cpu-checker (0.7-0ubuntu7) ...
Selecting previously unselected package libxenstore3.0:amd64.
Preparing to unpack .../02-libxenstore3.0_4.9.2-0ubuntu1_amd64.deb ...
Unpacking libxenstore3.0:amd64 (4.9.2-0ubuntu1) ...
Selecting previously unselected package libyajl2:amd64.
Preparing to unpack .../03-libyajl2_2.1.0-2build1_amd64.deb ...
Unpacking libyajl2:amd64 (2.1.0-2build1) ...
Selecting previously unselected package libxen-4.9:amd64.
Preparing to unpack .../04-libxen-4.9_4.9.2-0ubuntu1_amd64.deb ...
Unpacking libxen-4.9:amd64 (4.9.2-0ubuntu1) ...
Selecting previously unselected package qemu-system-mips.
Preparing to unpack .../05-qemu-system-mips_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-mips (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-slof.
Preparing to unpack .../06-qemu-slof_20170724+dfsg-1ubuntu1_all.deb ...
Unpacking qemu-slof (20170724+dfsg-1ubuntu1) ...
Selecting previously unselected package qemu-system-ppc.
Preparing to unpack .../07-qemu-system-ppc_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-ppc (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-sparc.
Preparing to unpack .../08-qemu-system-sparc_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-sparc (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-x86.
Preparing to unpack .../09-qemu-system-x86_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-x86 (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system-s390x.
Preparing to unpack .../10-qemu-system-s390x_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system-s390x (1:2.11+dfsg-1ubuntu7.23) ...
Selecting previously unselected package qemu-system.
Preparing to unpack .../11-qemu-system_1%3a2.11+dfsg-1ubuntu7.23_amd64.deb ...
Unpacking qemu-system (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-mips (1:2.11+dfsg-1ubuntu7.23) ...
Setting up libxenstore3.0:amd64 (4.9.2-0ubuntu1) ...
Setting up qemu-system-s390x (1:2.11+dfsg-1ubuntu7.23) ...
Setting up msr-tools (1.3-2build1) ...
Setting up qemu-slof (20170724+dfsg-1ubuntu1) ...
Setting up libyajl2:amd64 (2.1.0-2build1) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...
Setting up cpu-checker (0.7-0ubuntu7) ...
Setting up qemu-system-sparc (1:2.11+dfsg-1ubuntu7.23) ...
Processing triggers for man-db (2.8.3-2) ...
Setting up libxen-4.9:amd64 (4.9.2-0ubuntu1) ...
Setting up qemu-system-ppc (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system-x86 (1:2.11+dfsg-1ubuntu7.23) ...
Setting up qemu-system (1:2.11+dfsg-1ubuntu7.23) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...
root@localhost:/home/guest/spMore/mini-arm-os/00-HelloWorld#

```


```
root@localhost:/home/guest/spMore/mini-arm-os/00-HelloWorld# ls /usr/bin/qemu*
/usr/bin/qemu-aarch64         /usr/bin/qemu-system-alpha
/usr/bin/qemu-alpha           /usr/bin/qemu-system-arm
/usr/bin/qemu-arm             /usr/bin/qemu-system-cris
/usr/bin/qemu-armeb           /usr/bin/qemu-system-i386
/usr/bin/qemu-cris            /usr/bin/qemu-system-lm32
/usr/bin/qemu-hppa            /usr/bin/qemu-system-m68k
/usr/bin/qemu-i386            /usr/bin/qemu-system-microblaze
/usr/bin/qemu-img             /usr/bin/qemu-system-microblazeel
/usr/bin/qemu-io              /usr/bin/qemu-system-mips
/usr/bin/qemu-m68k            /usr/bin/qemu-system-mips64
/usr/bin/qemu-microblaze      /usr/bin/qemu-system-mips64el
/usr/bin/qemu-microblazeel    /usr/bin/qemu-system-mipsel
/usr/bin/qemu-mips            /usr/bin/qemu-system-moxie
/usr/bin/qemu-mips64          /usr/bin/qemu-system-nios2
/usr/bin/qemu-mips64el        /usr/bin/qemu-system-or1k
/usr/bin/qemu-mipsel          /usr/bin/qemu-system-ppc
/usr/bin/qemu-mipsn32         /usr/bin/qemu-system-ppc64
/usr/bin/qemu-mipsn32el       /usr/bin/qemu-system-ppc64le
/usr/bin/qemu-nbd             /usr/bin/qemu-system-ppcemb
/usr/bin/qemu-nios2           /usr/bin/qemu-system-s390x
/usr/bin/qemu-or1k            /usr/bin/qemu-system-sh4
/usr/bin/qemu-ppc             /usr/bin/qemu-system-sh4eb
/usr/bin/qemu-ppc64           /usr/bin/qemu-system-sparc
/usr/bin/qemu-ppc64abi32      /usr/bin/qemu-system-sparc64
/usr/bin/qemu-ppc64le         /usr/bin/qemu-system-tricore
/usr/bin/qemu-s390x           /usr/bin/qemu-system-unicore32
/usr/bin/qemu-sh4             /usr/bin/qemu-system-x86_64
/usr/bin/qemu-sh4eb           /usr/bin/qemu-system-xtensa
/usr/bin/qemu-sparc           /usr/bin/qemu-system-xtensaeb
/usr/bin/qemu-sparc32plus     /usr/bin/qemu-tilegx
/usr/bin/qemu-sparc64         /usr/bin/qemu-x86_64
/usr/bin/qemu-system-aarch64
root@localhost:/home/guest/spMore/mini-arm-os/00-HelloWorld# qemu-system-x86_64
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Could not initialize SDL(No available video device) - exiting

```

錯誤

```
root@localhost:/home/guest/spMore/xv6-public# ls *.img
xv6.img
root@localhost:/home/guest/spMore/xv6-public# qemu-system-x86_64 xv6.img
WARNING: Image format was not specified for 'xv6.img' and probing guessed raw.
         Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
         Specify the 'raw' format explicitly to remove the restrictions.
qemu-system-x86_64: warning: TCG doesn't support requested feature: CPUID.01H:ECX.vmx [bit 5]
Could not initialize SDL(No available video device) - exiting

```