#include "tele.h"

int main() {
  char buf[BSIZE];
  memset(buf, 0, BSIZE);
  int fd = open("chat.dat", O_CREAT|O_RDWR, 0755);
  write(fd, buf, BSIZE);
  close(fd);
}
