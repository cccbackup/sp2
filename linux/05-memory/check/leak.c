#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *var;

    var = malloc(sizeof(int));
    *var = 2;

    printf("%d\n", *var);
    return 0;
}
