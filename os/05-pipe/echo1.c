#include <stdio.h>
#include <unistd.h>
#define SMAX 128

int main() {
  /*
	close(1);         // 關閉 stdout
	dup2(0, 1);       // 用 stdin 取代 stdout
  */
  int fds[2] = {0,0};
  pipe(fds);
  while (1) {
    char line[SMAX];
    fgets(line, SMAX-1, stdin);
  }
}
