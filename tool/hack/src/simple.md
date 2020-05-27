# 簡單執行

```
PS D:\ccc\course\sp\code\c\04-toolchain\hack\src> make
gcc -std=c99 -O0 -Wall  cc/3/cc.c cc/3/lexer.c cc/3/compiler.c ir/3/ir.c ir/3/irvm.c ir/3/ir2m.c lib/util.c lib/map.c lib/strTable.c -o ../bin/cc3
gcc -std=c99 -O0 -Wall  ma/3/macro.c lib/util.c lib/map.c lib/strTable.c -o ../bin/ma3
gcc -std=c99 -O0 -Wall  as/3/asm.c lib/util.c lib/map.c lib/strTable.c -o ../bin/as3
gcc -D_VM_EXT_ -g -std=c99 -O0 -Wall  vm/3/vm.c lib/util.c lib/map.c lib/strTable.c -o ../bin/vm3
PS D:\ccc\course\sp\code\c\04-toolchain\hack\src> make cRun file=sum 
../bin/cc3 ../test/c/sum
../bin/ma2 ../test/c/sum.mx -o ../test/c/sum.sx
../bin/as3 ../test/c/sum
../bin/vm3 ../test/c/sum.ox
55
```