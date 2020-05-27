# 編譯只有 +- 的數字運算式

## exp0 -- 編譯成中間碼

基本範例

```
PS D:\ccc\sp\code\c\02-compiler\00-exp0> ./exp0 '3+5'  
argv[0]=D:\ccc\sp\code\c\02-compiler\00-exp0\exp0.exe argv[1]=3+5 
=== EBNF Grammar =====
E=F ([+-] F)*
F=Number | '(' E ')'
==== parse:3+5 ========
t0=3
t1=5
t2=t0+t1
```

過程解說

parse('3+5') => tokens = "3+5", tokenIdx = 0
  E()
    i1=F()        => i1=0
      3           => t0=3
    while () ...
        +             => op = +
        i2=F()        => i2=1, t1=5
        i=nextTemp()  => i=2
        print()       => t2=t0+t1

以 3+5 為例

```
// E = F ([+-] F)*
int E() {
  int i1 = F();               // t0=3, i1=0
  while (isNext("+-")) {
    char op=next();           // op = +
    int i2 = F();             // t1=5, i2=1 
    int i = nextTemp();       // i = 2
    printf("t%d=t%d%ct%d\n", i, i1, op, i2);
    // t2 = t0+t1
    i1 = i;
  }
  return i1;
}
```

進階案例

```
$ gcc exp0.c -o exp0
$ ./exp0 '3+(5-8)'
=== EBNF Grammar =====
E=F ([+-] F)*
F=Number | '(' E ')'
==== parse:3+(5-8) ========
t0=3
t1=5
t2=8
t3=t1-t2
t4=t0+t3
```

## exp0hack -- 編譯後產生 hack CPU 的組合語言 (nand2tetris)

```
$ gcc exp0hack.c -o exp0hack
$ ./exp0hack '3+(5-8)'
=== EBNF Grammar =====
E=F ([+-] F)*
F=Number | '(' E ')'
==== parse:3+(5-8) ========
# t0=3
@3
D=A
@t0
M=D
# t1=5
@5
D=A
@t1
M=D
# t2=8
@8
D=A
@t2
M=D
# t3=t1-t2
@t1
D=M
@t2
D=D-M
@t3
M=D
# t4=t0+t3
@t0
D=M
@t3
D=D+M
@t4
M=D
```

## exp0var -- 支援變數


```
PS D:\ccc\sp\code\c\02-compiler\00-exp0> gcc exp0var.c -o exp0var

PS D:\ccc\sp\code\c\02-compiler\00-exp0> ./exp0var 'x+5-y'         
=== EBNF Grammar =====
E=F ([+-] F)*
F=Number | '(' E ')'
==== parse:x+5-y ========
# t0=x
@x
D=M
@t0
M=D
# t1=5
@5
D=A
@t1
M=D
# t2=t0+t1
@t0
D=M
@t1
D=D+M
@t2
M=D
# t3=y
M=D
# t4=t2-t3
@t2
D=M
@t3
D=D-M
@t4
M=D
```