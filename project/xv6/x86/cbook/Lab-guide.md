# Lab-Guide


## Makefile 建置

```
...
dd if=/dev/zero of=xv6.img count=10000
10000+0 records in
10000+0 records out
5120000 bytes (5.1 MB, 4.9 MiB) copied, 0.0268772 s, 190 MB/s     // 前半部
dd if=bootblock of=xv6.img conv=notrunc
1+0 records in
1+0 records out
512 bytes copied, 0.000309389 s, 1.7 MB/s                         // 啟動磁區
dd if=kernel of=xv6.img seek=1 conv=notrunc                       // 核心區域
349+1 records in
349+1 records out
179024 bytes (179 kB, 175 KiB) copied, 0.00164986 s, 109 MB/s
```

## 習題指引 JOS makefile

The JOS GNUmakefile includes a number of phony targets for running JOS in various ways. All of these targets configure QEMU to listen for GDB connections (the *-gdb targets also wait for this connection). To start once QEMU is running, simply run gdb from your lab directory. We provide a .gdbinit file that automatically points GDB at QEMU, loads the kernel symbol file, and switches between 16-bit and 32-bit mode. Exiting GDB will shut down QEMU.

make qemu

    Build everything and start QEMU with the VGA console in a new window and the serial console in your terminal. To exit, either close the VGA window or press Ctrl-c or Ctrl-a x in your terminal.

make qemu-nox
    Like make qemu, but run with only the serial console. To exit, press Ctrl-a x. This is particularly useful over SSH connections to Athena dialups because the VGA window consumes a lot of bandwidth.

make qemu-gdb
    Like make qemu, but rather than passively accepting GDB connections at any time, this pauses at the first machine instruction and waits for a GDB connection.

make qemu-nox-gdb
    A combination of the qemu-nox and qemu-gdb targets.

make run-name
    (Lab 3+) Run user program name. For example, make run-hello runs user/hello.c.

make run-name-nox, run-name-gdb, run-name-gdb-nox,
    (Lab 3+) Variants of run-name that correspond to the variants of the qemu target.

The makefile also accepts a few useful variables:

make V=1 ...
    Verbose mode. Print out every command being executed, including arguments.

make V=1 grade
    Stop after any failed grade test and leave the QEMU output in jos.out for inspection.

make QEMUEXTRA='args' ...
    Specify additional arguments to pass to QEMU.

