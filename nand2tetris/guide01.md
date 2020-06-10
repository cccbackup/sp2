# nand2tetris -- 第 1 章指引

## 習題

1. not -- not(x) = nand(x,x)
2. and -- and(x,y) = not(nand(x,y))
3. or -- or(x,y) = not(not x and not y)
4. xor -- xor(x, y) = and(x, not y) or and(not x, y)
    * [Wikipedia: De Morgan's laws](https://zh.wikipedia.org/wiki/%E5%BE%B7%E6%91%A9%E6%A0%B9%E5%AE%9A%E5%BE%8B) : 
5. mux -- out = mux(a, b, sel) 二選一多工器，可按標準卡諾圖分析法設計
    * [維基百科: 數據多工器](https://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E9%80%89%E6%8B%A9%E5%99%A8)
6. dmux -- (a,b) = dmux(in, sel) 一對二解多工器
    * https://en.wikipedia.org/wiki/Multiplexer#Digital_demultiplexers
7. not16 -- out i = not(in i)    i = 0..15
8. and16 -- out i = and(xi, yi)  i= 0..15
9. or16 -- out i = or(xi, yi)    i=0..15
10. mux16 -- out i = mux(xi, yi) i=0..15
11. or8way -- out = or(in[0..7])
12. Mux4Way16 -- out = mux16(mux16(a,b), mux16(c,d))
13. Mux8Way16 -- out = mux16(mux4way16(a,b), mux4way16(c,d))
14. DMux4Way -- out = dmux(in, sel, a,b,c,d)
15. DMux8Way -- out = dmux(in, sel, a,b,c,d,e,f,g,h)

## 指引

本章是複習《數位邏輯》課程裡的基本 [邏輯閘](https://zh.wikipedia.org/zh-hant/%E9%82%8F%E8%BC%AF%E9%96%98) 。

首先從 nand 開始，建構 not, and, or, xor, [mux](https://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E9%80%89%E6%8B%A9%E5%99%A8), [dmux](https://en.wikipedia.org/wiki/Multiplexer#Digital_demultiplexers), Or8Way 等基本元件。

然後開始建立 16 位元的閘，包含 Not16, And16, Or16, Mux16, Mux4Way16, Mux8Way16, DMux4Way, DMux8Way 等等。

給予無限多的 nand 閘，請加上線路設計出下列邏輯閘。

(注意，最好依照順序，因為後面的元件可以利用前面設計出來的元件組合而成)
