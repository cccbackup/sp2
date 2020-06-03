#include "../net.h"

int main(int argc, char *argv[]) {
  int port = (argc >= 2) ? atoi(argv[1]) : PORT;
  char *host = (argc >= 3) ? argv[2] : "localhost";
  net_t net;
  net_init(&net, TCP, CLIENT, port, host);
  net_connect(&net);
  char recvBuff[1024];
  int n = read(net.sock_fd, recvBuff, sizeof(recvBuff)-1);
  recvBuff[n] = 0;
  fputs(recvBuff, stdout);
  close(net.sock_fd);
}
