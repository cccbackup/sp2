# compileExp

```
$ gcc compileExp.c -o compileExp

$ ./compileExp 1+3*x
=== EBNF Grammar =====
E=T ([+-] T)*
T=F ([*/] F)*
F=Number | Id | '(' E ')'
==== parse:1+3*x ========
t0=1
t1=3
t2=x
t3=t1*t2
t4=t0+t3
```

在 mac 底下若有括號必須外面先用 '...' 刮起來，如下所示，否則會錯誤。

```
csienqu-teacher:01-compileExp csienqu$ ./compileExp.o '(3+5)*x/y'
=== EBNF Grammar =====
E=T ([+-] T)*
T=F ([*/] F)*
F=Number | Id | '(' E ')'
==== parse:(3+5)*x/y ========
t0=3
t1=5
t2=t0+t1
t3=x
t4=t2*t3
t5=y
t6=t4/t5
```


$ ./exp1 '3+5*8'   
=== EBNF Grammar =====
E=T ([+-] T)*
T=F ([*/] F)*
F=Number | Id | '(' E ')'

E = 3+5*8
    T+ T
      F*F
      5 8

//     5   *   8
// T = F ([*/] F)*
int T() {
  int f1 = F();   // 5
  while (isNext("*/")) {
    char op=next(); // *
    int f2 = F();   // 8
    int f = nextTemp();
    printf("t%d=t%d%ct%d\n", f, f1, op, f2);
    f1 = f;
  }
  return f1;
}

//     3   +   5*8
// E = T ([+-] T)*
int E() {
  int i1 = T();      // 3
  while (isNext("+-")) {
    char op=next(); // +
    int i2 = T();   // (5*8)
    int i = nextTemp();
    printf("t%d=t%d%ct%d\n", i, i1, op, i2);
    i1 = i;
  }
  return i1;
}
