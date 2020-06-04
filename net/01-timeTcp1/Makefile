CC := gcc
CFLAGS = -std=c99 -O0
TARGET = server client

all: $(TARGET)

server: server.c
	$(CC) $(CFLAGS) $^ -o $@

client: client.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe $(TARGET)
