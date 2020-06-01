#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdatomic.h>

struct Data {
  atomic_int state;
  int data[];
};

#define NAME "/shmem-example"

#define NUM 3

#define SIZE (sizeof(struct Data) + NUM * sizeof(int))

#endif  /* PROTOCOL_H */