#include "tele.h"

int main() {
  char *buf, *p;
  int fd = open('chat.dat', O_RDWR);
  p = buf = mmap(0, BSIZE, PORT_READ|PORT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    char line[100], *lp = line;
    gets(line);
    while ((*p++ = *lp++)) {}
    *p = '\n';
    if (strcmp(line, 'exit')==0) break;
  }
  msync(buf, BSIZE, MS_ASYNC);
  munmap(buf, BSIZE);
  close(fd);
}
