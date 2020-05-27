# c6 -- 將 C 語言編譯為堆疊機 vm 的目的檔格式

c6 是一個可自我編譯的極簡版 C 語言編譯器，由陳鍾誠修改自 c4 專案。

c4 專案的來源為 -- https://github.com/rswier/c4 。

陳鍾誠修改之處:

1. 加上中文註解
2. 讓函數更模組化，例如增加虛擬機函數 vm_run(), 不受現在只有 4 個函數。
3. 讓虛擬機的 JMP, BZ, BNZ 等指令改為相對 PC 定址，而不是絕對定址，這樣可以有助於產生比較少修改紀錄的目的檔。
4. 加入 WRITE, MCPY 系統呼叫。
5. 可以指定 cc -o `path` 輸出虛擬機目的檔。
6. 可以用 vm `objfile` 載入目的檔然後執行之。

## 建置執行

```
PS D:\ccc\course\sp\code\c\08-compiler2\c6> make       
gcc -D__CC__ -Wall -std=gnu99 -o cc c6.c
gcc -D__VM__ -Wall -std=gnu99 -o vm c6.c
gcc -D__OBJDUMP__ -Wall -std=gnu99 -o objdump c6.c

PS D:\ccc\course\sp\code\c\08-compiler2\c6> ./cc -o test/fib.o test/fib.c
---------obj_save()-------------
header: entry=54

          Size      VMA      LMA   Offset
code: 0000011C 00C50050 00C50050 00000040
data: 0000000C 00C90058 00C90058 0000015C
relo: 00000020 00D10068 00D10068 00000168
stab: 000000B8 00CD0060 00CD0060 00000188
symt: 00000010 00C10048 00C10048 00000240

PS D:\ccc\course\sp\code\c\08-compiler2\c6> ./vm test/fib.o
f(7)=13
exit(8) cycle = 920

PS D:\ccc\course\sp\code\c\08-compiler2\c6> ./objdump test/fib.o
---------obj_dump()-------------
header: entry=54

          Size      VMA      LMA   Offset
code: 0000011C 00C50050 00620088 00000040
data: 0000000C 00C90058 006201A4 0000015C
relo: 00000020 00D10068 006201B0 00000168
stab: 000000B8 00CD0060 006201D0 00000188
symt: 00000010 00C10048 00620288 00000240

sym:
main 129
```
