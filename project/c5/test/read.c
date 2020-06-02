#include <stdio.h>
#include <stdlib.h>
/*
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>
*/
#include "../c6.h"

char buf[10000];

int main(int argc, char *argv[]) {
  int fd;
  char *oFile=argv[1]; // "sum.o"; "var.o"
  if ((fd = open(oFile, 0, 633)) < 0) { printf("could not open(%s)\n", oFile); return -1; }
  int len = read(fd, buf, sizeof(buf));
  printf("len=%d\n", len);
  close(fd);
  return 0;
}
