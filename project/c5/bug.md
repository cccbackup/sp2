## 

目前沒有已知的 bug !

## 

PS D:\ccc\course\sp\code\c\xss\c6> ./vm test/fib.o
PS D:\ccc\course\sp\code\c\xss\c6> ./objdump test/fib.o
 33024
 33024
PS D:\ccc\course\sp\code\c\xss\c6> ./objdump test/sum.o

## 

PS D:\ccc\course\sp\code\c\xss\c6> ./cc c6.c test/fib.c   
619: bad expression

## 

PS D:\ccc\course\sp\code\c\xss\c6> ./cc -o test/fib.o test/fib.c
f(7)=13
unknown instruction = 691480678! cycle = 918   <-- 注意，這個 cycle 只有 918，而非下面的 920 ，所以似乎少了一個指令。


但是

PS D:\ccc\course\sp\code\c\xss\c6> ./cc test/fib.c   
f(7)=13
exit(8) cycle = 920

沒事！

## 

PS D:\ccc\course\sp\code\c\xss\c6> ./cc test/hello.c     
hello, world
exit(0) cycle = 9
PS D:\ccc\course\sp\code\c\xss\c6> ./cc c6.c test/hello.c
9: bad global declaration


## 

fib 最後沒有 LEV 

查清楚原因後，發現 fib.c 的 main() 沒有 return, 因此沒有產生
11:   return 0;
    IMM  0
    LEV)

而且若 檔尾沒換行的話，也會造成沒有最後一個 LEV。

```
9: int main() {
10:   printf("f(7)=%d\n", f(7));
    ENT  0
    IMM  12058712
    PSH
    IMM  7
    PSH
    JSR  11796564
    ADJ  1
    PSH
    PRTF
    ADJ  2
f(7)=13
exit(8) cycle = 920
```

其他的都有

```
PS D:\ccc\course\sp\code\c\xss\c6> ./cc -s test/hello.c
1: #include <stdio.h>
3: int main()
4: {
5:   printf("hello, world\n");
    ENT  0
    IMM  12910680
    PSH
    PRTF
    ADJ  1
6:   return 0;
    IMM  0
    LEV
7: }
    LEV
hello, world
exit(0) cycle = 9

13:   }
14:   return s;
    JMP  -36
    LEA  -1
    LI
    LEV
15: }
    LEV
16:
17: int main() {
18:   printf("main:enter\n");
    ENT  0
    IMM  13107300
    PSH
    PRTF
    ADJ  1
19:   printf("sum(10)=%d\n", sum(10));
    IMM  13107312
    PSH 
    PSH
    JSR  12845140
    ADJ  1 
    PSH
    PRTF
    ADJ  2
20:   return 0;
    IMM  0
    LEV
21: }
    LEV
main:enter
sum:enter
sum(10)=55
exit(0) cycle = 311
```

## 

hello, sum, 成功了

但 fib 出來前失敗了 (unknown instruction = 691480678)。

```
PS D:\ccc\course\sp\code\c\xss\c6> ./cc -o test/hello.o test/hello.c
obj_read(): oFile=test/hello.o objLen=294
obj_head(): hc[O]=72 hd[O]=120 hr[O]=136 ht[O]==144 hs[O]=286
obj_head:pc=10551444 code=10551440 entry=1 data=10551488
obj_head:code0=11862096 data0=12124248
hello, world
exit(0) cycle = 9


PS D:\ccc\course\sp\code\c\xss\c6> ./cc -o test/sum.o test/sum.c    
obj_read(): oFile=test/sum.o objLen=725
obj_head(): codeLen=352 dataLen=36 relLen=32 stLen=217 symLen=16 objLen=725
obj_head(): hc[O]=72 hd[O]=424 hr[O]=460 ht[O]==492 hs[O]=709
obj_head:pc=12190092 code=12189840 entry=63 data=12190192
obj_head:code0=13500496 data0=13762648
main:enter
sum:enter
sum(10)=55
exit(0) cycle = 311

PS D:\ccc\course\sp\code\c\xss\c6> ./cc -o test/fib.o test/fib.c   
obj_read(): oFile=test/fib.o objLen=600
obj_head(): codeLen=284 dataLen=12 relLen=32 stLen=184 symLen=16 objLen=600
obj_head(): hc[O]=72 hd[O]=356 hr[O]=368 ht[O]==400 hs[O]=584
obj_head:pc=6422892 code=6422672 entry=55 data=6422956
obj_head:code0=13566032 data0=13828184
f(7)=13
unknown instruction = 691480678! cycle = 918
```

## 

```
PS D:\ccc\course\sp\code\c\xss\c6> ./cc -o test/sum.o test/sum.c
obj_read(): oFile=test/sum.o objLen=725
obj_head(): codeLen=352 dataLen=36 relLen=32 stLen=217 symLen=16 objLen=725
obj_head(): hc[O]=72 hd[O]=424 hr[O]=460 ht[O]==492 hs[O]=709
obj_head:pc=7799180 code=7798928 entry=63 data=7799280
obj_head:code0=13107280 data0=13369432
obj_load():code=7798928 data=7799280 code0=13107280 data0=13369432
rel:offset=4
rel:old:*cp=13369432
rel:type=1
rel:new:*cp=7799280
rel:offset=66
rel:old:*cp=13369444
rel:type=1
rel:new:*cp=7799292
rel:offset=72
rel:old:*cp=13369456
rel:type=1
rel:new:*cp=7799304
rel:offset=78
rel:old:*cp=13107284
rel:type=0
rel:new:*cp=11780196 // 奇怪，這應該是 7799*** 才對啊，為何會是 117....
main:enter
```


```
PS D:\ccc\course\sp\code\c\xss\c6> ./cc -d -o test/sum.o test/sum.c
obj_read(): oFile=test/sum.o objLen=623
obj_head(): codeLen=304 dataLen=12 relLen=16 stLen=203 symLen=16 objLen=623
obj_head(): hc[O]=72 hd[O]=376 hr[O]=388 ht[O]==404 hs[O]=607
obj_head:pc=10092916 code=10092688 entry=57
1> 0057:ENT  0
2> 0059:IMM  10092992
3> 0061:PSH
4> 0062:IMM  10
5> 0064:PSH
6> 0065:JSR  11075684
```

看來是只要有 JSR 就掛掉了，應該是 relocate 沒做好！

# 

mingw32 位元的 read 有問題

讀取 sum.o, fib.o 時，長度會有錯誤。

應該是 6xx 位元，讀到的卻只有 256 位元。

解決方式，沒有指定 binary, 改用 fread(..."rb") 就可以解決。

