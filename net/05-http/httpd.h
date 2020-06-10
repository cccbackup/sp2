#ifndef __HTTPD_H__
#define __HTTPD_H__

#include "../net.h"

void readHeader(int client_fd, char *header);
void parseHeader(char *header, char *path);
void responseFile(int client_fd, char *path);

#endif
