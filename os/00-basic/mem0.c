#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int counter;

int main(int argc, char *argv[]) {
    int *p = malloc(sizeof(int));
    printf("(%d) addr pointed to by p: %p\n", (int) getpid(), p);
    *p = 0;
    for (int i=0; i<5; i++) {
	    sleep(1);
	    *p = *p + 1;
	    printf("%d:(%d) value of p: %d\n", i, getpid(), *p);
    }
    return 0;
}

