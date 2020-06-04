# MSYS2

根目錄在

```
C:\msys64
```

## MSYS/MINGW64/MINGW32 三個 SHELL 版本的差異

* https://sourceforge.net/p/msys2/discussion/general/thread/dcf8f4d3/

When you start any of the MSYS2 shells, they all start an MSYS2 bash
program. Since it's a MSYS2 bash, it understands Unix paths and will do
translation when calling native Windows executables.

That being said, what is the difference between all the shells? It all
about the tweaking some environment variables to change default programs
picked when calling them. It's mainly about the PATH environment variable
but it also involves MSYSTEM PKG_CONFIG_PATH ACLOCAL_PATH MANPATH like Ray
said earlier. Checkout /etc/profile around line 28 to see the conditional
that sets all this.

Let's assume you have installed three toolchains:

* MSYS2 (package group msys2-devel) to compile MSYS2 tools which installs gcc in /usr/bin.
* MINGW32 (package group mingw-w64-i686-toolchain) to compile Windows native 32 bits executable which installs gcc in /mingw32/bin.
* MINGW64 (package group mingw-w64-x86_64-toolchain) to compile Windows native 64 bits executable which installs gcc in /mingw64/bin.

For msys2_shell, PATH is roughly only /usr/local/bin:/usr/bin:/bin. This
means that when running gcc, you will get /usr/bin/gcc.

For mingw32_shell, PATH is roughly
/mingw32/bin:/usr/local/bin:/usr/bin:/bin. This means that now, running
gcc you will get instead /mingw32/bin/gcc.

For mingw64_shell, PATH is roughly
/mingw64/bin:/usr/local/bin:/usr/bin:/bin and as you have guessed,
running gcc you will get instead /mingw64/bin/gcc.

This means that all three shells have the same capabilities, but because of
the different orders, tools that will be picked are different. So, if you
want to compile something, use the appropriate shell for what you want to
do (MSYS2 program, Windows native 32 bits or Windows native 64 bits).

If you are not compiling anything, then it depends. Usually, msys2_shell is
recommended. However, on a bare installation, /mingw64/bin is not added
anywhere when using msys2_shell, problem it can causes is that if you had
installed mingw64 packages, they are not available in the shell. In my
case, I have tweaked by .bash_profile to correctly add /mingw64/bin
after PATH (like /usr/local/bin:/usr/bin:/bin:/mingw64/bin). This
always favor MSYS2 tools but will pick /mingw64/bin when they don't exist
in MSYS2 /usr/bin.

