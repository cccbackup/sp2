#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#define SMAX 128

int main() {
  close(0);                      // 關閉標準輸入 stdin
  close(1);                      // 關閉標準輸出 stdout
  open("a.txt", O_RDWR);         // 此時 open，會找沒被使用的最小檔案代號 0
  open("b.txt", O_CREAT|O_RDWR); // 此時 open，會找沒被使用的最小檔案代號 1
  char line[SMAX];
  gets(line);                    // 從 0 (a.txt) 讀入一行字 line
  puts(line);                    // 輸出 line 到 1 (b.txt)
}
