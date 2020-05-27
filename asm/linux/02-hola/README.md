# hola.s

```
$ gcc -no-pie hola.s -o hola
$ ./hola
Hola, mundo
```

參考 -- https://stackoverflow.com/questions/60352424/call-an-assembler-function-from-c-code-in-linux

```
-no-pie 代表 no position independent executable

就是不要編成與位址無關的目的檔

```