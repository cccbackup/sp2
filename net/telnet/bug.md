# telnet 目前的 bug

執行 cd 之後，目錄不會切換。

https://stackoverflow.com/questions/7656549/understanding-requirements-for-execve-and-setting-environment-vars


## 解決

使用 env 取得每次指令執行後的 PWD ，然後在每次執行前都先 export PWD=path 再執行。

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/telnet1
$ printenv PWD
/d/ccc/course/sp2/net/telnet1

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/telnet1
$ env PWD
/d/ccc/course/sp2/net/telnet1

