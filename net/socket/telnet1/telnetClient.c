#include "net.h"

int main() 
{
  int sockfd; 
  struct sockaddr_in servaddr={ .sin_family = AF_INET, .sin_addr.s_addr = inet_addr("127.0.0.1"), .sin_port = htons(PORT)}; 
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  printf("sockfd=%d\n", sockfd); 
  bzero(&servaddr, sizeof(servaddr)); 
  if (connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr))!=0) {
    printf("connect fail!\n");
    exit(1);
  } else {
    printf("connect success!\n");
  }
  while (1) {
    char line[SMAX];
    fgets(line, SMAX-1, stdin);
    printf("line=%s\n", line);
    write(sockfd, line, strlen(line));
    if (strcmp(line, "exit")==0) break;
  }
  printf("bye!\n");
  // func(sockfd); 
  close(sockfd); 
}

