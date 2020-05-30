#include "tele.h"

int main() {
  char buf[BSIZE];
  memset(buf, 0, BSIZE);
  int fd = open('chat.dat', O_RDWR);
  write(fd, buf, BSIZE);
  close(fd);
}
