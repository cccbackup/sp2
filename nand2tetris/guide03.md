# nand2tetris -- 第 3 章指引

## 習題

1. Bit -- 1 位元暫存器
2. Register -- 16 位元暫存器
3. RAM8 -- 8 Word 的記憶體
4. RAM64 -- 64 Word 的記憶體
5. RAM512 -- 512 Word 的記憶體
6. RAM4K -- 4096 (4K) 的記憶體
7. RAM16K -- 16384 (16K) 的記憶體
8. PC -- 處理器的程式計數器模組

## 指引

第 3 章要建構的是《記憶元件》，包含《暫存器》和《記憶體》。

透過 and, or, not 等元件，我們可以建構出 [D 型正反器](https://zh.wikipedia.org/wiki/%E8%A7%A6%E5%8F%91%E5%99%A8#D%E8%A7%A6%E5%8F%91%E5%99%A8) ， 然後透過加入 [脈衝偵測電路](http://ccckmit.wikidot.com/ve:ptdflipflop) 或者採用 [主從式結構](https://en.wikipedia.org/wiki/Flip-flop_(electronics)#/media/File:Negative-edge_triggered_master_slave_D_flip-flop.svg) 就能做出[邊緣觸發的 D 型正反器](https://en.wikipedia.org/wiki/Flip-flop_(electronics)#Master%E2%80%93slave_edge-triggered_D_flip-flop) 

不過上面的 D 型正反器， nand2tetris 已經列入基本元件 DFF 了，所以我們不用自己再做一遍。

但是我們必須用 DFF 去做出一位元的記憶體 Bit ， 然後再用 16 個 Bit 做出 Register 。

接著用 8 個 Register 加上 MUX8Way16, DMux8Way 等元件，做出 8 個 Word 的記憶體 RAM8。

然後透過同樣的模式，一路從 RAM8, RAM64, RAM512, RAM4K, RAM32K 等記憶體。

最後我們必須用一個 Register 做出一個供 CPU 使用的程式計數器 PC ，這個 PC 會用來儲存指令的位址，每次執行一個指令後就會加 1，這樣下次就會執行下一個指令。 

當組合語言使用 `@100. 0;JMP` 之類的指令時，PC 會被修改，於是就會跳到指定的位址 (例如：位址 100)。
