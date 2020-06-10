#ifndef __HTTP_H__
#define __HTTP_H__

#include "../net.h"

#define PACKET_MAX 0xfff

void errExit(char *reason);
int httpDownload(char *host, int port, char *path, char *head, char *file);

#endif