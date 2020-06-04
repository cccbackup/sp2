#include "../net.h"

void readHeader(int client_fd, char *header) {
  int len = read(client_fd, header, TMAX);
  header[len] = '\0';
}

void parseHeader(char *header, char *path) {
  sscanf(header, "GET %s HTTP/", path);
}

void responseFile(int client_fd, char *path) {
  char text[TMAX], response[TMAX], fpath[SMAX];
  sprintf(fpath, "./web%s", path);
  printf("responseFile:fpath=%s\n", fpath);
  FILE *file = fopen(fpath, "r");
  int len;
  if (file == NULL) {
    strcpy(text, "<html><body><h1>File not Found!</h1></body></html>");
    len = strlen(text);
  } else {
    len = fread(text, 1, TMAX, file);
    text[len] = '\0';
  }
  sprintf(response, "HTTP/1.1 200 OK\r\n"
                    "Content-Type: text/html; charset=UTF-8\r\n"
                    "Content-Length: %d\r\n\r\n%s", len, text);
  write(client_fd, response, strlen(response));
}

int main(int argc, char *argv[]) {
	net_t net;
	net_init(&net, TCP, SERVER, argc, argv);
	net_bind(&net);
	net_listen(&net);
  while (1) {
    int client_fd = net_accept(&net);
    if (client_fd == -1) {
      printf("Can't accept");
      continue;
    }
    char header[TMAX], path[SMAX];
    readHeader(client_fd, header);
    printf("===========header=============\n%s\n", header);
    parseHeader(header, path);
    printf("path=%s\n", path);
    if (strstr(path, ".htm") != NULL) {
      printf("path contain .htm\n");
      responseFile(client_fd, path);
    } else {
      printf("not html => no response!\n");
    }
    sleep(1);
    close(client_fd);
  }
}
