CC := gcc
CFLAGS = -std=c99 -O0
TARGET = helloWebServer headPrintServer htmlServer

all: $(TARGET)

helloWebServer: helloWebServer.c ../net.c
	$(CC) $(CFLAGS) $^ -o $@

headPrintServer: headPrintServer.c ../net.c
	$(CC) $(CFLAGS) $^ -o $@

htmlServer: htmlServer.c ../net.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe $(TARGET)
