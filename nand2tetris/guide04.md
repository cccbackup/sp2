# nand2tetris -- 第 4 章指引

# 習題

本章將學習 nand2tetris 課程中 HackCPU 的組合語言。

習題需撰寫兩個組合語言程式，一個是乘法函數，另一個是輸出入控制程式。

1. Mult.asm -- 乘法函數
2. Fill.asm -- 輸出入控制程式，當按下鍵盤某鍵時，螢幕要反白。


## 指引

第 4 章要學習的是 《HackCPU 的組合語言》，理解了組合語言之後，我們就能學會整個電腦運作的底層原理。

認識組合語言之後，我們會進一步認識《指令的編碼方式》，也就是《機器語言》，這樣我們才有機會在下一章設計出 HackCPU。

這一章有兩個習題，一個是《乘法函數》，另一個是《按下鍵盤後螢幕會反白》的函數。

由於 HackCPU 的指令裏只有加減法，沒有乘除法，因此乘除法必須用《軟體的方式完成》，而第 1 個習題《乘法函數》就是用軟體方式完成乘法的組合語言程式。

第 2 個習題主要是學習《如何用記憶體映射的方式，讀取鍵盤按鍵，然後輸出到螢幕上》的方法，透過這個習題我們將學會《透過組合語言控制輸出入裝置的方法》。

## 從 C 到組合語言

以 nand2tetris 的 hackCPU 組合語言為例！

## 指定敘述改寫為組合語言

```C
#include <stdio.h>

int main() {      // 組合語言
                  // @a
  int a = 3;      // M=3

  int b = 5;      // @b
                  // M=5
  int c = a + b;  // @a; D = M;          D = a
                  // @b; D=D+M;          D = a+b
                  // @c; M=D;            c = D

  printf("a=%d b=%d c=%d\n", a, b, c);
}
```

## WHILE 改寫為 goto

原始有 while 迴圈的版本如下：

```C
#include <stdio.h>

int sum(int n) {
  int s = 0;
  int i = 1;
// WHILE:
  while (i<=n) { // if (i>n) goto EXIT
    s = s + i;
    i = i + 1;
  }              // goto WHILE
// EXIT:
  return s;
}

int main() {
  int s10 = sum(10);
  printf("s10=%d\n", s10);
}

```

用 if + goto 取代 while 的版本

```C
#include <stdio.h>

int sum(int n) {
  int s = 0;           //          @s; M=0;
  int i = 1;           //          @i; M=1;
WHILE:                 // (WHILE)
  // while (i<=n) {
  s = s + i;           //          @i; D=M;         D=i
                       //          @s; D=D+M;       D=D+s
                       //          @s; M=D;         s=D
  i = i + 1;
  // }
  // i<=n   .... => i-n <=0
  if (i<=n) goto WHILE; //         @n; D=M;         D=n
                        //         @i; D=M-D;       D=i-D  D=i-n
                        //         @WHILE; 
                        //         D; JLE
  return s;
}

int main() {
  int s10 = sum(10);
  printf("s10=%d\n", s10);
}

```

## IF ELSE 改寫為 goto

高階 C 語言版

```C
#include <stdio.h>

int max(int a, int b) {
  int c;
  if (a > b)  
    c = a;
  else
    c = b;
  return c;
}

int main() {
  int m = max(3, 8);
  printf("m=%d\n", m);
}

```

用 goto 取代 ELSE 的版本

```C
#include <stdio.h>

int max(int a, int b) {
  int c;
  if (a <= b) goto ELSE;
  c = a;
  goto EXIT;
ELSE:
  c = b;
EXIT:
  return c;
}

int main() {
  int m = max(3, 8);
  printf("m=%d\n", m);
}
```

## 第四章乘法習題

檔案：mult.c

```c
#include <stdio.h>

int main() {
    int R0 = 3;
    int R1 = 5;
    int R2 = 0;
    
    while (R0 > 0) {
      R2 = R2 + R1;
      R0 = R0 - 1;
      printf("R0=%d R1=%d R2=%d\n", R0, R1, R2);
    }
    
    printf("R2=%d\n", R2);
}

```

組合語言 mult.asm

```
// #include <stdio.h>

// int main() {
//    int R0 = 3;
//    int R1 = 5;
// =>    int R2 = 0;
@0
D=A
@R2
M=D 
//    while (R0 > 0) {
// => loop:
(loop)
// =>    if (R0 <= 0) goto exit1;
@R0
D=M
@exit1
D; JLE

// =>  R2 = R2 + R1;
@R1
D=M 
@R2
M=D+M

// =>  R0 = R0 - 1;
@R0
M=M-1

//     printf("R0=%d R1=%d R2=%d\n", R0, R1, R2);
// =>  goto loop;
@loop
0;JMP

// => exit1:
(exit1)
@exit1
0;JMP
//    }
    
//     printf("R2=%d\n", R2);
// }

```

## 第四章習題 fill.asm

```
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

// --------------------------
// 類似 Ｃ語言的高階寫法
// forever
//   arr = SCREEN
//   n = 8192
//   i = 0
//   while (i < n) {
//     if (*KBD != 0)
//       arr[i] = -1
//     else
//       arr[i] = 0
//     i = i + 1
//   }
// goto forever;
// --------------------------
// 類似 Ｃ語言的低階寫法
// arr = SCREEN
// n=8192
// FOREVER:
// loop:
//   if (i==n) goto ENDLOOP
//   if (*KBD != 0)
//     RAM[arr+i] = -1
//   else 
//     RAM[arr+i] = 0
//   i++
// goto loop
// ENDLOOP:
// goto FOREVER
// --------------------------

(FOREVER)
// arr = SCREEN
	@SCREEN
	D=A
	@arr
	M=D

// n=8192
	@8192
	D=A
	@n
	M=D

	@i
	M=0
(LOOP)
  // if (i==n) goto ENDLOOP
	@i
	D=M
	@n
	D=D-M
	@ENDLOOP
	D; JEQ
	
  // if (*KBD != 0)
	@KBD
	D=M     // D = *KBD
	@ELSE
	D; JEQ  // if (*KDB==0) goto ELSE
	
	//   RAM[arr+i] = -1
	@arr
	D=M
	@i
	A=D+M
	M=-1
	
	@ENDIF
	0; JMP
(ELSE)	
  // else 
  //   RAM[arr+i] = 0
	@arr
	D=M
	@i
	A=D+M
	M=0
	
(ENDIF)
	
	// i++
	@i
	M=M+1
	
	@LOOP
	0; JMP

(ENDLOOP)
	@FOREVER
	0; JMP
	

```
