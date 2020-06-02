# mmap -- 


* [POSIX Shared Memory](http://logan.tw/posts/2018/01/07/posix-shared-memory/)

## 執行結果

```
guest@localhost:~/sp/code/c/10-os2linux/05-memory/mmap$ gcc -o sender sender.c -lrt

guest@localhost:~/sp/code/c/10-os2linux/05-memory/mmap$ gcc -o receiver receiver.c -lrt

guest@localhost:~/sp/code/c/10-os2linux/05-memory/mmap$ ./sender
sender mapped address: 0x7f9ea37ef000

guest@localhost:~/sp/code/c/10-os2linux/05-memory/mmap$ ./receiver
receiver mapped address: 0x7fdfb13c1000
0
1
2

guest@localhost:~/sp/code/c/10-os2linux/05-memory/mmap$ ls -l /dev/shm/shmem-example
ls: cannot access '/dev/shm/shmem-example': No such file or directory
```
