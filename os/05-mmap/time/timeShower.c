#include "time.h"

int main() {
  time_t *p;
  int fd = open("time.dat", O_RDWR);
  p = mmap(0, sizeof(time_t), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    sleep(1);
    struct tm tm = *localtime(p);
    printf("%02d:%02d:%02d\n", tm.tm_hour, tm.tm_min, tm.tm_sec);
  }
  munmap(p, sizeof(time_t));
  close(fd);
}
