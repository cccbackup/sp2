#include "http.h"
#include "list.c"

int main(int argc, char *argv[]) {
    int port = (argc >= 2) ? atoi(argv[1]) : PORT;
    char *host = (argc >= 3) ? argv[2] : "localhost";
    char head[PACKET_MAX];
    for (int i=0; i<LIST_SIZE; i++) {
        char file[100];
        sprintf(file, "page/%s", list[i]);
        // httpDownload("misavo.com", 80, list[i], head, file);
        httpDownload(host, port, list[i], head, file);
    }
}
