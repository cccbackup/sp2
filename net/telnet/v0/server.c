#include "../net.h"

int serv(int connfd) {
	char readBuf[SMAX], sendBuff[SMAX];
	while (1) {
    int len = read(connfd, readBuf, SMAX);
		if (len < 0) break;
		readBuf[len-1] = '\0'; // len-1 : 把 \n 去除
		printf("readBuf=%s len=%d\n", readBuf, len);
		snprintf(sendBuff, sizeof(sendBuff), "> %s\n", readBuf);
		assert(write(connfd, sendBuff, strlen(sendBuff)) >=0);
		if (strcmp(readBuf, "exit")==0) break;
	}
	close(connfd);
	// sleep(1);
}

int main(int argc, char *argv[]) {
	int listenfd = socket(AF_INET, SOCK_STREAM, 0);
  assert(listenfd >= 0);
	struct sockaddr_in serv_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(PORT);

	assert(bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) >= 0);
	assert(listen(listenfd, 10) >= 0); // 最多十個同時連線
	while(1) {
		int connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
		assert(connfd >= 0);
		serv(connfd);
	}
}
