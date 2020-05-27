# GTK

```
$ pacman -S mingw-w64-x86_64-gtk3
警告：mingw-w64-x86_64-gtk3-3.22.30-1 已經爲最新 -- 重新安裝
正在解決依賴關係...
正在檢查衝突的套件...

套件 (1) mingw-w64-x86_64-gtk3-3.22.30-1

總計安裝大小：  72.10 MiB
淨升級大小：   0.00 MiB

:: 進行安裝嗎？ [Y/n] y
(1/1) 正在檢查鑰匙圈中的鑰匙                                     [###################################] 100%
(1/1) 正在檢查套件完整性                                         [###################################] 100%
(1/1) 正在載入套件檔案                                           [###################################] 100%
(1/1) 正在檢查檔案衝突                                           [###################################] 100%
(1/1) 正在檢查可用磁碟空間                                       [###################################] 100%
:: 正在處理套件變更...
(1/1) 正在重裝 mingw-w64-x86_64-gtk3                             [###################################] 100%

$ pkg-config --cflags gtk+-3.0
-mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include

$ ls
hellogtk.c  Makefile  README.md

$ make
gcc hellogtk.c -o hellogtk `pkg-config --cflags gtk+-3.0` -g -Wall -std=gnu11 -O3 `pkg-config --libs gtk+-3.0`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/03-gtk
$ ./hellogtk

```

## Examples 的用法

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/03-gtk/examples
$ cd application7

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/03-gtk/examples/application7
$ ls
app-menu.ui               exampleapp.h       exampleappwin.c  Makefile.am                     prefs.ui
exampleapp.c              exampleappprefs.c  exampleappwin.h  Makefile.example                window.ui
exampleapp.gresource.xml  exampleappprefs.h  main.c           org.gtk.exampleapp.gschema.xml

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/03-gtk/examples/application7
$ make -f Makefile.example
glib-compile-resources exampleapp.gresource.xml --target=resources.c --sourcedir=. --generate-source
cc -c -o resources.o -mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include resources.c
cc -c -o exampleapp.o -mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include exampleapp.c
cc -c -o exampleappwin.o -mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include exampleappwin.c
cc -c -o exampleappprefs.o -mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include exampleappprefs.c
cc -c -o main.o -mms-bitfields -pthread -mms-bitfields -I/mingw64/include/gtk-3.0 -I/mingw64/include/cairo -I/mingw64/include -I/mingw64/include/pango-1.0 -I/mingw64/include/fribidi -I/mingw64/include/atk-1.0 -I/mingw64/include/cairo -I/mingw64/include/pixman-1 -I/mingw64/include -I/mingw64/include/freetype2 -I/mingw64/include -I/mingw64/include/harfbuzz -I/mingw64/include -I/mingw64/include/libpng16 -I/mingw64/include/gdk-pixbuf-2.0 -I/mingw64/include/libpng16 -I/mingw64/include -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include main.c
glib-compile-schemas --strict --dry-run --schema-file=org.gtk.exampleapp.gschema.xml && mkdir -p . && touch org.gtk.exampleapp.gschema.valid
glib-compile-schemas .
cc -o exampleapp resources.o exampleapp.o exampleappwin.o exampleappprefs.o main.o -L/mingw64/lib -LC:/building/msys64/mingw64/lib/../lib -L/mingw64/lib -lgtk-3 -lgdk-3 -lgdi32 -limm32 -lshell32 -lole32 -Wl,-luuid -lwinmm -ldwmapi -lsetupapi -lcfgmgr32 -lz -lepoxy -lopengl32 -lgdi32 -lpangocairo-1.0 -lpangoft2-1.0 -lpangowin32-1.0 -lusp10 -lgdi32 -lpango-1.0 -lm -lfribidi -latk-1.0 -lcairo-gobject -lcairo -lz -lpixman-1 -lfontconfig -liconv -lexpat -lfreetype -lbz2 -lharfbuzz -lm -lgraphite2 -lpng16 -lz -lgdk_pixbuf-2.0 -lm -lpng16 -lz -lgio-2.0 -lz -lgmodule-2.0 -pthread -lgobject-2.0 -lffi -lglib-2.0 -lintl -pthread -lws2_32 -lole32 -lwinmm -lshlwapi -lpcre -lintl -lpcre

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/03-gtk/examples/application7
$ ./exampleapp

```