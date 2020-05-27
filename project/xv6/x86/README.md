# xv6 作業系統 x86 版

## 編譯執行方式

指令

```
$ make clean
$ make
$ make qemu-nox

```

然後就可以用 ls, cat 等指令，最後用 Ctrl-a-c 回到 qemu，然後下 quit 指令跳出。

```
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
$ wc README
47 312 2170 README
$ mkdir ccc
$ ls ccc
.              1 19 32
..             1 1 512
$ QEMU 2.11.1 monitor - type 'help' for more information
(qemu) quit

```
