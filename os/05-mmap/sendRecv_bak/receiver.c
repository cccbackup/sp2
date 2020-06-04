#include "protocol.h"

#include <stdio.h>
#include <stdlib.h>

#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

int main() {
  int fd = shm_open(NAME, O_RDONLY, 0666);
  if (fd < 0) {
    perror("shm_open()");
    return EXIT_FAILURE;
  }

  int *data =
      (int *)mmap(0, SIZE, PROT_READ, MAP_SHARED, fd, 0);
  printf("receiver mapped address: %p\n", data);

  for (int i = 0; i < NUM; ++i) {
    printf("%d\n", data[i]);
  }

  munmap(data, SIZE);

  close(fd);

  shm_unlink(NAME);

  return EXIT_SUCCESS;
}
