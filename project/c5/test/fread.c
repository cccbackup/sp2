#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>

char buf[10000];

int main(int argc, char *argv[]) {
  FILE *fd;
  char *oFile=argv[1]; // "sum.o"; "var.o"
  if ((fd = fopen(oFile, "rb")) < 0) { printf("could not open(%s)\n", oFile); return -1; }
  int len = fread(buf, 1, sizeof(buf), fd);
  printf("len=%d\n", len);
  fclose(fd);
  return 0;
}
