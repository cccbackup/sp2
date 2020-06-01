#include "../net.h"

int serv(int connfd) {
	close(STDOUT_FILENO);                    // 關閉 stdout
	dup2(connfd, STDOUT_FILENO);             // 用 connfd 取代 stdout
	while (1) {
		char cmd[SMAX];
    int len = read(connfd, cmd, SMAX);     // 讀入 client 傳來的命令
		if (len <= 0) break;                   // 若沒讀到就結束了！
		strtok(cmd, "\n");                     // 把 \n 去除
		fprintf(stderr, "cmd=%s\n", cmd);      // 印出命令方便觀察
		if (strncmp(cmd, "exit", 4)==0) break; // 若是 exit 則離開！
		system(cmd);                           // 執行該命令 (由於 connfd 取代了 stdout，所以命令的輸出會直接傳回給 client)
		write(connfd, "\n", 1); // 至少要回應 1byte ，否則 client 會讀不到而導致當掉
	}
	close(connfd);            // 關閉連線
	exit(0);                  // 結束此子行程
}

int main(int argc, char *argv[]) {
	// 執行方式 ./server port
	int port = (argc >= 2) ? atoi(argv[1]) : PORT;  // 沒指定 port 就是連預設的 PORT
	// socket (server) 基本參數設定
	int listenfd = socket(AF_INET, SOCK_STREAM, 0);
  assert(listenfd >= 0);
	struct sockaddr_in serv_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(port);

	assert(bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) >= 0); // 佔領 port
	assert(listen(listenfd, 10) >= 0); // 開始傾聽，最多十個同時連線
	while(1) { // 主迴圈：等待 client 連進來，然後啟動 serv 為其服務
		int connfd = accept(listenfd, (struct sockaddr*)NULL, NULL); // 等待連線進來
		assert(connfd >= 0);
		if (fork() <= 0) { // 創建新的行程去服務該連線。
			serv(connfd);    // 子行程開始執行 serv()
		}
	}
}
