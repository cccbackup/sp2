# open-and-spin


```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ ./open-and-spin /etc/fstab&
[1] 2500

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ in process 2500, file descriptor 3 is open to /etc/fstab


user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ ps
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
     2500    7068    2500       5712  pty1      197609 15:20:18 /d/ccc/course/sp2/os/12-op/open-and-spin
     7068    2608    7068       3116  pty1      197609 10:14:11 /usr/bin/bash
     2608       1    2608       2608  ?         197609 10:14:10 /usr/bin/mintty
    15196       1   15196      15196  ?         197609 10:12:42 /usr/bin/mintty
     7468    7068    7468       1880  pty1      197609 15:20:23 /usr/bin/ps
     3196   15196    3196       5488  pty0      197609 10:12:44 /usr/bin/bash

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ ls -l /proc/2500/fd
總計 0
lrwxrwxrwx 1 user None 0 六月  7 15:20 0 -> /dev/pty1
lrwxrwxrwx 1 user None 0 六月  7 15:20 1 -> /dev/pty1
lrwxrwxrwx 1 user None 0 六月  7 15:20 2 -> /dev/pty1
lrwxrwxrwx 1 user None 0 六月  7 15:20 3 -> /etc/fstab


```