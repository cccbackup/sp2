CC := gcc
CFLAGS = -std=c99 -O0
TARGET = compiler

all: $(TARGET)

$(TARGET): ir.c lexer.c compiler.c main.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe $(TARGET)
