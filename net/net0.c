#include "net.h"

int net_init(net_t *net, int type, int argc, char *argv[]) {
	memset(net, 0, sizeof(net_t));
	net->sock_fd = socket(AF_INET, SOCK_STREAM, 0);
	assert(net->sock_fd >=0);
	printf("port=%d sock_fd=%d\n", net->port, net->sock_fd);
	net->serv_addr.sin_family = AF_INET;
	net->serv_addr.sin_port = htons(PORT);
	printf("sin_port=%s\n", net->serv_addr.sin_port);
  if (type == CLIENT)
	  assert(inet_pton(AF_INET, "127.0.0.1", &net->serv_addr.sin_addr) > 0);
	else
	  net->serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
}

/*
	int listenfd = socket(AF_INET, SOCK_STREAM, 0);
  assert(listenfd >= 0);
	struct sockaddr_in serv_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(PORT);

*/

int net_connect(net_t *net) {
	printf("sock_fd=%d\n", net->sock_fd);
	int r = connect(net->sock_fd, (struct sockaddr *)&net->serv_addr, sizeof(net->serv_addr));
  printf("net_connect:r=%d\n", r);
	assert(r>0);
	return r;
}

int net_bind(net_t *net) {
	int r = bind(net->sock_fd, (struct sockaddr*)&net->serv_addr, sizeof(net->serv_addr));
	assert(r>=0);
	return r;
}

int net_listen(net_t *net) {
	int r = listen(net->sock_fd, 10); // 最多十個同時連線
	assert(r>=0);
	return r;
}

int net_accept(net_t *net) {
	int r = accept(net->sock_fd, (struct sockaddr*)NULL, NULL);
	assert(r>=0);
	return r;
}