# 爬蟲

## download

```
Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ gcc http.c download.c -o download

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ ./download
http://misavo.com:80/view/ccc/cccForStudent.md downloaded!

```

## crawSeq.c

```
Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ gcc http.c crawSeq.c -o crawSeq

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ ./crawSeq
http://misavo.com:80/view/ccc/cccForStudent.md downloaded!
http://misavo.com:80/view/ccc/cccForProfessor.md downloaded!
http://misavo.com:80/view/ccc/cccForProgrammer.md downloaded!
http://misavo.com:80/view/ccc/cccForCompany.md downloaded!
http://misavo.com:80/view/ccc/course.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter1.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter2.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter3.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter4.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter5.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter6.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter7.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter8.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter9.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter10.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter11.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter12.md downloaded!
http://misavo.com:80/view/jsh/chapter1.md downloaded!
http://misavo.com:80/view/jsh/chapter2.md downloaded!
http://misavo.com:80/view/jsh/chapter3.md downloaded!
http://misavo.com:80/view/jsh/chapter4.md downloaded!
http://misavo.com:80/view/jsh/chapter5.md downloaded!
http://misavo.com:80/view/jsh/chapter6.md downloaded!
http://misavo.com:80/view/jsh/chapter7.md downloaded!
http://misavo.com:80/view/jsh/chapter8.md downloaded!
http://misavo.com:80/view/jsh/chapter9.md downloaded!
http://misavo.com:80/view/jsh/chapter10.md downloaded!
http://misavo.com:80/view/jsh/chapter11.md downloaded!

```


## crawThread.c

```
Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ gcc http.c crawThread.c -o crawThread

Tim@DESKTOP-QOC5V2F MINGW32 /d/ccc/sp/code/c/06-os1windows/05-socket/crawler
$ ./crawThread
http://misavo.com:80/view/ccc/course.md downloaded!
http://misavo.com:80/view/jsh/chapter6.md downloaded!
http://misavo.com:80/view/jsh/chapter4.md downloaded!
http://misavo.com:80/view/jsh/chapter3.md downloaded!
http://misavo.com:80/view/jsh/chapter7.md downloaded!
http://misavo.com:80/view/jsh/chapter5.md downloaded!
http://misavo.com:80/view/jsh/chapter8.md downloaded!
http://misavo.com:80/view/jsh/chapter10.md downloaded!
http://misavo.com:80/view/jsh/chapter9.md downloaded!
http://misavo.com:80/view/jsh/chapter11.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter1.md downloaded!
http://misavo.com:80/view/ccc/cccForProfessor.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter12.md downloaded!
http://misavo.com:80/view/ccc/cccForStudent.md downloaded!
http://misavo.com:80/view/ccc/cccForProgrammer.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter2.md downloaded!
http://misavo.com:80/view/ccc/cccForCompany.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter4.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter5.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter6.md downloaded!
http://misavo.com:80/view/jsh/chapter1.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter7.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter8.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter10.md downloaded!
http://misavo.com:80/view/jsh/chapter2.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter9.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter11.md downloaded!
http://misavo.com:80/view/nand2tetris/chapter3.md downloaded!

```

## 參考
* [鄭中勝: 以 C Socket 實作 HTTP Client](https://notfalse.net/47/c-socket-http-client)
    * https://github.com/JS-Zheng/blog/blob/master/47.%20C%20Socket%20HTTP%20Client/main.c
