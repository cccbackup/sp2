# Shared Memory


* [POSIX Shared Memory](http://logan.tw/posts/2018/01/07/posix-shared-memory/)


## shm1.c

```
guest@localhost:~/sp/code/c/07-linux/03-ipc/mmap$ gcc shm1.c -o shm1
guest@localhost:~/sp/code/c/07-linux/03-ipc/mmap$ ./shm1
Parent read: hello
Child read: hello
Child wrote: goodbye
After 1s, parent read: goodbye
```

程式

* https://github.com/DevNaga/gists/blob/master/mmap.c
* https://github.com/DevNaga/gists/blob/master/mmap_comm.c
* https://github.com/DevNaga/gists/blob/master/mmap_sync.c