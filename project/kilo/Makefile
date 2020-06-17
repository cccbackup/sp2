CC ?= gcc
CFLAGS = -O2 -pipe
CFLAGS += -w -pedantic -std=c99 -Wall

TARGET = kilo

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	$(RM) $(TARGET)
