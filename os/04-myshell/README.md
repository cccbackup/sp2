# myshell -- 自己實作一個 shell

* [myshell:v1](v1) -- 第 1 版，可執行各種指令，但路徑的切換會有問題。
* [myshell:v2](v2) -- 第 2 版，可執行各種指令，路徑的切換也沒問題，但環境變數還是沒處理。

看完這兩個程式，就可以繼續看 telnet 了：

* [telnet1](../net/03-telnet1) -- 對應到 myshell:v1, 但卻是遠端操控的！
* [telnet2](../net/04-telnet2) -- 對應到 myshell:v2, 但卻是遠端操控的！

但是你得先懂 socket 的程式怎麼寫，請先看：

* [timeTcp1](../net/01-timeTcp1) -- 簡單的網路報時 client/server 程式。
* [timeTcp2](../net/02-timeTcp2) -- 模組化後的網路報時 client/server 程式。


## 參考文獻

* [How to write a (very basic) UNIX shell](https://github.com/spencertipping/shell-tutorial)


