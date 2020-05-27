#include <stdio.h>
#include <stdlib.h>

char buf[10000];

int main(int argc, char *argv[]) {
  // int fd;
  FILE *fd;
  char *oFile=argv[1];
  if ((fd = fopen(oFile, "rb")) < 0) { printf("could not open(%s)\n", oFile); return -1; }
  int len = fread(buf, 1, sizeof(buf), (FILE*)fd);
  printf("len=%d\n", len);
  fclose((FILE*)fd);
  return 0;
}