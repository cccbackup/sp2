#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>
 
char response[] = "HTTP/1.1 200 OK\r\n"
"Content-Type: text/plain; charset=UTF-8\r\n"
"Content-Length: 14\r\n\r\n"
"Hello World!\r\n";

int main()
{
  int one = 1, client_fd;
  int port = 8080;
  struct sockaddr_in cli_addr, svr_addr={ .sin_family = AF_INET, .sin_addr.s_addr = INADDR_ANY, .sin_port = htons(port)};
  socklen_t sin_len = sizeof(cli_addr);

  // svr_addr.sin_family = AF_INET;
  // svr_addr.sin_addr.s_addr = INADDR_ANY;
  // svr_addr.sin_port = htons(port);
 
  int sock = socket(AF_INET, SOCK_STREAM, 0); 
  setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(int));
  bind(sock, (struct sockaddr *) &svr_addr, sizeof(svr_addr));
  listen(sock, 5);
  while (1) {
    client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);
    printf("got connection:\nclient_fd=%d\n", client_fd);
    write(client_fd, response, sizeof(response) - 1); /*-1:'\0'*/
    close(client_fd);
  }
}