#include "sort.c"

int main() {
  int a[5];
  scanf("%d %d %d %d %d", &a[0], &a[1], &a[2], &a[3], &a[4]);
  print_array(a, 5);
  insertion_sort(a, 5);
  print_array(a, 5);
}
