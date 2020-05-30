// Write CPP code here 
#include <netdb.h> 
#include <stdio.h> 		
#include <stdlib.h> 
#include <string.h> 
#include <sys/socket.h> 

#define MAX 100
#define PORT 8080 
#define SA struct sockaddr 

void recvFile(int sockfd) 
{ 
	char buff[MAX]; 	// to store message from client
	
	FILE *fp;
	fp=fopen("received.txt","w"); // stores the file content in recieved.txt in the program directory
	
	if( fp == NULL ){
		printf("Error IN Opening File ");
		return ;
	}
	
	while( read(sockfd,buff,MAX) > 0 )
		fprintf(fp,"%s",buff);
	
	printf("File received successfully !! \n");
	printf("New File created is received.txt !! \n");

} 

int main() 
{ 
	int sockfd, connfd; 
	struct sockaddr_in servaddr, cli; 

	// socket create and varification 
	sockfd = socket(AF_INET, SOCK_STREAM, 0); 
	if (sockfd == -1) { 
		printf("socket creation failed...\n"); 
		exit(0); 
	} 
	else
		printf("Socket successfully created..\n"); 
	
	bzero(&servaddr, sizeof(servaddr)); 

	// assign IP, PORT 
	servaddr.sin_family = AF_INET; 
	servaddr.sin_addr.s_addr = inet_addr("127.0.0.1"); 
	servaddr.sin_port = htons(PORT); 

	// connect the client socket to server socket 
	if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr)) != 0) { 
		printf("connection with the server failed...\n"); 
		exit(0); 
	} 
	else
		printf("connected to the server..\n"); 

	// function for sending File 
	recvFile(sockfd); 

	// close the socket 
	close(sockfd); 
} 
