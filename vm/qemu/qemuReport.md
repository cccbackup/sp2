
編譯器 qemu 的初始創作者是 [Fabrice Bellard](https://bellard.org/) ，以下是他的作品網頁：

* https://bellard.org/

QEMU 是一種跨平台、跨處理器的虛擬機，可以在 x86 上模擬出 ARM 處理器的行為，也可以反過來在 ARM 上模擬出 x86 的行為。

其主要採用技術是將 img 二進位碼指令轉換成目標平台的微指令組合，這些微指令會呼叫背後的 C 語言程式，然後採用 gcc 為工具快速的將這些微指令編譯執行。

對於 QEMU 的設計原理，Fabrice Bellard 曾經寫過一篇論文描述，該論文網址如下：

* https://www.usenix.org/legacy/event/usenix05/tech/freenix/full_papers/bellard/bellard.pdf

論文中描述了 QEMU 的指令翻譯原理，以下是其中的一個 x86 指令範例：

> addi r1,r1,-16 # r1 = r1 - 16
