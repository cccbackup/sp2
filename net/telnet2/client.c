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
	char line[SMAX], sendBuf[SMAX], recvBuff[TMAX], op[SMAX], path[SMAX]="\0", cmd[SMAX];
	int n;
  printf("connect to server %s success!\n", IP);
	while (1) {
    printf("$ ");
    fgets(cmd, SMAX, stdin);
		if (strlen(path)>0)
		  sprintf(line, "cd %s;%s", path, cmd);
		else
		  sprintf(line, "%s", cmd);
    write(sockfd, line, strlen(line));

    sscanf(cmd, "%s", op);
    if (strncmp(op, "exit", 4)==0) break;
    sleep(1);

    int n = read(sockfd, recvBuff, TMAX-1);
		assert(n > 0);
		recvBuff[n-1] = '\0'; // 把最後一個 \n 去掉!
		char *p = recvBuff + n - 1;
		while ((*p != '\n')) p--;
		*p = '\0';
		strcpy(path, p+1);
 		puts(recvBuff);
		printf("\n");
	}
  close(sockfd);
	return 0;
}
