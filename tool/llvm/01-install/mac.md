# 在 mac 上安裝 llvm

## 安裝前置工具

```
  504  brew upgrade cmake
  505  brew upgrade gcc
  506  make --version
  507  zlib
  508  zlib --version
  509  brew install zlib
  510  zlib --version
```

## 取得 llvm 專案

```
$ git clone https://github.com/llvm/llvm-project.git
```

## 編譯建置

```
$ cd llvm-project
$ mkdir build
$ cd build
$ cmake -G Ninja ../llvm
$ cmake --build .
```
