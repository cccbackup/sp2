#include <stdio.h>

extern unsigned short A, D;
void hcode() {
	printf("D=%d A=%d\n", D, A);
  A=3;
  D=5;
}