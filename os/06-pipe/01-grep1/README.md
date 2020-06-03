# grep1.c

## 編譯

```
$ gcc grep1.c -o grep1

```

## 執行

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/pipe/01-grep1
$ ls -all
總計 149
drwxr-xr-x 1 user None      0 六月  2 09:48 .
drwxr-xr-x 1 user None      0 六月  2 09:47 ..
-rw-r--r-- 1 user None    151 六月  2 09:47 grep1.c
-rwxr-xr-x 1 user None 143451 六月  2 09:48 grep1.exe
-rw-r--r-- 1 user None      0 六月  2 09:47 README.md

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/pipe/01-grep1
$ ls -all | grep rwx
drwxr-xr-x 1 user None      0 六月  2 09:48 .
drwxr-xr-x 1 user None      0 六月  2 09:47 ..
-rwxr-xr-x 1 user None 143451 六月  2 09:48 grep1.exe

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/pipe/01-grep1
$ ls -all | ./grep1 rwx
drwxr-xr-x 1 user None      0 六月  2 09:48 .
drwxr-xr-x 1 user None      0 六月  2 09:47 ..
-rwxr-xr-x 1 user None 143451 六月  2 09:48 grep1.exe

```