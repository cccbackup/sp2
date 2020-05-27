CC := g++
IGLIB = -I/mingw64/include/ -I/mingw64/include/QtWidgets/
CFLAGS= $(IGLIB) -Wall
# LDLIBS= -L/mingw64/lib -lqtmain -lQt5Core.dll -lQt5Cored.dll -lQt5Guid.dll -lQt5Gui.dll -lQt5Qml.dll -lQt5Qmld.dll -lQt5Widgets.dll -lQt5Widgetsd.dll
LDLIBS= -L/mingw64/lib -lqtmain -lQt5Core.dll -lQt5Gui.dll -lQt5Qml.dll -lQt5Widgets.dll # -lQt5PlatformSupport.dll
TARGET= qtapp1

all: $(TARGET)

qtapp1: qtapp1.cpp MainWindow.cpp
	$(CC) $^ -o $@ $(CFLAGS) $(LDLIBS) 

clean:
	rm -f $(TARGET) *.o *.exe

