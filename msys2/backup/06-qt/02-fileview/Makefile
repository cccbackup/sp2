CC := g++
IGLIB = -I/mingw64/include/QtWidgets/
CFLAGS= $(IGLIB) -Wall
LDLIBS= -L/mingw64/lib -lqtmain -lQt5Core.dll -lQt5Cored.dll -lQt5Guid.dll -lQt5Gui.dll -lQt5Qml.dll -lQt5Qmld.dll -lQt5Widgets.dll -lQt5Widgetsd.dll
TARGET= main

all: $(TARGET)

main: main.cpp fileview.cpp
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe