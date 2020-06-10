# Nand2tetris -- Part I 硬體部分習題

示範程式 -- https://github.com/ccccourse/co

請將習題從第 1 章到第 5 章按照順序逐題設計出來！

這樣就能學會從頭到尾設計一台簡易電腦的完整硬體。

首先請從下列網址下載 Nand2tetris Software Suite 

* https://www.nand2tetris.org/software

解開之後會有下列兩個資料夾

* projects -- 習題 (您必須要完成的)
* tools -- 用來測試習題是否正確的工具。

其中 tools/HardwareSimulator 是 Part I 的主要測試工具，您每寫完一個習題後，都應該用它確認您的實作是否正確。

(tools/HardwareSimulator.bat 是給 windows 用的，而 tools/HardwareSimulator.sh 則是給 linux/iMac 用的)

如果您用的是 Linux/iMac , 請先用 chmod 777 HardwareSimulator.sh 修改權限，讓該檔案可以被執行，然後才開始使用 (以下是 iMac 中的執行方法）。

```
csienqu-teacher:tools csienqu$ pwd
/Users/csienqu/Desktop/ccc/nand2tetris/tools
csienqu-teacher:tools csienqu$ chmod 777 HardwareSimulator.sh
csienqu-teacher:tools csienqu$ ./HardwareSimulator.sh
```

