#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {
  int fds[2] = {0,0};
  pipe(fds);
  if (fork()==0)
}