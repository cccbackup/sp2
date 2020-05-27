#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int counter = 0;

int main(int argc, char *argv[]) {
    printf("(%d) addr of counter: %p\n", (int) getpid(), &counter);
    for (int i=0; i<5; i++) {
	    sleep(1);
	    counter = counter + 1;
	    printf("%d:(%d) value of counter: %d\n", i, getpid(), counter);
    }
    return 0;
}

