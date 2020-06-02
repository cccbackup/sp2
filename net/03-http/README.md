# HelloWebServer

修改來源 -- http://rosettacode.org/wiki/Hello_world/Web_server#C

## helloWebServer.c

```
$ gcc helloWebServer.c -o helloWebServer.exe
$ ./helloWebServer.exe
```

然後打 http://127.0.0.1:8080/ 你會看到一個只會說 hello world! 的 server

## headPrintServer.c

```
$ gcc headPrintServer.c -o headPrintServer.exe
$ ./headPrintServer.exe
```

一樣只會說 hello world! 

但會印出 http header 方便觀察！

## htmlServer

```
$ gcc htmlServer.c -o htmlServer.exe
$ ./htmlServer.exe
```

然後訪問 http://127.0.0.1:8080/index.html 可以看到網頁，任意點選連結訪問其他頁面！

## threadServer

```
$ gcc threadServer.c -o threadServer
$ ./threadServer
```

這版功能和 htmlServer 一樣，但是使用 multi thread 可以快速應付更多的請求 (流量)！


## 問題


因為 socket 函式庫是放在 usr 底下的，以下是在 mingw64 底下的編譯錯誤情況。

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp2/net/socket/htmlServer
$ gcc -I /usr/include -L /usr/lib/w32api/ -lws2_32 helloWebServer.c -o helloWebServer
In file included from C:/msys64/usr/include/netdb.h:66:0,
                 from helloWebServer.c:7:
C:/msys64/usr/include/inttypes.h:28:0: warning: "__STRINGIFY" redefined
 #define __STRINGIFY(a) #a

In file included from C:/msys64/mingw64/x86_64-w64-mingw32/include/_mingw.h:12: ,
                 from C:/msys64/mingw64/x86_64-w64-mingw32/include/crtdefs.h:10,
                 from C:/msys64/mingw64/x86_64-w64-mingw32/include/stddef.h:7,
                 from C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/7.3.0/include/stddef.h:1,
                 from C:/msys64/usr/include/sys/cdefs.h:45,
                 from C:/msys64/usr/include/stdio.h:35,
                 from helloWebServer.c:1:
C:/msys64/mingw64/x86_64-w64-mingw32/include/_mingw_mac.h:10:0: note: this is the location of the previous definition
 #define __STRINGIFY(x) #x

```
