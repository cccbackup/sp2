# LLVM

## 架構與工具

```
                
                                              
高階語言  =>  前端    =>   中間碼 IR       => 優化器 1,2,3... ＝>   後端       =>  組合語言  <=> 目的檔
C/C++        clang       lli (中間碼解譯器)  opt 優化器            llc                  llvm-mc    
Fortran      flang                                              IR ＝> 目標碼
Go           llgo                                                                  
rust         rust                llvm-as =>
                     .ll (文字檔)   <=>      .bc (二進位)
                                 llvm-dis <= 
```

emscripten -- compiling C/C++ to asm.js and WebAssembly.

## 工具用法

```
$ clang -S -emit-llvm main.c      // 將 C 語言編譯為 IR
$ lli main.ll                     // 用 lli 執行 IR
$ opt -S -mem2reg main.ll         // 對 IR 執行指定的 optimizer pass
$ opt -S -globalopt -loop-simplify -mem2reg main.ll
$ llc main.ll                     // 把 LLVM IR 編譯成機器語言
```

## 參考文獻

* https://llvm.org/docs/tutorial/index.html
* [編譯器 LLVM 淺淺玩](https://medium.com/@zetavg/%E7%B7%A8%E8%AD%AF%E5%99%A8-llvm-%E6%B7%BA%E6%B7%BA%E7%8E%A9-42a58c7a7309)
* [LLVM tutorial in Rust language](https://github.com/jauhien/iron-kaleidoscope)
* https://github.com/banach-space/llvm-tutor
* [淺談編譯器最佳化技術](https://www.slideshare.net/kitocheng/ss-42438227)
* 書 -- https://github.com/ashleyj/llvm
* [Building WebAssembly for Deno](https://tilman.xyz/blog/2019/12/building-webassembly-for-deno/)
