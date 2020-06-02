#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>
#include <time.h>
#include <assert.h>
#include <sys/wait.h>
#include <sys/errno.h>

#define PORT 8080
#define SMAX 256
#define TMAX 65536
#define ENDTAG "<__end__>"

enum { CLIENT, SERVER };
enum { TCP, UDP };

typedef struct _net_t {
  char *serv_ip;
  struct sockaddr_in serv_addr;
  int sock_fd, port, side, protocol;
} net_t;

int net_init(net_t *net, int protocol, int type, int argc, char *argv[]);
int net_connect(net_t *net);
int net_bind(net_t *net);
int net_listen(net_t *net);
int net_accept(net_t *net);
