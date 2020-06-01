# myshell 第 2 版

切換路徑 cd 沒問題了！

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v2
$ gcc myshell.c -o myshell

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v2
$ ./myshell
myshell:/d/ccc/course/sp2/my/shell/v2 $ ls
myshell.c  myshell.exe  path.txt
myshell:/d/ccc/course/sp2/my/shell/v2 $ cd ..
myshell:/d/ccc/course/sp2/my/shell $ ls
my.h  myshell.exe  README.md  v1  v2
myshell:/d/ccc/course/sp2/my/shell $ cd ..
myshell:/d/ccc/course/sp2/my $ ls
c5  shell  telnet
myshell:/d/ccc/course/sp2/my $ cd ..
myshell:/d/ccc/course/sp2 $ ls
asm       cpu       embed  hack   msys2  net      obj  project    tool
compiler  database  gcc    linux  my     note.md  os   README.md  vm
myshell:/d/ccc/course/sp2 $ echo hello world
hello world
myshell:/d/ccc/course/sp2 $ cd /
myshell:/ $ ls
asm.exe         home                 mingw32      msys2.exe        tmp
autorebase.bat  InstallationLog.txt  mingw32.exe  msys2.ico        usr
bin             macro.exe            mingw32.ini  msys2.ini        var
components.xml  maintenancetool.dat  mingw64      msys2_shell.cmd  vm.exe
dev             maintenancetool.exe  mingw64.exe  network.xml
etc             maintenancetool.ini  mingw64.ini  proc
myshell:/ $

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v2

```