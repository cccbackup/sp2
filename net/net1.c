#include "net.h"

int net_init(net_t *net, int type, int argc, char *argv[]) {
	net->type = type;
	net->port = (argc >= 2) ? atoi(argv[1]) : PORT;
	net->serv_ip = (argc >= 3) ? argv[2] : "127.0.0.1";
	net->sock_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (net->sock_fd < 0) return -1;
	memset(&net->serv_addr, 0, sizeof(net->serv_addr));
	net->serv_addr.sin_family = AF_INET;
	net->serv_addr.sin_addr.s_addr = (net->type == SERVER) ? htonl(INADDR_ANY) : inet_addr(net->serv_ip);
	net->serv_addr.sin_port = htons(net->port);
  return 0;
}

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