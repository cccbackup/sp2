# Zombie

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$ ./zombie&
[1] 6840

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$  ps -e pid,ppid,stat,cmd
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
     6840    7068    6840       5568  pty1      197609 14:42:44 /d/ccc/course/sp2/os/02-fork/05-zombie/zombie
     7068    2608    7068       3116  pty1      197609 10:14:11 /usr/bin/bash
     8696    7068    8696       2152  pty1      197609 14:43:06 /usr/bin/ps
     2608       1    2608       2608  ?         197609 10:14:10 /usr/bin/mintty
    15196       1   15196      15196  ?         197609 10:12:42 /usr/bin/mintty
     3196   15196    3196       5488  pty0      197609 10:12:44 /usr/bin/bash
     4100    6840    6840       4100  pty1      197609 14:42:45 /d/ccc/course/sp2/os/02-fork/05-zombie/zombie <defunct>

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$  ps -e pid,ppid,stat,cmd
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
     7068    2608    7068       3116  pty1      197609 10:14:11 /usr/bin/bash
     8728    7068    8728       6480  pty1      197609 14:43:55 /usr/bin/ps
     2608       1    2608       2608  ?         197609 10:14:10 /usr/bin/mintty
    15196       1   15196      15196  ?         197609 10:12:42 /usr/bin/mintty
     3196   15196    3196       5488  pty0      197609 10:12:44 /usr/bin/bash
[1]+  已完成               ./zombie
```
