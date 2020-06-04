#include "../net.h"

int main(int argc, char *argv[]) {
  int port = (argc >= 2) ? atoi(argv[1]) : PORT;
  net_t net;
  net_init(&net, TCP, SERVER, port, NULL);
  net_bind(&net);
  net_listen(&net);
  while(1) {
    int connfd = net_accept(&net);
    time_t ticks = time(NULL);
    char sendBuff[1024];
    snprintf(sendBuff, sizeof(sendBuff), "%.24s\r\n", ctime(&ticks));
    write(connfd, sendBuff, strlen(sendBuff));
    close(connfd);
    sleep(1);
  }
}
