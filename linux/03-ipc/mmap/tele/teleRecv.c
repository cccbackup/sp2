#include <stdio.h>
#define BSIZE 10000

int main() {
  char *buf, *p;
  int fd = open('chat.dat', O_RDWR);
  p = buf = mmap(0, BSIZE, PORT_READ|PORT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    if (*p) putc(*p, stdout);
    if (strcmp(p-6, '\nexit\n')==0) break;
  }
  munmap(buf, BSIZE);
  close(fd);
}
