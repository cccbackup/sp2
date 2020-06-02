#include "../net.h"
 
char response[] = "HTTP/1.1 200 OK\r\n"
"Content-Type: text/plain; charset=UTF-8\r\n"
"Content-Length: 14\r\n\r\n"
"Hello World!\r\n";

int main() {
  struct sockaddr_in svr_addr;
	memset(&svr_addr, 0, sizeof(svr_addr));
  svr_addr.sin_family = AF_INET;
  svr_addr.sin_addr.s_addr = INADDR_ANY;
  svr_addr.sin_port = htons(PORT);
 
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  assert(sock >= 0);
  int one = 1;
  assert(setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(int)) >= 0);
  assert(bind(sock, (struct sockaddr *) &svr_addr, sizeof(svr_addr)) >= 0);
  assert(listen(sock, 10) >= 0);
  int count=0;
  while (1) {
    struct sockaddr_in cli_addr;
    socklen_t sin_len = sizeof(cli_addr);
    int client_fd = accept(sock, (struct sockaddr *) &cli_addr, &sin_len);
    printf("%d:got connection, client_fd=%d\n", count++, client_fd);
    int n = write(client_fd, response, strlen(response));
    fsync(client_fd);
    assert(n > 0);
    sleep(1);
    close(client_fd);
  }
}