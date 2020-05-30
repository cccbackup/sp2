#include "tele.h"

int main() {
  char *buf, *p;
  int fd = open("chat.dat", O_RDWR);
  p = buf = mmap(0, BSIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    if ((*p)) putc(*p++, stdout); else sleep(1);
    if (p-buf > 6 && strcmp(p-6, "\nexit\n")==0) break;
  }
  munmap(buf, BSIZE);
  close(fd);
}
