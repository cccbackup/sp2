CC := gcc
IGLIB = `pkg-config --cflags libpq`
CFLAGS= $(IGLIB) -g -Wall -std=gnu11 -O3
LDLIBS= `pkg-config --libs libpq`
TARGET= pqhello pqserver pqcreate pqquery pqmultirows pqprepare pqheader pqlisttab pqtransact

all: $(TARGET)

pqhello: pqhello.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

pqserver: pqserver.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

pqcreate: pqcreate.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqquery: pqquery.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqmultirows: pqmultirows.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqprepare: pqprepare.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqheader: pqheader.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqlisttab: pqlisttab.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

pqtransact: pqtransact.c
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS)

clean:
	rm -f $(TARGET) *.o *.exe

