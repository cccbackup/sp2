CC := gcc
IGLIB = `pkg-config --cflags gtk+-3.0`
CFLAGS= $(IGLIB) -g -Wall -std=gnu11 -O3
LDLIBS= `pkg-config --libs gtk+-3.0`
TARGET= hellogtk

all: $(TARGET)

hellogtk: hellogtk.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

dialogtk: dialogtk.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe
