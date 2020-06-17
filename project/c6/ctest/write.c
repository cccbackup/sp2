
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
  int fd;
  int buf[] = {1,2,3,4,5};
  char oFile[] = "test.o";
  printf("O_RDONLY=%d\n", O_RDONLY);
  printf("O_WRONLY|O_CREAT|O_TRUNC=%d\n", O_WRONLY|O_CREAT|O_TRUNC);
  if ((fd = open(oFile, O_WRONLY|O_CREAT|O_TRUNC, 0644)) < 0) { printf("could not open(%s)\n", oFile); return -1; }
  printf("sizeof(buf)=%d\n", sizeof(buf));
  write(fd, buf, sizeof(buf));
  close(fd);
  return 0;
}
