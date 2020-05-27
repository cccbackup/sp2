# 巨集展開

```
gcc -E max.c -o max.i
```

## max.c 展開前

```c
#include <stdio.h>
#define MAX(a,b) ((a)>(b)?(a):(b))

int main() {
  int a=3, b=5;
  int c = MAX(a,b);
  printf("c=%d\n", c);
}

```

## 展開後 => max.i

```c
... 

# 4 "max.c"
int main() {
  int a=3, b=5;
  int c = ((a)>(b)?(a):(b));
  printf("c=%d\n", c);
}


```

