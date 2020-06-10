#include "http.h"

int httpDownload(char *host, int port, char *path, char *head, char *file) {
    net_t net;
    net_init(&net, TCP, CLIENT, port, host);
    if (net_connect(&net) < 0) {
        printf("net_connect: %s:%d%s fail!\n", host, port, path);
        return -1;
    }
    char request[PACKET_MAX], response[PACKET_MAX]; // 請求 與 回應訊息
    FILE *fp = fopen(file, "wb");
    snprintf(request, PACKET_MAX, "GET %s HTTP/1.1\r\nHost: %s\r\n\r\n\r\n", path, host); //組裝請求訊息
    if (send(net.sock_fd, request, strlen(request), 0) < 0) // 發送請求
        errExit("Send");

    // 接收回應
    int contentSize = 0, contentLength = -1;
    for (int i=0; ; i++) {
        // recv 函數請參考: http://pubs.opengroup.org/onlinepubs/000095399/functions/recv.html
        memset(response, 0, sizeof(response));
        int packetLen = recv(net.sock_fd, response, PACKET_MAX, MSG_WAITALL); // MSG_WAITALL 會等待全部完成
        // printf("packetLen=%d\n", packetLen);
        if (i==0) {
            // 取得 http header
            char *headEnd = strstr(response, "\r\n\r\n");
            strncpy(head, response, headEnd-response);
            head[headEnd-response] = '\0';
            // printf("head=%s\n", head);
            char *bodyStart = headEnd + 4;
            int headLen = (bodyStart - response);
            int len = packetLen - headLen;
            contentSize += len;
            // 取得 Content-Length 欄位
            char *p = strstr(response, "Content-Length:");
            if (p) {
                sscanf(p, "Content-Length:%d", &contentLength);
                // printf("contentLength=%d\n", contentLength);
            } else {
                errExit("No Content-Length Found!"); 
            }
            fwrite(bodyStart, 1, len, fp);
        } else {
            contentSize += packetLen;
            fwrite(response, 1, packetLen, fp);
        }
        if (packetLen <= 0) { // 沒有任何訊息了
            // printf("No more message!\n");
            break;
        } else if (contentSize >= contentLength) { // 取得內容長度已經大於 Content-Length
            // printf("Content All Received!");
            break;
        }
        // printf("----------\nResponse:\n----------\n%s\n", response);
    }
    net_close(&net);
    fclose(fp);
    printf("http://%s:%d%s downloaded!\n", host, port, path);
    return 0;
}

void errExit(char *reason) {
    char *buff = reason ? reason : strerror(errno);
    printf("Error: %s", buff);
    exit(EXIT_FAILURE);
}
