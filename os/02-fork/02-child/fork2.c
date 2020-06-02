#include <stdio.h> 
#include <sys/types.h> 
#include <unistd.h>

int main() { 
    fork();  // 一個行程分叉成父子兩個行程
    if (fork()==0) { // 兩個行程又分別分叉出兩對父子，所以變成四個行程。
      printf("%-5d: I am child!\n", getpid());
    } else {
      printf("%-5d: I am parent!\n", getpid());
    }
}
