# nand2tetris -- 第 8 章指引 (堆疊式虛擬機)

## 堆疊機

1. 堆疊機概念的講解
    * 對照暫存器機
    * push, add, pop 基本堆疊運算
2. 如何實作 call, function 與 return
    * 參數處理
    * 返回位址

## 將 HackVM 對應到 HackCPU

暫存器 -- SP:R0, LCL:R1, ARG:R2, THIS:R3, THAT:R4, TEMP:R5-12, General Purpose:R13..15

Static -- static: mapped on RAM[16 ... 255];

each segment reference static i appearing in a VM file named f is compiled to the assembly language symbol f.i (recall that the assembler further maps such symbols to the RAM, from address 16 onward)


## HackVM 函數呼叫如何處理

第八章習題 : https://www.nand2tetris.org/project08

NestedCall: Sys.vm

An optional and intermediate test, which may be useful when SimpleFunction (the previous test) passes but FibonacciElement (the next test) fails.

Tests several requirements of the function calling protocol. 

For more information about this optional test, see [this guide] and [this stack diagram] . 

Can be used with or without the VM bootstrap code.

[this guide]:https://www.nand2tetris.org/copy-of-hdl-survival-guide
[this stack diagram]:https://www.nand2tetris.org/copy-of-nestedcall

## 實作

```

function cmdCall(name, n) {
  var returnAddress = newLabel();
  cmdPush("constant", returnAddress); // push return_address
  cmdPush("reg", R_LCL);              // push LCL
  cmdPush("reg", R_ARG);              // push ARG
  cmdPush("reg", R_THIS);             // push THIS
  cmdPush("reg", R_THAT);             // push THAT
  loadSeg("R"+R_SP, -n-5);
  compToReg(R_ARG, 'D');              // ARG=SP-n-5
  regToReg(R_LCL, R_SP);              // LCL=SP
  A(name);                            // A=function_name
  C('0; JMP');                        // 0;JMP
  cmdLabel(returnAddress);            // (return_address)
}
...
function cmdReturn() {
  regToReg(R_FRAME, R_LCL);   // R_FRAME = R_LCL
  A("5");                     // A=5
  C("A=D-A");                 // A=FRAME-5
  C("D=M");                   // D=M
  compToReg(R_RET, 'D');      // RET=*(FRAME-5)
  cmdPop("argument", 0);      // *ARG=return value
  regToDest('D', R_ARG);      // D=ARG
  compToReg(R_SP, 'D+1');     // SP=ARG+1
  prevFrameToReg(R_THAT);     // THAT=*(FRAME-1)
  prevFrameToReg(R_THIS);     // THIS=*(FRAME-2)
  prevFrameToReg(R_ARG);      // ARG=*(FRAME-3)
  prevFrameToReg(R_LCL);      // LCL=*(FRAME-4)
  prevFrameToReg(R_RET);      // A=RET
  C("0; JMP");                // goto RET
}

```

## 虛擬機中間碼

* https://github.com/cccbook/sp/blob/master/code/nand2tetris/08/FunctionCalls/FibonacciElement/Main.vm

```
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/08/FunctionCalls/FibonacciElement/Main.vm

// Computes the n'th element of the Fibonacci series, recursively.
// n is given in argument[0].  Called by the Sys.init function 
// (part of the Sys.vm file), which also pushes the argument[0] 
// parameter before this code starts running.

function Main.fibonacci 0
push argument 0
push constant 2
lt                     // check if n < 2
if-goto IF_TRUE
goto IF_FALSE
label IF_TRUE          // if n<2, return n
push argument 0        
return
label IF_FALSE         // if n>=2, return fib(n-2)+fib(n-1)
push argument 0
push constant 2
sub
call Main.fibonacci 1  // compute fib(n-2)
push argument 0
push constant 1
sub
call Main.fibonacci 1  // compute fib(n-1)
add                    // return fib(n-1) + fib(n-2)
return

```

## 轉換為 Hack 組合語言

* https://github.com/cccbook/sp/blob/master/code/nand2tetris/08/FunctionCalls/FibonacciElement/FibonacciElement.asm

```
// init
@256
D=A
@R0
M=D
@LABEL1
D=A
@SP
A=M
M=D
@SP
M=M+1
@R1
D=M
@SP
A=M
M=D
@SP
M=M+1
@R2
D=M
@SP
A=M
M=D
@SP
M=M+1
@R3
D=M
@SP
A=M
M=D
@SP
M=M+1
@R4
D=M
@SP
A=M
M=D
@SP
M=M+1
@5
D=A
@R0
A=M
AD=A-D
@R2
M=D
@R0
D=M
@R1
M=D
@Sys.init
0;JMP
(LABEL1)
// function Main.fibonacci 0
(Main.fibonacci)
// push argument 0
@ARG
AD=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
// lt                     // check if n < 2
@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
@SP
A=M
A=M
D=A-D
@LABEL2
D;JLT
@SP
A=M
M=0
@LABEL3
0;JMP
(LABEL2)
@SP
A=M
M=-1
(LABEL3)
@SP
M=M+1
// if-goto IF_TRUE
@SP
M=M-1
@SP
A=M
D=M
@IF_TRUE
D;JNE
// goto IF_FALSE
@IF_FALSE
0;JMP
// label IF_TRUE          // if n<2, return n
(IF_TRUE)
// push argument 0        
@ARG
AD=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// return
@R1
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
M=M-1
@ARG
AD=M
@R15
M=D
@SP
A=M
D=M
@R15
A=M
M=D
@R2
D=M
@R0
M=D+1
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R4
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R3
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R2
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R1
M=D
@R14
A=M
0;JMP
// label IF_FALSE         // if n>=2, return fib(n-2)+fib(n-1)
(IF_FALSE)
// push argument 0
@ARG
AD=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// push constant 2
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
// sub
@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
@SP
A=M
A=M
D=A-D
@SP
A=M
M=D
@SP
M=M+1
// call Main.fibonacci 1  // compute fib(n-2)
@LABEL4
D=A
@SP
A=M
M=D
@SP
M=M+1
@R1
D=M
@SP
A=M
M=D
@SP
M=M+1
@R2
D=M
@SP
A=M
M=D
@SP
M=M+1
@R3
D=M
@SP
A=M
M=D
@SP
M=M+1
@R4
D=M
@SP
A=M
M=D
@SP
M=M+1
@6
D=A
@R0
A=M
AD=A-D
@R2
M=D
@R0
D=M
@R1
M=D
@Main.fibonacci
0;JMP
(LABEL4)
// push argument 0
@ARG
AD=M
D=M
@SP
A=M
M=D
@SP
M=M+1
// push constant 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
// sub
@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
@SP
A=M
A=M
D=A-D
@SP
A=M
M=D
@SP
M=M+1
// call Main.fibonacci 1  // compute fib(n-1)
@LABEL5
D=A
@SP
A=M
M=D
@SP
M=M+1
@R1
D=M
@SP
A=M
M=D
@SP
M=M+1
@R2
D=M
@SP
A=M
M=D
@SP
M=M+1
@R3
D=M
@SP
A=M
M=D
@SP
M=M+1
@R4
D=M
@SP
A=M
M=D
@SP
M=M+1
@6
D=A
@R0
A=M
AD=A-D
@R2
M=D
@R0
D=M
@R1
M=D
@Main.fibonacci
0;JMP
(LABEL5)
// add                    // return fib(n-1) + fib(n-2)
@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
@SP
A=M
A=M
D=D+A
@SP
A=M
M=D
@SP
M=M+1
// return
@R1
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
M=M-1
@ARG
AD=M
@R15
M=D
@SP
A=M
D=M
@R15
A=M
M=D
@R2
D=M
@R0
M=D+1
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R4
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R3
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R2
M=D
@R13
D=M
D=D-1
@R13
M=D
A=D
D=M
@R1
M=D
@R14
A=M
0;JMP
// function Sys.init 0
(Sys.init)
// push constant 4
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Main.fibonacci 1   // Compute the 4'th fibonacci element
@LABEL6
D=A
@SP
A=M
M=D
@SP
M=M+1
@R1
D=M
@SP
A=M
M=D
@SP
M=M+1
@R2
D=M
@SP
A=M
M=D
@SP
M=M+1
@R3
D=M
@SP
A=M
M=D
@SP
M=M+1
@R4
D=M
@SP
A=M
M=D
@SP
M=M+1
@6
D=A
@R0
A=M
AD=A-D
@R2
M=D
@R0
D=M
@R1
M=D
@Main.fibonacci
0;JMP
(LABEL6)
// label WHILE
(WHILE)
// goto WHILE              // Loop infinitely
@WHILE
0;JMP

```
