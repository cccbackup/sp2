## 載入系統 -- 以 xv6 為例

```
PS D:\ccc\course\sp\code\c\03-asmVm\qemu\xv6\img> qemu-system-i386 -nographic -drive file=fs.img,index=1,media=disk,format=raw -drive file=xv6.img,index=0,media=disk,format=raw -smp 2 -m 512
```

然後就可以開始使用了

```
SeaBIOS (version rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+1FF908D0+1FEF08D0 CA00



Booting from Hard Disk...
xv6...
cpu1: starting 1
cpu0: starting 0
sb: size 1000 nblocks 941 ninodes 200 nlog 30 logstart 2 inodestart 32 bmap start 58
init: starting sh
$



  ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
$ mkdir ccc
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
$ cat README
xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6).  xv6 loosely follows the structure and style of v6,
but is implemented for a modern x86-based multiprocessor using ANSI C.

ACKNOWLEDGMENTS

xv6 is inspired by John Lions's Commentary on UNIX 6th Edition (Peer
to Peer Communications; ISBN: 1-57398-013-7; 1st edition (June 14,
2000)). See also https://pdos.csail.mit.edu/6.828/, which
provides pointers to on-line resources for v6.

xv6 borrows code from the following sources:
    JOS (asm.h, elf.h, mmu.h, bootasm.S, ide.c, console.c, and others)
    Plan 9 (entryother.S, mp.h, mp.c, lapic.c)
    FreeBSD (ioapic.c)
    NetBSD (console.c)

The following people have made contributions: Russ Cox (context switching,
locking), Cliff Frey (MP), Xiao Yu (MP), Nickolai Zeldovich, and Austin
Clements.

We are also grateful for the bug reports and patches contributed by Silas
Boyd-Wickizer, Anton Burtsev, Cody Cutler, Mike CAT, Tej Chajed, eyalz800,
Nelson Elhage, Saar Ettinger, Alice Ferrazzi, Nathaniel Filardo, Peter
Froehlich, Yakir Goaron,Shivam Handa, Bryan Henry, Jim Huang, Alexander
Kapshuk, Anders Kaseorg, kehao95, Wolfgang Keller, Eddie Kohler, Austin
Liew, Imbar Marinescu, Yandong Mao, Matan Shabtay, Hitoshi Mitake, Carmi
Merimovich, Mark Morrissey, mtasm, Joel Nider, Greg Price, Ayan Shafqat,
Eldar Sehayek, Yongming Shen, Cam Tenny, tyfkda, Rafael Ubal, Warren
Toomey, Stephen Tu, Pablo Ventura, Xi Wang, Keiichi Watanabe, Nicolas
Wolovick, wxdao, Grant Wu, Jindong Zhang, Icenowy Zheng, and Zou Chang Wei.

The code in the files that constitute xv6 is
Copyright 2006-2018 Frans Kaashoek, Robert Morris, and Russ Cox.

ERROR REPORTS

We switched our focus to xv6 on RISC-V; see the mit-pdos/xv6-riscv.git
repository on github.com.

BUILDING AND RUNNING XV6

To build xv6 on an x86 ELF machine (like Linux or FreeBSD), run
"make". On non-x86 or non-ELF machines (like OS X, even on x86), you
will need to install a cross-compiler gcc suite capable of producing
x86 ELF binaries (see https://pdos.csail.mit.edu/6.828/).
Then run "make TOOLPREFIX=i386-jos-elf-". Now install the QEMU PC
simulator and run "make qemu".$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
```

## 使用案例

```
SeaBIOS (version rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org
)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+1FF908D0+1FEF08D0 CA00   




Booting from Hard Disk..xv6...
cpu1: starting 1
cpu0: starting 0
sb: size 1000 nblock



                    s 941 ninodes 200 nlog 30 logstart 2 inodestart 32 bmap start 58
init: starting sh
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
$ rmdir ccc
exec: fail
exec rmdir failed
$ rmdir ccc
exec: fail
exec rmdir failed
$ rm
Usage: rm files...
$ rm -rf ccc
rm: -rf failed to delete
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
















 [0mSeaBIOS (version rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org
)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+1FF908D0+1FEF08D0 CA00
                            
  


Booting from Hard Disk..xv6...
cpu1: starting 1
cpu0: starting 0
sb: size 1000 nblocks 941 ninodes 200 nlog 30 logstart 2 inodestart 32 bmap start 58
init: starting sh
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
$ echo hello
hello
$ echo hello world!
hello world!
$ echo hello 你好!
hello 你好!
$ wc README  
47 312 2170 README
$ grep xv6 README
xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6).  xv6 loosely follows the structure and style of v6,
xv6 is inspired by John Lions's Commentary on UNIX 6th Edition (Peer
xv6 borrows code from the following sources:
The code in the files that constitute xv6 is
We switched our focus to xv6 on RISC-V; see the mit-pdos/xv6-riscv.git
To build xv6 on an x86 ELF machine (like Linux or FreeBSD), run
$ ln rd rmdir
link rd rmdir: failed
$ ln cd chdir
link cd chdir: failed
$ ln chdir cd
link chdir cd: failed
$ ln md mkdir
link md mkdir: failed
$ ln mkdir md
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
md             2 11 12772
$ md ccc2
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc            1 19 32
md             2 11 12772
ccc2           1 20 32
$ rm md
$ rm ccc
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
ccc2           1 20 32
$ rm ccc2
$ ls
.              1 1 512
..             1 1 512
README         2 2 2170
cat            2 3 13628
echo           2 4 12640
forktest       2 5 8068
grep           2 6 15504
init           2 7 13220
kill           2 8 12692
ln             2 9 12588
ls             2 10 14776
mkdir          2 11 12772
rm             2 12 12748
sh             2 13 23236
stressfs       2 14 13420
usertests      2 15 56352
wc             2 16 14168
zombie         2 17 12412
console        3 18 0
$ QEMU 4.2.0 monitor - type 'help' for more information
(qemu) quit
PS D:\ccc\sp\code\c\03-asmVm\qemu\xv6>
```