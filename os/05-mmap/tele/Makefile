CC := gcc
CFLAGS = -std=c99 -O0
TARGET = teleCreate teleRecv teleSend

all: $(TARGET)

teleCreate: teleCreate.c
	$(CC) $(CFLAGS) $^ -o $@

teleSend: teleSend.c
	$(CC) $(CFLAGS) $^ -o $@

teleRecv: teleRecv.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe $(TARGET)
