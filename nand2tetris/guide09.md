# nand2tetris -- 第 9 章指引

## 語法理論

| 教學 | 主題  | 影片  |
|--------|------|-----|
| PDF | [Chapter 9. High-Level Language](https://drive.google.com/file/d/1rbHGZV8AK4UalmdJyivgt0fpPiD1Q6Vk/view) |  |
| 電子書 | [語言處理技術](https://www.slideshare.net/ccckmit/ss-15898210) |  |

## C 的執行環境 (記憶體配置)

* https://www.tutorialspoint.com/operating_system/os_memory_management.htm

```
Code
Data
Stack
Heap
```

## Stack 與 Heap

函數呼叫 : 參數、返回點、區域變數

遞迴 Recursive 的運作原理

## malloc 的運作原理

* LinkedList -- https://github.com/pseudomuto/c-data-structures/blob/master/src/implementation/list.c
* https://www.gribblelab.org/CBootCamp/7_Memory_Stack_vs_Heap.html (讚!)
* https://www.geeksforgeeks.org/memory-layout-of-c-program/ (讚!)
* https://en.wikipedia.org/wiki/C_dynamic_memory_allocation
* https://en.cppreference.com/w/c/memory/malloc
* https://www.tutorialspoint.com/operating_system/os_memory_management.htm

## 比較 C 與其他語言

malloc vs. Garbage Collection

* 自行釋放: malloc + free
    * C/C++
* 垃圾收集: Garbage Collection
    * C#, Java, JavaScript,  


## 垃圾蒐集算法

* https://www.geeksforgeeks.org/mark-and-sweep-garbage-collection-algorithm/
* https://plumbr.io/handbook/garbage-collection-algorithms



