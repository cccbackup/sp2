# msys2 安裝

* https://www.msys2.org/

## 安裝執行檔

請視情況開啟 MSYS2 64bits 或 MSYS2 32bits
(若程式無法執行，通常改另一版就會ok!)

繼續安裝 gcc 之類的套件

```
$ pacman -S gcc
$ pacman -S make
...
```

## 安裝函式庫

若是要安裝函式庫類的套件 (例如 glib2) ，必須決定是要裝 32 bits 或 64bits 的版本，你可以使用 pacman -Ss glib2 指令搜尋該套件，然後再用 pacman -S mingw-w64-x86_64-glib2 安裝。

(注意： 單純使用 pacman -S glib2 只會安裝執行檔，不會安裝函式庫)。

```
user@DESKTOP-96FRN6B MINGW64 ~
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

user@DESKTOP-96FRN6B MINGW64 ~
$ pacman -S mingw-w64-x86_64-glib2
警告：mingw-w64-x86_64-glib2-2.56.1-2 已經爲最新 -- 重新安裝
正在解決依賴關係...
正在檢查衝突的套件...

套件 (1) mingw-w64-x86_64-glib2-2.56.1-2

總計安裝大小：  40.73 MiB
淨升級大小：   0.00 MiB

:: 進行安裝嗎？ [Y/n] n
```

## 