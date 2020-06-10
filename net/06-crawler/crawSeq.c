#include "http.h"
#include "list.c"

int main(int argc, char *argv[]) {
    char head[PACKET_MAX];
    for (int i=0; i<LIST_SIZE; i++) {
        char file[100];
        sprintf(file, "page/%s", list[i]);
        // httpDownload("misavo.com", 80, list[i], head, file);
        httpDownload("localhost", 8080, list[i], head, file);
    }
}
