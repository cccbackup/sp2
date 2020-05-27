CC := g++
IGLIB = -I/mingw64/include/ -I/mingw64/include/wx-3.0/ -I/mingw64/include/wx-3.0/wx/
CFLAGS= $(IGLIB) -Wall
LDLIBS= -L/mingw64/lib -lwx_baseu-3.0
TARGET= hellowx

all: $(TARGET)

hellowx: hellowx.cpp
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe

