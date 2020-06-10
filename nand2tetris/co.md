# nand2tetris (Part 1) -- 計算機結構補充教材

## 速度議題
* [陳鍾誠:如何設計電腦 -- 還有讓電腦變快的那些方法](https://www.slideshare.net/ccckmit/ss-85466673) (SlideShare)
* [Jserv : 現代處理器設計：原理和關鍵特徵](http://hackfoldr.org/cpu/)
* [C 語言pthread 多執行緒平行化程式設計入門教學與範例- G. T. Wang](https://blog.gtwang.org/programming/pthread-multithreading-programming-in-c-tutorial/)
* [維基百科:超執行緒](https://zh.wikipedia.org/wiki/%E8%B6%85%E5%9F%B7%E8%A1%8C%E7%B7%92)

## CPU 的漏洞

Spectre 與 Meltdown

* https://meltdownattack.com/ (原始論文)
* [给程序员解释 Spectre 和 Meltdown漏洞](https://zhuanlan.zhihu.com/p/32784852)
* 展示影片 -- Meltdown in Action: Dumping memory
    * https://www.youtube.com/watch?time_continue=15&v=bReA1dvGJ6Y

* [一步一步理解CPU芯片漏洞：Meltdown与Spectre](https://www.freebuf.com/articles/system/159811.html) (Meltdown 講清楚了)

摘要:

由于处理器的缓存（cache）机制，那些被预测执行或乱序执行的指令会被先加载到缓存中，但在处理器恢复状态时并不会恢复处理器缓存的内容。而最新的研究表明攻击者可以利用缓存进行侧信道攻击，而Meltdown与Spectre从本质上来看属于利用处理器的乱序执行或预测执行漏洞进行的缓存侧信道攻击。...

缓存命中与失效对应的响应时间是有差别的，攻击者正是利用这种时间的差异性来推测缓存中的信息，从而获得隐私数据。...

缓存侧信道攻击主要有Evict+Time[7]、Prime+Probe[6])与Flush+Reload[5]等攻击方式，这里主要简单介绍一下Flush+Reload，也是下文exploit中利用的方法。假设攻击者和目标程序共享物理内存（也可以是云中不同虚拟机共享内存），攻击者可以反复利用处理器指令将监控的内存块（某些地址）从缓存中驱逐出去，然后在等待目标程序访问共享内存（Flush阶段）。然后攻击者重新加载监控的内存块并测量读取时间(Reload阶段)，如果该内存块被目标程序访问过，其对应的内存会被导入到处理器缓存中，则攻击者对该内存的访问时间将会较短。通过测量加载时间的长短，攻击者可以清楚地知道该内存块是否被目标程序读取过。

Meltdown与Spectre利用这种侧信道可以进行越权内存访问，甚至读取整个内核的内存数据。

