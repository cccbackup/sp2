# OS 操作

```
/proc/version
/proc/self
/proc/cpuinfo
/proc/devices
/proc/pci
/proc/tty/driver/serial
/proc/sys/kernel
/proc/meminfo
/proc/filesystems
/proc/mounts
/proc/uptime
```

```
% cat /proc/sys/kernel/ostype
Linux
% cat /proc/sys/kernel/osrelease
2.2.14-5.0
% cat /proc/sys/kernel/version
#1 Tue Mar 7 21:07:39 EST 2000
```


```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os
$ cat /proc/meminfo
MemTotal:        4096500 kB
MemFree:          700448 kB
HighTotal:             0 kB
HighFree:              0 kB
LowTotal:        4096500 kB
LowFree:          700448 kB
SwapTotal:       6246872 kB
SwapFree:        5527860 kB

```

```
% cat /proc/ide/ide1/hdc/media
cdrom
% cat /proc/ide/ide1/hdc/model
TOSHIBA CD-ROM XM-6702B
```

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os
$ cat /proc/mounts
C:/msys64 / ntfs binary,noacl,auto 1 1
C:/msys64/usr/bin /bin ntfs binary,noacl,auto 1 1
C: /c ntfs binary,noacl,posix=0,user,noumount,auto 1 1
D: /d ntfs binary,noacl,posix=0,user,noumount,auto 1 1

```

```
% touch /tmp/test-file
% ./lock-file /tmp/test-file
file /tmp/test-file
opening /tmp/test-file
locking
locked; hit enter to unlock...
In another window, look at the contents of /proc/locks.
% cat /proc/locks
1: POSIX ADVISORY WRITE 5467 08:05:181288 0 2147483647 d1b5f740 00000000
dfea7d40 00000000 00000000
```

```
$  cat /proc/uptime
720054.17 139715.28
```

## /proc

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$ ls -l /proc/version
-r--r--r-- 1 user None 0 六月  7 15:02 /proc/version

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$ cat /proc/version
MSYS_NT-10.0 version 2.10.0(0.325/5/3) (Alexx@WARLOCK) (gcc version 6.4.0 (GCC) ) 2018-02-09 15:25

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$ man 5 proc
bash: man：命令找不到

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/02-fork/05-zombie
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 76
model name      : Intel(R) Celeron(R) CPU  J3160  @ 1.60GHz
stepping        : 4
cpu MHz         : 1600.000
cache size      : 1024 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt aes rdrand lahf_lm ida arat epb dtherm tsc_adjust smep erms
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 76
model name      : Intel(R) Celeron(R) CPU  J3160  @ 1.60GHz
stepping        : 4
cpu MHz         : 1600.000
cache size      : 1024 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt aes rdrand lahf_lm ida arat epb dtherm tsc_adjust smep erms
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 76
model name      : Intel(R) Celeron(R) CPU  J3160  @ 1.60GHz
stepping        : 4
cpu MHz         : 1600.000
cache size      : 1024 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 2
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt aes rdrand lahf_lm ida arat epb dtherm tsc_adjust smep erms
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 76
model name      : Intel(R) Celeron(R) CPU  J3160  @ 1.60GHz
stepping        : 4
cpu MHz         : 1600.000
cache size      : 1024 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 2
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt aes rdrand lahf_lm ida arat epb dtherm tsc_adjust smep erms
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:
```

## /proc/self

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ ls /proc/self
cmdline  environ  fd    mountinfo  ppid  stat    uid
ctty     exe      gid   mounts     root  statm   winexename
cwd      exename  maps  pgid       sid   status  winpid

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ ls /proc/self/uid
/proc/self/uid

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ cat /proc/self/uid
197609

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ cat /proc/self/stat
6920 (cat) R 3196 6920 3196 8912896 -1 0 1300 1300 0 0 0 31 0 31 8 0 0 0 718641000 4931584 1029 345
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ cat /proc/self/cwd
cat: /proc/self/cwd: Is a directory

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ ls /proc/self/cwd
crawSeq.c     crawThread.exe            download.exe  http1.c   page
crawSeq.exe   crawThread.exe.stackdump  http.c        list.c    README.md
crawThread.c  download.c                http.h        Makefile

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ ls /proc/self/exename
/proc/self/exename

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06-crawler
$ cat /proc/self/exename
/usr/bin/cat
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/net/06
```

## /proc/devices

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ ls /proc/devices
/proc/devices

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/12-op
$ cat /proc/devices
Character devices:
  1 mem
  3 cons
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  9 st
 13 misc
 14 sound
117 ttyS
136 tty

Block devices:
  2 fd
  8 sd
 11 sr
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd

```