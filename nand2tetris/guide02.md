# nand2tetris -- 第 2 章指引

## 習題

1. HalfAdder -- 半加器
    * 參考 : [維基百科: 加法器](https://zh.wikipedia.org/zh-hant/%E5%8A%A0%E6%B3%95%E5%99%A8)
2. FullAdder -- 全加器
    * 參考 : [維基百科: 加法器](https://zh.wikipedia.org/zh-hant/%E5%8A%A0%E6%B3%95%E5%99%A8)
3. Add16 -- 加法器
    * 參考 : [維基百科: 加法器](https://zh.wikipedia.org/zh-hant/%E5%8A%A0%E6%B3%95%E5%99%A8)
4. Inc16 -- 遞增器
    * 把 Add16 的一個輸入固定為 1
5. ALU -- 算術邏輯單元 (不需輸出比較結果 zr, ng)
    * 參考 -- [nand2tetris 第 2 章投影片](https://www.slideshare.net/ccckmit/nand2tetris-127760880)
6. ALU -- 算術邏輯單元 (需要輸出比較結果 zr, ng)
    * 參考 -- [nand2tetris 第 2 章投影片](https://www.slideshare.net/ccckmit/nand2tetris-127760880)

## 指引

本章是透過第 1 章的元件，建立 CPU 中的算術邏輯單元 ALU ！

首先從單一位元加法元件 [半加器 HalfAdder 和全加器 FullAdder](https://zh.wikipedia.org/wiki/%E5%8A%A0%E6%B3%95%E5%99%A8) 開始，這是建構 16 位元加法器的關鍵元件。


接著用一個半加器和 15 個全加器 FullAdder 串接建立 [16 位元加法器 Add16](https://zh.wikipedia.org/wiki/%E5%8A%A0%E6%B3%95%E5%99%A8#%E6%B3%A2%E7%BA%B9%E8%BF%9B%E4%BD%8D%E5%8A%A0%E6%B3%95%E5%99%A8%EF%BC%88%E8%84%89%E5%8A%A8%E8%BF%9B%E4%BD%8D%E5%8A%A0%E6%B3%95%E5%99%A8%EF%BC%89)

然後就可以利用 Add16 輕易建立 Inc16 (將其中一個輸入設定為 1 即可)。

最後以 Add16 為基礎，加入許多《多工器與其他元件》後，可以建構出一個完整的 [ALU 單元](https://en.wikipedia.org/wiki/Arithmetic_logic_unit) (稱為 HackALU )，HackALU 的運作邏輯請參考下表！

![Hack CPU 的 ALU 之運作邏輯](img/aluTable.png)

HackALU 的運作牽涉到一些《2 補數》的數學，特別是以下的引理  `-x = !x + 1` (2 補數 = 1 補數 + 1) (1補數就是全部取 not)。


```
練習題：請證明 y-x = !(x+!y)

陳盈翰同學給出證明如下：

引理： -x = !x + 1 
定理： !x = -x-1

證明：!(x+!y) 
= -(x+!y)-1
= -(x+(-y-1))-1
= - (x-y-1)-1
= -x+y
= y-x
```
