#include "protocol.h"

#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>

#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

int main() {
  int fd = shm_open(NAME, O_CREAT | O_EXCL | O_RDWR, 0600);
  if (fd < 0) {
    perror("shm_open()");
    return EXIT_FAILURE;
  }

  ftruncate(fd, SIZE);

  struct Data *data = (struct Data *)
      mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  printf("request: mapped address: %p\n", data);

  for (int i = 0; i < NUM; ++i) {
    data->data[i] = i;
  }

  printf("request: release initial data\n");
  atomic_store(&data->state, 1);

  printf("request: waiting updated data\n");
  while (atomic_load(&data->state) != 2) {}
  printf("request: acquire updated data\n");

  printf("request: updated data:\n");
  for (int i = 0; i < NUM; ++i) {
    printf("%d\n", data->data[i]);
  }

  munmap(data, SIZE);

  close(fd);

  shm_unlink(NAME);

  return EXIT_SUCCESS;
}