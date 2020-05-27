#include "protocol.h"

#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>

#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

int main() {
  int fd = -1;
  while (fd == -1) {
    fd = shm_open(NAME, O_RDWR, 0666);
    if (fd < 0 && errno != ENOENT) {
      perror("shm_open()");
      return EXIT_FAILURE;
    }
  }

  ftruncate(fd, SIZE);

  struct Data *data = (struct Data *)
      mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  printf("worker: mapped address: %p\n", data);

  printf("worker: waiting initial data\n");
  while (atomic_load(&data->state) != 1) {}
  printf("worker: acquire initial data\n");

  printf("worker: update data\n");
  for (int i = 0; i < NUM; ++i) {
    data->data[i] = data->data[i] * 42;
  }

  printf("worker: release updated data\n");
  atomic_store(&data->state, 2);

  munmap(data, SIZE);

  close(fd);

  return EXIT_SUCCESS;
}