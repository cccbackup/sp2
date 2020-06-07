

```
user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/01-thread
$ gcc georgeMary.c -o georgeMary

user@DESKTOP-96FRN6B MSYS /d/ccc/course/sp2/os/01-thread
$ strace georgeMary
create_child: georgeMary
--- Process 9036 created
--- Process 9036 loaded C:\Windows\System32\ntdll.dll at 00007ffface80000
--- Process 9036 loaded C:\Windows\System32\kernel32.dll at 00007fffacd80000
--- Process 9036 loaded C:\Windows\System32\KernelBase.dll at 00007fffa9ef0000
--- Process 9036 thread 9068 created
--- Process 9036 loaded C:\msys64\usr\bin\msys-2.0.dll at 0000000180040000
    8       8 [main] georgeMary (9036) **********************************************
  206     214 [main] georgeMary (9036) Program name: D:\ccc\course\sp2\os\01-thread\georgeMary.exe (windows pid 9036)
  100     314 [main] georgeMary (9036) OS version:   Windows NT-10.0
  157     471 [main] georgeMary (9036) **********************************************
--- Process 9036 loaded C:\Windows\System32\advapi32.dll at 00007fffac7e0000
--- Process 9036 loaded C:\Windows\System32\msvcrt.dll at 00007fffac740000
--- Process 9036 loaded C:\Windows\System32\sechost.dll at 00007fffab220000
--- Process 9036 loaded C:\Windows\System32\rpcrt4.dll at 00007fffaaf30000
--- Process 9036 thread 4240 created
--- Process 9036 loaded C:\Windows\System32\cryptbase.dll at 00007fffa9780000
--- Process 9036 loaded C:\Windows\System32\bcryptprimitives.dll at 00007fffaac40000
10145   10616 [main] georgeMary (9036) sigprocmask: 0 = sigprocmask (0, 0x0, 0x1802DDC30)
  810   11426 [main] georgeMary 9036 open_shared: name shared.5, n 5, shared 0x180030000 (wanted 0x180030000), h 0x100, *m 6
  105   11531 [main] georgeMary 9036 user_heap_info::init: heap base 0x600000000, heap top 0x600000000, heap size 0x20000000 (536870912)
  125   11656 [main] georgeMary 9036 open_shared: name S-1-5-21-666728823-4059694745-3045949050-1001.1, n 1, shared 0x180020000 (wanted 0x180020000), h 0x104, *m 6
   74   11730 [main] georgeMary 9036 user_info::create: opening user shared for 'S-1-5-21-666728823-4059694745-3045949050-1001' at 0x180020000
   78   11808 [main] georgeMary 9036 user_info::create: user shared version AB1FCCE8
  144   11952 [main] georgeMary 9036 fhandler_pipe::create: name \\.\pipe\msys-dd50a72ab4668b33-9036-sigwait, size 11440, mode PIPE_TYPE_MESSAGE
  187   12139 [main] georgeMary 9036 fhandler_pipe::create: pipe read handle 0x118
   70   12209 [main] georgeMary 9036 fhandler_pipe::create: CreateFile: name \\.\pipe\msys-dd50a72ab4668b33-9036-sigwait
  137   12346 [main] georgeMary 9036 fhandler_pipe::create: pipe write handle 0x11C
  131   12477 [main] georgeMary 9036 dll_crt0_0: finished dll_crt0_0 initialization
--- Process 9036 thread 8360 created
  817   13294 [sig] georgeMary 9036 wait_sig: entering ReadFile loop, my_readsig 0x118, my_sendsig 0x11C
  805   14099 [main] georgeMary 9036 time: 1591515159 = time(0x0)
  314   14413 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (D:\ccc\course\sp2\os\01-thread, 0x0, no-add-slash)
  195   14608 [main] georgeMary 9036 normalize_win32_path: D:\ccc\course\sp2\os\01-thread = normalize_win32_path (D:\ccc\course\sp2\os\01-thread)
   96   14704 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   80   14784 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   79   14863 [main] georgeMary 9036 mount_info::conv_to_posix_path: /d/ccc/course/sp2/os/01-thread = conv_to_posix_path (D:\ccc\course\sp2\os\01-thread)
  154   15017 [main] georgeMary 9036 sigprocmask: 0 = sigprocmask (0, 0x0, 0x600018130)
  683   15700 [main] georgeMary 9036 _cygwin_istext_for_stdio: fd 0: not open
   97   15797 [main] georgeMary 9036 _cygwin_istext_for_stdio: fd 1: not open
   70   15867 [main] georgeMary 9036 _cygwin_istext_for_stdio: fd 2: not open
  296   16163 [main] georgeMary (9036) open_shared: name cygpid.9036, n 9036, shared 0x180010000 (wanted 0x180010000), h 0x138, *m 2
   89   16252 [main] georgeMary (9036) time: 1591515159 = time(0x0)
   88   16340 [main] georgeMary 9036 pinfo::thisproc: myself dwProcessId 9036
  121   16461 [main] georgeMary 9036 environ_init: GetEnvironmentStrings returned 0x743B80
  287   16748 [main] georgeMary 9036 win32env_to_cygenv: 0x6000284F0: !::=::\
  138   16886 [main] georgeMary 9036 win32env_to_cygenv: 0x600028510: !C:=C:\msys64
  134   17020 [main] georgeMary 9036 win32env_to_cygenv: 0x600028530: ALLUSERSPROFILE=C:\ProgramData
  134   17154 [main] georgeMary 9036 win32env_to_cygenv: 0x600028560: ANDROID_HOME=C:\Users\user\AppData\Local\Android\Sdk
  143   17297 [main] georgeMary 9036 win32env_to_cygenv: 0x6000285A0: APPDATA=C:\Users\user\AppData\Roaming
  140   17437 [main] georgeMary 9036 win32env_to_cygenv: 0x6000285D0: BINARYEN_ROOT=D:/install/emsdk-portable-64bit/clang/e1.37.26_64bit/binaryen
  158   17595 [main] georgeMary 9036 win32env_to_cygenv: 0x600028630: COMMONPROGRAMFILES=C:\Program Files\Common Files
  157   17752 [main] georgeMary 9036 win32env_to_cygenv: 0x600028670: COMPUTERNAME=DESKTOP-96FRN6B
  159   17911 [main] georgeMary 9036 win32env_to_cygenv: 0x6000286A0: COMSPEC=C:\WINDOWS\system32\cmd.exe
  142   18053 [main] georgeMary 9036 win32env_to_cygenv: 0x6000286D0: CONFIG_SITE=/etc/config.site
  150   18203 [main] georgeMary 9036 win32env_to_cygenv: 0x600028700: CONTITLE=MSYS2 MSYS
  156   18359 [main] georgeMary 9036 win32env_to_cygenv: 0x600028720: ChocolateyInstall=C:\ProgramData\chocolatey
  155   18514 [main] georgeMary 9036 win32env_to_cygenv: 0x600028760: ChocolateyLastPathUpdate=Tue Sep 24 17:09:51 2019
  146   18660 [main] georgeMary 9036 win32env_to_cygenv: 0x6000287A0: ChocolateyToolsLocation=C:\tools
  143   18803 [main] georgeMary 9036 win32env_to_cygenv: 0x6000287D0: CommonProgramFiles(x86)=C:\Program Files (x86)\Common Files
  151   18954 [main] georgeMary 9036 win32env_to_cygenv: 0x600028820: CommonProgramW6432=C:\Program Files\Common Files
  142   19096 [main] georgeMary 9036 win32env_to_cygenv: 0x600028860: DriverData=C:\Windows\System32\Drivers\DriverData
  143   19239 [main] georgeMary 9036 win32env_to_cygenv: 0x6000288A0: EMSCRIPTEN=D:/install/emsdk-portable-64bit/emscripten/1.37.26
  142   19381 [main] georgeMary 9036 win32env_to_cygenv: 0x6000288F0: GH_TOKEN=663f5010b96e140b0b79c80c83ba3103ed73dd58
  134   19515 [main] georgeMary 9036 win32env_to_cygenv: 0x600028930: GOPATH=c:\mygo
  135   19650 [main] georgeMary 9036 win32env_to_cygenv: 0x600028950: GOROOT=C:\Go\
  131   19781 [main] georgeMary 9036 win32env_to_cygenv: 0x600028970: GYP_MSVS_VERSION=2015
  133   19914 [main] georgeMary 9036 getwinenv: can't set native for HOME= since no environ yet
   89   20003 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\home\user, 0x10000000, no-add-slash)
   77   20080 [main] georgeMary 9036 normalize_win32_path: C:\msys64\home\user = normalize_win32_path (C:\msys64\home\user)
   89   20169 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   85   20254 [main] georgeMary 9036 mount_info::conv_to_posix_path: /home/user = conv_to_posix_path (C:\msys64\home\user)
  210   20464 [main] georgeMary 9036 win_env::add_cache: posix /home/user
   73   20537 [main] georgeMary 9036 win_env::add_cache: native HOME=C:\msys64\home\user
   90   20627 [main] georgeMary 9036 posify_maybe: env var converted to HOME=/home/user
  192   20819 [main] georgeMary 9036 win32env_to_cygenv: 0x600028A10: HOME=/home/user
  133   20952 [main] georgeMary 9036 win32env_to_cygenv: 0x600028990: HOMEDRIVE=C:
  134   21086 [main] georgeMary 9036 win32env_to_cygenv: 0x600028A30: HOMEPATH=\Users\user
  134   21220 [main] georgeMary 9036 win32env_to_cygenv: 0x600028A50: HOSTNAME=DESKTOP-96FRN6B
  146   21366 [main] georgeMary 9036 win32env_to_cygenv: 0x600028A80: INFOPATH=/usr/local/info:/usr/share/info:/usr/info:/share/info
  137   21503 [main] georgeMary 9036 win32env_to_cygenv: 0x600028AD0: JAVA_HOME=D:/install/emsdk-portable-64bit/java/7.45_64bit
  131   21634 [main] georgeMary 9036 win32env_to_cygenv: 0x600028B20: LANG=zh_TW.UTF-8
  133   21767 [main] georgeMary 9036 win32env_to_cygenv: 0x600028B40: LOCALAPPDATA=C:\Users\user\AppData\Local
  136   21903 [main] georgeMary 9036 win32env_to_cygenv: 0x600028B80: LOGINSHELL=bash
  140   22043 [main] georgeMary 9036 win32env_to_cygenv: 0x600028BA0: LOGONSERVER=\\DESKTOP-96FRN6B
  135   22178 [main] georgeMary 9036 win32env_to_cygenv: 0x600028BD0: MANPATH=/usr/local/man:/usr/share/man:/usr/man:/share/man
  149   22327 [main] georgeMary 9036 win32env_to_cygenv: 0x600028C20: MSYSCON=mintty.exe
  128   22455 [main] georgeMary 9036 win32env_to_cygenv: 0x600028C40: MSYSTEM=MSYS
  139   22594 [main] georgeMary 9036 win32env_to_cygenv: 0x600028C60: MSYSTEM_CARCH=x86_64
  135   22729 [main] georgeMary 9036 win32env_to_cygenv: 0x600028C80: MSYSTEM_CHOST=x86_64-pc-msys
  137   22866 [main] georgeMary 9036 win32env_to_cygenv: 0x600028CB0: MSYSTEM_PREFIX=/usr
  134   23000 [main] georgeMary 9036 win32env_to_cygenv: 0x600028CD0: NUMBER_OF_PROCESSORS=4
  140   23140 [main] georgeMary 9036 win32env_to_cygenv: 0x600028CF0: OLDPWD=/d/ccc/course/sp2/os
  141   23281 [main] georgeMary 9036 win32env_to_cygenv: 0x600028D20: OPENSSL_CONF=C:\Program Files\PostgreSQL\psqlODBC\etc\openssl.cnf
  140   23421 [main] georgeMary 9036 win32env_to_cygenv: 0x600028D70: ORIGINAL_PATH=/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/
  118   23539 [main] georgeMary 9036 win32env_to_cygenv: 0x600028DF0: ORIGINAL_TEMP=/c/Users/user/AppData/Local/Temp
  114   23653 [main] georgeMary 9036 win32env_to_cygenv: 0x600028E30: ORIGINAL_TMP=/c/Users/user/AppData/Local/Temp
  158   23811 [main] georgeMary 9036 win32env_to_cygenv: 0x600028E70: OS=Windows_NT
  142   23953 [main] georgeMary 9036 win32env_to_cygenv: 0x600028E90: OneDrive=C:\Users\user\OneDrive
  151   24104 [main] georgeMary 9036 getwinenv: can't set native for PATH= since no environ yet
  182   24286 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\local\bin, 0x10000100, no-add-slash)
   79   24365 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\local\bin = normalize_win32_path (C:\msys64\usr\local\bin)
   91   24456 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
  102   24558 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/local/bin = conv_to_posix_path (C:\msys64\usr\local\bin)
   74   24632 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\bin, 0x10000100, no-add-slash)
  100   24732 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\bin = normalize_win32_path (C:\msys64\usr\bin)
   81   24813 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   91   24904 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/bin = conv_to_posix_path (C:\msys64\usr\bin)
   72   24976 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\bin, 0x10000100, no-add-slash)
   70   25046 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\bin = normalize_win32_path (C:\msys64\usr\bin)
   83   25129 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   85   25214 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/bin = conv_to_posix_path (C:\msys64\usr\bin)
   86   25300 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\opt\bin, 0x10000100, no-add-slash)
   74   25374 [main] georgeMary 9036 normalize_win32_path: C:\msys64\opt\bin = normalize_win32_path (C:\msys64\opt\bin)
   75   25449 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   79   25528 [main] georgeMary 9036 mount_info::conv_to_posix_path: /opt/bin = conv_to_posix_path (C:\msys64\opt\bin)
   73   25601 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Windows\System32, 0x10000100, no-add-slash)
   71   25672 [main] georgeMary 9036 normalize_win32_path: C:\Windows\System32 = normalize_win32_path (C:\Windows\System32)
   79   25751 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   70   25821 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   86   25907 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Windows/System32 = conv_to_posix_path (C:\Windows\System32)
   82   25989 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Windows, 0x10000100, no-add-slash)
   78   26067 [main] georgeMary 9036 normalize_win32_path: C:\Windows = normalize_win32_path (C:\Windows)
   71   26138 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   74   26212 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   86   26298 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Windows = conv_to_posix_path (C:\Windows)
   79   26377 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Windows\System32\Wbem, 0x10000100, no-add-slash)
   74   26451 [main] georgeMary 9036 normalize_win32_path: C:\Windows\System32\Wbem = normalize_win32_path (C:\Windows\System32\Wbem)
   71   26522 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   72   26594 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   78   26672 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Windows/System32/Wbem = conv_to_posix_path (C:\Windows\System32\Wbem)
   99   26771 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Windows\System32\WindowsPowerShell\v1.0, 0x10000100, no-add-slash)
   75   26846 [main] georgeMary 9036 normalize_win32_path: C:\Windows\System32\WindowsPowerShell\v1.0 = normalize_win32_path (C:\Windows\System32\WindowsPowerShell\v1.0)
   71   26917 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   86   27003 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   72   27075 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Windows/System32/WindowsPowerShell/v1.0 = conv_to_posix_path (C:\Windows\System32\WindowsPowerShell\v1.0)
   84   27159 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\bin\site_perl, 0x10000100, no-add-slash)
   93   27252 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\bin\site_perl = normalize_win32_path (C:\msys64\usr\bin\site_perl)
   80   27332 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   71   27403 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/bin/site_perl = conv_to_posix_path (C:\msys64\usr\bin\site_perl)
   79   27482 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\bin\vendor_perl, 0x10000100, no-add-slash)
   86   27568 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\bin\vendor_perl = normalize_win32_path (C:\msys64\usr\bin\vendor_perl)
   81   27649 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   73   27722 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/bin/vendor_perl = conv_to_posix_path (C:\msys64\usr\bin\vendor_perl)
   73   27795 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\usr\bin\core_perl, 0x10000100, no-add-slash)
   84   27879 [main] georgeMary 9036 normalize_win32_path: C:\msys64\usr\bin\core_perl = normalize_win32_path (C:\msys64\usr\bin\core_perl)
   88   27967 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   71   28038 [main] georgeMary 9036 mount_info::conv_to_posix_path: /usr/bin/core_perl = conv_to_posix_path (C:\msys64\usr\bin\core_perl)
  214   28252 [main] georgeMary 9036 win_env::add_cache: posix /usr/local/bin:/usr/bin:/usr/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
   77   28329 [main] georgeMary 9036 win_env::add_cache: native PATH=C:\msys64\usr\local\bin;C:\msys64\usr\bin;C:\msys64\usr\bin;C:\msys64\opt\bin;C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\msys64\usr\bin\site_perl;C:\msys64\usr\bin\vendor_perl;C:\msys64\usr\bin\core_perl
   74   28403 [main] georgeMary 9036 posify_maybe: env var converted to PATH=/usr/local/bin:/usr/bin:/usr/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
  188   28591 [main] georgeMary 9036 win32env_to_cygenv: 0x6000391E0: PATH=/usr/local/bin:/usr/bin:/usr/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
  140   28731 [main] georgeMary 9036 win32env_to_cygenv: 0x600028EC0: PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
  135   28866 [main] georgeMary 9036 win32env_to_cygenv: 0x600028F10: PGDATA=/home/usr/pgdata
  145   29011 [main] georgeMary 9036 win32env_to_cygenv: 0x600028F30: PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig
  133   29144 [main] georgeMary 9036 win32env_to_cygenv: 0x600028F80: PRINTER=Microsoft Print to PDF
  158   29302 [main] georgeMary 9036 win32env_to_cygenv: 0x600028FB0: PROCESSOR_ARCHITECTURE=AMD64
  140   29442 [main] georgeMary 9036 win32env_to_cygenv: 0x6000392C0: PROCESSOR_IDENTIFIER=Intel64 Family 6 Model 76 Stepping 4, GenuineIntel
  138   29580 [main] georgeMary 9036 win32env_to_cygenv: 0x600039310: PROCESSOR_LEVEL=6
  134   29714 [main] georgeMary 9036 win32env_to_cygenv: 0x600039330: PROCESSOR_REVISION=4c04
  141   29855 [main] georgeMary 9036 win32env_to_cygenv: 0x600039350: PROGRAMFILES=C:\Program Files
  133   29988 [main] georgeMary 9036 win32env_to_cygenv: 0x600039380: PROMPT=$P$G
  141   30129 [main] georgeMary 9036 win32env_to_cygenv: 0x6000393A0: PS1=\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n\$
  159   30288 [main] georgeMary 9036 win32env_to_cygenv: 0x600039410: PSModulePath=C:\Users\user\Documents\WindowsPowerShell\Modules
  154   30442 [main] georgeMary 9036 win32env_to_cygenv: 0x600039460: PUBLIC=C:\Users\Public
  154   30596 [main] georgeMary 9036 win32env_to_cygenv: 0x600039480: PWD=/d/ccc/course/sp2/os/01-thread
  138   30734 [main] georgeMary 9036 win32env_to_cygenv: 0x6000394B0: ProgramData=C:\ProgramData
  138   30872 [main] georgeMary 9036 win32env_to_cygenv: 0x6000394E0: ProgramFiles(x86)=C:\Program Files (x86)
  135   31007 [main] georgeMary 9036 win32env_to_cygenv: 0x600039520: ProgramW6432=C:\Program Files
  137   31144 [main] georgeMary 9036 win32env_to_cygenv: 0x600039550: SESSIONNAME=Console
  152   31296 [main] georgeMary 9036 win32env_to_cygenv: 0x600039570: SHELL=/usr/bin/bash
  138   31434 [main] georgeMary 9036 win32env_to_cygenv: 0x600039590: SHLVL=1
  132   31566 [main] georgeMary 9036 win32env_to_cygenv: 0x6000395B0: SYSTEMDRIVE=C:
  136   31702 [main] georgeMary 9036 win32env_to_cygenv: 0x6000395D0: SYSTEMROOT=C:\WINDOWS
  137   31839 [main] georgeMary 9036 getwinenv: can't set native for TEMP= since no environ yet
   76   31915 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\tmp, 0x10000000, no-add-slash)
   85   32000 [main] georgeMary 9036 normalize_win32_path: C:\msys64\tmp = normalize_win32_path (C:\msys64\tmp)
   89   32089 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   73   32162 [main] georgeMary 9036 mount_info::conv_to_posix_path: /tmp = conv_to_posix_path (C:\msys64\tmp)
  236   32398 [main] georgeMary 9036 win_env::add_cache: posix /tmp
   76   32474 [main] georgeMary 9036 win_env::add_cache: native TEMP=C:\msys64\tmp
   82   32556 [main] georgeMary 9036 posify_maybe: env var converted to TEMP=/tmp
  202   32758 [main] georgeMary 9036 win32env_to_cygenv: 0x600039650: TEMP=/tmp
  145   32903 [main] georgeMary 9036 win32env_to_cygenv: 0x6000395F0: TERM=xterm
  136   33039 [main] georgeMary 9036 getwinenv: can't set native for TMP= since no environ yet
   73   33112 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\msys64\tmp, 0x10000000, no-add-slash)
   83   33195 [main] georgeMary 9036 normalize_win32_path: C:\msys64\tmp = normalize_win32_path (C:\msys64\tmp)
   85   33280 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   68   33348 [main] georgeMary 9036 mount_info::conv_to_posix_path: /tmp = conv_to_posix_path (C:\msys64\tmp)
  201   33549 [main] georgeMary 9036 win_env::add_cache: posix /tmp
   75   33624 [main] georgeMary 9036 win_env::add_cache: native TMP=C:\msys64\tmp
   71   33695 [main] georgeMary 9036 posify_maybe: env var converted to TMP=/tmp
  218   33913 [main] georgeMary 9036 win32env_to_cygenv: 0x6000396D0: TMP=/tmp
  139   34052 [main] georgeMary 9036 win32env_to_cygenv: 0x600039670: TZ=Asia/Taipei
  154   34206 [main] georgeMary 9036 win32env_to_cygenv: 0x6000396F0: USER=user
  139   34345 [main] georgeMary 9036 win32env_to_cygenv: 0x600039710: USERDOMAIN=DESKTOP-96FRN6B
  134   34479 [main] georgeMary 9036 win32env_to_cygenv: 0x600039740: USERDOMAIN_ROAMINGPROFILE=DESKTOP-96FRN6B
  134   34613 [main] georgeMary 9036 win32env_to_cygenv: 0x600039780: USERNAME=user
  138   34751 [main] georgeMary 9036 win32env_to_cygenv: 0x6000397A0: USERPROFILE=C:\Users\user
  134   34885 [main] georgeMary 9036 win32env_to_cygenv: 0x6000397D0: VBOX_MSI_INSTALL_PATH=C:\Program Files\Oracle\VirtualBox\
  142   35027 [main] georgeMary 9036 win32env_to_cygenv: 0x600039820: VS140COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\
  141   35168 [main] georgeMary 9036 win32env_to_cygenv: 0x600039880: VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community
  161   35329 [main] georgeMary 9036 win32env_to_cygenv: 0x6000398E0: WD=C:\msys64\usr\bin\
  178   35507 [main] georgeMary 9036 win32env_to_cygenv: 0x600039900: WINDIR=C:\WINDOWS
  162   35669 [main] georgeMary 9036 win32env_to_cygenv: 0x600039920: _=/usr/bin/strace
  144   35813 [main] georgeMary 9036 getwinenv: can't set native for TEMP= since no environ yet
   80   35893 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Users\user\AppData\Local\Temp, 0x10000000, no-add-slash)
   96   35989 [main] georgeMary 9036 normalize_win32_path: C:\Users\user\AppData\Local\Temp = normalize_win32_path (C:\Users\user\AppData\Local\Temp)
   89   36078 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   93   36171 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   92   36263 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Users/user/AppData/Local/Temp = conv_to_posix_path (C:\Users\user\AppData\Local\Temp)
  218   36481 [main] georgeMary 9036 win_env::add_cache: posix /c/Users/user/AppData/Local/Temp
   79   36560 [main] georgeMary 9036 win_env::add_cache: native TEMP=C:\Users\user\AppData\Local\Temp
   91   36651 [main] georgeMary 9036 posify_maybe: env var converted to TEMP=/c/Users/user/AppData/Local/Temp
  219   36870 [main] georgeMary 9036 win32env_to_cygenv: 0x600039610: TEMP=/c/Users/user/AppData/Local/Temp
  159   37029 [main] georgeMary 9036 getwinenv: can't set native for TMP= since no environ yet
   84   37113 [main] georgeMary 9036 mount_info::conv_to_posix_path: conv_to_posix_path (C:\Users\user\AppData\Local\Temp, 0x10000000, no-add-slash)
   92   37205 [main] georgeMary 9036 normalize_win32_path: C:\Users\user\AppData\Local\Temp = normalize_win32_path (C:\Users\user\AppData\Local\Temp)
   89   37294 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[0] .. checking / -> C:\msys64
   85   37379 [main] georgeMary 9036 mount_info::conv_to_posix_path:  mount[1] .. checking /bin -> C:\msys64\usr\bin
   89   37468 [main] georgeMary 9036 mount_info::conv_to_posix_path: /c/Users/user/AppData/Local/Temp = conv_to_posix_path (C:\Users\user\AppData\Local\Temp)
  231   37699 [main] georgeMary 9036 win_env::add_cache: posix /c/Users/user/AppData/Local/Temp
   78   37777 [main] georgeMary 9036 win_env::add_cache: native TMP=C:\Users\user\AppData\Local\Temp
   89   37866 [main] georgeMary 9036 posify_maybe: env var converted to TMP=/c/Users/user/AppData/Local/Temp
  220   38086 [main] georgeMary 9036 win32env_to_cygenv: 0x600039690: TMP=/c/Users/user/AppData/Local/Temp
  100   38186 [main] georgeMary 9036 pinfo_init: Set nice to 0
   91   38277 [main] georgeMary 9036 pinfo_init: pid 9036, pgid 9036, process_state 0x41
   85   38362 [main] georgeMary 9036 App version:  2010.0, api: 0.325
   85   38447 [main] georgeMary 9036 DLL version:  2010.0, api: 0.325
   90   38537 [main] georgeMary 9036 DLL build:    2018-02-09 15:25
  124   38661 [main] georgeMary 9036 dtable::extend: size 32, fds 0x180305E80
  173   38834 [main] georgeMary 9036 __get_lcid_from_locale: LCID=0x0404
39678   78512 [main] georgeMary 9036 transport_layer_pipes::connect: Try to connect to named pipe: \\.\pipe\msys-dd50a72ab4668b33-lpc
  232   78744 [main] georgeMary 9036 transport_layer_pipes::connect: Error opening the pipe (2)
  175   78919 [main] georgeMary 9036 client_request::make_request: cygserver un-available
--- Process 9036 loaded C:\Windows\System32\netapi32.dll at 00007fff999f0000
--- Process 9036 loaded C:\Windows\System32\samcli.dll at 00007fffa40d0000
--- Process 9036 loaded C:\Windows\System32\ucrtbase.dll at 00007fffaa1a0000
--- Process 9036 loaded C:\Windows\System32\samlib.dll at 00007fffa67e0000
--- Process 9036 loaded C:\Windows\System32\netutils.dll at 00007fffa93d0000
16558   95477 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <user:*:197609:197121:U-DESKTOP-96FRN6B\user,S-1-5-21-666728823-4059694745-3045949050-1001:/home/user:/usr/bin/bash>
27534  123011 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: NetLocalGroupGetInfo(None) 1376
  177  123188 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <None:S-1-5-21-666728823-4059694745-3045949050-513:197121:>
15930  139118 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <docker-users:S-1-5-21-666728823-4059694745-3045949050-1002:197610:>
 2578  141696 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Ssh Users:S-1-5-21-666728823-4059694745-3045949050-1003:197611:>
 1724  143420 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Performance Log Users:S-1-5-32-559:559:>
 1172  144592 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Users:S-1-5-32-545:545:>
  138  144730 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <INTERACTIVE:S-1-5-4:4:>
   73  144803 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <CONSOLE LOGON:S-1-2-1:66049:>
   70  144873 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Authenticated Users:S-1-5-11:11:>
   71  144944 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <This Organization:S-1-5-15:15:>
   70  145014 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <本機帳戶:S-1-5-113:113:>
   76  145090 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <LOCAL:S-1-2-0:66048:>
   87  145177 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <NTLM Authentication:S-1-5-64-10:262154:>
  104  145281 [main] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Medium Mandatory Level:S-1-16-8192:401408:>
  100  145381 [main] georgeMary 9036 cygheap_user::ontherange: what 2, pw 0x1803061D0
   71  145452 [main] georgeMary 9036 cygheap_user::ontherange: HOME is already in the environment /home/user
  178  145630 [main] georgeMary 9036 build_argv: cmd = 'georgeMary', winshell = 1, glob = 1
  133  145763 [main] georgeMary 9036 build_argv: argv[0] = 'georgeMary'
   69  145832 [main] georgeMary 9036 build_argv: argc 1
  629  146461 [main] georgeMary 9036 build_fh_pc: created an archetype (0x180308230) for /dev/pty1(136/1)
   95  146556 [main] georgeMary 9036 build_fh_pc: fh 0x180307EC0, dev 00880001
   94  146650 [main] georgeMary 9036 fhandler_pipe::create: name \\.\pipe\msys-dd50a72ab4668b33-pty1-from-master, size 131072, mode PIPE_TYPE_MESSAGE
  195  146845 [main] georgeMary 9036 fhandler_pipe::create: pipe busy
   75  146920 [main] georgeMary 9036 tty::exists: exists 1
  605  147525 [main] georgeMary 9036 set_posix_access: ACL-Size: 124
  337  147862 [main] georgeMary 9036 set_posix_access: Created SD-Size: 200
   79  147941 [main] georgeMary 9036 fhandler_pty_slave::open: (393): pty output_mutex (0x13C): waiting -1 ms
  125  148066 [main] georgeMary 9036 fhandler_pty_slave::open: (393): pty output_mutex: acquired
  106  148172 [main] georgeMary 9036 tty::create_inuse: cygtty.slave_alive.1 0x16C
   77  148249 [main] georgeMary 9036 fhandler_pty_slave::open: (396): pty output_mutex(0x13C) released
  181  148430 [main] georgeMary 9036 open_shared: name cygpid.2608, n 2608, shared 0x160000 (wanted 0x0), h 0x17C, *m 6
  159  148589 [main] georgeMary 9036 fhandler_pty_slave::open: dup handles directly since I'm the owner
  157  148746 [main] georgeMary 9036 fhandler_pty_slave::open: duplicated from_master 0x408->0x17C from pty_owner
   71  148817 [main] georgeMary 9036 fhandler_pty_slave::open: duplicated to_master 0x414->0x184 from pty_owner
   66  148883 [main] georgeMary 9036 fhandler_pty_slave::open: duplicated to_master_cyg 0x41C->0x188 from pty_owner
  163  149046 [main] georgeMary 9036 fhandler_console::need_invisible: invisible_console 0
  405  149451 [main] georgeMary 9036 fhandler_base::open_with_arch: line 458:  /dev/pty1<0x180308230> usecount + 1 = 1
  122  149573 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   71  149644 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   73  149717 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   96  149813 [main] georgeMary 9036 _pinfo::set_ctty: old no ctty, ctty device number 0xFFFFFFFF, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   91  149904 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty 0x0, archetype 0x180308230
   70  149974 [main] georgeMary 9036 _pinfo::set_ctty: ctty was NULL
   84  150058 [main] georgeMary 9036 _pinfo::set_ctty: line 497:  /dev/pty1<0x180308230> usecount + 1 = 2
   73  150131 [main] georgeMary 9036 _pinfo::set_ctty: /dev/pty1 ctty, usecount 2
   79  150210 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 9036, pid 9036, pgid 9036, tty->pgid 14208, tty->sid 7068
   75  150285 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   75  150360 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 2
   99  150459 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   79  150538 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   72  150610 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   72  150682 [main] georgeMary 9036 _pinfo::set_ctty: old ctty /dev/pty1, ctty device number 0x880001, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   75  150757 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 7068, pid 9036, pgid 14208, tty->pgid 14208, tty->sid 7068
   88  150845 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   74  150919 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 2
  184  151103 [main] georgeMary 9036 build_fh_pc: found an archetype for (null)(136/1) io_handle 0x17C
   77  151180 [main] georgeMary 9036 build_fh_pc: fh 0x180308610, dev 00880001
  101  151281 [main] georgeMary 9036 fhandler_base::open_with_arch: line 478:  /dev/pty1<0x180308230> usecount + 1 = 3
   78  151359 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   73  151432 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   71  151503 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   85  151588 [main] georgeMary 9036 _pinfo::set_ctty: old ctty /dev/pty1, ctty device number 0x880001, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   94  151682 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 7068, pid 9036, pgid 14208, tty->pgid 14208, tty->sid 7068
   88  151770 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   82  151852 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 3
   81  151933 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   73  152006 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   83  152089 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   77  152166 [main] georgeMary 9036 _pinfo::set_ctty: old ctty /dev/pty1, ctty device number 0x880001, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   80  152246 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 7068, pid 9036, pgid 14208, tty->pgid 14208, tty->sid 7068
   77  152323 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   90  152413 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 3
  183  152596 [main] georgeMary 9036 build_fh_pc: found an archetype for (null)(136/1) io_handle 0x17C
   88  152684 [main] georgeMary 9036 build_fh_pc: fh 0x180308980, dev 00880001
   96  152780 [main] georgeMary 9036 fhandler_base::open_with_arch: line 478:  /dev/pty1<0x180308230> usecount + 1 = 4
   86  152866 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   71  152937 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   82  153019 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   76  153095 [main] georgeMary 9036 _pinfo::set_ctty: old ctty /dev/pty1, ctty device number 0x880001, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   80  153175 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 7068, pid 9036, pgid 14208, tty->pgid 14208, tty->sid 7068
   74  153249 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   74  153323 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 4
   76  153399 [main] georgeMary 9036 fhandler_base::set_flags: flags 0x10002, supplied_bin 0x0
   71  153470 [main] georgeMary 9036 fhandler_base::set_flags: O_TEXT/O_BINARY set in flags 0x10000
   81  153551 [main] georgeMary 9036 fhandler_base::set_flags: filemode set to binary
   88  153639 [main] georgeMary 9036 _pinfo::set_ctty: old ctty /dev/pty1, ctty device number 0x880001, tc.ntty device number 0x880001 flags & O_NOCTTY 0x0
   85  153724 [main] georgeMary 9036 _pinfo::set_ctty: attaching ctty /dev/pty1 sid 7068, pid 9036, pgid 14208, tty->pgid 14208, tty->sid 7068
   85  153809 [main] georgeMary 9036 _pinfo::set_ctty: cygheap->ctty now 0x180308230, archetype 0x180308230
   86  153895 [main] georgeMary 9036 fhandler_pty_slave::open_setup: /dev/pty1 opened, usecount 4
  217  154112 [main] georgeMary 9036 __set_errno: void dll_crt0_1(void*):992 setting errno 0
 1138  155250 [main] georgeMary 9036 sigprocmask: 0 = sigprocmask (0, 0x0, 0x600039C90)
--- Process 9036 thread 11992 created
 1148  156398 [main] georgeMary 9036 sigprocmask: 0 = sigprocmask (0, 0x0, 0x600039D90)
  105  156503 [georgeMary] georgeMary 9036 pthread::thread_init_wrapper: tid 0xFFDFCE00
 2129  158632 [georgeMary] georgeMary 9036 time: 1591515159 = time(0x0)
--- Process 9036 thread 9536 created
 2515  161147 [georgeMary] georgeMary 9036 pthread::thread_init_wrapper: tid 0xFFBFCE00
 1835  162982 [georgeMary] georgeMary 9036 pwdgrp::fetch_account_from_windows: line: <Administrators:S-1-5-32-544:544:>
  177  163159 [georgeMary] georgeMary 9036 stat64: entering
  227  163386 [georgeMary] georgeMary 9036 normalize_posix_path: src /dev
   84  163470 [georgeMary] georgeMary 9036 normalize_posix_path: /dev = normalize_posix_path (/dev)
   73  163543 [georgeMary] georgeMary 9036 mount_info::conv_to_win32_path: conv_to_win32_path (/dev)
  102  163645 [georgeMary] georgeMary 9036 mount_info::conv_to_win32_path: iscygdrive (/dev) mount_table->cygdrive /
   73  163718 [georgeMary] georgeMary 9036 mount_info::cygdrive_win32_path: src '/dev', dst ''
   75  163793 [georgeMary] georgeMary 9036 mount_info::conv_to_win32_path:  mount[0] .. checking /bin -> C:\msys64\usr\bin
   95  163888 [georgeMary] georgeMary 9036 mount_info::conv_to_win32_path:  mount[1] .. checking / -> C:\msys64
   99  163987 [georgeMary] georgeMary 9036 set_flags: flags: binary (0x2)
   93  164080 [georgeMary] georgeMary 9036 mount_info::conv_to_win32_path: src_path /dev, dst C:\msys64\dev, flags 0x3200A, rc 0
  383  164463 [georgeMary] georgeMary 9036 symlink_info::check: 0x0 = NtCreateFile (\??\C:\msys64\dev)
  241  164704 [georgeMary] georgeMary 9036 symlink_info::check: not a symlink
  107  164811 [georgeMary] georgeMary 9036 symlink_info::check: 0 = symlink.check(C:\msys64\dev, 0xFFDFB7D0) (0x43200A)
  125  164936 [georgeMary] georgeMary 9036 build_fh_pc: fh 0x180308DA8, dev 000000C1
  128  165064 [georgeMary] georgeMary 9036 stat_worker: (\??\C:\msys64\dev, 0x1802DDAA0, 0x180308DA8), file_attributes 16
  115  165179 [georgeMary] georgeMary 9036 fhandler_base::fstat_helper: 0 = fstat (\??\C:\msys64\dev, 0x1802DDAA0) st_size=0, st_mode=040755, st_ino=2251799814545287st_atim=5C1D9058.25263FD4 st_ctim=5C1D9058.25263FD4 st_mtim=5C1D9058.25263FD4 st_birthtim=5C1D9057.10BD8750
  110  165289 [georgeMary] georgeMary 9036 stat_worker: 0 = (\??\C:\msys64\dev,0x1802DDAA0)
  132  165421 [georgeMary] georgeMary 9036 fstat64: 0 = fstat(1, 0xFFDFCB00)
  180  165601 [georgeMary] georgeMary 9036 isatty: 1 = isatty(1)
  281  165882 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
   78  165960 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   87  166047 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   80  166127 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
George
  105  166232 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  532  166764 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  222  166986 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
  100  167086 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   72  167158 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   73  167231 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
   94  167325 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  532  167857 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  242  168099 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 5)
   84  168183 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   92  168275 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   95  168370 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
Mary
  113  168483 [georgeMary] georgeMary 9036 write: 5 = write(1, 0x600071EC0, 5)
  330  168813 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (2.000000000)
997682 1166495 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  837 1167332 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
  228 1167560 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  218 1167778 [main] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  139 1167917 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
  440 1168357 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
George
  135 1168492 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  508 1169000 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  439 1169439 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
  133 1169572 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  177 1169749 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
  131 1169880 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
   78 1169958 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  432 1170390 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
998528 2168918 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
 1076 2169994 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 2.000000000, 0.d)
  122 2170116 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
  106 2170222 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  104 2170326 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   95 2170421 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
George
   91 2170512 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  590 2171102 [main] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  108 2171210 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  557 2171767 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 5)
   95 2171862 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  119 2171981 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
Mary
  123 2172104 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
  125 2172229 [georgeMary] georgeMary 9036 write: 5 = write(1, 0x600071EC0, 5)
  511 2172740 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (2.000000000)
  214 2172954 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
   78 2173032 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   79 2173111 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   87 2173198 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
   95 2173293 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  326 2173619 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
997809 3171428 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  960 3172388 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
  107 3172495 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  171 3172666 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
George
  147 3172813 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
  139 3172952 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  456 3173408 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
   96 3173504 [main] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  460 3173964 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
  158 3174122 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   90 3174212 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
  143 3174355 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
   88 3174443 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  305 3174748 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
998095 4172843 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 2.000000000, 0.d)
  774 4173617 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 5)
  169 4173786 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  115 4173901 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
  142 4174043 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  185 4174228 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
Mary
  313 4174541 [georgeMary] georgeMary 9036 write: 5 = write(1, 0x600071EC0, 5)
  525 4175066 [main] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  668 4175734 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (2.000000000)
  142 4175876 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
   71 4175947 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   74 4176021 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   75 4176096 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
George
   82 4176178 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  449 4176627 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  213 4176840 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
   77 4176917 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   76 4176993 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   80 4177073 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
  119 4177192 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  345 4177537 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
998657 5176194 [georgeMary] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  734 5176928 [georgeMary] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 7)
  112 5177040 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
  108 5177148 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
  130 5177278 [georgeMary] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
George
  341 5177619 [georgeMary] georgeMary 9036 write: 7 = write(1, 0x600071EC0, 7)
  508 5178127 [main] georgeMary 9036 clock_nanosleep: 0 = clock_nanosleep(1, 0, 1.000000000, 0.d)
  101 5178228 [georgeMary] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
  665 5178893 [main] georgeMary 9036 fhandler_pty_slave::write: pty1, write(0x600071EC0, 17)
   91 5178984 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex (0x13C): waiting -1 ms
   75 5179059 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1914): pty output_mutex: acquired
   85 5179144 [main] georgeMary 9036 fhandler_pty_common::process_opost_output: (1953): pty output_mutex(0x13C) released
----------------
  100 5179244 [main] georgeMary 9036 write: 17 = write(1, 0x600071EC0, 17)
  334 5179578 [main] georgeMary 9036 clock_nanosleep: clock_nanosleep (1.000000000)
888516 6068094 [sig] georgeMary 9036 sigpacket::process: signal 2 processing
  180 6068274 [sig] georgeMary 9036 init_cygheap::find_tls: sig 2

```

