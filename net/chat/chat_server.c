#include <netdb.h> 1
#include <netinet/in.h> 	
#include <stdlib.h> 		// for memory allocation and deallocation i.e Socket , open close
#include <stdio.h> 			// for basic file read and write i.e user input and display
#include <string.h> 		// for bzero() , strncmp ()
#include <sys/socket.h> 
#include <sys/types.h> 

#define MAX 80 
#define PORT 8080 
#define SA struct sockaddr 			// used for typecasting when bindinging

// Function designed for chat between client and server. 
void chatFunc(int connfd) 
{ 
	char buff[MAX]; 	// to store message from client
	int n; 				// for traversing buffer buff
	
	// infinite loop for chat 
	for (;;) { 
	
		bzero(buff, MAX); 		// empties the buffer

		// read the message from client and copy it in buffer 
		read(connfd, buff, sizeof(buff)); 
		
		// print buffer which contains the client contents 
		printf("From client: %s\t To client : ", buff); 
		
		bzero(buff, MAX); 		// empties the buffer
		n = 0; 					
		
		// copy server message in the buffer 
		while ((buff[n++] = getchar()) != '\n') ; 

		// and send that buffer to client 
		write(connfd, buff, sizeof(buff)); 	// read from standard input until enter('\n') is encountered.

		// if msg contains "Exit" then server exit and chat ended. 
		if (strncmp("exit", buff, 4) == 0) { 
			printf("Server Exit...\n"); 
			break; 
		} 
	} 
} 

// Driver function 
int main() 
{ 
	int sockfd, connfd, len; 				// create socket file descriptor 
	struct sockaddr_in servaddr, cli; 		// create structure object of sockaddr_in for client and server

	// socket create and verification 
	sockfd = socket(AF_INET, SOCK_STREAM, 0); 			// creating a TCP socket ( SOCK_STREAM )
	
	if (sockfd == -1) { 
		printf("Socket creation failed...\n"); 
		exit(0); 
	} 
	else
		printf("Socket successfully created..\n"); 
	
	// empty the 
	bzero(&servaddr, sizeof(servaddr)); 

	// assign IP, PORT 
	servaddr.sin_family = AF_INET;					// specifies address family with IPv4 Protocol 
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY); 	// binds to any address
	servaddr.sin_port = htons(PORT); 				// binds to PORT specified

	// Binding newly created socket to given IP and verification 
	if ((bind(sockfd, (SA*)&servaddr, sizeof(servaddr))) != 0) { 
		printf("socket bind failed...\n"); 
		exit(0); 
	} 
	else
		printf("Socket successfully binded..\n"); 

	// Now server is ready to listen and verification 
	if ((listen(sockfd, 5)) != 0) { 
		printf("Listen failed...\n"); 
		exit(0); 
	} 
	else
		printf("Server listening..\n"); 
	
	len = sizeof(cli); 

	// Accept the data packet from client and verification 
	connfd = accept(sockfd, (SA*)&cli, &len); 	// accepts connection from socket
	
	if (connfd < 0) { 
		printf("server acccept failed...\n"); 
		exit(0); 
	} 
	else
		printf("server acccept the client...\n"); 

	// Function for chatting between client and server 
	chatFunc(connfd); 

	// After chatting close the socket 
	close(sockfd); 
} 
