short D=0, A=0;
short m[32768];

void test() {
  D = 1;     // movw	$1, _D
  D = A+1;   // movzwl	_A, %eax; addl	$1, %eax;	movw	%ax, _D
  A = D&A;   // movzwl	_A, %eax
  m[A] = D;  // 
  D = m[A]-1;// 
}
