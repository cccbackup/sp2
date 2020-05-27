# make 建置函式庫

```
PS D:\ccc\sp\code\c\04-toolchain\gcc\05-makeLib> make   
gcc -std=c99 -O0 -c sum.c -o sum.o
ar -r libstat.a sum.o
gcc -std=c99 -O0 -c main.c -o main.o
gcc -std=c99 -O0 libstat.a main.o -L ./ -lstat -o run
PS D:\ccc\sp\code\c\04-toolchain\gcc\05-makeLib> ./run  
sum(10)=-45481793

```