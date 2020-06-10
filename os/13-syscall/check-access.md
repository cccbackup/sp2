# check-access.c

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/13-syscall
$ gcc check-access.c -o check-access

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/13-syscall
$  ./check-access /mnt/cdrom/README
/mnt/cdrom/README does not exist

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/13-syscall
$  ./check-access /d
/d exists
/d is readable
/d is writable
```
