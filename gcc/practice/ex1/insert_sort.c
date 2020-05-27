#include <stdio.h>

void print_array(int a[], int len) {
  for (int i=0; i<len; i++) {
    printf("%d ", a[i]);
  }
  printf("\n");
}

void insertion_sort(int arr[], int len){
  int i,j,key;
  for (i=1;i<len;i++){
    key = arr[i];
    j=i-1;
    while((j>=0) && (arr[j]>key)) {
      arr[j+1] = arr[j];
      j--;
    }
    arr[j+1] = key;
    printf("i=%d : ", i);
    print_array(arr, len);
  }
}

int main() {
  int array[] = {5,3,1,4,2};
  print_array(array, 5);
  insertion_sort(array, 5);
  print_array(array, 5);
}