# write(1, message, 13)
.macro write_str fd, msg, len
  mov     $1, %rax            # system call 1 is write
  mov     \fd, %rdi           # file handle 1 is stdout
  mov     \msg, %rsi          # address of string to output
  mov     \len, %rdx          # number of bytes
  syscall
.endm