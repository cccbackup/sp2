# nand2tetris -- 第 5 章指引

## 習題

1. Memory.hdl -- 記憶體模組
2. CPU.hdl -- HackCPU 處理器
3. Computer.hdl -- 整台電腦


## 指引

第 5 章是 nand2tetris (Part 1) 的重頭戲，因為我們終於要設計 CPU 了！

在 nand2tetris 1-4 章所做的所有習題，都是為了建構 HackCPU 而準備的，我們必須用 ALU, Register, PC, MUX, DMUX, Mux16 等元件，組合成一顆 CPU ，當然這並不會太容易，但是老師已經盡力簡化了，只要我們努力去思考 (想不出來的時候可以參考一下別人的習題) ，就能做出一顆 CPU 了！

以下是 HackCPU 的電路圖，但是其中所有的 (C) 符號都得由我們自己去設計完成，那些 (C) 符號都是一些布林邏輯式，這些邏輯式形成了所謂的《控制單元》，這些《控制式》掌控著整個 CPU 的運作邏輯。

![HackCPU 的架構圖](img/hackcpu.png)

當然，我們必須理解 HackCPU 指令的機器碼格式，這樣才能精準的將其中的每一個位元導入到 (C) 邏輯式裏，設計出對應的邏輯電路，下圖的 C 指令格式，是 HackCPU 的運算指令格式，清楚的理解該格式對設計 CPU 非常有幫助，請將上面的架構圖與下面的指令編碼表反覆對照，您應該會慢慢的理解其中的關連性，理解得夠深了之後，就可以動手設計 CPU 了！

![HackCPU 的 C 型指令編碼格式](img/cinstruction.png)
