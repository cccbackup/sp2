# 檔案與輸出入系統

Linux/UNIX 所使用的檔案輸出入是基於整數代號 (0,1,2, ....) 的，其中：

```
0 - 標準輸入 stdin  (STDIN_FILENO)
1 - 標準輸出 stdout (STDOUT_FILENO)
2 - 標準錯誤 stderr (STDERR_FILENO)
3 - 3 之後才是真正分配給檔案的
```

0, 1, 2 是開始執行 main 時都會預設分配給你的，若你用 open 打開檔案，會從 3 開始分配給你。

當你使用 open() 開檔時，系統會找到最小沒被使用的代號傳給你，所以如果你把 0, 1, 2 給 close 了，那麼之後 open 時就會取得最小沒被分配的 file descriptor 分配給你！

另外若用 dup(fd) 也是會將 fd 複製一份放到從最小沒被分配的 file descriptor 中。

但若用 dup2(fd1, fd2) 則是會把 fd1 複製一份放到 fd2 中，但是若 fd2 還開著，那就會先被關閉。

理解了這些，就可以看懂下列程式了！

1. [fecho1.c](fecho1.c)
2. [fecho2.c](fecho2.c)
