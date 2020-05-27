# @2
mov $2, %eax
# D=A
movl %eax, %ebx
mov %ebx, %edx
# @3
mov $3, %eax
# D=D+A
movl %edx, %ebx
addl %eax, %ebx
mov %ebx, %edx
# @0
mov $0, %eax
# M=D
movl %edx, %ebx
mov %ebx, _m(%eax,%eax)
