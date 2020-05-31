# Memory Check

* https://github.com/DevNaga/linux-systems-programming-with-c/blob/master/valgrind.md

```
$ sudo apt-get install valgrind
$ gcc -g leak.c -o leak
$ valgrind -v leak
```




$ valgrind -v --leak-check=full --leak-resolution=high ./leak_program
