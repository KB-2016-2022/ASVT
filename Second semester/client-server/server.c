#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>


int main()
{
    printf("START\n");
    int sock, listener;
    struct sockaddr_in addr;
    char buf[1024];
    int bytes_read;

    listener = socket(AF_INET, SOCK_STREAM, 0);
    if(listener < 0)
    {
        perror("socket");
        exit(1);
    }
    
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8080);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if(bind(listener, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        perror("bind");
        exit(2);
    }

    listen(listener, 1);
    
    while(1)
    {
        sock = accept(listener, NULL, NULL);
        if(sock < 0)
        {
            perror("accept");
            exit(3);
        }

        while(1)
        {
            memset(buf, 0, 1024);
            bytes_read = recv(sock, buf, 1, 0);
            printf("RECV\n");
            if(bytes_read <= 0) break;
            printf("%s\n", buf);
            printf("%d\n", bytes_read);
            // send(sock, buf, bytes_read, 0);
            
        }
    
        close(sock);
    }
    
    return 0;
}