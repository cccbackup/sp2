# Linux/UNIX

## 連上 linux 的工具

先安裝 putty ，然後連到下列帳號:

* guest@misavo.com

密碼為 csienqu


## 管理者

我已經使用 chmod -R 777 目錄 將 sp 改成『大家都可以讀寫執行』了。

## 使用 VsCode 遠端編輯

* 參考 -- [VS Code 如何遠端編輯你的程式碼](http://andy51002000.blogspot.com/2019/03/vs-code.html)

1 - File > Preferences > Settings (或是Ctrl + , ) 搜尋 sshfs.configs

然後設定如下：

```
default settings
{
    "remote.onstartup": true,
    "sshfs.configs":[
        {
            "root": "/home/guest",
            "host": "misavo.com",
            "port": 22,
            "username": "guest",
            "password": "csienqu",
            "name": "unnamed"
        }
    ]
}
```

2. 按F1選擇SSH FS: Connect as Workspace folder這個指令
3. 在左側檔案目錄就可以看到檔案了。

## GNU 工具鏈

* [系統程式 - 附錄](https://www.slideshare.net/ccckmit/ss-61169583)
* [Jserv : How A Compiler Works: GNU Toolchain](https://www.slideshare.net/jserv/how-a-compiler-works-gnu-toolchain) 
    * 包含歷史，GNU 工具，編譯器原理，優化方法等等 ... (讚!)
    * https://www.slideshare.net/jserv/presentations

## Linux 程式設計

* [The Linux Programming Interface](http://man7.org/tlpi/)
    * https://github.com/bradfa/tlpi-dist/
    * http://man7.org/tlpi/code/online/all_files_by_chapter.html
* [Advanced Programming in the UNIX® Environment, Third Edition](http://www.apuebook.com/toc3e.html)
* [Systems Programming under Linux](https://github.com/DevNaga/linux-systems-programming-with-c)
    * 程式 -- https://github.com/DevNaga/gists/
* 21 世紀的 C 語言
    * https://github.com/b-k/21st-Century-Examples
