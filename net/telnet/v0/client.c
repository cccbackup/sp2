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
	char line[SMAX], sendBuf[SMAX], recvBuff[SMAX], op[SMAX];
	int n;
	while (1) {
    fgets(line, SMAX, stdin);
    write(sockfd, line, strlen(line));

    sscanf(line, "%s", op);
    if (strcmp(op, "exit")==0) break;
    sleep(1);
    
    int n = read(sockfd, recvBuff, SMAX-1);
    if (n < 0) break;
		recvBuff[n] = 0;
		fputs(recvBuff, stdout);
	}
  close(sockfd);
	return 0;
}
