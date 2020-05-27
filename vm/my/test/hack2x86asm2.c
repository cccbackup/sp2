short m[32768];

void test() {
  register short D, A;
loop:
  D = 1;     // movl	$1, %edx
  D = !D;    // testw	%dx, %dx; sete %bl; movzbl %bl, %edx
  D = -D;
  A = D+1;   // movl	%edx, %eax; addl	$1, %eax
  D = D&A;   // movl  %edx, %ebx; andl %ebx, %eax; movl %ebx, %edx;
  m[A] = D;  // movw	%dx, _m(%eax,%eax)
  D = m[A]-1;// movzwl	_m(%eax,%eax), %ebx; sub $1, ebx; movl %ebx, %edx;
  if (D <= 0) goto loop; // testw	%dx, %dx; jlt loop;
  if (A+1 > 0) goto loop; // addl	$1, %eax; testl %eax, %eax; jgt loop
}

/*
SETE help. Sets the destination operand to 0 or 1 depending on the settings of the status flags (CF, SF, OF, ZF, and PF) in the EFLAGS register. The destination operand points to a byte register or a byte in memory. ... 0F 94 SETE r/m8 M Valid Valid Set byte if equal (ZF=1).
*/