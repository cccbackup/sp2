#include "../net.h"

int serv(int connfd) {
	close(STDOUT_FILENO);
	dup2(connfd, STDOUT_FILENO);
	while (1) {
		char command[SMAX], fullcmd[SMAX];
    int len = read(connfd, command, SMAX);
		if (len <= 0) break;
		command[len-1] = '\0'; // len-1 : 把 \n 去除
		fprintf(stderr, "command=%s len=%d\n", command, len);
		if (strncmp(command, "exit", 4)==0) break;
		char hint[] = "user@telnet ";
		write(connfd, hint, strlen(hint));
		system("pwd");
		sprintf(fullcmd, "%s;echo path=$PATH", command);
		system(fullcmd);
	}
	close(connfd);
	exit(0);
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
		if (fork() <= 0) {
			serv(connfd); // child:serv()
		}
		// sleep(1);
	}
}
