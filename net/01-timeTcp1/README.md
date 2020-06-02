# Simple Socket Client/Server

來源 -- https://gist.github.com/browny/5211329

```
gcc server.c -o server
gcc client.c -o client
```

背景執行 server

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ./server&
[2] 6716

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ./client
Sun May 31 10:18:09 2020

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ./client
Sun May 31 10:18:11 2020

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ./client
Sun May 31 10:18:12 2020

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ./client
Sun May 31 10:18:13 2020

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/timeServer
$ ps
      PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
     3252    2556    3252       3344  pty2      197609 10:14:40 /d/ccc/course/sp2/net/timeServer/server
     1664    1936    1664       8072  pty0      197609 09:45:29 /usr/bin/bash
     6716    2556    6716       2492  pty2      197609 10:18:06 /d/ccc/course/sp2/net/timeServer/server
     2556   12524    2556       1612  pty2      197609 09:30:16 /usr/bin/bash
    12028    2556   12028       3192  pty2      197609 10:18:47 /usr/bin/ps
     1936       1    1936       1936  ?         197609 09:45:28 /usr/bin/mintty
    12524       1   12524      12524  ?         197609 09:30:15 /usr/bin/mintty


```