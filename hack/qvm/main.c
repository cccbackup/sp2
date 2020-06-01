#include <stdio.h>

extern void hcode();

unsigned short m[65536], A=0, D=0;

int main() {
  hcode();
  printf("A=%d D=%d\n", A, D);
}

