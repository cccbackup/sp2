#include "../net.h"

int main(int argc, char *argv[]) {
	net_t net;
  net_init(&net, CLIENT, argc, argv);
	net_connect(&net);
	char recvBuff[1024];
	int n = read(net.sock_fd, recvBuff, sizeof(recvBuff)-1);
	recvBuff[n] = 0;
	fputs(recvBuff, stdout);
}
