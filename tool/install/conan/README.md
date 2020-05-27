# conan -- C/C++ 跨平台開發套件安裝器

* [C++ Package Management With Conan: Introduction](https://medium.com/@ilyas.hamadouche/c-package-management-with-conan-introduction-8c7bd928c009)


## 使用

```
$ pip3 install conan
$ conan --help
$ conan search sqlite3* --remote=conan-center
Existing package recipes:
sqlite3/3.14.1@bincrafters/stable
sqlite3/3.20.1@bincrafters/stable
sqlite3/3.21.0@bincrafters/stable
sqlite3/3.25.3@bincrafters/stable
sqlite3/3.26.0@bincrafters/stable
sqlite3/3.27.1@bincrafters/stable
sqlite3/3.27.2@bincrafters/stable
sqlite3/3.28.0@bincrafters/stable
sqlite3/3.29.0
sqlite3/3.29.0@bincrafters/stable

```

然後

```
$ mkdir build
$ cd build
$ conan install ..
$ cmake .. -G Ninja
$ ninja
$ cd bin
$ ./testConan
Opened database successfully
```

