#include "../net.h"

int main(int argc, char *argv[]) {
  int port = (argc >= 2) ? atoi(argv[1]) : PORT;
  char *host = (argc >= 3) ? argv[2] : "localhost";
  net_t net;
  net_init(&net, TCP, CLIENT, port, host);
  net_connect(&net);
  char cmd[SMAX], recvBuff[TMAX], op[SMAX], line[SMAX], path[SMAX];
  printf("connect to server %s success!\n", net.serv_ip);
  while (1) { // 主迴圈：等待使用者輸入命令，然後發送請求給伺服器，並接收回應。
    printf("%s %s\n$ ", net.serv_ip, path);              // 印出提示訊息
    fgets(cmd, SMAX, stdin);                // 等待使用者輸入命令！
    if (strlen(path)>0)
      sprintf(line, "cd %s;%s", path, cmd);
    else
      sprintf(line, "%s", cmd);
    write(net.sock_fd, line, strlen(line));       // 將命令傳給 server

    sscanf(cmd, "%s", op);                   // 取得指令
    if (strncmp(op, "exit", 4)==0) break;    // 若是 exit 則離開
    sleep(1);                                // 休息一秒鐘

    int n = read(net.sock_fd, recvBuff, TMAX-1);  // 讀取 server 傳回來的訊息
    assert(n > 0);
    recvBuff[n-1] = '\0';                    // 字串結尾，把最後一個 \n 去掉!
    char *p = recvBuff + n - 1;              // 準備取出最後的 path
    while ((*p != '\n')) p--;                // 往前找到 \n
    *p = '\0';                               // 將 \n 改為 \0
    strcpy(path, p+1);                       // 取得 path
    printf("path=%s\n", path);
    puts(recvBuff);                         // 顯示回應訊息
    // printf("\n");
  }
  close(net.sock_fd);
  return 0;
}
