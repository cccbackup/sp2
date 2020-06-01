# telent v1

## 啟動

啟動 server 之後

```
$ ./server
```

再啟動 client (可以分兩視窗，也可以 server 用背景執行)

```
$ ./client
```

## 使用

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/telnet/v1
$ ./client
connect to server 127.0.0.1 success!
127.0.0.1 $ ls
client.c
client.exe
client.exe.stackdump
Makefile
server.c
server.exe

127.0.0.1 $ cat Makefile
CC = gcc
CFLAGS = -Wall -std=gnu99
TARGET = server client
all: $(TARGET)

server: server.c
        $(CC) $(CFLAGS) -o $@ $<

client: client.c
        $(CC) $(CFLAGS) -o $@ $<

clean:
        $(RM) $(TARGET) *.exe

127.0.0.1 $ echo hello
hello

127.0.0.1 $ echo $PATH
/usr/local/bin:/usr/bin:/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

127.0.0.1 $ exit

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/telnet/v1

```