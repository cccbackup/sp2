#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  char cmd[100];
  sprintf(cmd, "grep %s", argv[1]);
  system(cmd);
}
