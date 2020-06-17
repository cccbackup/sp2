#include "http.h"
#include "list.c"

int main(int argc, char *argv[]) {
    char head[PACKET_MAX];
    httpDownload("example.com", 80, "/index.html", head, "page/index.html");
    // httpDownload("localhost", 8080, "/page1.html", head, "page/page1.html");
}
