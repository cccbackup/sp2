#include <stdio.h>
#include <unistd.h>

int main() {
  char *arg[] = {"ls", "-l", NULL };
  printf("execvp():before\n");
  execvp(arg[0], arg);
  printf("execvp():after\n");
}
