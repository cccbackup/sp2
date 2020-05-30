#include "net.h"

int main()
{
  int one = 1, client_fd;
  int port = PORT;
  struct sockaddr_in cli_addr, svr_addr={ .sin_family = AF_INET, .sin_addr.s_addr = INADDR_ANY, .sin_port = htons(port)};
  socklen_t sin_len = sizeof(cli_addr);

  int sock = socket(AF_INET, SOCK_STREAM, 0); 
  setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(int));
  bind(sock, (struct sockaddr *) &svr_addr, sizeof(svr_addr));
  listen(sock, 5);
  while (1) {
    printf("accept():\n");
    client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);
    printf("got connection:\nclient_fd=%d\n", client_fd);
    char cwd[SMAX], line[SMAX], response[SMAX];
    write(client_fd, cwd, strlen(cwd));
    int len = read(client_fd, line, SMAX);
    sprintf(response, "> %s\n", line);
    write(client_fd, response, strlen(response));
    close(client_fd);
  }
}
