CC := gcc
CFLAGS = -std=c99 -O0
TARGET = timeCreate timeProvider timeShower

all: $(TARGET)

timeCreate: timeCreate.c
	$(CC) $(CFLAGS) $^ -o $@

timeProvider: timeProvider.c
	$(CC) $(CFLAGS) $^ -o $@

timeShower: timeShower.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f *.o *.exe $(TARGET)
