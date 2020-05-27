# cat.c

## 編譯執行

```
PS D:\ccc\course\sp\code\c\06-os1windows\01-stdc\02-cat> gcc cat.c -o cat
PS D:\ccc\course\sp\code\c\06-os1windows\01-stdc\02-cat> ./cat cat.c     
#include <stdio.h>

#define TEXT_SIZE 1000000

char text[TEXT_SIZE];

int main(int argc, char *argv[]) {
  char *fileName = argv[1];
  FILE *file = fopen(fileName, "rt");
  int len = fread(text, 1, TEXT_SIZE-1, file);
  text[len] = 0;
  printf("%s\n", text);
}
```
