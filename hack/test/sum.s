L0: # @10
  mov $10, %eax
L1: # D=A
  movl %eax, %ebx
  mov %ebx, %edx
L2: # @0
  mov $0, %eax
L3: # M=D
  movl %edx, %ebx
  mov %ebx, _m(%eax,%eax)
L4: # @16
  mov $16, %eax
L5: # M=1
  movl $1, %ebx
  mov %ebx, _m(%eax,%eax)
L6: # @17
  mov $17, %eax
L7: # M=0
  movl $0, %ebx
  mov %ebx, _m(%eax,%eax)
L8: # @16
  mov $16, %eax
L9: # D=M
  movl _m(%eax,%eax), %ebx
  mov %ebx, %edx
L10: # @0
  mov $0, %eax
L11: # D=D-M
  movl %edx, %ebx
  movl _m(%eax,%eax), %ecx
  subl %ecx, %ebx
  mov %ebx, %edx
L12: # @22
  mov $22, %eax
L13: # D;JGT
  movl %edx, %ebx
  testw	%bx, %bx
  JGT *%eax
L14: # @16
  mov $16, %eax
L15: # D=M
  movl _m(%eax,%eax), %ebx
  mov %ebx, %edx
L16: # @17
  mov $17, %eax
L17: # M=D+M
  movl _m(%eax,%eax), %ebx
  addl %edx, %ebx
  mov %ebx, _m(%eax,%eax)
L18: # @16
  mov $16, %eax
L19: # M=M+1
  movl _m(%eax,%eax), %ebx
  addl $1, %ebx
  mov %ebx, _m(%eax,%eax)
L20: # @8
  mov $8, %eax
L21: # 0;JMP
  movl $0, %ebx
  testw	%bx, %bx
  JMP *%eax
L22: # @17
  mov $17, %eax
L23: # D=M
  movl _m(%eax,%eax), %ebx
  mov %ebx, %edx
L24: # @1
  mov $1, %eax
L25: # M=D
  movl %edx, %ebx
  mov %ebx, _m(%eax,%eax)

.data
.align 4
JumpTable:
  .long L0
  .long L1
  .long L2
  .long L3
  .long L4
  .long L5
  .long L6
  .long L7
  .long L8
  .long L9
  .long L10
  .long L11
  .long L12
  .long L13
  .long L14
  .long L15
  .long L16
  .long L17
  .long L18
  .long L19
  .long L20
  .long L21
  .long L22
  .long L23
  .long L24
  .long L25
