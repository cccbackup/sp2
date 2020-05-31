#include "time.h"

int main() {
  time_t *p;
  int fd = open("time.dat", O_RDWR);
  p = mmap(NULL, sizeof(time_t), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    *p = time(NULL);
    sleep(1);
  }
  msync(p, sizeof(time_t), MS_ASYNC);
  close(fd);
}
