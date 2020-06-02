CC := gcc
IGLIB = 
CFLAGS= $(IGLIB) -g -Wall -std=gnu11 -O3
LDLIBS= -lmgl
TARGET= mathgl1 # mathglGif

all: $(TARGET)

mathgl1: mathgl1.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

mathglGif: mathglGif.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe
