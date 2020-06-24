#include <pthread.h>
#include "../net.h"
#include "httpd.h"

void *serve(void *argu) {
  int client_fd = *(int*) argu;
  if (client_fd == -1) {
    printf("Can't accept");
    return NULL;
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
  return NULL;
}

int main(int argc, char *argv[]) {
  int port = (argc >= 2) ? atoi(argv[1]) : PORT;
	net_t net;
	net_init(&net, TCP, SERVER, port, NULL);
	net_bind(&net);
	net_listen(&net);
  printf("Server started at port: %d\n", net.port);
  while (1) {
    int client_fd = net_accept(&net);
    pthread_t thread1;
    pthread_create(&thread1, NULL, &serve, &client_fd);
  }
}
