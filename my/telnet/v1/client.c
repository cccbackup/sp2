#include "../net.h"

int main(int argc, char *argv[]) {
	// 執行方式 ./client ip port
	char *serverIp = (argc >= 2) ? argv[1] : LOCALHOST; // 沒指定 ip 就是連 127.0.0.1
	int port = (argc >= 3) ? atoi(argv[2]) : PORT;      // 沒指定 port 就是連預設的 PORT
	// 以下為 socket (client) 基本參數設定
	struct sockaddr_in serv_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(port);
	assert(inet_pton(AF_INET, serverIp, &serv_addr.sin_addr) > 0);
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);
	assert(sockfd >=0);
  // 連到 server
	assert(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) >= 0);
	char cmd[SMAX], recvBuff[TMAX], op[SMAX];
  printf("connect to server %s success!\n", serverIp);
	while (1) { // 主迴圈：等待使用者輸入命令，然後發送請求給伺服器，並接收回應。
    printf("%s $ ", serverIp);              // 印出提示訊息
    fgets(cmd, SMAX, stdin);                // 等待使用者輸入命令！
    write(sockfd, cmd, strlen(cmd));        // 將命令傳給 server

    sscanf(cmd, "%s", op);                  // 取得指令
    if (strncmp(op, "exit", 4)==0) break;   // 若是 exit 則離開

    sleep(1);                               // 休息一秒鐘
    int n = read(sockfd, recvBuff, TMAX-1); // 讀取 server 傳回來的訊息
		assert(n > 0);
		recvBuff[n-1] = '\0'; // 字串結尾，把最後一個 \n 去掉!
 		puts(recvBuff);                         // 顯示回應訊息
	}
  close(sockfd);
	return 0;
}
