#include <stdio.h>
void F();

// E = F
void E() {
  printf("E started\n");
  // E();
  F();
  printf("E finished\n");
}

// F = 'F'
void F() {
  printf("  F started\n");
  printf("    F\n");
  printf("  F finished\n");
}

int main() {
  E();
}
