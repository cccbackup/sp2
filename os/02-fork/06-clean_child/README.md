
* [Advanced Linux Programming](http://discourse-production.oss-cn-shanghai.aliyuncs.com/original/3X/f/4/f4c905949ecd71ab2889b4fd10b1e11910b67460.pdf)

```c
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
sig_atomic_t child_exit_status;
void clean_up_child_process (int signal_number)
{
  /* Clean up the child process. */
  int status;
  wait (&status);
  /* Store its exit status in a global variable. */
  child_exit_status = status;
}
int main ()
{
  /* Handle SIGCHLD by calling clean_up_child_process. */
  struct sigaction sigchld_action;
  memset (&sigchld_action, 0, sizeof (sigchld_action));
  sigchld_action.sa_handler = &clean_up_child_process;
  sigaction (SIGCHLD, &sigchld_action, NULL);
  /* Now do things, including forking a child process. */
  /* ... */
  return 0;
}
```

