#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    char *msg = argv[1];

    for (int i=0; i<5; i++) {
        printf("%d:%s\n", i, msg);
        sleep(1);
    }
    return 0;
}
