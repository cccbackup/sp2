CC := gcc
IGLIB = -I /mingw64/include/plplot
CFLAGS= $(IGLIB) -g -Wall -std=gnu11 -O3
LDLIBS= -lplplot
TARGET= plplot1 # mathglGif

all: $(TARGET)

plplot1: plplot1.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe
