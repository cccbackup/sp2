CC = gcc
CFLAGS = -Wall -std=gnu99
TARGET = cc vm objdump
all: $(TARGET)

cc: c6.c
	$(CC) -D__CC__ $(CFLAGS) -o $@ $< $(LDFLAGS)

vm: c6.c
	$(CC) -D__VM__ $(CFLAGS) -o $@ $< $(LDFLAGS)

objdump: c6.c
	$(CC) -D__OBJDUMP__ $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	$(RM) $(TARGET)

wclean:
	del *.exe
