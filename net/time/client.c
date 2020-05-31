#include "../net.h"

int main(int argc, char *argv[]) {
	struct sockaddr_in serv_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	assert(inet_pton(AF_INET, IP, &serv_addr.sin_addr) > 0);

	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	assert(sockfd >=0);
	assert(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) >= 0);
	char recvBuff[1024];
	int n;
	while ((n = read(sockfd, recvBuff, sizeof(recvBuff)-1)) > 0) {
		recvBuff[n] = 0;
		fputs(recvBuff, stdout);
	}
	return 0;
}