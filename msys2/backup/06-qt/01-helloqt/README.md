# qtapp1

* 來源 -- https://github.com/ArthurSonzogni/cmake-Qt5-example

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/12-qt/01-helloqt
$ make
g++ qtapp1.cpp MainWindow.cpp -o qtapp1 -I/mingw64/include/QtWidgets/ -Wall -L/mingw64/lib -lqtmain -lQt5Core.dll -lQt5Cored.dll -lQt5Guid.dll -lQt5Gui.dll -lQt5Qml.dll -lQt5Qmld.dll -lQt5Widgets.dll -lQt5Widgetsd.dll

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/12-qt/01-helloqt
$ ./qtapp1
```

然後就成功地看到一個小視窗出現了！

## 學習點


首先從引用檔裏面看到有使用 QWidget, QApplication, QMainWindow ... 等。

為了找出到底 MSYS2 裏應該連結那些 library，我們使用了 find 指令:

```
$ find /mingw64/include/ -name "QApplication"
/mingw64/include/QtWidgets/QApplication

```

於是我們推斷應該使用下列 Include

-I/mingw64/include/QtWidgets/

然後我們去 c:/msys64/mingw64/lib 底下看到有

```
libQt5Qmld.dll.a
libQt5Widgets.dll.a
```

等檔案，因此推斷應該引入這些函式庫。

加上網路搜尋到這篇

* https://retifrav.github.io/blog/2018/02/17/build-qt-statically/#windows-1

發現似乎應該引用 

 -lQt5Core.dll -lQt5Cored.dll -lQt5Guid.dll -lQt5Gui.dll -lQt5Qml.dll -lQt5Qmld.dll 

結果終於成功了！
