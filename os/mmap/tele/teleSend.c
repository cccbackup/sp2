#include "tele.h"

int main() {
  char *buf, *p;
  int fd = open("chat.dat", O_RDWR);
  p = buf = mmap(NULL, BSIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
  while (1) {
    char line[100], *lp = line;
    printf("> ");
    fgets(line, sizeof(line)-1, stdin);
    while ((*lp != '\0')) *p++ = *lp++;
    if (strcmp(line, "exit\n")==0) break;
    sleep(1);
  }
  msync(buf, BSIZE, MS_ASYNC);
  munmap(buf, BSIZE);
  close(fd);
}
