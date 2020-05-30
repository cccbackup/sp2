#include "time.h"

int main() {
  time_t t;
  int fd = open("time.dat", O_CREAT|O_RDWR, 0755);
  write(fd, &t, sizeof(time_t));
  close(fd);
}
