// https://stackoverflow.com/questions/7656549/understanding-requirements-for-execve-and-setting-environment-vars
#include <stdio.h>

int main(int argc, char *argv[], char *envp[])
{
    while(*envp)
        printf("%s\n",*envp++);
}

/*
In Unix systems you can define main a third way, using three arguments:

int main (int argc, char *argv[], char *envp[])

https://stackoverflow.com/questions/31034993/how-does-a-program-inherit-environment-variables

The C library copies the envp argument into the environ global variable somewhere in its startup code, 
before it calls main: for instance, GNU libc does this in _init and musl libc does it in __init_libc.
 (You may find musl libc's code easier to trace through than GNU libc's.) Conversely, if you start a 
 program using one of the exec wrapper functions that don't take an explicit environment vector, the 
 C library supplies environ as the third argument to execve. Inheritance of environment variables is 
 thus strictly a user-space convention. As far as the kernel is concerned, each program receives two 
 argument vectors, and it doesn't care what's in them.
*/