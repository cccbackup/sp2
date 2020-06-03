#include "../myshell.h"

int main(int argc, char *argv[]) {
  char path[SMAX], cmd[SMAX];
  getcwd(path, SMAX-1); // 取得初始路徑
	while (1) { // 不斷等待使用者輸入命令並執行之
    printf("myshell:%s $ ", path); // 顯示提示訊息
    gets(cmd);                     // 等待使用者輸入命令
    system(cmd);                   // 執行命令
  }
}
