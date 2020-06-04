# myshell 第一版

程式很簡單，但切換路徑 cd 有問題！

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v1
$ gcc myshell.c -o myshell

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v1
$ ./myshell
myshell:/d/ccc/course/sp2/my/shell/v1 $ ls
myshell.c  myshell.exe  path.txt  README.md
myshell:/d/ccc/course/sp2/my/shell/v1 $ cat myshell.c
#include "../my.h"

int main(int argc, char *argv[]) {
  char path[SMAX], cmd[SMAX];
  getcwd(path, SMAX-1);
        while (1) {
    printf("myshell:%s $ ", path);
    fgets(cmd, SMAX, stdin);
    system(cmd);
  }
}
myshell:/d/ccc/course/sp2/my/shell/v1 $ cd .. // cd 切換失敗，因為 system 呼叫是用 exec 為獨立行程
myshell:/d/ccc/course/sp2/my/shell/v1 $ cd .. // 所以不管如何用 cd 都不會導致 main.c 切換資料夾。
myshell:/d/ccc/course/sp2/my/shell/v1 $ cd /
myshell:/d/ccc/course/sp2/my/shell/v1 $ ls
myshell.c  myshell.exe  path.txt  README.md
myshell:/d/ccc/course/sp2/my/shell/v1 $

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/my/shell/v1

```