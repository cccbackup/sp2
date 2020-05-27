#include "sort.c"

int main() {
  int array[] = {5,3,1,4,2};
  print_array(array, 5);
  insertion_sort(array, 5);
  print_array(array, 5);
}
