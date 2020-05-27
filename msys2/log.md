
## 接著執行

```
user@DESKTOP-96FRN6B MINGW64 ~
$ cd /d/ccc/course/sp/code/c/06-os1windows/03-msys2

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2
$ ls
georgeMary.c  README.md

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2
$ gcc georgeMary.c -o georgeMary

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2
$ ./georgeMary
George
----------------
Mary
George
----------------
George
----------------
Mary
----------------
George
George
Mary
----------------


```

## 如果用 CodeBlocks 的 gcc 會怎樣！

```
PS D:\ccc\sp\code\c\06-os1windows\03-msys2> gcc georgeMary.c -o georgeMary
georgeMary.c: In function 'print_george':
georgeMary.c:9:5: warning: implicit declaration of function 'sleep' [-Wimplicit-function-declaration]
     sleep(1);
     ^
C:\Users\Tim\AppData\Local\Temp\ccFjAMD5.o:georgeMary.c:(.text+0x1a): undefined reference to `sleep'
C:\Users\Tim\AppData\Local\Temp\ccFjAMD5.o:georgeMary.c:(.text+0x3a): undefined reference to `sleep'
C:\Users\Tim\AppData\Local\Temp\ccFjAMD5.o:georgeMary.c:(.text+0xaa): undefined reference to `sleep'
collect2.exe: error: ld returned 1 exit status
```

## 安裝 gcc

```
Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/03-msys2
$ pacman -S gcc
正在解決依賴關係…
正在檢查衝突的軟體包…

軟體包 (8) binutils-2.30-2  isl-0.21-1  mpc-1.1.0-1
           msys2-runtime-devel-3.0.7-6
           msys2-w32api-headers-7.0.0.5479.8db8dd5a-1
           msys2-w32api-runtime-7.0.0.5479.8db8dd5a-1
           windows-default-manifest-6.4-1  gcc-9.1.0-2

總計下載大小：   42.83 MiB
總計安裝大小：  287.14 MiB

:: 進行安裝嗎？ [Y/n] y
:: 正在接收軟體包…
 binutils-2.30-2-...     4.3 MiB   606 KiB/s 00:07 [#####################] 100%
 isl-0.21-1-x86_64     505.7 KiB   949 KiB/s 00:01 [#####################] 100%
 mpc-1.1.0-1-x86_64     74.1 KiB  2.49 MiB/s 00:00 [#####################] 100%
 msys2-runtime-de...     5.3 MiB   839 KiB/s 00:06 [#####################] 100%
 msys2-w32api-hea...     4.6 MiB   739 KiB/s 00:06 [#####################] 100%
 msys2-w32api-run...  1825.4 KiB   731 KiB/s 00:02 [#####################] 100%
 windows-default-...  1388.0   B  0.00   B/s 00:00 [#####################] 100%
 gcc-9.1.0-2-x86_64     26.3 MiB   811 KiB/s 00:33 [#####################] 100%
(8/8) 正在檢查鑰匙圈中的鑰匙                       [#####################] 100%
(8/8) 正在檢查軟體包完整性                         [#####################] 100%
(8/8) 正在載入軟體包檔案                           [#####################] 100%
(8/8) 正在檢查檔案衝突                             [#####################] 100%
(8/8) 正在檢查可用磁碟空間                         [#####################] 100%
:: 正在處理軟體包變更…
(1/8) 正在安裝 binutils                            [#####################] 100%
(2/8) 正在安裝 isl                                 [#####################] 100%
(3/8) 正在安裝 mpc                                 [#####################] 100%
(4/8) 正在安裝 msys2-runtime-devel                 [#####################] 100%
(5/8) 正在安裝 msys2-w32api-headers                [#####################] 100%
(6/8) 正在安裝 msys2-w32api-runtime                [#####################] 100%
(7/8) 正在安裝 windows-default-manifest            [#####################] 100%
(8/8) 正在安裝 gcc                                 [#####################] 100%

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/03-msys2

```

安裝 make

```
Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/03-msys2
$ make
bash: make：命令找不到

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/03-msys2
$ pacman -S make
正在解決依賴關係…
正在檢查衝突的軟體包…

軟體包 (1) make-4.3-1

總計下載大小：  0.45 MiB
總計安裝大小：  1.48 MiB

:: 進行安裝嗎？ [Y/n] y
:: 正在接收軟體包…
 make-4.3-1-x86_64     456.7 KiB   340 KiB/s 00:01 [#####################] 100%
(1/1) 正在檢查鑰匙圈中的鑰匙                       [#####################] 100%
(1/1) 正在檢查軟體包完整性                         [#####################] 100%
(1/1) 正在載入軟體包檔案                           [#####################] 100%
(1/1) 正在檢查檔案衝突                             [#####################] 100%
(1/1) 正在檢查可用磁碟空間                         [#####################] 100%
:: 正在處理軟體包變更…
(1/1) 正在安裝 make                                [#####################] 100%

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/03-msys2
$ make
make: *** 沒有指明目標並且找不到 makefile。 停止。

```
