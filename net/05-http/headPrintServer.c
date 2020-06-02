#include "../net.h"
 
char response[] = "HTTP/1.1 200 OK\r\n"
"Content-Type: text/plain; charset=UTF-8\r\n"
"Content-Length: 14\r\n\r\n"
"Hello World!\r\n";

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
    // == 取得表頭並印出來 ==
    char header[TMAX];
    int len = read(client_fd, header, TMAX);
    header[len] = '\0';
    printf("===========header=============\n%s\n", header);
    write(client_fd, response, sizeof(response) - 1); /*-1:'\0'*/
    close(client_fd);
  }
}