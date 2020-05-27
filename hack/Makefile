CC := gcc
CFLAGS = -std=c99 -O0
TARGET = asm vm

all: $(TARGET)

asm: asm.c c6.c
	$(CC) $(CFLAGS) $^ -o $@

vm: vm.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe
