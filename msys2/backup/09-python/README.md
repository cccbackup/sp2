# python

最後安裝 numpy 失敗!

## Python3

```
$ pacman -S python3
正在檢查衝突的套件...

套件 (2) mpdecimal-2.4.2-2  python-3.6.2-1

總計下載大小：  13.86 MiB
總計安裝大小：  97.90 MiB

:: 進行安裝嗎？ [Y/n] y
:: 正在擷取套件...
 mpdecimal-2.4.2-2-x...    86.7 KiB   162K/s 00:01 [#####################] 100%
 python-3.6.2-1-x86_64     13.8 MiB  1295K/s 00:11 [#####################] 100%
(2/2) 正在檢查鑰匙圈中的鑰匙                       [#####################] 100%
(2/2) 正在檢查套件完整性                           [#####################] 100%
(2/2) 正在載入套件檔案                             [#####################] 100%
(2/2) 正在檢查檔案衝突                             [#####################] 100%
(2/2) 正在檢查可用磁碟空間                         [#####################] 100%
:: 正在處理套件變更...
(1/2) 正在安裝 mpdecimal                           [#####################] 100%
(2/2) 正在安裝 python                              [#####################] 100%

```

## pip3

```
$ pacman -Ss pip
mingw32/mingw-w64-i686-python2-pip 10.0.1-1
    An easy_install replacement for installing pypi python packages (mingw-w64)
mingw32/mingw-w64-i686-python3-pip 10.0.1-1
    An easy_install replacement for installing pypi python packages (mingw-w64)
mingw64/mingw-w64-x86_64-python2-pip 10.0.1-1
    An easy_install replacement for installing pypi python packages (mingw-w64)
mingw64/mingw-w64-x86_64-python3-pip 10.0.1-1
    An easy_install replacement for installing pypi python packages (mingw-w64)
msys/gnu-netcat 0.7.1-1
    GNU rewrite of netcat, the network piping application
msys/libpipeline 1.4.1-1 (libraries)
    a C library for manipulating pipelines of subprocesses in a flexible and
    convenient way
msys/libpipeline-devel 1.4.1-1 (development)
    libpipeline headers and libraries
msys/pv 1.6.0-2
    Pipe viewer
msys/python2-pip 9.0.1-3
    The PyPA recommended tool for installing Python packages
msys/python3-pip 9.0.1-3
    The PyPA recommended tool for installing Python packages

```

更新 pip

```
$ python3 -m pip install --upgrade pip
Collecting pip
  Downloading https://files.pythonhosted.org/packages/54/2e/df11ea7e23e7e761d484ed3740285a34e38548cf2bad2bed3dd5768ec8b9/pip-20.1-py2.py3-none-any.whl (1.5MB)
    38% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k                   | 573kB 1.3MB/s eta 0:00:0    39% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m                   | 583kB 1.3MB/s eta 0:00:0    39% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o                   | 593kB 1.1MB/s eta 0:00:0    40% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i                   | 604kB 1.1MB/s eta 0:00:0    41% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j                  | 614kB 1.6MB/s eta 0:00:    41% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l                  | 624kB 1.6MB/s eta 0:00:    42% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n                  | 634kB 1.3MB/s eta 0:00:    43% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p                  | 645kB 1.3MB/s eta 0:00:    43% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i                  | 655kB 1.3MB/s eta 0:00:    44% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k                 | 665kB 1.1MB/s eta 0:00    45% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m                 | 675kB 1.1MB/s eta 0:00    46% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o                 | 686kB 1.1MB/s eta 0:00    46% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i                 | 696kB 1.1MB/s eta 0:00    47% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j                | 706kB 936kB/s eta 0:0    48% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l                | 716kB 936kB/s eta 0:0    48% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n                | 727kB 1.1MB/s eta 0:0    49% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p                | 737kB 1.3MB/s eta 0:0    50% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i                | 747kB 1.3MB/s eta 0:0    50% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k               | 757kB 1.3MB/s eta 0:    51% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m               | 768kB 1.6MB/s eta 0:    52% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o               | 778kB 1.3MB/s eta 0:    52% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i               | 788kB 1.3MB/s eta 0:    53% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j              | 798kB 1.3MB/s eta 0    54% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l              | 808kB 1.3MB/s eta 0    54% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n              | 819kB 1.3MB/s eta 0    55% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p              | 829kB 1.3MB/s eta 0    56% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i              | 839kB 1.1MB/s eta 0    57% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k             | 849kB 1.1MB/s eta     57% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m             | 860kB 1.1MB/s eta     58% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o             | 870kB 936kB/s eta     59% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i             | 880kB 1.3MB/s eta     59% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j            | 890kB 1.3MB/s eta    60% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l            | 901kB 1.3MB/s eta    61% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n            | 911kB 1.6MB/s eta    61% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p            | 921kB 1.6MB/s eta    62% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i            | 931kB 1.3MB/s eta    63% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k           | 942kB 936kB/s et    63% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m           | 952kB 936kB/s et    64% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o           | 962kB 819kB/s et    65% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i           | 972kB 936kB/s et    65% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j          | 983kB 819kB/s e    66% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l          | 993kB 790kB/s e    67% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m          | 1.0MB 890kB/s e    68% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o          | 1.0MB 813kB/s e    68% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i          | 1.0MB 747kB/s e    69% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j         | 1.0MB 837kB/s     70% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l         | 1.0MB 1.3MB/s     70% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n         | 1.1MB 1.3MB/s     71% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p         | 1.1MB 2.1MB/s     72% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i         | 1.1MB 1.6MB/s     72% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k        | 1.1MB 2.1MB/s    73% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m        | 1.1MB 1.4MB/s    74% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o        | 1.1MB 1.4MB/s    74% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i        | 1.1MB 1.6MB/s    75% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j       | 1.1MB 1.9MB/    76% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l       | 1.1MB 1.5MB/    76% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n       | 1.1MB 1.2MB/    77% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p       | 1.2MB 1.3MB/    78% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i       | 1.2MB 1.3MB/    79% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k      | 1.2MB 1.3MB    79% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m      | 1.2MB 1.3MB    80% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o      | 1.2MB 1.6MB    81% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i      | 1.2MB 1.6MB    81% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j     | 1.2MB 1.3M    82% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l     | 1.2MB 1.3M    83% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n     | 1.2MB 1.6M    83% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p     | 1.2MB 1.6M    84% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i     | 1.3MB 1.6M    85% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k    | 1.3MB 1.6    85% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m    | 1.3MB 1.6    86% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o    | 1.3MB 1.6    87% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i    | 1.3MB 1.6    87% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j   | 1.3MB 1.    88% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l   | 1.3MB 1.    89% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n   | 1.3MB 1.    90% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p   | 1.3MB 1.    90% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i   | 1.4MB 1.    91% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k  | 1.4MB 1    92% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m  | 1.4MB 1    92% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o  | 1.4MB 1    93% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i  | 1.4MB 1    94% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒j | 1.4MB     94% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒l | 1.4MB     95% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒n | 1.4MB     96% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒p | 1.4MB     96% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i | 1.4MB     97% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒k| 1.5MB    98% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒m| 1.5MB    98% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒o| 1.5MB    99% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i| 1.5MB    100% |▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i▒i| 1.5MB 936kB/s
Installing collected packages: pip
  Found existing installation: pip 10.0.1
    Uninstalling pip-10.0.1:
      Successfully uninstalled pip-10.0.1
Successfully installed pip-20.1

```

## 安裝 numpy

```
$ pip3 install numpy
Collecting numpy
  Using cached numpy-1.18.4.zip (5.4 MB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... error
  ERROR: Command errored out with exit status 1:
   command: C:/msys64/mingw64/bin/python3.exe C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py get_requires_for_build_wheel C:/Users/user/AppData/Local/Temp/tmpn2i_cxlp
       cwd: C:/Users/user/AppData/Local/Temp/pip-install-epi12tac/numpy
  Complete output (40 lines):
  Traceback (most recent call last):
    File "C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py", line 280, in <module>
      main()
    File "C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py", line 263, in main
      json_out['return_val'] = hook(**hook_input['kwargs'])
    File "C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py", line 108, in get_requires_for_build_wheel
      backend = _build_backend()
    File "C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py", line 86, in _build_backend
      obj = import_module(mod_path)
    File "C:/msys64/mingw64/lib/python3.6\importlib\__init__.py", line 126, in import_module
      return _bootstrap._gcd_import(name[level:], package, level)
    File "<frozen importlib._bootstrap>", line 994, in _gcd_import
    File "<frozen importlib._bootstrap>", line 971, in _find_and_load
    File "<frozen importlib._bootstrap>", line 941, in _find_and_load_unlocked
    File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
    File "<frozen importlib._bootstrap>", line 994, in _gcd_import
    File "<frozen importlib._bootstrap>", line 971, in _find_and_load
    File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
    File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
    File "<frozen importlib._bootstrap_external>", line 678, in exec_module
    File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
    File "C:/Users/user/AppData/Local/Temp/pip-build-env-lw1exs0x/overlay/lib/python3.6/site-packages\setuptools\__init__.py", line 232, in <module>
      monkey.patch_all()
    File "C:/Users/user/AppData/Local/Temp/pip-build-env-lw1exs0x/overlay/lib/python3.6/site-packages\setuptools\monkey.py", line 101, in patch_all
      patch_for_msvc_specialized_compiler()
    File "C:/Users/user/AppData/Local/Temp/pip-build-env-lw1exs0x/overlay/lib/python3.6/site-packages\setuptools\monkey.py", line 164, in patch_for_msvc_specialized_compiler
      patch_func(*msvc9('find_vcvarsall'))
    File "C:/Users/user/AppData/Local/Temp/pip-build-env-lw1exs0x/overlay/lib/python3.6/site-packages\setuptools\monkey.py", line 151, in patch_params
      mod = import_module(mod_name)
    File "C:/msys64/mingw64/lib/python3.6\importlib\__init__.py", line 126, in import_module
      return _bootstrap._gcd_import(name[level:], package, level)
    File "<frozen importlib._bootstrap>", line 994, in _gcd_import
    File "<frozen importlib._bootstrap>", line 971, in _find_and_load
    File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
    File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
    File "<frozen importlib._bootstrap_external>", line 678, in exec_module
    File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
    File "C:/msys64/mingw64/lib/python3.6\distutils\msvc9compiler.py", line 297, in <module>
      raise DistutilsPlatformError("VC %0.1f is not supported by this module" % VERSION)
  distutils.errors.DistutilsPlatformError: VC 6.0 is not supported by this module
  ----------------------------------------
ERROR: Command errored out with exit status 1: C:/msys64/mingw64/bin/python3.exe C:/msys64/mingw64/lib/python3.6/site-packages/pip/_vendor/pep517/_in_process.py get_requires_for_build_wheel C:/Users/user/AppData/Local/Temp/tmpn2i_cxlp Check the logs for full command output.

```