# pacman


## 搜尋套件 pacman -Ss


```
$ pacman -Ss glib2
mingw32/mingw-w64-i686-glib2 2.56.1-2
    Common C routines used by GTK+ 2.4 and other libs (mingw-w64)
mingw64/mingw-w64-x86_64-glib2 2.56.1-2 [已安裝]
    Common C routines used by GTK+ 2.4 and other libs (mingw-w64)
msys/glib2 2.48.2-1 [已安裝]
    Common C routines used by GTK+ and other libs
msys/glib2-devel 2.48.2-1 (development)
    glib2 headers and libraries
msys/glib2-docs 2.48.2-1
    Documentation for glib2


$ pacman -Ss pkgconf
mingw32/mingw-w64-i686-ruby-pkg-config 1.3.0-1
    Implementation of pkg-config in ruby (mingw-w64)
mingw64/mingw-w64-x86_64-ruby-pkg-config 1.3.0-1
    Implementation of pkg-config in ruby (mingw-w64)
msys/perl-ExtUtils-PkgConfig 1.16-1 (perl-modules)
    The Perl Pkgconfig module
msys/pkg-config 0.29.2-1 (base-devel)
    A system for managing library compile/link flags
```

## 安裝套件

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/10-os2linux/01-c/lib/02-glib
$ pacman -S pkg-config
正在解決依賴關係...
正在檢查衝突的套件...

套件 (1) pkg-config-0.29.2-1

總計下載大小：  0.18 MiB
總計安裝大小：  0.54 MiB

:: 進行安裝嗎？ [Y/n] y
:: 正在擷取套件...
 pkg-config-0.29.2-1-x86_64             185.7 KiB   205K/s 00:01 [###################################] 100%
(1/1) 正在檢查鑰匙圈中的鑰匙                                     [###################################] 100%
(1/1) 正在檢查套件完整性                                         [###################################] 100%
(1/1) 正在載入套件檔案                                           [###################################] 100%
(1/1) 正在檢查檔案衝突                                           [###################################] 100%
(1/1) 正在檢查可用磁碟空間                                       [###################################] 100%
:: 正在處理套件變更...
(1/1) 正在安裝 pkg-config                                        [###################################] 100%

```

## 檢視安裝套件資訊

```
Tim@DESKTOP-QOC5V2F MINGW64 ~
$ pacman -Qi glib2
名稱                   : glib2
版本                   : 2.54.3-3
描述                   : Common C routines used by GTK+ and other libs
硬體架構               : x86_64
URL                    : https://www.gtk.org/
軟體授權               : LGPL
群組                   : 無
它提供                 : 無
它依賴                 : libxslt  libpcre  libffi  libiconv  zlib
可選依賴               : gamin: for gio fam module
                         python3: for gdbus-codegen and gtester-report
需要它                 : libp11-kit  pkg-config
為這些軟體包的可選依賴 : 無
與它衝突               : 無
它會取代               : 無
安裝後大小             : 10.54 MiB
打包者                 : Alexey Pavlov <alexpux@gmail.com>
建置日期               : 2020年04月17日 上午 02:13:17
安裝日期               : 2020年05月20日 下午 03:42:15
安裝原因               : 作為其他軟體包的依賴安裝
安裝指令稿             : 否
驗證者                 : 簽章


```