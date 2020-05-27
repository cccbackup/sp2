// Mutual exclusion lock.
/*
xv6 用结构体 `struct spinlock`（1401）。该结构体中的关键成员是 `locked` 。
这是一个字，在锁可以被获得时值为0，而当锁已经被获得时值为非零。
*/
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
  uint pcs[10];      // The call stack (an array of program counters)
                     // that locked the lock.
};

