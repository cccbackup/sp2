#include "../net.h"

int serv(int connfd) {
	while (1) {
		char command[SMAX];
    int len = read(connfd, command, SMAX);
		if (len < 0) break;
		command[len-1] = '\0'; // len-1 : 把 \n 去除
		fprintf(stderr, "command=%s len=%d\n", command, len);
		if (strncmp(command, "exit", 4)==0) break;
		char *tokens[SMAX];
		memset(tokens, 0, sizeof(tokens));
		int args = 0;
		char *p = strtok (command," \t");
		while ((p)) {
			fprintf(stderr, "%d:%s , ",args, p);
			tokens[args++] = p;
			p = strtok (NULL, " \t");
		}
		fprintf(stderr, "\n");
		if (fork() <= 0) {
			fprintf(stderr, "child:execvp():before\n");
			close(STDOUT_FILENO);
			dup2(connfd, STDOUT_FILENO);
			execvp(tokens[0], tokens);
			// exit(0);
		}
		int status = 0;
		pid_t wpid;
		wpid = wait(&status); // wait child finished!
		write(connfd, ENDTAG, strlen(ENDTAG));
		// sleep(1);
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
