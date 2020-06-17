
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	80010113          	addi	sp,sp,-2048 # 80008800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00008617          	auipc	a2,0x8
    8000004e:	fb660613          	addi	a2,a2,-74 # 80008000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	8c478793          	addi	a5,a5,-1852 # 80005920 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd97e3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	c7a78793          	addi	a5,a5,-902 # 80000d20 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7119                	addi	sp,sp,-128
    800000e2:	fc86                	sd	ra,120(sp)
    800000e4:	f8a2                	sd	s0,112(sp)
    800000e6:	f4a6                	sd	s1,104(sp)
    800000e8:	f0ca                	sd	s2,96(sp)
    800000ea:	ecce                	sd	s3,88(sp)
    800000ec:	e8d2                	sd	s4,80(sp)
    800000ee:	e4d6                	sd	s5,72(sp)
    800000f0:	e0da                	sd	s6,64(sp)
    800000f2:	fc5e                	sd	s7,56(sp)
    800000f4:	f862                	sd	s8,48(sp)
    800000f6:	f466                	sd	s9,40(sp)
    800000f8:	f06a                	sd	s10,32(sp)
    800000fa:	ec6e                	sd	s11,24(sp)
    800000fc:	0100                	addi	s0,sp,128
    800000fe:	8b2a                	mv	s6,a0
    80000100:	8aae                	mv	s5,a1
    80000102:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000104:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000108:	00010517          	auipc	a0,0x10
    8000010c:	6f850513          	addi	a0,a0,1784 # 80010800 <cons>
    80000110:	00001097          	auipc	ra,0x1
    80000114:	9c2080e7          	jalr	-1598(ra) # 80000ad2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000118:	00010497          	auipc	s1,0x10
    8000011c:	6e848493          	addi	s1,s1,1768 # 80010800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000120:	89a6                	mv	s3,s1
    80000122:	00010917          	auipc	s2,0x10
    80000126:	77690913          	addi	s2,s2,1910 # 80010898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000012a:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000012c:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012e:	4da9                	li	s11,10
  while(n > 0){
    80000130:	07405863          	blez	s4,800001a0 <consoleread+0xc0>
    while(cons.r == cons.w){
    80000134:	0984a783          	lw	a5,152(s1)
    80000138:	09c4a703          	lw	a4,156(s1)
    8000013c:	02f71463          	bne	a4,a5,80000164 <consoleread+0x84>
      if(myproc()->killed){
    80000140:	00001097          	auipc	ra,0x1
    80000144:	704080e7          	jalr	1796(ra) # 80001844 <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	e96080e7          	jalr	-362(ra) # 80001fe6 <sleep>
    while(cons.r == cons.w){
    80000158:	0984a783          	lw	a5,152(s1)
    8000015c:	09c4a703          	lw	a4,156(s1)
    80000160:	fef700e3          	beq	a4,a5,80000140 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000164:	0017871b          	addiw	a4,a5,1
    80000168:	08e4ac23          	sw	a4,152(s1)
    8000016c:	07f7f713          	andi	a4,a5,127
    80000170:	9726                	add	a4,a4,s1
    80000172:	01874703          	lbu	a4,24(a4)
    80000176:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    8000017a:	079c0663          	beq	s8,s9,800001e6 <consoleread+0x106>
    cbuf = c;
    8000017e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000182:	4685                	li	a3,1
    80000184:	f8f40613          	addi	a2,s0,-113
    80000188:	85d6                	mv	a1,s5
    8000018a:	855a                	mv	a0,s6
    8000018c:	00002097          	auipc	ra,0x2
    80000190:	0ba080e7          	jalr	186(ra) # 80002246 <either_copyout>
    80000194:	01a50663          	beq	a0,s10,800001a0 <consoleread+0xc0>
    dst++;
    80000198:	0a85                	addi	s5,s5,1
    --n;
    8000019a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000019c:	f9bc1ae3          	bne	s8,s11,80000130 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001a0:	00010517          	auipc	a0,0x10
    800001a4:	66050513          	addi	a0,a0,1632 # 80010800 <cons>
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	97e080e7          	jalr	-1666(ra) # 80000b26 <release>

  return target - n;
    800001b0:	414b853b          	subw	a0,s7,s4
    800001b4:	a811                	j	800001c8 <consoleread+0xe8>
        release(&cons.lock);
    800001b6:	00010517          	auipc	a0,0x10
    800001ba:	64a50513          	addi	a0,a0,1610 # 80010800 <cons>
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	968080e7          	jalr	-1688(ra) # 80000b26 <release>
        return -1;
    800001c6:	557d                	li	a0,-1
}
    800001c8:	70e6                	ld	ra,120(sp)
    800001ca:	7446                	ld	s0,112(sp)
    800001cc:	74a6                	ld	s1,104(sp)
    800001ce:	7906                	ld	s2,96(sp)
    800001d0:	69e6                	ld	s3,88(sp)
    800001d2:	6a46                	ld	s4,80(sp)
    800001d4:	6aa6                	ld	s5,72(sp)
    800001d6:	6b06                	ld	s6,64(sp)
    800001d8:	7be2                	ld	s7,56(sp)
    800001da:	7c42                	ld	s8,48(sp)
    800001dc:	7ca2                	ld	s9,40(sp)
    800001de:	7d02                	ld	s10,32(sp)
    800001e0:	6de2                	ld	s11,24(sp)
    800001e2:	6109                	addi	sp,sp,128
    800001e4:	8082                	ret
      if(n < target){
    800001e6:	000a071b          	sext.w	a4,s4
    800001ea:	fb777be3          	bgeu	a4,s7,800001a0 <consoleread+0xc0>
        cons.r--;
    800001ee:	00010717          	auipc	a4,0x10
    800001f2:	6af72523          	sw	a5,1706(a4) # 80010898 <cons+0x98>
    800001f6:	b76d                	j	800001a0 <consoleread+0xc0>

00000000800001f8 <consputc>:
  if(panicked){
    800001f8:	00025797          	auipc	a5,0x25
    800001fc:	e087a783          	lw	a5,-504(a5) # 80025000 <panicked>
    80000200:	c391                	beqz	a5,80000204 <consputc+0xc>
    for(;;)
    80000202:	a001                	j	80000202 <consputc+0xa>
{
    80000204:	1141                	addi	sp,sp,-16
    80000206:	e406                	sd	ra,8(sp)
    80000208:	e022                	sd	s0,0(sp)
    8000020a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000020c:	10000793          	li	a5,256
    80000210:	00f50a63          	beq	a0,a5,80000224 <consputc+0x2c>
    uartputc(c);
    80000214:	00000097          	auipc	ra,0x0
    80000218:	5d2080e7          	jalr	1490(ra) # 800007e6 <uartputc>
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000224:	4521                	li	a0,8
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	5c0080e7          	jalr	1472(ra) # 800007e6 <uartputc>
    8000022e:	02000513          	li	a0,32
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5b4080e7          	jalr	1460(ra) # 800007e6 <uartputc>
    8000023a:	4521                	li	a0,8
    8000023c:	00000097          	auipc	ra,0x0
    80000240:	5aa080e7          	jalr	1450(ra) # 800007e6 <uartputc>
    80000244:	bfe1                	j	8000021c <consputc+0x24>

0000000080000246 <consolewrite>:
{
    80000246:	715d                	addi	sp,sp,-80
    80000248:	e486                	sd	ra,72(sp)
    8000024a:	e0a2                	sd	s0,64(sp)
    8000024c:	fc26                	sd	s1,56(sp)
    8000024e:	f84a                	sd	s2,48(sp)
    80000250:	f44e                	sd	s3,40(sp)
    80000252:	f052                	sd	s4,32(sp)
    80000254:	ec56                	sd	s5,24(sp)
    80000256:	0880                	addi	s0,sp,80
    80000258:	89aa                	mv	s3,a0
    8000025a:	84ae                	mv	s1,a1
    8000025c:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    8000025e:	00010517          	auipc	a0,0x10
    80000262:	5a250513          	addi	a0,a0,1442 # 80010800 <cons>
    80000266:	00001097          	auipc	ra,0x1
    8000026a:	86c080e7          	jalr	-1940(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    8000026e:	03505e63          	blez	s5,800002aa <consolewrite+0x64>
    80000272:	00148913          	addi	s2,s1,1
    80000276:	fffa879b          	addiw	a5,s5,-1
    8000027a:	1782                	slli	a5,a5,0x20
    8000027c:	9381                	srli	a5,a5,0x20
    8000027e:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000280:	5a7d                	li	s4,-1
    80000282:	4685                	li	a3,1
    80000284:	8626                	mv	a2,s1
    80000286:	85ce                	mv	a1,s3
    80000288:	fbf40513          	addi	a0,s0,-65
    8000028c:	00002097          	auipc	ra,0x2
    80000290:	010080e7          	jalr	16(ra) # 8000229c <either_copyin>
    80000294:	01450b63          	beq	a0,s4,800002aa <consolewrite+0x64>
    consputc(c);
    80000298:	fbf44503          	lbu	a0,-65(s0)
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	f5c080e7          	jalr	-164(ra) # 800001f8 <consputc>
  for(i = 0; i < n; i++){
    800002a4:	0485                	addi	s1,s1,1
    800002a6:	fd249ee3          	bne	s1,s2,80000282 <consolewrite+0x3c>
  release(&cons.lock);
    800002aa:	00010517          	auipc	a0,0x10
    800002ae:	55650513          	addi	a0,a0,1366 # 80010800 <cons>
    800002b2:	00001097          	auipc	ra,0x1
    800002b6:	874080e7          	jalr	-1932(ra) # 80000b26 <release>
}
    800002ba:	8556                	mv	a0,s5
    800002bc:	60a6                	ld	ra,72(sp)
    800002be:	6406                	ld	s0,64(sp)
    800002c0:	74e2                	ld	s1,56(sp)
    800002c2:	7942                	ld	s2,48(sp)
    800002c4:	79a2                	ld	s3,40(sp)
    800002c6:	7a02                	ld	s4,32(sp)
    800002c8:	6ae2                	ld	s5,24(sp)
    800002ca:	6161                	addi	sp,sp,80
    800002cc:	8082                	ret

00000000800002ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	e04a                	sd	s2,0(sp)
    800002d8:	1000                	addi	s0,sp,32
    800002da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002dc:	00010517          	auipc	a0,0x10
    800002e0:	52450513          	addi	a0,a0,1316 # 80010800 <cons>
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	7ee080e7          	jalr	2030(ra) # 80000ad2 <acquire>

  switch(c){
    800002ec:	47d5                	li	a5,21
    800002ee:	0af48663          	beq	s1,a5,8000039a <consoleintr+0xcc>
    800002f2:	0297ca63          	blt	a5,s1,80000326 <consoleintr+0x58>
    800002f6:	47a1                	li	a5,8
    800002f8:	0ef48763          	beq	s1,a5,800003e6 <consoleintr+0x118>
    800002fc:	47c1                	li	a5,16
    800002fe:	10f49a63          	bne	s1,a5,80000412 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000302:	00002097          	auipc	ra,0x2
    80000306:	ff0080e7          	jalr	-16(ra) # 800022f2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000030a:	00010517          	auipc	a0,0x10
    8000030e:	4f650513          	addi	a0,a0,1270 # 80010800 <cons>
    80000312:	00001097          	auipc	ra,0x1
    80000316:	814080e7          	jalr	-2028(ra) # 80000b26 <release>
}
    8000031a:	60e2                	ld	ra,24(sp)
    8000031c:	6442                	ld	s0,16(sp)
    8000031e:	64a2                	ld	s1,8(sp)
    80000320:	6902                	ld	s2,0(sp)
    80000322:	6105                	addi	sp,sp,32
    80000324:	8082                	ret
  switch(c){
    80000326:	07f00793          	li	a5,127
    8000032a:	0af48e63          	beq	s1,a5,800003e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000032e:	00010717          	auipc	a4,0x10
    80000332:	4d270713          	addi	a4,a4,1234 # 80010800 <cons>
    80000336:	0a072783          	lw	a5,160(a4)
    8000033a:	09872703          	lw	a4,152(a4)
    8000033e:	9f99                	subw	a5,a5,a4
    80000340:	07f00713          	li	a4,127
    80000344:	fcf763e3          	bltu	a4,a5,8000030a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000348:	47b5                	li	a5,13
    8000034a:	0cf48763          	beq	s1,a5,80000418 <consoleintr+0x14a>
      consputc(c);
    8000034e:	8526                	mv	a0,s1
    80000350:	00000097          	auipc	ra,0x0
    80000354:	ea8080e7          	jalr	-344(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000358:	00010797          	auipc	a5,0x10
    8000035c:	4a878793          	addi	a5,a5,1192 # 80010800 <cons>
    80000360:	0a07a703          	lw	a4,160(a5)
    80000364:	0017069b          	addiw	a3,a4,1
    80000368:	0006861b          	sext.w	a2,a3
    8000036c:	0ad7a023          	sw	a3,160(a5)
    80000370:	07f77713          	andi	a4,a4,127
    80000374:	97ba                	add	a5,a5,a4
    80000376:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000037a:	47a9                	li	a5,10
    8000037c:	0cf48563          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000380:	4791                	li	a5,4
    80000382:	0cf48263          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000386:	00010797          	auipc	a5,0x10
    8000038a:	5127a783          	lw	a5,1298(a5) # 80010898 <cons+0x98>
    8000038e:	0807879b          	addiw	a5,a5,128
    80000392:	f6f61ce3          	bne	a2,a5,8000030a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000396:	863e                	mv	a2,a5
    80000398:	a07d                	j	80000446 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000039a:	00010717          	auipc	a4,0x10
    8000039e:	46670713          	addi	a4,a4,1126 # 80010800 <cons>
    800003a2:	0a072783          	lw	a5,160(a4)
    800003a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	00010497          	auipc	s1,0x10
    800003ae:	45648493          	addi	s1,s1,1110 # 80010800 <cons>
    while(cons.e != cons.w &&
    800003b2:	4929                	li	s2,10
    800003b4:	f4f70be3          	beq	a4,a5,8000030a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b8:	37fd                	addiw	a5,a5,-1
    800003ba:	07f7f713          	andi	a4,a5,127
    800003be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c0:	01874703          	lbu	a4,24(a4)
    800003c4:	f52703e3          	beq	a4,s2,8000030a <consoleintr+0x3c>
      cons.e--;
    800003c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003cc:	10000513          	li	a0,256
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	e28080e7          	jalr	-472(ra) # 800001f8 <consputc>
    while(cons.e != cons.w &&
    800003d8:	0a04a783          	lw	a5,160(s1)
    800003dc:	09c4a703          	lw	a4,156(s1)
    800003e0:	fcf71ce3          	bne	a4,a5,800003b8 <consoleintr+0xea>
    800003e4:	b71d                	j	8000030a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e6:	00010717          	auipc	a4,0x10
    800003ea:	41a70713          	addi	a4,a4,1050 # 80010800 <cons>
    800003ee:	0a072783          	lw	a5,160(a4)
    800003f2:	09c72703          	lw	a4,156(a4)
    800003f6:	f0f70ae3          	beq	a4,a5,8000030a <consoleintr+0x3c>
      cons.e--;
    800003fa:	37fd                	addiw	a5,a5,-1
    800003fc:	00010717          	auipc	a4,0x10
    80000400:	4af72223          	sw	a5,1188(a4) # 800108a0 <cons+0xa0>
      consputc(BACKSPACE);
    80000404:	10000513          	li	a0,256
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	df0080e7          	jalr	-528(ra) # 800001f8 <consputc>
    80000410:	bded                	j	8000030a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000412:	ee048ce3          	beqz	s1,8000030a <consoleintr+0x3c>
    80000416:	bf21                	j	8000032e <consoleintr+0x60>
      consputc(c);
    80000418:	4529                	li	a0,10
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	dde080e7          	jalr	-546(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000422:	00010797          	auipc	a5,0x10
    80000426:	3de78793          	addi	a5,a5,990 # 80010800 <cons>
    8000042a:	0a07a703          	lw	a4,160(a5)
    8000042e:	0017069b          	addiw	a3,a4,1
    80000432:	0006861b          	sext.w	a2,a3
    80000436:	0ad7a023          	sw	a3,160(a5)
    8000043a:	07f77713          	andi	a4,a4,127
    8000043e:	97ba                	add	a5,a5,a4
    80000440:	4729                	li	a4,10
    80000442:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000446:	00010797          	auipc	a5,0x10
    8000044a:	44c7ab23          	sw	a2,1110(a5) # 8001089c <cons+0x9c>
        wakeup(&cons.r);
    8000044e:	00010517          	auipc	a0,0x10
    80000452:	44a50513          	addi	a0,a0,1098 # 80010898 <cons+0x98>
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	d16080e7          	jalr	-746(ra) # 8000216c <wakeup>
    8000045e:	b575                	j	8000030a <consoleintr+0x3c>

0000000080000460 <consoleinit>:

void
consoleinit(void)
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e406                	sd	ra,8(sp)
    80000464:	e022                	sd	s0,0(sp)
    80000466:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000468:	00006597          	auipc	a1,0x6
    8000046c:	cb058593          	addi	a1,a1,-848 # 80006118 <userret+0x88>
    80000470:	00010517          	auipc	a0,0x10
    80000474:	39050513          	addi	a0,a0,912 # 80010800 <cons>
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	548080e7          	jalr	1352(ra) # 800009c0 <initlock>

  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00020797          	auipc	a5,0x20
    8000048c:	5b878793          	addi	a5,a5,1464 # 80020a40 <devsw>
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5070713          	addi	a4,a4,-944 # 800000e0 <consoleread>
    80000498:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000049a:	00000717          	auipc	a4,0x0
    8000049e:	dac70713          	addi	a4,a4,-596 # 80000246 <consolewrite>
    800004a2:	ef98                	sd	a4,24(a5)
}
    800004a4:	60a2                	ld	ra,8(sp)
    800004a6:	6402                	ld	s0,0(sp)
    800004a8:	0141                	addi	sp,sp,16
    800004aa:	8082                	ret

00000000800004ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ac:	7179                	addi	sp,sp,-48
    800004ae:	f406                	sd	ra,40(sp)
    800004b0:	f022                	sd	s0,32(sp)
    800004b2:	ec26                	sd	s1,24(sp)
    800004b4:	e84a                	sd	s2,16(sp)
    800004b6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b8:	c219                	beqz	a2,800004be <printint+0x12>
    800004ba:	08054663          	bltz	a0,80000546 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004be:	2501                	sext.w	a0,a0
    800004c0:	4881                	li	a7,0
    800004c2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c8:	2581                	sext.w	a1,a1
    800004ca:	00006617          	auipc	a2,0x6
    800004ce:	34660613          	addi	a2,a2,838 # 80006810 <digits>
    800004d2:	883a                	mv	a6,a4
    800004d4:	2705                	addiw	a4,a4,1
    800004d6:	02b577bb          	remuw	a5,a0,a1
    800004da:	1782                	slli	a5,a5,0x20
    800004dc:	9381                	srli	a5,a5,0x20
    800004de:	97b2                	add	a5,a5,a2
    800004e0:	0007c783          	lbu	a5,0(a5)
    800004e4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e8:	0005079b          	sext.w	a5,a0
    800004ec:	02b5553b          	divuw	a0,a0,a1
    800004f0:	0685                	addi	a3,a3,1
    800004f2:	feb7f0e3          	bgeu	a5,a1,800004d2 <printint+0x26>

  if(sign)
    800004f6:	00088b63          	beqz	a7,8000050c <printint+0x60>
    buf[i++] = '-';
    800004fa:	fe040793          	addi	a5,s0,-32
    800004fe:	973e                	add	a4,a4,a5
    80000500:	02d00793          	li	a5,45
    80000504:	fef70823          	sb	a5,-16(a4)
    80000508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000050c:	02e05763          	blez	a4,8000053a <printint+0x8e>
    80000510:	fd040793          	addi	a5,s0,-48
    80000514:	00e784b3          	add	s1,a5,a4
    80000518:	fff78913          	addi	s2,a5,-1
    8000051c:	993a                	add	s2,s2,a4
    8000051e:	377d                	addiw	a4,a4,-1
    80000520:	1702                	slli	a4,a4,0x20
    80000522:	9301                	srli	a4,a4,0x20
    80000524:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000528:	fff4c503          	lbu	a0,-1(s1)
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	ccc080e7          	jalr	-820(ra) # 800001f8 <consputc>
  while(--i >= 0)
    80000534:	14fd                	addi	s1,s1,-1
    80000536:	ff2499e3          	bne	s1,s2,80000528 <printint+0x7c>
}
    8000053a:	70a2                	ld	ra,40(sp)
    8000053c:	7402                	ld	s0,32(sp)
    8000053e:	64e2                	ld	s1,24(sp)
    80000540:	6942                	ld	s2,16(sp)
    80000542:	6145                	addi	sp,sp,48
    80000544:	8082                	ret
    x = -xx;
    80000546:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000054a:	4885                	li	a7,1
    x = -xx;
    8000054c:	bf9d                	j	800004c2 <printint+0x16>

000000008000054e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000054e:	1101                	addi	sp,sp,-32
    80000550:	ec06                	sd	ra,24(sp)
    80000552:	e822                	sd	s0,16(sp)
    80000554:	e426                	sd	s1,8(sp)
    80000556:	1000                	addi	s0,sp,32
    80000558:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000055a:	00010797          	auipc	a5,0x10
    8000055e:	3607a323          	sw	zero,870(a5) # 800108c0 <pr+0x18>
  printf("panic: ");
    80000562:	00006517          	auipc	a0,0x6
    80000566:	bbe50513          	addi	a0,a0,-1090 # 80006120 <userret+0x90>
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	02e080e7          	jalr	46(ra) # 80000598 <printf>
  printf(s);
    80000572:	8526                	mv	a0,s1
    80000574:	00000097          	auipc	ra,0x0
    80000578:	024080e7          	jalr	36(ra) # 80000598 <printf>
  printf("\n");
    8000057c:	00006517          	auipc	a0,0x6
    80000580:	c3450513          	addi	a0,a0,-972 # 800061b0 <userret+0x120>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	014080e7          	jalr	20(ra) # 80000598 <printf>
  panicked = 1; // freeze other CPUs
    8000058c:	4785                	li	a5,1
    8000058e:	00025717          	auipc	a4,0x25
    80000592:	a6f72923          	sw	a5,-1422(a4) # 80025000 <panicked>
  for(;;)
    80000596:	a001                	j	80000596 <panic+0x48>

0000000080000598 <printf>:
{
    80000598:	7131                	addi	sp,sp,-192
    8000059a:	fc86                	sd	ra,120(sp)
    8000059c:	f8a2                	sd	s0,112(sp)
    8000059e:	f4a6                	sd	s1,104(sp)
    800005a0:	f0ca                	sd	s2,96(sp)
    800005a2:	ecce                	sd	s3,88(sp)
    800005a4:	e8d2                	sd	s4,80(sp)
    800005a6:	e4d6                	sd	s5,72(sp)
    800005a8:	e0da                	sd	s6,64(sp)
    800005aa:	fc5e                	sd	s7,56(sp)
    800005ac:	f862                	sd	s8,48(sp)
    800005ae:	f466                	sd	s9,40(sp)
    800005b0:	f06a                	sd	s10,32(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d97          	auipc	s11,0x10
    800005ce:	2f6dad83          	lw	s11,758(s11) # 800108c0 <pr+0x18>
  if(locking)
    800005d2:	020d9b63          	bnez	s11,80000608 <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0263          	beqz	s4,8000061a <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	16050263          	beqz	a0,8000074a <printf+0x1b2>
    800005ea:	4481                	li	s1,0
    if(c != '%'){
    800005ec:	02500a93          	li	s5,37
    switch(c){
    800005f0:	07000b13          	li	s6,112
  consputc('x');
    800005f4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f6:	00006b97          	auipc	s7,0x6
    800005fa:	21ab8b93          	addi	s7,s7,538 # 80006810 <digits>
    switch(c){
    800005fe:	07300c93          	li	s9,115
    80000602:	06400c13          	li	s8,100
    80000606:	a82d                	j	80000640 <printf+0xa8>
    acquire(&pr.lock);
    80000608:	00010517          	auipc	a0,0x10
    8000060c:	2a050513          	addi	a0,a0,672 # 800108a8 <pr>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	4c2080e7          	jalr	1218(ra) # 80000ad2 <acquire>
    80000618:	bf7d                	j	800005d6 <printf+0x3e>
    panic("null fmt");
    8000061a:	00006517          	auipc	a0,0x6
    8000061e:	b1650513          	addi	a0,a0,-1258 # 80006130 <userret+0xa0>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f2c080e7          	jalr	-212(ra) # 8000054e <panic>
      consputc(c);
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	bce080e7          	jalr	-1074(ra) # 800001f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000632:	2485                	addiw	s1,s1,1
    80000634:	009a07b3          	add	a5,s4,s1
    80000638:	0007c503          	lbu	a0,0(a5)
    8000063c:	10050763          	beqz	a0,8000074a <printf+0x1b2>
    if(c != '%'){
    80000640:	ff5515e3          	bne	a0,s5,8000062a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000644:	2485                	addiw	s1,s1,1
    80000646:	009a07b3          	add	a5,s4,s1
    8000064a:	0007c783          	lbu	a5,0(a5)
    8000064e:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000652:	cfe5                	beqz	a5,8000074a <printf+0x1b2>
    switch(c){
    80000654:	05678a63          	beq	a5,s6,800006a8 <printf+0x110>
    80000658:	02fb7663          	bgeu	s6,a5,80000684 <printf+0xec>
    8000065c:	09978963          	beq	a5,s9,800006ee <printf+0x156>
    80000660:	07800713          	li	a4,120
    80000664:	0ce79863          	bne	a5,a4,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	85ea                	mv	a1,s10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e32080e7          	jalr	-462(ra) # 800004ac <printint>
      break;
    80000682:	bf45                	j	80000632 <printf+0x9a>
    switch(c){
    80000684:	0b578263          	beq	a5,s5,80000728 <printf+0x190>
    80000688:	0b879663          	bne	a5,s8,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	45a9                	li	a1,10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e0e080e7          	jalr	-498(ra) # 800004ac <printint>
      break;
    800006a6:	b771                	j	80000632 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b8:	03000513          	li	a0,48
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	b3c080e7          	jalr	-1220(ra) # 800001f8 <consputc>
  consputc('x');
    800006c4:	07800513          	li	a0,120
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	b30080e7          	jalr	-1232(ra) # 800001f8 <consputc>
    800006d0:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	03c9d793          	srli	a5,s3,0x3c
    800006d6:	97de                	add	a5,a5,s7
    800006d8:	0007c503          	lbu	a0,0(a5)
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	b1c080e7          	jalr	-1252(ra) # 800001f8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e4:	0992                	slli	s3,s3,0x4
    800006e6:	397d                	addiw	s2,s2,-1
    800006e8:	fe0915e3          	bnez	s2,800006d2 <printf+0x13a>
    800006ec:	b799                	j	80000632 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006ee:	f8843783          	ld	a5,-120(s0)
    800006f2:	00878713          	addi	a4,a5,8
    800006f6:	f8e43423          	sd	a4,-120(s0)
    800006fa:	0007b903          	ld	s2,0(a5)
    800006fe:	00090e63          	beqz	s2,8000071a <printf+0x182>
      for(; *s; s++)
    80000702:	00094503          	lbu	a0,0(s2)
    80000706:	d515                	beqz	a0,80000632 <printf+0x9a>
        consputc(*s);
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	af0080e7          	jalr	-1296(ra) # 800001f8 <consputc>
      for(; *s; s++)
    80000710:	0905                	addi	s2,s2,1
    80000712:	00094503          	lbu	a0,0(s2)
    80000716:	f96d                	bnez	a0,80000708 <printf+0x170>
    80000718:	bf29                	j	80000632 <printf+0x9a>
        s = "(null)";
    8000071a:	00006917          	auipc	s2,0x6
    8000071e:	a0e90913          	addi	s2,s2,-1522 # 80006128 <userret+0x98>
      for(; *s; s++)
    80000722:	02800513          	li	a0,40
    80000726:	b7cd                	j	80000708 <printf+0x170>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ace080e7          	jalr	-1330(ra) # 800001f8 <consputc>
      break;
    80000732:	b701                	j	80000632 <printf+0x9a>
      consputc('%');
    80000734:	8556                	mv	a0,s5
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	ac2080e7          	jalr	-1342(ra) # 800001f8 <consputc>
      consputc(c);
    8000073e:	854a                	mv	a0,s2
    80000740:	00000097          	auipc	ra,0x0
    80000744:	ab8080e7          	jalr	-1352(ra) # 800001f8 <consputc>
      break;
    80000748:	b5ed                	j	80000632 <printf+0x9a>
  if(locking)
    8000074a:	020d9163          	bnez	s11,8000076c <printf+0x1d4>
}
    8000074e:	70e6                	ld	ra,120(sp)
    80000750:	7446                	ld	s0,112(sp)
    80000752:	74a6                	ld	s1,104(sp)
    80000754:	7906                	ld	s2,96(sp)
    80000756:	69e6                	ld	s3,88(sp)
    80000758:	6a46                	ld	s4,80(sp)
    8000075a:	6aa6                	ld	s5,72(sp)
    8000075c:	6b06                	ld	s6,64(sp)
    8000075e:	7be2                	ld	s7,56(sp)
    80000760:	7c42                	ld	s8,48(sp)
    80000762:	7ca2                	ld	s9,40(sp)
    80000764:	7d02                	ld	s10,32(sp)
    80000766:	6de2                	ld	s11,24(sp)
    80000768:	6129                	addi	sp,sp,192
    8000076a:	8082                	ret
    release(&pr.lock);
    8000076c:	00010517          	auipc	a0,0x10
    80000770:	13c50513          	addi	a0,a0,316 # 800108a8 <pr>
    80000774:	00000097          	auipc	ra,0x0
    80000778:	3b2080e7          	jalr	946(ra) # 80000b26 <release>
}
    8000077c:	bfc9                	j	8000074e <printf+0x1b6>

000000008000077e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000077e:	1101                	addi	sp,sp,-32
    80000780:	ec06                	sd	ra,24(sp)
    80000782:	e822                	sd	s0,16(sp)
    80000784:	e426                	sd	s1,8(sp)
    80000786:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000788:	00010497          	auipc	s1,0x10
    8000078c:	12048493          	addi	s1,s1,288 # 800108a8 <pr>
    80000790:	00006597          	auipc	a1,0x6
    80000794:	9b058593          	addi	a1,a1,-1616 # 80006140 <userret+0xb0>
    80000798:	8526                	mv	a0,s1
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	226080e7          	jalr	550(ra) # 800009c0 <initlock>
  pr.locking = 1;
    800007a2:	4785                	li	a5,1
    800007a4:	cc9c                	sw	a5,24(s1)
}
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6105                	addi	sp,sp,32
    800007ae:	8082                	ret

00000000800007b0 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007b0:	1141                	addi	sp,sp,-16
    800007b2:	e422                	sd	s0,8(sp)
    800007b4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b6:	100007b7          	lui	a5,0x10000
    800007ba:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007be:	f8000713          	li	a4,-128
    800007c2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c6:	470d                	li	a4,3
    800007c8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007d0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007d4:	471d                	li	a4,7
    800007d6:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007da:	4705                	li	a4,1
    800007dc:	00e780a3          	sb	a4,1(a5)
}
    800007e0:	6422                	ld	s0,8(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e422                	sd	s0,8(sp)
    800007ea:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007ec:	10000737          	lui	a4,0x10000
    800007f0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007f4:	0ff7f793          	andi	a5,a5,255
    800007f8:	0207f793          	andi	a5,a5,32
    800007fc:	dbf5                	beqz	a5,800007f0 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007fe:	0ff57513          	andi	a0,a0,255
    80000802:	100007b7          	lui	a5,0x10000
    80000806:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000816:	100007b7          	lui	a5,0x10000
    8000081a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000081e:	8b85                	andi	a5,a5,1
    80000820:	cb91                	beqz	a5,80000834 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000082a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000082e:	6422                	ld	s0,8(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret
    return -1;
    80000834:	557d                	li	a0,-1
    80000836:	bfe5                	j	8000082e <uartgetc+0x1e>

0000000080000838 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000838:	1101                	addi	sp,sp,-32
    8000083a:	ec06                	sd	ra,24(sp)
    8000083c:	e822                	sd	s0,16(sp)
    8000083e:	e426                	sd	s1,8(sp)
    80000840:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000842:	54fd                	li	s1,-1
    int c = uartgetc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	fcc080e7          	jalr	-52(ra) # 80000810 <uartgetc>
    if(c == -1)
    8000084c:	00950763          	beq	a0,s1,8000085a <uartintr+0x22>
      break;
    consoleintr(c);
    80000850:	00000097          	auipc	ra,0x0
    80000854:	a7e080e7          	jalr	-1410(ra) # 800002ce <consoleintr>
  while(1){
    80000858:	b7f5                	j	80000844 <uartintr+0xc>
  }
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	e04a                	sd	s2,0(sp)
    8000086e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000870:	03451793          	slli	a5,a0,0x34
    80000874:	ebb9                	bnez	a5,800008ca <kfree+0x66>
    80000876:	84aa                	mv	s1,a0
    80000878:	00024797          	auipc	a5,0x24
    8000087c:	7a478793          	addi	a5,a5,1956 # 8002501c <end>
    80000880:	04f56563          	bltu	a0,a5,800008ca <kfree+0x66>
    80000884:	47c5                	li	a5,17
    80000886:	07ee                	slli	a5,a5,0x1b
    80000888:	04f57163          	bgeu	a0,a5,800008ca <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4585                	li	a1,1
    80000890:	00000097          	auipc	ra,0x0
    80000894:	2de080e7          	jalr	734(ra) # 80000b6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000898:	00010917          	auipc	s2,0x10
    8000089c:	03090913          	addi	s2,s2,48 # 800108c8 <kmem>
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	230080e7          	jalr	560(ra) # 80000ad2 <acquire>
  r->next = kmem.freelist;
    800008aa:	01893783          	ld	a5,24(s2)
    800008ae:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008b0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008b4:	854a                	mv	a0,s2
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	270080e7          	jalr	624(ra) # 80000b26 <release>
}
    800008be:	60e2                	ld	ra,24(sp)
    800008c0:	6442                	ld	s0,16(sp)
    800008c2:	64a2                	ld	s1,8(sp)
    800008c4:	6902                	ld	s2,0(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    panic("kfree");
    800008ca:	00006517          	auipc	a0,0x6
    800008ce:	87e50513          	addi	a0,a0,-1922 # 80006148 <userret+0xb8>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	c7c080e7          	jalr	-900(ra) # 8000054e <panic>

00000000800008da <freerange>:
{
    800008da:	7179                	addi	sp,sp,-48
    800008dc:	f406                	sd	ra,40(sp)
    800008de:	f022                	sd	s0,32(sp)
    800008e0:	ec26                	sd	s1,24(sp)
    800008e2:	e84a                	sd	s2,16(sp)
    800008e4:	e44e                	sd	s3,8(sp)
    800008e6:	e052                	sd	s4,0(sp)
    800008e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008ea:	6785                	lui	a5,0x1
    800008ec:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800008f0:	94aa                	add	s1,s1,a0
    800008f2:	757d                	lui	a0,0xfffff
    800008f4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f6:	94be                	add	s1,s1,a5
    800008f8:	0095ee63          	bltu	a1,s1,80000914 <freerange+0x3a>
    800008fc:	892e                	mv	s2,a1
    kfree(p);
    800008fe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000900:	6985                	lui	s3,0x1
    kfree(p);
    80000902:	01448533          	add	a0,s1,s4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f5e080e7          	jalr	-162(ra) # 80000864 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000090e:	94ce                	add	s1,s1,s3
    80000910:	fe9979e3          	bgeu	s2,s1,80000902 <freerange+0x28>
}
    80000914:	70a2                	ld	ra,40(sp)
    80000916:	7402                	ld	s0,32(sp)
    80000918:	64e2                	ld	s1,24(sp)
    8000091a:	6942                	ld	s2,16(sp)
    8000091c:	69a2                	ld	s3,8(sp)
    8000091e:	6a02                	ld	s4,0(sp)
    80000920:	6145                	addi	sp,sp,48
    80000922:	8082                	ret

0000000080000924 <kinit>:
{
    80000924:	1141                	addi	sp,sp,-16
    80000926:	e406                	sd	ra,8(sp)
    80000928:	e022                	sd	s0,0(sp)
    8000092a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000092c:	00006597          	auipc	a1,0x6
    80000930:	82458593          	addi	a1,a1,-2012 # 80006150 <userret+0xc0>
    80000934:	00010517          	auipc	a0,0x10
    80000938:	f9450513          	addi	a0,a0,-108 # 800108c8 <kmem>
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	084080e7          	jalr	132(ra) # 800009c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000944:	45c5                	li	a1,17
    80000946:	05ee                	slli	a1,a1,0x1b
    80000948:	00024517          	auipc	a0,0x24
    8000094c:	6d450513          	addi	a0,a0,1748 # 8002501c <end>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f8a080e7          	jalr	-118(ra) # 800008da <freerange>
}
    80000958:	60a2                	ld	ra,8(sp)
    8000095a:	6402                	ld	s0,0(sp)
    8000095c:	0141                	addi	sp,sp,16
    8000095e:	8082                	ret

0000000080000960 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000096a:	00010497          	auipc	s1,0x10
    8000096e:	f5e48493          	addi	s1,s1,-162 # 800108c8 <kmem>
    80000972:	8526                	mv	a0,s1
    80000974:	00000097          	auipc	ra,0x0
    80000978:	15e080e7          	jalr	350(ra) # 80000ad2 <acquire>
  r = kmem.freelist;
    8000097c:	6c84                	ld	s1,24(s1)
  if(r)
    8000097e:	c885                	beqz	s1,800009ae <kalloc+0x4e>
    kmem.freelist = r->next;
    80000980:	609c                	ld	a5,0(s1)
    80000982:	00010517          	auipc	a0,0x10
    80000986:	f4650513          	addi	a0,a0,-186 # 800108c8 <kmem>
    8000098a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	19a080e7          	jalr	410(ra) # 80000b26 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000994:	6605                	lui	a2,0x1
    80000996:	4595                	li	a1,5
    80000998:	8526                	mv	a0,s1
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	1d4080e7          	jalr	468(ra) # 80000b6e <memset>
  return (void*)r;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	addi	sp,sp,32
    800009ac:	8082                	ret
  release(&kmem.lock);
    800009ae:	00010517          	auipc	a0,0x10
    800009b2:	f1a50513          	addi	a0,a0,-230 # 800108c8 <kmem>
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	170080e7          	jalr	368(ra) # 80000b26 <release>
  if(r)
    800009be:	b7d5                	j	800009a2 <kalloc+0x42>

00000000800009c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800009c0:	1141                	addi	sp,sp,-16
    800009c2:	e422                	sd	s0,8(sp)
    800009c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800009c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009cc:	00053823          	sd	zero,16(a0)
}
    800009d0:	6422                	ld	s0,8(sp)
    800009d2:	0141                	addi	sp,sp,16
    800009d4:	8082                	ret

00000000800009d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009e0:	100024f3          	csrr	s1,sstatus
    800009e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009ee:	00001097          	auipc	ra,0x1
    800009f2:	e3a080e7          	jalr	-454(ra) # 80001828 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	e2e080e7          	jalr	-466(ra) # 80001828 <mycpu>
    80000a02:	5d3c                	lw	a5,120(a0)
    80000a04:	2785                	addiw	a5,a5,1
    80000a06:	dd3c                	sw	a5,120(a0)
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
    mycpu()->intena = old;
    80000a12:	00001097          	auipc	ra,0x1
    80000a16:	e16080e7          	jalr	-490(ra) # 80001828 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a1a:	8085                	srli	s1,s1,0x1
    80000a1c:	8885                	andi	s1,s1,1
    80000a1e:	dd64                	sw	s1,124(a0)
    80000a20:	bfe9                	j	800009fa <push_off+0x24>

0000000080000a22 <pop_off>:

void
pop_off(void)
{
    80000a22:	1141                	addi	sp,sp,-16
    80000a24:	e406                	sd	ra,8(sp)
    80000a26:	e022                	sd	s0,0(sp)
    80000a28:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a2a:	00001097          	auipc	ra,0x1
    80000a2e:	dfe080e7          	jalr	-514(ra) # 80001828 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a36:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a38:	ef8d                	bnez	a5,80000a72 <pop_off+0x50>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a3a:	5d3c                	lw	a5,120(a0)
    80000a3c:	37fd                	addiw	a5,a5,-1
    80000a3e:	0007871b          	sext.w	a4,a5
    80000a42:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a44:	02079693          	slli	a3,a5,0x20
    80000a48:	0206cd63          	bltz	a3,80000a82 <pop_off+0x60>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a4c:	ef19                	bnez	a4,80000a6a <pop_off+0x48>
    80000a4e:	5d7c                	lw	a5,124(a0)
    80000a50:	cf89                	beqz	a5,80000a6a <pop_off+0x48>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a52:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a56:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a5a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a6a:	60a2                	ld	ra,8(sp)
    80000a6c:	6402                	ld	s0,0(sp)
    80000a6e:	0141                	addi	sp,sp,16
    80000a70:	8082                	ret
    panic("pop_off - interruptible");
    80000a72:	00005517          	auipc	a0,0x5
    80000a76:	6e650513          	addi	a0,a0,1766 # 80006158 <userret+0xc8>
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ad4080e7          	jalr	-1324(ra) # 8000054e <panic>
    panic("pop_off");
    80000a82:	00005517          	auipc	a0,0x5
    80000a86:	6ee50513          	addi	a0,a0,1774 # 80006170 <userret+0xe0>
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	ac4080e7          	jalr	-1340(ra) # 8000054e <panic>

0000000080000a92 <holding>:
{
    80000a92:	1101                	addi	sp,sp,-32
    80000a94:	ec06                	sd	ra,24(sp)
    80000a96:	e822                	sd	s0,16(sp)
    80000a98:	e426                	sd	s1,8(sp)
    80000a9a:	1000                	addi	s0,sp,32
    80000a9c:	84aa                	mv	s1,a0
  push_off();
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	f38080e7          	jalr	-200(ra) # 800009d6 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000aa6:	409c                	lw	a5,0(s1)
    80000aa8:	ef81                	bnez	a5,80000ac0 <holding+0x2e>
    80000aaa:	4481                	li	s1,0
  pop_off();
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	f76080e7          	jalr	-138(ra) # 80000a22 <pop_off>
}
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	60e2                	ld	ra,24(sp)
    80000ab8:	6442                	ld	s0,16(sp)
    80000aba:	64a2                	ld	s1,8(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ac0:	6884                	ld	s1,16(s1)
    80000ac2:	00001097          	auipc	ra,0x1
    80000ac6:	d66080e7          	jalr	-666(ra) # 80001828 <mycpu>
    80000aca:	8c89                	sub	s1,s1,a0
    80000acc:	0014b493          	seqz	s1,s1
    80000ad0:	bff1                	j	80000aac <holding+0x1a>

0000000080000ad2 <acquire>:
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
    80000adc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	ef8080e7          	jalr	-264(ra) # 800009d6 <push_off>
  if(holding(lk))
    80000ae6:	8526                	mv	a0,s1
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	faa080e7          	jalr	-86(ra) # 80000a92 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af0:	4705                	li	a4,1
  if(holding(lk))
    80000af2:	e115                	bnez	a0,80000b16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af4:	87ba                	mv	a5,a4
    80000af6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000afa:	2781                	sext.w	a5,a5
    80000afc:	ffe5                	bnez	a5,80000af4 <acquire+0x22>
  __sync_synchronize();
    80000afe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b02:	00001097          	auipc	ra,0x1
    80000b06:	d26080e7          	jalr	-730(ra) # 80001828 <mycpu>
    80000b0a:	e888                	sd	a0,16(s1)
}
    80000b0c:	60e2                	ld	ra,24(sp)
    80000b0e:	6442                	ld	s0,16(sp)
    80000b10:	64a2                	ld	s1,8(sp)
    80000b12:	6105                	addi	sp,sp,32
    80000b14:	8082                	ret
    panic("acquire");
    80000b16:	00005517          	auipc	a0,0x5
    80000b1a:	66250513          	addi	a0,a0,1634 # 80006178 <userret+0xe8>
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	a30080e7          	jalr	-1488(ra) # 8000054e <panic>

0000000080000b26 <release>:
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
    80000b30:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	f60080e7          	jalr	-160(ra) # 80000a92 <holding>
    80000b3a:	c115                	beqz	a0,80000b5e <release+0x38>
  lk->cpu = 0;
    80000b3c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b40:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b44:	0f50000f          	fence	iorw,ow
    80000b48:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	ed6080e7          	jalr	-298(ra) # 80000a22 <pop_off>
}
    80000b54:	60e2                	ld	ra,24(sp)
    80000b56:	6442                	ld	s0,16(sp)
    80000b58:	64a2                	ld	s1,8(sp)
    80000b5a:	6105                	addi	sp,sp,32
    80000b5c:	8082                	ret
    panic("release");
    80000b5e:	00005517          	auipc	a0,0x5
    80000b62:	62250513          	addi	a0,a0,1570 # 80006180 <userret+0xf0>
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	9e8080e7          	jalr	-1560(ra) # 8000054e <panic>

0000000080000b6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b6e:	1141                	addi	sp,sp,-16
    80000b70:	e422                	sd	s0,8(sp)
    80000b72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000b74:	ce09                	beqz	a2,80000b8e <memset+0x20>
    80000b76:	87aa                	mv	a5,a0
    80000b78:	fff6071b          	addiw	a4,a2,-1
    80000b7c:	1702                	slli	a4,a4,0x20
    80000b7e:	9301                	srli	a4,a4,0x20
    80000b80:	0705                	addi	a4,a4,1
    80000b82:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000b84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000b88:	0785                	addi	a5,a5,1
    80000b8a:	fee79de3          	bne	a5,a4,80000b84 <memset+0x16>
  }
  return dst;
}
    80000b8e:	6422                	ld	s0,8(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000b94:	1141                	addi	sp,sp,-16
    80000b96:	e422                	sd	s0,8(sp)
    80000b98:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000b9a:	ca05                	beqz	a2,80000bca <memcmp+0x36>
    80000b9c:	fff6069b          	addiw	a3,a2,-1
    80000ba0:	1682                	slli	a3,a3,0x20
    80000ba2:	9281                	srli	a3,a3,0x20
    80000ba4:	0685                	addi	a3,a3,1
    80000ba6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ba8:	00054783          	lbu	a5,0(a0)
    80000bac:	0005c703          	lbu	a4,0(a1)
    80000bb0:	00e79863          	bne	a5,a4,80000bc0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bb4:	0505                	addi	a0,a0,1
    80000bb6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000bb8:	fed518e3          	bne	a0,a3,80000ba8 <memcmp+0x14>
  }

  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a019                	j	80000bc4 <memcmp+0x30>
      return *s1 - *s2;
    80000bc0:	40e7853b          	subw	a0,a5,a4
}
    80000bc4:	6422                	ld	s0,8(sp)
    80000bc6:	0141                	addi	sp,sp,16
    80000bc8:	8082                	ret
  return 0;
    80000bca:	4501                	li	a0,0
    80000bcc:	bfe5                	j	80000bc4 <memcmp+0x30>

0000000080000bce <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bce:	1141                	addi	sp,sp,-16
    80000bd0:	e422                	sd	s0,8(sp)
    80000bd2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000bd4:	02a5e563          	bltu	a1,a0,80000bfe <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000bd8:	fff6069b          	addiw	a3,a2,-1
    80000bdc:	ce11                	beqz	a2,80000bf8 <memmove+0x2a>
    80000bde:	1682                	slli	a3,a3,0x20
    80000be0:	9281                	srli	a3,a3,0x20
    80000be2:	0685                	addi	a3,a3,1
    80000be4:	96ae                	add	a3,a3,a1
    80000be6:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000be8:	0585                	addi	a1,a1,1
    80000bea:	0785                	addi	a5,a5,1
    80000bec:	fff5c703          	lbu	a4,-1(a1)
    80000bf0:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000bf4:	fed59ae3          	bne	a1,a3,80000be8 <memmove+0x1a>

  return dst;
}
    80000bf8:	6422                	ld	s0,8(sp)
    80000bfa:	0141                	addi	sp,sp,16
    80000bfc:	8082                	ret
  if(s < d && s + n > d){
    80000bfe:	02061713          	slli	a4,a2,0x20
    80000c02:	9301                	srli	a4,a4,0x20
    80000c04:	00e587b3          	add	a5,a1,a4
    80000c08:	fcf578e3          	bgeu	a0,a5,80000bd8 <memmove+0xa>
    d += n;
    80000c0c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c0e:	fff6069b          	addiw	a3,a2,-1
    80000c12:	d27d                	beqz	a2,80000bf8 <memmove+0x2a>
    80000c14:	02069613          	slli	a2,a3,0x20
    80000c18:	9201                	srli	a2,a2,0x20
    80000c1a:	fff64613          	not	a2,a2
    80000c1e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c20:	17fd                	addi	a5,a5,-1
    80000c22:	177d                	addi	a4,a4,-1
    80000c24:	0007c683          	lbu	a3,0(a5)
    80000c28:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c2c:	fec79ae3          	bne	a5,a2,80000c20 <memmove+0x52>
    80000c30:	b7e1                	j	80000bf8 <memmove+0x2a>

0000000080000c32 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c32:	1141                	addi	sp,sp,-16
    80000c34:	e406                	sd	ra,8(sp)
    80000c36:	e022                	sd	s0,0(sp)
    80000c38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	f94080e7          	jalr	-108(ra) # 80000bce <memmove>
}
    80000c42:	60a2                	ld	ra,8(sp)
    80000c44:	6402                	ld	s0,0(sp)
    80000c46:	0141                	addi	sp,sp,16
    80000c48:	8082                	ret

0000000080000c4a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c4a:	1141                	addi	sp,sp,-16
    80000c4c:	e422                	sd	s0,8(sp)
    80000c4e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c50:	ce11                	beqz	a2,80000c6c <strncmp+0x22>
    80000c52:	00054783          	lbu	a5,0(a0)
    80000c56:	cf89                	beqz	a5,80000c70 <strncmp+0x26>
    80000c58:	0005c703          	lbu	a4,0(a1)
    80000c5c:	00f71a63          	bne	a4,a5,80000c70 <strncmp+0x26>
    n--, p++, q++;
    80000c60:	367d                	addiw	a2,a2,-1
    80000c62:	0505                	addi	a0,a0,1
    80000c64:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c66:	f675                	bnez	a2,80000c52 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c68:	4501                	li	a0,0
    80000c6a:	a809                	j	80000c7c <strncmp+0x32>
    80000c6c:	4501                	li	a0,0
    80000c6e:	a039                	j	80000c7c <strncmp+0x32>
  if(n == 0)
    80000c70:	ca09                	beqz	a2,80000c82 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c72:	00054503          	lbu	a0,0(a0)
    80000c76:	0005c783          	lbu	a5,0(a1)
    80000c7a:	9d1d                	subw	a0,a0,a5
}
    80000c7c:	6422                	ld	s0,8(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    return 0;
    80000c82:	4501                	li	a0,0
    80000c84:	bfe5                	j	80000c7c <strncmp+0x32>

0000000080000c86 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000c86:	1141                	addi	sp,sp,-16
    80000c88:	e422                	sd	s0,8(sp)
    80000c8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000c8c:	872a                	mv	a4,a0
    80000c8e:	8832                	mv	a6,a2
    80000c90:	367d                	addiw	a2,a2,-1
    80000c92:	01005963          	blez	a6,80000ca4 <strncpy+0x1e>
    80000c96:	0705                	addi	a4,a4,1
    80000c98:	0005c783          	lbu	a5,0(a1)
    80000c9c:	fef70fa3          	sb	a5,-1(a4)
    80000ca0:	0585                	addi	a1,a1,1
    80000ca2:	f7f5                	bnez	a5,80000c8e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ca4:	86ba                	mv	a3,a4
    80000ca6:	00c05c63          	blez	a2,80000cbe <strncpy+0x38>
    *s++ = 0;
    80000caa:	0685                	addi	a3,a3,1
    80000cac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cb0:	fff6c793          	not	a5,a3
    80000cb4:	9fb9                	addw	a5,a5,a4
    80000cb6:	010787bb          	addw	a5,a5,a6
    80000cba:	fef048e3          	bgtz	a5,80000caa <strncpy+0x24>
  return os;
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e422                	sd	s0,8(sp)
    80000cc8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cca:	02c05363          	blez	a2,80000cf0 <safestrcpy+0x2c>
    80000cce:	fff6069b          	addiw	a3,a2,-1
    80000cd2:	1682                	slli	a3,a3,0x20
    80000cd4:	9281                	srli	a3,a3,0x20
    80000cd6:	96ae                	add	a3,a3,a1
    80000cd8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000cda:	00d58963          	beq	a1,a3,80000cec <safestrcpy+0x28>
    80000cde:	0585                	addi	a1,a1,1
    80000ce0:	0785                	addi	a5,a5,1
    80000ce2:	fff5c703          	lbu	a4,-1(a1)
    80000ce6:	fee78fa3          	sb	a4,-1(a5)
    80000cea:	fb65                	bnez	a4,80000cda <safestrcpy+0x16>
    ;
  *s = 0;
    80000cec:	00078023          	sb	zero,0(a5)
  return os;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret

0000000080000cf6 <strlen>:

int
strlen(const char *s)
{
    80000cf6:	1141                	addi	sp,sp,-16
    80000cf8:	e422                	sd	s0,8(sp)
    80000cfa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000cfc:	00054783          	lbu	a5,0(a0)
    80000d00:	cf91                	beqz	a5,80000d1c <strlen+0x26>
    80000d02:	0505                	addi	a0,a0,1
    80000d04:	87aa                	mv	a5,a0
    80000d06:	4685                	li	a3,1
    80000d08:	9e89                	subw	a3,a3,a0
    80000d0a:	00f6853b          	addw	a0,a3,a5
    80000d0e:	0785                	addi	a5,a5,1
    80000d10:	fff7c703          	lbu	a4,-1(a5)
    80000d14:	fb7d                	bnez	a4,80000d0a <strlen+0x14>
    ;
  return n;
}
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d1c:	4501                	li	a0,0
    80000d1e:	bfe5                	j	80000d16 <strlen+0x20>

0000000080000d20 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d20:	1141                	addi	sp,sp,-16
    80000d22:	e406                	sd	ra,8(sp)
    80000d24:	e022                	sd	s0,0(sp)
    80000d26:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d28:	00001097          	auipc	ra,0x1
    80000d2c:	af0080e7          	jalr	-1296(ra) # 80001818 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d30:	00024717          	auipc	a4,0x24
    80000d34:	2d470713          	addi	a4,a4,724 # 80025004 <started>
  if(cpuid() == 0){
    80000d38:	c139                	beqz	a0,80000d7e <main+0x5e>
    while(started == 0)
    80000d3a:	431c                	lw	a5,0(a4)
    80000d3c:	2781                	sext.w	a5,a5
    80000d3e:	dff5                	beqz	a5,80000d3a <main+0x1a>
      ;
    __sync_synchronize();
    80000d40:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d44:	00001097          	auipc	ra,0x1
    80000d48:	ad4080e7          	jalr	-1324(ra) # 80001818 <cpuid>
    80000d4c:	85aa                	mv	a1,a0
    80000d4e:	00005517          	auipc	a0,0x5
    80000d52:	45250513          	addi	a0,a0,1106 # 800061a0 <userret+0x110>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	842080e7          	jalr	-1982(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	1e8080e7          	jalr	488(ra) # 80000f46 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d66:	00001097          	auipc	ra,0x1
    80000d6a:	6cc080e7          	jalr	1740(ra) # 80002432 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	bf2080e7          	jalr	-1038(ra) # 80005960 <plicinithart>
  }

  scheduler();        
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	fa8080e7          	jalr	-88(ra) # 80001d1e <scheduler>
    consoleinit();
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	6e2080e7          	jalr	1762(ra) # 80000460 <consoleinit>
    printfinit();
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	9f8080e7          	jalr	-1544(ra) # 8000077e <printfinit>
    printf("\n");
    80000d8e:	00005517          	auipc	a0,0x5
    80000d92:	42250513          	addi	a0,a0,1058 # 800061b0 <userret+0x120>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	802080e7          	jalr	-2046(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000d9e:	00005517          	auipc	a0,0x5
    80000da2:	3ea50513          	addi	a0,a0,1002 # 80006188 <userret+0xf8>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	7f2080e7          	jalr	2034(ra) # 80000598 <printf>
    printf("\n");
    80000dae:	00005517          	auipc	a0,0x5
    80000db2:	40250513          	addi	a0,a0,1026 # 800061b0 <userret+0x120>
    80000db6:	fffff097          	auipc	ra,0xfffff
    80000dba:	7e2080e7          	jalr	2018(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dbe:	00000097          	auipc	ra,0x0
    80000dc2:	b66080e7          	jalr	-1178(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	30a080e7          	jalr	778(ra) # 800010d0 <kvminit>
    kvminithart();   // turn on paging
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	178080e7          	jalr	376(ra) # 80000f46 <kvminithart>
    procinit();      // process table
    80000dd6:	00001097          	auipc	ra,0x1
    80000dda:	972080e7          	jalr	-1678(ra) # 80001748 <procinit>
    trapinit();      // trap vectors
    80000dde:	00001097          	auipc	ra,0x1
    80000de2:	62c080e7          	jalr	1580(ra) # 8000240a <trapinit>
    trapinithart();  // install kernel trap vector
    80000de6:	00001097          	auipc	ra,0x1
    80000dea:	64c080e7          	jalr	1612(ra) # 80002432 <trapinithart>
    plicinit();      // set up interrupt controller
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	b5c080e7          	jalr	-1188(ra) # 8000594a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000df6:	00005097          	auipc	ra,0x5
    80000dfa:	b6a080e7          	jalr	-1174(ra) # 80005960 <plicinithart>
    binit();         // buffer cache
    80000dfe:	00002097          	auipc	ra,0x2
    80000e02:	d6c080e7          	jalr	-660(ra) # 80002b6a <binit>
    iinit();         // inode cache
    80000e06:	00002097          	auipc	ra,0x2
    80000e0a:	3fc080e7          	jalr	1020(ra) # 80003202 <iinit>
    fileinit();      // file table
    80000e0e:	00003097          	auipc	ra,0x3
    80000e12:	370080e7          	jalr	880(ra) # 8000417e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	c64080e7          	jalr	-924(ra) # 80005a7a <virtio_disk_init>
    userinit();      // first user process
    80000e1e:	00001097          	auipc	ra,0x1
    80000e22:	c9a080e7          	jalr	-870(ra) # 80001ab8 <userinit>
    __sync_synchronize();
    80000e26:	0ff0000f          	fence
    started = 1;
    80000e2a:	4785                	li	a5,1
    80000e2c:	00024717          	auipc	a4,0x24
    80000e30:	1cf72c23          	sw	a5,472(a4) # 80025004 <started>
    80000e34:	b789                	j	80000d76 <main+0x56>

0000000080000e36 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e36:	7139                	addi	sp,sp,-64
    80000e38:	fc06                	sd	ra,56(sp)
    80000e3a:	f822                	sd	s0,48(sp)
    80000e3c:	f426                	sd	s1,40(sp)
    80000e3e:	f04a                	sd	s2,32(sp)
    80000e40:	ec4e                	sd	s3,24(sp)
    80000e42:	e852                	sd	s4,16(sp)
    80000e44:	e456                	sd	s5,8(sp)
    80000e46:	e05a                	sd	s6,0(sp)
    80000e48:	0080                	addi	s0,sp,64
    80000e4a:	84aa                	mv	s1,a0
    80000e4c:	89ae                	mv	s3,a1
    80000e4e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e50:	57fd                	li	a5,-1
    80000e52:	83e9                	srli	a5,a5,0x1a
    80000e54:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e56:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e58:	04b7f263          	bgeu	a5,a1,80000e9c <walk+0x66>
    panic("walk");
    80000e5c:	00005517          	auipc	a0,0x5
    80000e60:	35c50513          	addi	a0,a0,860 # 800061b8 <userret+0x128>
    80000e64:	fffff097          	auipc	ra,0xfffff
    80000e68:	6ea080e7          	jalr	1770(ra) # 8000054e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000e6c:	060a8663          	beqz	s5,80000ed8 <walk+0xa2>
    80000e70:	00000097          	auipc	ra,0x0
    80000e74:	af0080e7          	jalr	-1296(ra) # 80000960 <kalloc>
    80000e78:	84aa                	mv	s1,a0
    80000e7a:	c529                	beqz	a0,80000ec4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000e7c:	6605                	lui	a2,0x1
    80000e7e:	4581                	li	a1,0
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	cee080e7          	jalr	-786(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000e88:	00c4d793          	srli	a5,s1,0xc
    80000e8c:	07aa                	slli	a5,a5,0xa
    80000e8e:	0017e793          	ori	a5,a5,1
    80000e92:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000e96:	3a5d                	addiw	s4,s4,-9
    80000e98:	036a0063          	beq	s4,s6,80000eb8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000e9c:	0149d933          	srl	s2,s3,s4
    80000ea0:	1ff97913          	andi	s2,s2,511
    80000ea4:	090e                	slli	s2,s2,0x3
    80000ea6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000ea8:	00093483          	ld	s1,0(s2)
    80000eac:	0014f793          	andi	a5,s1,1
    80000eb0:	dfd5                	beqz	a5,80000e6c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000eb2:	80a9                	srli	s1,s1,0xa
    80000eb4:	04b2                	slli	s1,s1,0xc
    80000eb6:	b7c5                	j	80000e96 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000eb8:	00c9d513          	srli	a0,s3,0xc
    80000ebc:	1ff57513          	andi	a0,a0,511
    80000ec0:	050e                	slli	a0,a0,0x3
    80000ec2:	9526                	add	a0,a0,s1
}
    80000ec4:	70e2                	ld	ra,56(sp)
    80000ec6:	7442                	ld	s0,48(sp)
    80000ec8:	74a2                	ld	s1,40(sp)
    80000eca:	7902                	ld	s2,32(sp)
    80000ecc:	69e2                	ld	s3,24(sp)
    80000ece:	6a42                	ld	s4,16(sp)
    80000ed0:	6aa2                	ld	s5,8(sp)
    80000ed2:	6b02                	ld	s6,0(sp)
    80000ed4:	6121                	addi	sp,sp,64
    80000ed6:	8082                	ret
        return 0;
    80000ed8:	4501                	li	a0,0
    80000eda:	b7ed                	j	80000ec4 <walk+0x8e>

0000000080000edc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000edc:	7179                	addi	sp,sp,-48
    80000ede:	f406                	sd	ra,40(sp)
    80000ee0:	f022                	sd	s0,32(sp)
    80000ee2:	ec26                	sd	s1,24(sp)
    80000ee4:	e84a                	sd	s2,16(sp)
    80000ee6:	e44e                	sd	s3,8(sp)
    80000ee8:	e052                	sd	s4,0(sp)
    80000eea:	1800                	addi	s0,sp,48
    80000eec:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000eee:	84aa                	mv	s1,a0
    80000ef0:	6905                	lui	s2,0x1
    80000ef2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ef4:	4985                	li	s3,1
    80000ef6:	a821                	j	80000f0e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ef8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000efa:	0532                	slli	a0,a0,0xc
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	fe0080e7          	jalr	-32(ra) # 80000edc <freewalk>
      pagetable[i] = 0;
    80000f04:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f08:	04a1                	addi	s1,s1,8
    80000f0a:	03248163          	beq	s1,s2,80000f2c <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f0e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f10:	00f57793          	andi	a5,a0,15
    80000f14:	ff3782e3          	beq	a5,s3,80000ef8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f18:	8905                	andi	a0,a0,1
    80000f1a:	d57d                	beqz	a0,80000f08 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f1c:	00005517          	auipc	a0,0x5
    80000f20:	2a450513          	addi	a0,a0,676 # 800061c0 <userret+0x130>
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	62a080e7          	jalr	1578(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000f2c:	8552                	mv	a0,s4
    80000f2e:	00000097          	auipc	ra,0x0
    80000f32:	936080e7          	jalr	-1738(ra) # 80000864 <kfree>
}
    80000f36:	70a2                	ld	ra,40(sp)
    80000f38:	7402                	ld	s0,32(sp)
    80000f3a:	64e2                	ld	s1,24(sp)
    80000f3c:	6942                	ld	s2,16(sp)
    80000f3e:	69a2                	ld	s3,8(sp)
    80000f40:	6a02                	ld	s4,0(sp)
    80000f42:	6145                	addi	sp,sp,48
    80000f44:	8082                	ret

0000000080000f46 <kvminithart>:
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e422                	sd	s0,8(sp)
    80000f4a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f4c:	00024797          	auipc	a5,0x24
    80000f50:	0bc7b783          	ld	a5,188(a5) # 80025008 <kernel_pagetable>
    80000f54:	83b1                	srli	a5,a5,0xc
    80000f56:	577d                	li	a4,-1
    80000f58:	177e                	slli	a4,a4,0x3f
    80000f5a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f5c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f60:	12000073          	sfence.vma
}
    80000f64:	6422                	ld	s0,8(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <walkaddr>:
  if(va >= MAXVA)
    80000f6a:	57fd                	li	a5,-1
    80000f6c:	83e9                	srli	a5,a5,0x1a
    80000f6e:	00b7f463          	bgeu	a5,a1,80000f76 <walkaddr+0xc>
    return 0;
    80000f72:	4501                	li	a0,0
}
    80000f74:	8082                	ret
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f7e:	4601                	li	a2,0
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	eb6080e7          	jalr	-330(ra) # 80000e36 <walk>
  if(pte == 0)
    80000f88:	c105                	beqz	a0,80000fa8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000f8a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f8c:	0117f693          	andi	a3,a5,17
    80000f90:	4745                	li	a4,17
    return 0;
    80000f92:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f94:	00e68663          	beq	a3,a4,80000fa0 <walkaddr+0x36>
}
    80000f98:	60a2                	ld	ra,8(sp)
    80000f9a:	6402                	ld	s0,0(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret
  pa = PTE2PA(*pte);
    80000fa0:	00a7d513          	srli	a0,a5,0xa
    80000fa4:	0532                	slli	a0,a0,0xc
  return pa;
    80000fa6:	bfcd                	j	80000f98 <walkaddr+0x2e>
    return 0;
    80000fa8:	4501                	li	a0,0
    80000faa:	b7fd                	j	80000f98 <walkaddr+0x2e>

0000000080000fac <kvmpa>:
{
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	e426                	sd	s1,8(sp)
    80000fb4:	1000                	addi	s0,sp,32
    80000fb6:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fb8:	1552                	slli	a0,a0,0x34
    80000fba:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fbe:	4601                	li	a2,0
    80000fc0:	00024517          	auipc	a0,0x24
    80000fc4:	04853503          	ld	a0,72(a0) # 80025008 <kernel_pagetable>
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	e6e080e7          	jalr	-402(ra) # 80000e36 <walk>
  if(pte == 0)
    80000fd0:	cd09                	beqz	a0,80000fea <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000fd2:	6108                	ld	a0,0(a0)
    80000fd4:	00157793          	andi	a5,a0,1
    80000fd8:	c38d                	beqz	a5,80000ffa <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000fda:	8129                	srli	a0,a0,0xa
    80000fdc:	0532                	slli	a0,a0,0xc
}
    80000fde:	9526                	add	a0,a0,s1
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6105                	addi	sp,sp,32
    80000fe8:	8082                	ret
    panic("kvmpa");
    80000fea:	00005517          	auipc	a0,0x5
    80000fee:	1e650513          	addi	a0,a0,486 # 800061d0 <userret+0x140>
    80000ff2:	fffff097          	auipc	ra,0xfffff
    80000ff6:	55c080e7          	jalr	1372(ra) # 8000054e <panic>
    panic("kvmpa");
    80000ffa:	00005517          	auipc	a0,0x5
    80000ffe:	1d650513          	addi	a0,a0,470 # 800061d0 <userret+0x140>
    80001002:	fffff097          	auipc	ra,0xfffff
    80001006:	54c080e7          	jalr	1356(ra) # 8000054e <panic>

000000008000100a <mappages>:
{
    8000100a:	715d                	addi	sp,sp,-80
    8000100c:	e486                	sd	ra,72(sp)
    8000100e:	e0a2                	sd	s0,64(sp)
    80001010:	fc26                	sd	s1,56(sp)
    80001012:	f84a                	sd	s2,48(sp)
    80001014:	f44e                	sd	s3,40(sp)
    80001016:	f052                	sd	s4,32(sp)
    80001018:	ec56                	sd	s5,24(sp)
    8000101a:	e85a                	sd	s6,16(sp)
    8000101c:	e45e                	sd	s7,8(sp)
    8000101e:	0880                	addi	s0,sp,80
    80001020:	8aaa                	mv	s5,a0
    80001022:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001024:	777d                	lui	a4,0xfffff
    80001026:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000102a:	167d                	addi	a2,a2,-1
    8000102c:	00b609b3          	add	s3,a2,a1
    80001030:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001034:	893e                	mv	s2,a5
    80001036:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000103a:	6b85                	lui	s7,0x1
    8000103c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001040:	4605                	li	a2,1
    80001042:	85ca                	mv	a1,s2
    80001044:	8556                	mv	a0,s5
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	df0080e7          	jalr	-528(ra) # 80000e36 <walk>
    8000104e:	c51d                	beqz	a0,8000107c <mappages+0x72>
    if(*pte & PTE_V)
    80001050:	611c                	ld	a5,0(a0)
    80001052:	8b85                	andi	a5,a5,1
    80001054:	ef81                	bnez	a5,8000106c <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001056:	80b1                	srli	s1,s1,0xc
    80001058:	04aa                	slli	s1,s1,0xa
    8000105a:	0164e4b3          	or	s1,s1,s6
    8000105e:	0014e493          	ori	s1,s1,1
    80001062:	e104                	sd	s1,0(a0)
    if(a == last)
    80001064:	03390863          	beq	s2,s3,80001094 <mappages+0x8a>
    a += PGSIZE;
    80001068:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000106a:	bfc9                	j	8000103c <mappages+0x32>
      panic("remap");
    8000106c:	00005517          	auipc	a0,0x5
    80001070:	16c50513          	addi	a0,a0,364 # 800061d8 <userret+0x148>
    80001074:	fffff097          	auipc	ra,0xfffff
    80001078:	4da080e7          	jalr	1242(ra) # 8000054e <panic>
      return -1;
    8000107c:	557d                	li	a0,-1
}
    8000107e:	60a6                	ld	ra,72(sp)
    80001080:	6406                	ld	s0,64(sp)
    80001082:	74e2                	ld	s1,56(sp)
    80001084:	7942                	ld	s2,48(sp)
    80001086:	79a2                	ld	s3,40(sp)
    80001088:	7a02                	ld	s4,32(sp)
    8000108a:	6ae2                	ld	s5,24(sp)
    8000108c:	6b42                	ld	s6,16(sp)
    8000108e:	6ba2                	ld	s7,8(sp)
    80001090:	6161                	addi	sp,sp,80
    80001092:	8082                	ret
  return 0;
    80001094:	4501                	li	a0,0
    80001096:	b7e5                	j	8000107e <mappages+0x74>

0000000080001098 <kvmmap>:
{
    80001098:	1141                	addi	sp,sp,-16
    8000109a:	e406                	sd	ra,8(sp)
    8000109c:	e022                	sd	s0,0(sp)
    8000109e:	0800                	addi	s0,sp,16
    800010a0:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010a2:	86ae                	mv	a3,a1
    800010a4:	85aa                	mv	a1,a0
    800010a6:	00024517          	auipc	a0,0x24
    800010aa:	f6253503          	ld	a0,-158(a0) # 80025008 <kernel_pagetable>
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	f5c080e7          	jalr	-164(ra) # 8000100a <mappages>
    800010b6:	e509                	bnez	a0,800010c0 <kvmmap+0x28>
}
    800010b8:	60a2                	ld	ra,8(sp)
    800010ba:	6402                	ld	s0,0(sp)
    800010bc:	0141                	addi	sp,sp,16
    800010be:	8082                	ret
    panic("kvmmap");
    800010c0:	00005517          	auipc	a0,0x5
    800010c4:	12050513          	addi	a0,a0,288 # 800061e0 <userret+0x150>
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	486080e7          	jalr	1158(ra) # 8000054e <panic>

00000000800010d0 <kvminit>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010da:	00000097          	auipc	ra,0x0
    800010de:	886080e7          	jalr	-1914(ra) # 80000960 <kalloc>
    800010e2:	00024797          	auipc	a5,0x24
    800010e6:	f2a7b323          	sd	a0,-218(a5) # 80025008 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800010ea:	6605                	lui	a2,0x1
    800010ec:	4581                	li	a1,0
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	a80080e7          	jalr	-1408(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010f6:	4699                	li	a3,6
    800010f8:	6605                	lui	a2,0x1
    800010fa:	100005b7          	lui	a1,0x10000
    800010fe:	10000537          	lui	a0,0x10000
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f96080e7          	jalr	-106(ra) # 80001098 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000110a:	4699                	li	a3,6
    8000110c:	6605                	lui	a2,0x1
    8000110e:	100015b7          	lui	a1,0x10001
    80001112:	10001537          	lui	a0,0x10001
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	f82080e7          	jalr	-126(ra) # 80001098 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000111e:	4699                	li	a3,6
    80001120:	6641                	lui	a2,0x10
    80001122:	020005b7          	lui	a1,0x2000
    80001126:	02000537          	lui	a0,0x2000
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f6e080e7          	jalr	-146(ra) # 80001098 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001132:	4699                	li	a3,6
    80001134:	00400637          	lui	a2,0x400
    80001138:	0c0005b7          	lui	a1,0xc000
    8000113c:	0c000537          	lui	a0,0xc000
    80001140:	00000097          	auipc	ra,0x0
    80001144:	f58080e7          	jalr	-168(ra) # 80001098 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001148:	00006497          	auipc	s1,0x6
    8000114c:	eb848493          	addi	s1,s1,-328 # 80007000 <initcode>
    80001150:	46a9                	li	a3,10
    80001152:	80006617          	auipc	a2,0x80006
    80001156:	eae60613          	addi	a2,a2,-338 # 7000 <_entry-0x7fff9000>
    8000115a:	4585                	li	a1,1
    8000115c:	05fe                	slli	a1,a1,0x1f
    8000115e:	852e                	mv	a0,a1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f38080e7          	jalr	-200(ra) # 80001098 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001168:	4699                	li	a3,6
    8000116a:	4645                	li	a2,17
    8000116c:	066e                	slli	a2,a2,0x1b
    8000116e:	8e05                	sub	a2,a2,s1
    80001170:	85a6                	mv	a1,s1
    80001172:	8526                	mv	a0,s1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f24080e7          	jalr	-220(ra) # 80001098 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000117c:	46a9                	li	a3,10
    8000117e:	6605                	lui	a2,0x1
    80001180:	00005597          	auipc	a1,0x5
    80001184:	e8058593          	addi	a1,a1,-384 # 80006000 <trampoline>
    80001188:	04000537          	lui	a0,0x4000
    8000118c:	157d                	addi	a0,a0,-1
    8000118e:	0532                	slli	a0,a0,0xc
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f08080e7          	jalr	-248(ra) # 80001098 <kvmmap>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <uvmunmap>:
{
    800011a2:	715d                	addi	sp,sp,-80
    800011a4:	e486                	sd	ra,72(sp)
    800011a6:	e0a2                	sd	s0,64(sp)
    800011a8:	fc26                	sd	s1,56(sp)
    800011aa:	f84a                	sd	s2,48(sp)
    800011ac:	f44e                	sd	s3,40(sp)
    800011ae:	f052                	sd	s4,32(sp)
    800011b0:	ec56                	sd	s5,24(sp)
    800011b2:	e85a                	sd	s6,16(sp)
    800011b4:	e45e                	sd	s7,8(sp)
    800011b6:	0880                	addi	s0,sp,80
    800011b8:	8a2a                	mv	s4,a0
    800011ba:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011bc:	77fd                	lui	a5,0xfffff
    800011be:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011c2:	167d                	addi	a2,a2,-1
    800011c4:	00b609b3          	add	s3,a2,a1
    800011c8:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011cc:	4b05                	li	s6,1
    a += PGSIZE;
    800011ce:	6b85                	lui	s7,0x1
    800011d0:	a8b1                	j	8000122c <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    800011d2:	00005517          	auipc	a0,0x5
    800011d6:	01650513          	addi	a0,a0,22 # 800061e8 <userret+0x158>
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	374080e7          	jalr	884(ra) # 8000054e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800011e2:	862a                	mv	a2,a0
    800011e4:	85ca                	mv	a1,s2
    800011e6:	00005517          	auipc	a0,0x5
    800011ea:	01250513          	addi	a0,a0,18 # 800061f8 <userret+0x168>
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	3aa080e7          	jalr	938(ra) # 80000598 <printf>
      panic("uvmunmap: not mapped");
    800011f6:	00005517          	auipc	a0,0x5
    800011fa:	01250513          	addi	a0,a0,18 # 80006208 <userret+0x178>
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	350080e7          	jalr	848(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001206:	00005517          	auipc	a0,0x5
    8000120a:	01a50513          	addi	a0,a0,26 # 80006220 <userret+0x190>
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	340080e7          	jalr	832(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001216:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001218:	0532                	slli	a0,a0,0xc
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	64a080e7          	jalr	1610(ra) # 80000864 <kfree>
    *pte = 0;
    80001222:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001226:	03390763          	beq	s2,s3,80001254 <uvmunmap+0xb2>
    a += PGSIZE;
    8000122a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000122c:	4601                	li	a2,0
    8000122e:	85ca                	mv	a1,s2
    80001230:	8552                	mv	a0,s4
    80001232:	00000097          	auipc	ra,0x0
    80001236:	c04080e7          	jalr	-1020(ra) # 80000e36 <walk>
    8000123a:	84aa                	mv	s1,a0
    8000123c:	d959                	beqz	a0,800011d2 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000123e:	6108                	ld	a0,0(a0)
    80001240:	00157793          	andi	a5,a0,1
    80001244:	dfd9                	beqz	a5,800011e2 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001246:	3ff57793          	andi	a5,a0,1023
    8000124a:	fb678ee3          	beq	a5,s6,80001206 <uvmunmap+0x64>
    if(do_free){
    8000124e:	fc0a8ae3          	beqz	s5,80001222 <uvmunmap+0x80>
    80001252:	b7d1                	j	80001216 <uvmunmap+0x74>
}
    80001254:	60a6                	ld	ra,72(sp)
    80001256:	6406                	ld	s0,64(sp)
    80001258:	74e2                	ld	s1,56(sp)
    8000125a:	7942                	ld	s2,48(sp)
    8000125c:	79a2                	ld	s3,40(sp)
    8000125e:	7a02                	ld	s4,32(sp)
    80001260:	6ae2                	ld	s5,24(sp)
    80001262:	6b42                	ld	s6,16(sp)
    80001264:	6ba2                	ld	s7,8(sp)
    80001266:	6161                	addi	sp,sp,80
    80001268:	8082                	ret

000000008000126a <uvmcreate>:
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	6ec080e7          	jalr	1772(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    8000127c:	cd11                	beqz	a0,80001298 <uvmcreate+0x2e>
    8000127e:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001280:	6605                	lui	a2,0x1
    80001282:	4581                	li	a1,0
    80001284:	00000097          	auipc	ra,0x0
    80001288:	8ea080e7          	jalr	-1814(ra) # 80000b6e <memset>
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6105                	addi	sp,sp,32
    80001296:	8082                	ret
    panic("uvmcreate: out of memory");
    80001298:	00005517          	auipc	a0,0x5
    8000129c:	fa050513          	addi	a0,a0,-96 # 80006238 <userret+0x1a8>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	2ae080e7          	jalr	686(ra) # 8000054e <panic>

00000000800012a8 <uvminit>:
{
    800012a8:	7179                	addi	sp,sp,-48
    800012aa:	f406                	sd	ra,40(sp)
    800012ac:	f022                	sd	s0,32(sp)
    800012ae:	ec26                	sd	s1,24(sp)
    800012b0:	e84a                	sd	s2,16(sp)
    800012b2:	e44e                	sd	s3,8(sp)
    800012b4:	e052                	sd	s4,0(sp)
    800012b6:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012b8:	6785                	lui	a5,0x1
    800012ba:	04f67863          	bgeu	a2,a5,8000130a <uvminit+0x62>
    800012be:	8a2a                	mv	s4,a0
    800012c0:	89ae                	mv	s3,a1
    800012c2:	84b2                	mv	s1,a2
  mem = kalloc();
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	69c080e7          	jalr	1692(ra) # 80000960 <kalloc>
    800012cc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	89c080e7          	jalr	-1892(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012da:	4779                	li	a4,30
    800012dc:	86ca                	mv	a3,s2
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	8552                	mv	a0,s4
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	d26080e7          	jalr	-730(ra) # 8000100a <mappages>
  memmove(mem, src, sz);
    800012ec:	8626                	mv	a2,s1
    800012ee:	85ce                	mv	a1,s3
    800012f0:	854a                	mv	a0,s2
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	8dc080e7          	jalr	-1828(ra) # 80000bce <memmove>
}
    800012fa:	70a2                	ld	ra,40(sp)
    800012fc:	7402                	ld	s0,32(sp)
    800012fe:	64e2                	ld	s1,24(sp)
    80001300:	6942                	ld	s2,16(sp)
    80001302:	69a2                	ld	s3,8(sp)
    80001304:	6a02                	ld	s4,0(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("inituvm: more than a page");
    8000130a:	00005517          	auipc	a0,0x5
    8000130e:	f4e50513          	addi	a0,a0,-178 # 80006258 <userret+0x1c8>
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	23c080e7          	jalr	572(ra) # 8000054e <panic>

000000008000131a <uvmdealloc>:
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000134c:	4685                	li	a3,1
    8000134e:	40e58633          	sub	a2,a1,a4
    80001352:	85ba                	mv	a1,a4
    80001354:	00000097          	auipc	ra,0x0
    80001358:	e4e080e7          	jalr	-434(ra) # 800011a2 <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	0ab66163          	bltu	a2,a1,80001400 <uvmalloc+0xa2>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	ec4e                	sd	s3,24(sp)
    8000136e:	e852                	sd	s4,16(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8aaa                	mv	s5,a0
    80001376:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001378:	6985                	lui	s3,0x1
    8000137a:	19fd                	addi	s3,s3,-1
    8000137c:	95ce                	add	a1,a1,s3
    8000137e:	79fd                	lui	s3,0xfffff
    80001380:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001384:	08c9f063          	bgeu	s3,a2,80001404 <uvmalloc+0xa6>
  a = oldsz;
    80001388:	894e                	mv	s2,s3
    mem = kalloc();
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	5d6080e7          	jalr	1494(ra) # 80000960 <kalloc>
    80001392:	84aa                	mv	s1,a0
    if(mem == 0){
    80001394:	c51d                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	7d4080e7          	jalr	2004(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013a2:	4779                	li	a4,30
    800013a4:	86a6                	mv	a3,s1
    800013a6:	6605                	lui	a2,0x1
    800013a8:	85ca                	mv	a1,s2
    800013aa:	8556                	mv	a0,s5
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	c5e080e7          	jalr	-930(ra) # 8000100a <mappages>
    800013b4:	e905                	bnez	a0,800013e4 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013b6:	6785                	lui	a5,0x1
    800013b8:	993e                	add	s2,s2,a5
    800013ba:	fd4968e3          	bltu	s2,s4,8000138a <uvmalloc+0x2c>
  return newsz;
    800013be:	8552                	mv	a0,s4
    800013c0:	a809                	j	800013d2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	f52080e7          	jalr	-174(ra) # 8000131a <uvmdealloc>
      return 0;
    800013d0:	4501                	li	a0,0
}
    800013d2:	70e2                	ld	ra,56(sp)
    800013d4:	7442                	ld	s0,48(sp)
    800013d6:	74a2                	ld	s1,40(sp)
    800013d8:	7902                	ld	s2,32(sp)
    800013da:	69e2                	ld	s3,24(sp)
    800013dc:	6a42                	ld	s4,16(sp)
    800013de:	6aa2                	ld	s5,8(sp)
    800013e0:	6121                	addi	sp,sp,64
    800013e2:	8082                	ret
      kfree(mem);
    800013e4:	8526                	mv	a0,s1
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	47e080e7          	jalr	1150(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013ee:	864e                	mv	a2,s3
    800013f0:	85ca                	mv	a1,s2
    800013f2:	8556                	mv	a0,s5
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	f26080e7          	jalr	-218(ra) # 8000131a <uvmdealloc>
      return 0;
    800013fc:	4501                	li	a0,0
    800013fe:	bfd1                	j	800013d2 <uvmalloc+0x74>
    return oldsz;
    80001400:	852e                	mv	a0,a1
}
    80001402:	8082                	ret
  return newsz;
    80001404:	8532                	mv	a0,a2
    80001406:	b7f1                	j	800013d2 <uvmalloc+0x74>

0000000080001408 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001408:	1101                	addi	sp,sp,-32
    8000140a:	ec06                	sd	ra,24(sp)
    8000140c:	e822                	sd	s0,16(sp)
    8000140e:	e426                	sd	s1,8(sp)
    80001410:	1000                	addi	s0,sp,32
    80001412:	84aa                	mv	s1,a0
    80001414:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001416:	4685                	li	a3,1
    80001418:	4581                	li	a1,0
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	d88080e7          	jalr	-632(ra) # 800011a2 <uvmunmap>
  freewalk(pagetable);
    80001422:	8526                	mv	a0,s1
    80001424:	00000097          	auipc	ra,0x0
    80001428:	ab8080e7          	jalr	-1352(ra) # 80000edc <freewalk>
}
    8000142c:	60e2                	ld	ra,24(sp)
    8000142e:	6442                	ld	s0,16(sp)
    80001430:	64a2                	ld	s1,8(sp)
    80001432:	6105                	addi	sp,sp,32
    80001434:	8082                	ret

0000000080001436 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001436:	c671                	beqz	a2,80001502 <uvmcopy+0xcc>
{
    80001438:	715d                	addi	sp,sp,-80
    8000143a:	e486                	sd	ra,72(sp)
    8000143c:	e0a2                	sd	s0,64(sp)
    8000143e:	fc26                	sd	s1,56(sp)
    80001440:	f84a                	sd	s2,48(sp)
    80001442:	f44e                	sd	s3,40(sp)
    80001444:	f052                	sd	s4,32(sp)
    80001446:	ec56                	sd	s5,24(sp)
    80001448:	e85a                	sd	s6,16(sp)
    8000144a:	e45e                	sd	s7,8(sp)
    8000144c:	0880                	addi	s0,sp,80
    8000144e:	8b2a                	mv	s6,a0
    80001450:	8aae                	mv	s5,a1
    80001452:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001454:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001456:	4601                	li	a2,0
    80001458:	85ce                	mv	a1,s3
    8000145a:	855a                	mv	a0,s6
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	9da080e7          	jalr	-1574(ra) # 80000e36 <walk>
    80001464:	c531                	beqz	a0,800014b0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001466:	6118                	ld	a4,0(a0)
    80001468:	00177793          	andi	a5,a4,1
    8000146c:	cbb1                	beqz	a5,800014c0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000146e:	00a75593          	srli	a1,a4,0xa
    80001472:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001476:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	4e6080e7          	jalr	1254(ra) # 80000960 <kalloc>
    80001482:	892a                	mv	s2,a0
    80001484:	c939                	beqz	a0,800014da <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001486:	6605                	lui	a2,0x1
    80001488:	85de                	mv	a1,s7
    8000148a:	fffff097          	auipc	ra,0xfffff
    8000148e:	744080e7          	jalr	1860(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001492:	8726                	mv	a4,s1
    80001494:	86ca                	mv	a3,s2
    80001496:	6605                	lui	a2,0x1
    80001498:	85ce                	mv	a1,s3
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	b6e080e7          	jalr	-1170(ra) # 8000100a <mappages>
    800014a4:	e515                	bnez	a0,800014d0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014a6:	6785                	lui	a5,0x1
    800014a8:	99be                	add	s3,s3,a5
    800014aa:	fb49e6e3          	bltu	s3,s4,80001456 <uvmcopy+0x20>
    800014ae:	a83d                	j	800014ec <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800014b0:	00005517          	auipc	a0,0x5
    800014b4:	dc850513          	addi	a0,a0,-568 # 80006278 <userret+0x1e8>
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	096080e7          	jalr	150(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    800014c0:	00005517          	auipc	a0,0x5
    800014c4:	dd850513          	addi	a0,a0,-552 # 80006298 <userret+0x208>
    800014c8:	fffff097          	auipc	ra,0xfffff
    800014cc:	086080e7          	jalr	134(ra) # 8000054e <panic>
      kfree(mem);
    800014d0:	854a                	mv	a0,s2
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	392080e7          	jalr	914(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014da:	4685                	li	a3,1
    800014dc:	864e                	mv	a2,s3
    800014de:	4581                	li	a1,0
    800014e0:	8556                	mv	a0,s5
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	cc0080e7          	jalr	-832(ra) # 800011a2 <uvmunmap>
  return -1;
    800014ea:	557d                	li	a0,-1
}
    800014ec:	60a6                	ld	ra,72(sp)
    800014ee:	6406                	ld	s0,64(sp)
    800014f0:	74e2                	ld	s1,56(sp)
    800014f2:	7942                	ld	s2,48(sp)
    800014f4:	79a2                	ld	s3,40(sp)
    800014f6:	7a02                	ld	s4,32(sp)
    800014f8:	6ae2                	ld	s5,24(sp)
    800014fa:	6b42                	ld	s6,16(sp)
    800014fc:	6ba2                	ld	s7,8(sp)
    800014fe:	6161                	addi	sp,sp,80
    80001500:	8082                	ret
  return 0;
    80001502:	4501                	li	a0,0
}
    80001504:	8082                	ret

0000000080001506 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001506:	1141                	addi	sp,sp,-16
    80001508:	e406                	sd	ra,8(sp)
    8000150a:	e022                	sd	s0,0(sp)
    8000150c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000150e:	4601                	li	a2,0
    80001510:	00000097          	auipc	ra,0x0
    80001514:	926080e7          	jalr	-1754(ra) # 80000e36 <walk>
  if(pte == 0)
    80001518:	c901                	beqz	a0,80001528 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000151a:	611c                	ld	a5,0(a0)
    8000151c:	9bbd                	andi	a5,a5,-17
    8000151e:	e11c                	sd	a5,0(a0)
}
    80001520:	60a2                	ld	ra,8(sp)
    80001522:	6402                	ld	s0,0(sp)
    80001524:	0141                	addi	sp,sp,16
    80001526:	8082                	ret
    panic("uvmclear");
    80001528:	00005517          	auipc	a0,0x5
    8000152c:	d9050513          	addi	a0,a0,-624 # 800062b8 <userret+0x228>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	01e080e7          	jalr	30(ra) # 8000054e <panic>

0000000080001538 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001538:	c6bd                	beqz	a3,800015a6 <copyout+0x6e>
{
    8000153a:	715d                	addi	sp,sp,-80
    8000153c:	e486                	sd	ra,72(sp)
    8000153e:	e0a2                	sd	s0,64(sp)
    80001540:	fc26                	sd	s1,56(sp)
    80001542:	f84a                	sd	s2,48(sp)
    80001544:	f44e                	sd	s3,40(sp)
    80001546:	f052                	sd	s4,32(sp)
    80001548:	ec56                	sd	s5,24(sp)
    8000154a:	e85a                	sd	s6,16(sp)
    8000154c:	e45e                	sd	s7,8(sp)
    8000154e:	e062                	sd	s8,0(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8c2e                	mv	s8,a1
    80001556:	8a32                	mv	s4,a2
    80001558:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000155a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000155c:	6a85                	lui	s5,0x1
    8000155e:	a015                	j	80001582 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001560:	9562                	add	a0,a0,s8
    80001562:	0004861b          	sext.w	a2,s1
    80001566:	85d2                	mv	a1,s4
    80001568:	41250533          	sub	a0,a0,s2
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	662080e7          	jalr	1634(ra) # 80000bce <memmove>

    len -= n;
    80001574:	409989b3          	sub	s3,s3,s1
    src += n;
    80001578:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000157a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000157e:	02098263          	beqz	s3,800015a2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001582:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001586:	85ca                	mv	a1,s2
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	9e0080e7          	jalr	-1568(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    80001592:	cd01                	beqz	a0,800015aa <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001594:	418904b3          	sub	s1,s2,s8
    80001598:	94d6                	add	s1,s1,s5
    if(n > len)
    8000159a:	fc99f3e3          	bgeu	s3,s1,80001560 <copyout+0x28>
    8000159e:	84ce                	mv	s1,s3
    800015a0:	b7c1                	j	80001560 <copyout+0x28>
  }
  return 0;
    800015a2:	4501                	li	a0,0
    800015a4:	a021                	j	800015ac <copyout+0x74>
    800015a6:	4501                	li	a0,0
}
    800015a8:	8082                	ret
      return -1;
    800015aa:	557d                	li	a0,-1
}
    800015ac:	60a6                	ld	ra,72(sp)
    800015ae:	6406                	ld	s0,64(sp)
    800015b0:	74e2                	ld	s1,56(sp)
    800015b2:	7942                	ld	s2,48(sp)
    800015b4:	79a2                	ld	s3,40(sp)
    800015b6:	7a02                	ld	s4,32(sp)
    800015b8:	6ae2                	ld	s5,24(sp)
    800015ba:	6b42                	ld	s6,16(sp)
    800015bc:	6ba2                	ld	s7,8(sp)
    800015be:	6c02                	ld	s8,0(sp)
    800015c0:	6161                	addi	sp,sp,80
    800015c2:	8082                	ret

00000000800015c4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015c4:	c6bd                	beqz	a3,80001632 <copyin+0x6e>
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
    800015e0:	8a2e                	mv	s4,a1
    800015e2:	8c32                	mv	s8,a2
    800015e4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015e6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015e8:	6a85                	lui	s5,0x1
    800015ea:	a015                	j	8000160e <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015ec:	9562                	add	a0,a0,s8
    800015ee:	0004861b          	sext.w	a2,s1
    800015f2:	412505b3          	sub	a1,a0,s2
    800015f6:	8552                	mv	a0,s4
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	5d6080e7          	jalr	1494(ra) # 80000bce <memmove>

    len -= n;
    80001600:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001604:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001606:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000160a:	02098263          	beqz	s3,8000162e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    8000160e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001612:	85ca                	mv	a1,s2
    80001614:	855a                	mv	a0,s6
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	954080e7          	jalr	-1708(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    8000161e:	cd01                	beqz	a0,80001636 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001620:	418904b3          	sub	s1,s2,s8
    80001624:	94d6                	add	s1,s1,s5
    if(n > len)
    80001626:	fc99f3e3          	bgeu	s3,s1,800015ec <copyin+0x28>
    8000162a:	84ce                	mv	s1,s3
    8000162c:	b7c1                	j	800015ec <copyin+0x28>
  }
  return 0;
    8000162e:	4501                	li	a0,0
    80001630:	a021                	j	80001638 <copyin+0x74>
    80001632:	4501                	li	a0,0
}
    80001634:	8082                	ret
      return -1;
    80001636:	557d                	li	a0,-1
}
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret

0000000080001650 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001650:	c6c5                	beqz	a3,800016f8 <copyinstr+0xa8>
{
    80001652:	715d                	addi	sp,sp,-80
    80001654:	e486                	sd	ra,72(sp)
    80001656:	e0a2                	sd	s0,64(sp)
    80001658:	fc26                	sd	s1,56(sp)
    8000165a:	f84a                	sd	s2,48(sp)
    8000165c:	f44e                	sd	s3,40(sp)
    8000165e:	f052                	sd	s4,32(sp)
    80001660:	ec56                	sd	s5,24(sp)
    80001662:	e85a                	sd	s6,16(sp)
    80001664:	e45e                	sd	s7,8(sp)
    80001666:	0880                	addi	s0,sp,80
    80001668:	8a2a                	mv	s4,a0
    8000166a:	8b2e                	mv	s6,a1
    8000166c:	8bb2                	mv	s7,a2
    8000166e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001670:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001672:	6985                	lui	s3,0x1
    80001674:	a035                	j	800016a0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001676:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000167a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000167c:	0017b793          	seqz	a5,a5
    80001680:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001684:	60a6                	ld	ra,72(sp)
    80001686:	6406                	ld	s0,64(sp)
    80001688:	74e2                	ld	s1,56(sp)
    8000168a:	7942                	ld	s2,48(sp)
    8000168c:	79a2                	ld	s3,40(sp)
    8000168e:	7a02                	ld	s4,32(sp)
    80001690:	6ae2                	ld	s5,24(sp)
    80001692:	6b42                	ld	s6,16(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	6161                	addi	sp,sp,80
    80001698:	8082                	ret
    srcva = va0 + PGSIZE;
    8000169a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000169e:	c8a9                	beqz	s1,800016f0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800016a0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800016a4:	85ca                	mv	a1,s2
    800016a6:	8552                	mv	a0,s4
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	8c2080e7          	jalr	-1854(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    800016b0:	c131                	beqz	a0,800016f4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800016b2:	41790833          	sub	a6,s2,s7
    800016b6:	984e                	add	a6,a6,s3
    if(n > max)
    800016b8:	0104f363          	bgeu	s1,a6,800016be <copyinstr+0x6e>
    800016bc:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016be:	955e                	add	a0,a0,s7
    800016c0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016c4:	fc080be3          	beqz	a6,8000169a <copyinstr+0x4a>
    800016c8:	985a                	add	a6,a6,s6
    800016ca:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016cc:	41650633          	sub	a2,a0,s6
    800016d0:	14fd                	addi	s1,s1,-1
    800016d2:	9b26                	add	s6,s6,s1
    800016d4:	00f60733          	add	a4,a2,a5
    800016d8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9fe4>
    800016dc:	df49                	beqz	a4,80001676 <copyinstr+0x26>
        *dst = *p;
    800016de:	00e78023          	sb	a4,0(a5)
      --max;
    800016e2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016e6:	0785                	addi	a5,a5,1
    while(n > 0){
    800016e8:	ff0796e3          	bne	a5,a6,800016d4 <copyinstr+0x84>
      dst++;
    800016ec:	8b42                	mv	s6,a6
    800016ee:	b775                	j	8000169a <copyinstr+0x4a>
    800016f0:	4781                	li	a5,0
    800016f2:	b769                	j	8000167c <copyinstr+0x2c>
      return -1;
    800016f4:	557d                	li	a0,-1
    800016f6:	b779                	j	80001684 <copyinstr+0x34>
  int got_null = 0;
    800016f8:	4781                	li	a5,0
  if(got_null){
    800016fa:	0017b793          	seqz	a5,a5
    800016fe:	40f00533          	neg	a0,a5
}
    80001702:	8082                	ret

0000000080001704 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001704:	1101                	addi	sp,sp,-32
    80001706:	ec06                	sd	ra,24(sp)
    80001708:	e822                	sd	s0,16(sp)
    8000170a:	e426                	sd	s1,8(sp)
    8000170c:	1000                	addi	s0,sp,32
    8000170e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	382080e7          	jalr	898(ra) # 80000a92 <holding>
    80001718:	c909                	beqz	a0,8000172a <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000171a:	749c                	ld	a5,40(s1)
    8000171c:	00978f63          	beq	a5,s1,8000173a <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001720:	60e2                	ld	ra,24(sp)
    80001722:	6442                	ld	s0,16(sp)
    80001724:	64a2                	ld	s1,8(sp)
    80001726:	6105                	addi	sp,sp,32
    80001728:	8082                	ret
    panic("wakeup1");
    8000172a:	00005517          	auipc	a0,0x5
    8000172e:	b9e50513          	addi	a0,a0,-1122 # 800062c8 <userret+0x238>
    80001732:	fffff097          	auipc	ra,0xfffff
    80001736:	e1c080e7          	jalr	-484(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000173a:	4c98                	lw	a4,24(s1)
    8000173c:	4785                	li	a5,1
    8000173e:	fef711e3          	bne	a4,a5,80001720 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001742:	4789                	li	a5,2
    80001744:	cc9c                	sw	a5,24(s1)
}
    80001746:	bfe9                	j	80001720 <wakeup1+0x1c>

0000000080001748 <procinit>:
{
    80001748:	715d                	addi	sp,sp,-80
    8000174a:	e486                	sd	ra,72(sp)
    8000174c:	e0a2                	sd	s0,64(sp)
    8000174e:	fc26                	sd	s1,56(sp)
    80001750:	f84a                	sd	s2,48(sp)
    80001752:	f44e                	sd	s3,40(sp)
    80001754:	f052                	sd	s4,32(sp)
    80001756:	ec56                	sd	s5,24(sp)
    80001758:	e85a                	sd	s6,16(sp)
    8000175a:	e45e                	sd	s7,8(sp)
    8000175c:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000175e:	00005597          	auipc	a1,0x5
    80001762:	b7258593          	addi	a1,a1,-1166 # 800062d0 <userret+0x240>
    80001766:	0000f517          	auipc	a0,0xf
    8000176a:	18250513          	addi	a0,a0,386 # 800108e8 <pid_lock>
    8000176e:	fffff097          	auipc	ra,0xfffff
    80001772:	252080e7          	jalr	594(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001776:	0000f917          	auipc	s2,0xf
    8000177a:	58a90913          	addi	s2,s2,1418 # 80010d00 <proc>
      initlock(&p->lock, "proc");
    8000177e:	00005b97          	auipc	s7,0x5
    80001782:	b5ab8b93          	addi	s7,s7,-1190 # 800062d8 <userret+0x248>
      uint64 va = KSTACK((int) (p - proc));
    80001786:	8b4a                	mv	s6,s2
    80001788:	00005a97          	auipc	s5,0x5
    8000178c:	190a8a93          	addi	s5,s5,400 # 80006918 <syscalls+0xb0>
    80001790:	040009b7          	lui	s3,0x4000
    80001794:	19fd                	addi	s3,s3,-1
    80001796:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	00015a17          	auipc	s4,0x15
    8000179c:	f68a0a13          	addi	s4,s4,-152 # 80016700 <tickslock>
      initlock(&p->lock, "proc");
    800017a0:	85de                	mv	a1,s7
    800017a2:	854a                	mv	a0,s2
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	21c080e7          	jalr	540(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	1b4080e7          	jalr	436(ra) # 80000960 <kalloc>
    800017b4:	85aa                	mv	a1,a0
      if(pa == 0)
    800017b6:	c929                	beqz	a0,80001808 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800017b8:	416904b3          	sub	s1,s2,s6
    800017bc:	848d                	srai	s1,s1,0x3
    800017be:	000ab783          	ld	a5,0(s5)
    800017c2:	02f484b3          	mul	s1,s1,a5
    800017c6:	2485                	addiw	s1,s1,1
    800017c8:	00d4949b          	slliw	s1,s1,0xd
    800017cc:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d0:	4699                	li	a3,6
    800017d2:	6605                	lui	a2,0x1
    800017d4:	8526                	mv	a0,s1
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	8c2080e7          	jalr	-1854(ra) # 80001098 <kvmmap>
      p->kstack = va;
    800017de:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	16890913          	addi	s2,s2,360
    800017e6:	fb491de3          	bne	s2,s4,800017a0 <procinit+0x58>
  kvminithart();
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	75c080e7          	jalr	1884(ra) # 80000f46 <kvminithart>
}
    800017f2:	60a6                	ld	ra,72(sp)
    800017f4:	6406                	ld	s0,64(sp)
    800017f6:	74e2                	ld	s1,56(sp)
    800017f8:	7942                	ld	s2,48(sp)
    800017fa:	79a2                	ld	s3,40(sp)
    800017fc:	7a02                	ld	s4,32(sp)
    800017fe:	6ae2                	ld	s5,24(sp)
    80001800:	6b42                	ld	s6,16(sp)
    80001802:	6ba2                	ld	s7,8(sp)
    80001804:	6161                	addi	sp,sp,80
    80001806:	8082                	ret
        panic("kalloc");
    80001808:	00005517          	auipc	a0,0x5
    8000180c:	ad850513          	addi	a0,a0,-1320 # 800062e0 <userret+0x250>
    80001810:	fffff097          	auipc	ra,0xfffff
    80001814:	d3e080e7          	jalr	-706(ra) # 8000054e <panic>

0000000080001818 <cpuid>:
{
    80001818:	1141                	addi	sp,sp,-16
    8000181a:	e422                	sd	s0,8(sp)
    8000181c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000181e:	8512                	mv	a0,tp
}
    80001820:	2501                	sext.w	a0,a0
    80001822:	6422                	ld	s0,8(sp)
    80001824:	0141                	addi	sp,sp,16
    80001826:	8082                	ret

0000000080001828 <mycpu>:
mycpu(void) {
    80001828:	1141                	addi	sp,sp,-16
    8000182a:	e422                	sd	s0,8(sp)
    8000182c:	0800                	addi	s0,sp,16
    8000182e:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001830:	2781                	sext.w	a5,a5
    80001832:	079e                	slli	a5,a5,0x7
}
    80001834:	0000f517          	auipc	a0,0xf
    80001838:	0cc50513          	addi	a0,a0,204 # 80010900 <cpus>
    8000183c:	953e                	add	a0,a0,a5
    8000183e:	6422                	ld	s0,8(sp)
    80001840:	0141                	addi	sp,sp,16
    80001842:	8082                	ret

0000000080001844 <myproc>:
myproc(void) {
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	1000                	addi	s0,sp,32
  push_off();
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	188080e7          	jalr	392(ra) # 800009d6 <push_off>
    80001856:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001858:	2781                	sext.w	a5,a5
    8000185a:	079e                	slli	a5,a5,0x7
    8000185c:	0000f717          	auipc	a4,0xf
    80001860:	08c70713          	addi	a4,a4,140 # 800108e8 <pid_lock>
    80001864:	97ba                	add	a5,a5,a4
    80001866:	6f84                	ld	s1,24(a5)
  pop_off();
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	1ba080e7          	jalr	442(ra) # 80000a22 <pop_off>
}
    80001870:	8526                	mv	a0,s1
    80001872:	60e2                	ld	ra,24(sp)
    80001874:	6442                	ld	s0,16(sp)
    80001876:	64a2                	ld	s1,8(sp)
    80001878:	6105                	addi	sp,sp,32
    8000187a:	8082                	ret

000000008000187c <forkret>:
{
    8000187c:	1141                	addi	sp,sp,-16
    8000187e:	e406                	sd	ra,8(sp)
    80001880:	e022                	sd	s0,0(sp)
    80001882:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001884:	00000097          	auipc	ra,0x0
    80001888:	fc0080e7          	jalr	-64(ra) # 80001844 <myproc>
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	29a080e7          	jalr	666(ra) # 80000b26 <release>
  if (first) {
    80001894:	00005797          	auipc	a5,0x5
    80001898:	7a07a783          	lw	a5,1952(a5) # 80007034 <first.1653>
    8000189c:	eb89                	bnez	a5,800018ae <forkret+0x32>
  usertrapret();
    8000189e:	00001097          	auipc	ra,0x1
    800018a2:	bac080e7          	jalr	-1108(ra) # 8000244a <usertrapret>
}
    800018a6:	60a2                	ld	ra,8(sp)
    800018a8:	6402                	ld	s0,0(sp)
    800018aa:	0141                	addi	sp,sp,16
    800018ac:	8082                	ret
    first = 0;
    800018ae:	00005797          	auipc	a5,0x5
    800018b2:	7807a323          	sw	zero,1926(a5) # 80007034 <first.1653>
    fsinit(ROOTDEV);
    800018b6:	4505                	li	a0,1
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	8ca080e7          	jalr	-1846(ra) # 80003182 <fsinit>
    800018c0:	bff9                	j	8000189e <forkret+0x22>

00000000800018c2 <allocpid>:
allocpid() {
    800018c2:	1101                	addi	sp,sp,-32
    800018c4:	ec06                	sd	ra,24(sp)
    800018c6:	e822                	sd	s0,16(sp)
    800018c8:	e426                	sd	s1,8(sp)
    800018ca:	e04a                	sd	s2,0(sp)
    800018cc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018ce:	0000f917          	auipc	s2,0xf
    800018d2:	01a90913          	addi	s2,s2,26 # 800108e8 <pid_lock>
    800018d6:	854a                	mv	a0,s2
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	1fa080e7          	jalr	506(ra) # 80000ad2 <acquire>
  pid = nextpid;
    800018e0:	00005797          	auipc	a5,0x5
    800018e4:	75878793          	addi	a5,a5,1880 # 80007038 <nextpid>
    800018e8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018ea:	0014871b          	addiw	a4,s1,1
    800018ee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	234080e7          	jalr	564(ra) # 80000b26 <release>
}
    800018fa:	8526                	mv	a0,s1
    800018fc:	60e2                	ld	ra,24(sp)
    800018fe:	6442                	ld	s0,16(sp)
    80001900:	64a2                	ld	s1,8(sp)
    80001902:	6902                	ld	s2,0(sp)
    80001904:	6105                	addi	sp,sp,32
    80001906:	8082                	ret

0000000080001908 <proc_pagetable>:
{
    80001908:	1101                	addi	sp,sp,-32
    8000190a:	ec06                	sd	ra,24(sp)
    8000190c:	e822                	sd	s0,16(sp)
    8000190e:	e426                	sd	s1,8(sp)
    80001910:	e04a                	sd	s2,0(sp)
    80001912:	1000                	addi	s0,sp,32
    80001914:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	954080e7          	jalr	-1708(ra) # 8000126a <uvmcreate>
    8000191e:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001920:	4729                	li	a4,10
    80001922:	00004697          	auipc	a3,0x4
    80001926:	6de68693          	addi	a3,a3,1758 # 80006000 <trampoline>
    8000192a:	6605                	lui	a2,0x1
    8000192c:	040005b7          	lui	a1,0x4000
    80001930:	15fd                	addi	a1,a1,-1
    80001932:	05b2                	slli	a1,a1,0xc
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	6d6080e7          	jalr	1750(ra) # 8000100a <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    8000193c:	4719                	li	a4,6
    8000193e:	05893683          	ld	a3,88(s2)
    80001942:	6605                	lui	a2,0x1
    80001944:	020005b7          	lui	a1,0x2000
    80001948:	15fd                	addi	a1,a1,-1
    8000194a:	05b6                	slli	a1,a1,0xd
    8000194c:	8526                	mv	a0,s1
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	6bc080e7          	jalr	1724(ra) # 8000100a <mappages>
}
    80001956:	8526                	mv	a0,s1
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	64a2                	ld	s1,8(sp)
    8000195e:	6902                	ld	s2,0(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret

0000000080001964 <allocproc>:
{
    80001964:	1101                	addi	sp,sp,-32
    80001966:	ec06                	sd	ra,24(sp)
    80001968:	e822                	sd	s0,16(sp)
    8000196a:	e426                	sd	s1,8(sp)
    8000196c:	e04a                	sd	s2,0(sp)
    8000196e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001970:	0000f497          	auipc	s1,0xf
    80001974:	39048493          	addi	s1,s1,912 # 80010d00 <proc>
    80001978:	00015917          	auipc	s2,0x15
    8000197c:	d8890913          	addi	s2,s2,-632 # 80016700 <tickslock>
    acquire(&p->lock);
    80001980:	8526                	mv	a0,s1
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	150080e7          	jalr	336(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    8000198a:	4c9c                	lw	a5,24(s1)
    8000198c:	cf81                	beqz	a5,800019a4 <allocproc+0x40>
      release(&p->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	196080e7          	jalr	406(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001998:	16848493          	addi	s1,s1,360
    8000199c:	ff2492e3          	bne	s1,s2,80001980 <allocproc+0x1c>
  return 0;
    800019a0:	4481                	li	s1,0
    800019a2:	a0a9                	j	800019ec <allocproc+0x88>
  p->pid = allocpid();
    800019a4:	00000097          	auipc	ra,0x0
    800019a8:	f1e080e7          	jalr	-226(ra) # 800018c2 <allocpid>
    800019ac:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	fb2080e7          	jalr	-78(ra) # 80000960 <kalloc>
    800019b6:	892a                	mv	s2,a0
    800019b8:	eca8                	sd	a0,88(s1)
    800019ba:	c121                	beqz	a0,800019fa <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019bc:	8526                	mv	a0,s1
    800019be:	00000097          	auipc	ra,0x0
    800019c2:	f4a080e7          	jalr	-182(ra) # 80001908 <proc_pagetable>
    800019c6:	e8a8                	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context);
    800019c8:	07000613          	li	a2,112
    800019cc:	4581                	li	a1,0
    800019ce:	06048513          	addi	a0,s1,96
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	19c080e7          	jalr	412(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret;
    800019da:	00000797          	auipc	a5,0x0
    800019de:	ea278793          	addi	a5,a5,-350 # 8000187c <forkret>
    800019e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019e4:	60bc                	ld	a5,64(s1)
    800019e6:	6705                	lui	a4,0x1
    800019e8:	97ba                	add	a5,a5,a4
    800019ea:	f4bc                	sd	a5,104(s1)
}
    800019ec:	8526                	mv	a0,s1
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6902                	ld	s2,0(sp)
    800019f6:	6105                	addi	sp,sp,32
    800019f8:	8082                	ret
    release(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	12a080e7          	jalr	298(ra) # 80000b26 <release>
    return 0;
    80001a04:	84ca                	mv	s1,s2
    80001a06:	b7dd                	j	800019ec <allocproc+0x88>

0000000080001a08 <proc_freepagetable>:
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	e04a                	sd	s2,0(sp)
    80001a12:	1000                	addi	s0,sp,32
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	6605                	lui	a2,0x1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	77e080e7          	jalr	1918(ra) # 800011a2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a2c:	4681                	li	a3,0
    80001a2e:	6605                	lui	a2,0x1
    80001a30:	020005b7          	lui	a1,0x2000
    80001a34:	15fd                	addi	a1,a1,-1
    80001a36:	05b6                	slli	a1,a1,0xd
    80001a38:	8526                	mv	a0,s1
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	768080e7          	jalr	1896(ra) # 800011a2 <uvmunmap>
  if(sz > 0)
    80001a42:	00091863          	bnez	s2,80001a52 <proc_freepagetable+0x4a>
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret
    uvmfree(pagetable, sz);
    80001a52:	85ca                	mv	a1,s2
    80001a54:	8526                	mv	a0,s1
    80001a56:	00000097          	auipc	ra,0x0
    80001a5a:	9b2080e7          	jalr	-1614(ra) # 80001408 <uvmfree>
}
    80001a5e:	b7e5                	j	80001a46 <proc_freepagetable+0x3e>

0000000080001a60 <freeproc>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	1000                	addi	s0,sp,32
    80001a6a:	84aa                	mv	s1,a0
  if(p->tf)
    80001a6c:	6d28                	ld	a0,88(a0)
    80001a6e:	c509                	beqz	a0,80001a78 <freeproc+0x18>
    kfree((void*)p->tf);
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	df4080e7          	jalr	-524(ra) # 80000864 <kfree>
  p->tf = 0;
    80001a78:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a7c:	68a8                	ld	a0,80(s1)
    80001a7e:	c511                	beqz	a0,80001a8a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a80:	64ac                	ld	a1,72(s1)
    80001a82:	00000097          	auipc	ra,0x0
    80001a86:	f86080e7          	jalr	-122(ra) # 80001a08 <proc_freepagetable>
  p->pagetable = 0;
    80001a8a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a8e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a92:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001a96:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001a9a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a9e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001aa2:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001aa6:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001aaa:	0004ac23          	sw	zero,24(s1)
}
    80001aae:	60e2                	ld	ra,24(sp)
    80001ab0:	6442                	ld	s0,16(sp)
    80001ab2:	64a2                	ld	s1,8(sp)
    80001ab4:	6105                	addi	sp,sp,32
    80001ab6:	8082                	ret

0000000080001ab8 <userinit>:
{
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ac2:	00000097          	auipc	ra,0x0
    80001ac6:	ea2080e7          	jalr	-350(ra) # 80001964 <allocproc>
    80001aca:	84aa                	mv	s1,a0
  initproc = p;
    80001acc:	00023797          	auipc	a5,0x23
    80001ad0:	54a7b223          	sd	a0,1348(a5) # 80025010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ad4:	03300613          	li	a2,51
    80001ad8:	00005597          	auipc	a1,0x5
    80001adc:	52858593          	addi	a1,a1,1320 # 80007000 <initcode>
    80001ae0:	6928                	ld	a0,80(a0)
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	7c6080e7          	jalr	1990(ra) # 800012a8 <uvminit>
  p->sz = PGSIZE;
    80001aea:	6785                	lui	a5,0x1
    80001aec:	e4bc                	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80001aee:	6cb8                	ld	a4,88(s1)
    80001af0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001af4:	6cb8                	ld	a4,88(s1)
    80001af6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001af8:	4641                	li	a2,16
    80001afa:	00004597          	auipc	a1,0x4
    80001afe:	7ee58593          	addi	a1,a1,2030 # 800062e8 <userret+0x258>
    80001b02:	15848513          	addi	a0,s1,344
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	1be080e7          	jalr	446(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001b0e:	00004517          	auipc	a0,0x4
    80001b12:	7ea50513          	addi	a0,a0,2026 # 800062f8 <userret+0x268>
    80001b16:	00002097          	auipc	ra,0x2
    80001b1a:	06e080e7          	jalr	110(ra) # 80003b84 <namei>
    80001b1e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b22:	4789                	li	a5,2
    80001b24:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	ffe080e7          	jalr	-2(ra) # 80000b26 <release>
}
    80001b30:	60e2                	ld	ra,24(sp)
    80001b32:	6442                	ld	s0,16(sp)
    80001b34:	64a2                	ld	s1,8(sp)
    80001b36:	6105                	addi	sp,sp,32
    80001b38:	8082                	ret

0000000080001b3a <growproc>:
{
    80001b3a:	1101                	addi	sp,sp,-32
    80001b3c:	ec06                	sd	ra,24(sp)
    80001b3e:	e822                	sd	s0,16(sp)
    80001b40:	e426                	sd	s1,8(sp)
    80001b42:	e04a                	sd	s2,0(sp)
    80001b44:	1000                	addi	s0,sp,32
    80001b46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b48:	00000097          	auipc	ra,0x0
    80001b4c:	cfc080e7          	jalr	-772(ra) # 80001844 <myproc>
    80001b50:	892a                	mv	s2,a0
  sz = p->sz;
    80001b52:	652c                	ld	a1,72(a0)
    80001b54:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b58:	00904f63          	bgtz	s1,80001b76 <growproc+0x3c>
  } else if(n < 0){
    80001b5c:	0204cc63          	bltz	s1,80001b94 <growproc+0x5a>
  p->sz = sz;
    80001b60:	1602                	slli	a2,a2,0x20
    80001b62:	9201                	srli	a2,a2,0x20
    80001b64:	04c93423          	sd	a2,72(s2)
  return 0;
    80001b68:	4501                	li	a0,0
}
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b76:	9e25                	addw	a2,a2,s1
    80001b78:	1602                	slli	a2,a2,0x20
    80001b7a:	9201                	srli	a2,a2,0x20
    80001b7c:	1582                	slli	a1,a1,0x20
    80001b7e:	9181                	srli	a1,a1,0x20
    80001b80:	6928                	ld	a0,80(a0)
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	7dc080e7          	jalr	2012(ra) # 8000135e <uvmalloc>
    80001b8a:	0005061b          	sext.w	a2,a0
    80001b8e:	fa69                	bnez	a2,80001b60 <growproc+0x26>
      return -1;
    80001b90:	557d                	li	a0,-1
    80001b92:	bfe1                	j	80001b6a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b94:	9e25                	addw	a2,a2,s1
    80001b96:	1602                	slli	a2,a2,0x20
    80001b98:	9201                	srli	a2,a2,0x20
    80001b9a:	1582                	slli	a1,a1,0x20
    80001b9c:	9181                	srli	a1,a1,0x20
    80001b9e:	6928                	ld	a0,80(a0)
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	77a080e7          	jalr	1914(ra) # 8000131a <uvmdealloc>
    80001ba8:	0005061b          	sext.w	a2,a0
    80001bac:	bf55                	j	80001b60 <growproc+0x26>

0000000080001bae <fork>:
{
    80001bae:	7179                	addi	sp,sp,-48
    80001bb0:	f406                	sd	ra,40(sp)
    80001bb2:	f022                	sd	s0,32(sp)
    80001bb4:	ec26                	sd	s1,24(sp)
    80001bb6:	e84a                	sd	s2,16(sp)
    80001bb8:	e44e                	sd	s3,8(sp)
    80001bba:	e052                	sd	s4,0(sp)
    80001bbc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001bbe:	00000097          	auipc	ra,0x0
    80001bc2:	c86080e7          	jalr	-890(ra) # 80001844 <myproc>
    80001bc6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	d9c080e7          	jalr	-612(ra) # 80001964 <allocproc>
    80001bd0:	c175                	beqz	a0,80001cb4 <fork+0x106>
    80001bd2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bd4:	04893603          	ld	a2,72(s2)
    80001bd8:	692c                	ld	a1,80(a0)
    80001bda:	05093503          	ld	a0,80(s2)
    80001bde:	00000097          	auipc	ra,0x0
    80001be2:	858080e7          	jalr	-1960(ra) # 80001436 <uvmcopy>
    80001be6:	04054863          	bltz	a0,80001c36 <fork+0x88>
  np->sz = p->sz;
    80001bea:	04893783          	ld	a5,72(s2)
    80001bee:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001bf2:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001bf6:	05893683          	ld	a3,88(s2)
    80001bfa:	87b6                	mv	a5,a3
    80001bfc:	0589b703          	ld	a4,88(s3)
    80001c00:	12068693          	addi	a3,a3,288
    80001c04:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c08:	6788                	ld	a0,8(a5)
    80001c0a:	6b8c                	ld	a1,16(a5)
    80001c0c:	6f90                	ld	a2,24(a5)
    80001c0e:	01073023          	sd	a6,0(a4)
    80001c12:	e708                	sd	a0,8(a4)
    80001c14:	eb0c                	sd	a1,16(a4)
    80001c16:	ef10                	sd	a2,24(a4)
    80001c18:	02078793          	addi	a5,a5,32
    80001c1c:	02070713          	addi	a4,a4,32
    80001c20:	fed792e3          	bne	a5,a3,80001c04 <fork+0x56>
  np->tf->a0 = 0;
    80001c24:	0589b783          	ld	a5,88(s3)
    80001c28:	0607b823          	sd	zero,112(a5)
    80001c2c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001c30:	15000a13          	li	s4,336
    80001c34:	a03d                	j	80001c62 <fork+0xb4>
    freeproc(np);
    80001c36:	854e                	mv	a0,s3
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	e28080e7          	jalr	-472(ra) # 80001a60 <freeproc>
    release(&np->lock);
    80001c40:	854e                	mv	a0,s3
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	ee4080e7          	jalr	-284(ra) # 80000b26 <release>
    return -1;
    80001c4a:	54fd                	li	s1,-1
    80001c4c:	a899                	j	80001ca2 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c4e:	00002097          	auipc	ra,0x2
    80001c52:	5c2080e7          	jalr	1474(ra) # 80004210 <filedup>
    80001c56:	009987b3          	add	a5,s3,s1
    80001c5a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001c5c:	04a1                	addi	s1,s1,8
    80001c5e:	01448763          	beq	s1,s4,80001c6c <fork+0xbe>
    if(p->ofile[i])
    80001c62:	009907b3          	add	a5,s2,s1
    80001c66:	6388                	ld	a0,0(a5)
    80001c68:	f17d                	bnez	a0,80001c4e <fork+0xa0>
    80001c6a:	bfcd                	j	80001c5c <fork+0xae>
  np->cwd = idup(p->cwd);
    80001c6c:	15093503          	ld	a0,336(s2)
    80001c70:	00001097          	auipc	ra,0x1
    80001c74:	74c080e7          	jalr	1868(ra) # 800033bc <idup>
    80001c78:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c7c:	4641                	li	a2,16
    80001c7e:	15890593          	addi	a1,s2,344
    80001c82:	15898513          	addi	a0,s3,344
    80001c86:	fffff097          	auipc	ra,0xfffff
    80001c8a:	03e080e7          	jalr	62(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001c8e:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001c92:	4789                	li	a5,2
    80001c94:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c98:	854e                	mv	a0,s3
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	e8c080e7          	jalr	-372(ra) # 80000b26 <release>
}
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	70a2                	ld	ra,40(sp)
    80001ca6:	7402                	ld	s0,32(sp)
    80001ca8:	64e2                	ld	s1,24(sp)
    80001caa:	6942                	ld	s2,16(sp)
    80001cac:	69a2                	ld	s3,8(sp)
    80001cae:	6a02                	ld	s4,0(sp)
    80001cb0:	6145                	addi	sp,sp,48
    80001cb2:	8082                	ret
    return -1;
    80001cb4:	54fd                	li	s1,-1
    80001cb6:	b7f5                	j	80001ca2 <fork+0xf4>

0000000080001cb8 <reparent>:
{
    80001cb8:	7179                	addi	sp,sp,-48
    80001cba:	f406                	sd	ra,40(sp)
    80001cbc:	f022                	sd	s0,32(sp)
    80001cbe:	ec26                	sd	s1,24(sp)
    80001cc0:	e84a                	sd	s2,16(sp)
    80001cc2:	e44e                	sd	s3,8(sp)
    80001cc4:	e052                	sd	s4,0(sp)
    80001cc6:	1800                	addi	s0,sp,48
    80001cc8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cca:	0000f497          	auipc	s1,0xf
    80001cce:	03648493          	addi	s1,s1,54 # 80010d00 <proc>
      pp->parent = initproc;
    80001cd2:	00023a17          	auipc	s4,0x23
    80001cd6:	33ea0a13          	addi	s4,s4,830 # 80025010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cda:	00015997          	auipc	s3,0x15
    80001cde:	a2698993          	addi	s3,s3,-1498 # 80016700 <tickslock>
    80001ce2:	a029                	j	80001cec <reparent+0x34>
    80001ce4:	16848493          	addi	s1,s1,360
    80001ce8:	03348363          	beq	s1,s3,80001d0e <reparent+0x56>
    if(pp->parent == p){
    80001cec:	709c                	ld	a5,32(s1)
    80001cee:	ff279be3          	bne	a5,s2,80001ce4 <reparent+0x2c>
      acquire(&pp->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	dde080e7          	jalr	-546(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001cfc:	000a3783          	ld	a5,0(s4)
    80001d00:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	e22080e7          	jalr	-478(ra) # 80000b26 <release>
    80001d0c:	bfe1                	j	80001ce4 <reparent+0x2c>
}
    80001d0e:	70a2                	ld	ra,40(sp)
    80001d10:	7402                	ld	s0,32(sp)
    80001d12:	64e2                	ld	s1,24(sp)
    80001d14:	6942                	ld	s2,16(sp)
    80001d16:	69a2                	ld	s3,8(sp)
    80001d18:	6a02                	ld	s4,0(sp)
    80001d1a:	6145                	addi	sp,sp,48
    80001d1c:	8082                	ret

0000000080001d1e <scheduler>:
{
    80001d1e:	7139                	addi	sp,sp,-64
    80001d20:	fc06                	sd	ra,56(sp)
    80001d22:	f822                	sd	s0,48(sp)
    80001d24:	f426                	sd	s1,40(sp)
    80001d26:	f04a                	sd	s2,32(sp)
    80001d28:	ec4e                	sd	s3,24(sp)
    80001d2a:	e852                	sd	s4,16(sp)
    80001d2c:	e456                	sd	s5,8(sp)
    80001d2e:	e05a                	sd	s6,0(sp)
    80001d30:	0080                	addi	s0,sp,64
    80001d32:	8792                	mv	a5,tp
  int id = r_tp();
    80001d34:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d36:	00779a93          	slli	s5,a5,0x7
    80001d3a:	0000f717          	auipc	a4,0xf
    80001d3e:	bae70713          	addi	a4,a4,-1106 # 800108e8 <pid_lock>
    80001d42:	9756                	add	a4,a4,s5
    80001d44:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001d48:	0000f717          	auipc	a4,0xf
    80001d4c:	bc070713          	addi	a4,a4,-1088 # 80010908 <cpus+0x8>
    80001d50:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001d52:	4989                	li	s3,2
        p->state = RUNNING;
    80001d54:	4b0d                	li	s6,3
        c->proc = p;
    80001d56:	079e                	slli	a5,a5,0x7
    80001d58:	0000fa17          	auipc	s4,0xf
    80001d5c:	b90a0a13          	addi	s4,s4,-1136 # 800108e8 <pid_lock>
    80001d60:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d62:	00015917          	auipc	s2,0x15
    80001d66:	99e90913          	addi	s2,s2,-1634 # 80016700 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001d6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001d6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001d72:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d7a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7e:	10079073          	csrw	sstatus,a5
    80001d82:	0000f497          	auipc	s1,0xf
    80001d86:	f7e48493          	addi	s1,s1,-130 # 80010d00 <proc>
    80001d8a:	a03d                	j	80001db8 <scheduler+0x9a>
        p->state = RUNNING;
    80001d8c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001d90:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001d94:	06048593          	addi	a1,s1,96
    80001d98:	8556                	mv	a0,s5
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	606080e7          	jalr	1542(ra) # 800023a0 <swtch>
        c->proc = 0;
    80001da2:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    80001da6:	8526                	mv	a0,s1
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	d7e080e7          	jalr	-642(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001db0:	16848493          	addi	s1,s1,360
    80001db4:	fb248be3          	beq	s1,s2,80001d6a <scheduler+0x4c>
      acquire(&p->lock);
    80001db8:	8526                	mv	a0,s1
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	d18080e7          	jalr	-744(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE) {
    80001dc2:	4c9c                	lw	a5,24(s1)
    80001dc4:	ff3791e3          	bne	a5,s3,80001da6 <scheduler+0x88>
    80001dc8:	b7d1                	j	80001d8c <scheduler+0x6e>

0000000080001dca <sched>:
{
    80001dca:	7179                	addi	sp,sp,-48
    80001dcc:	f406                	sd	ra,40(sp)
    80001dce:	f022                	sd	s0,32(sp)
    80001dd0:	ec26                	sd	s1,24(sp)
    80001dd2:	e84a                	sd	s2,16(sp)
    80001dd4:	e44e                	sd	s3,8(sp)
    80001dd6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	a6c080e7          	jalr	-1428(ra) # 80001844 <myproc>
    80001de0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	cb0080e7          	jalr	-848(ra) # 80000a92 <holding>
    80001dea:	c93d                	beqz	a0,80001e60 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dec:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001dee:	2781                	sext.w	a5,a5
    80001df0:	079e                	slli	a5,a5,0x7
    80001df2:	0000f717          	auipc	a4,0xf
    80001df6:	af670713          	addi	a4,a4,-1290 # 800108e8 <pid_lock>
    80001dfa:	97ba                	add	a5,a5,a4
    80001dfc:	0907a703          	lw	a4,144(a5)
    80001e00:	4785                	li	a5,1
    80001e02:	06f71763          	bne	a4,a5,80001e70 <sched+0xa6>
  if(p->state == RUNNING)
    80001e06:	4c98                	lw	a4,24(s1)
    80001e08:	478d                	li	a5,3
    80001e0a:	06f70b63          	beq	a4,a5,80001e80 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e12:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e14:	efb5                	bnez	a5,80001e90 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e16:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e18:	0000f917          	auipc	s2,0xf
    80001e1c:	ad090913          	addi	s2,s2,-1328 # 800108e8 <pid_lock>
    80001e20:	2781                	sext.w	a5,a5
    80001e22:	079e                	slli	a5,a5,0x7
    80001e24:	97ca                	add	a5,a5,s2
    80001e26:	0947a983          	lw	s3,148(a5)
    80001e2a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001e2c:	2781                	sext.w	a5,a5
    80001e2e:	079e                	slli	a5,a5,0x7
    80001e30:	0000f597          	auipc	a1,0xf
    80001e34:	ad858593          	addi	a1,a1,-1320 # 80010908 <cpus+0x8>
    80001e38:	95be                	add	a1,a1,a5
    80001e3a:	06048513          	addi	a0,s1,96
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	562080e7          	jalr	1378(ra) # 800023a0 <swtch>
    80001e46:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	97ca                	add	a5,a5,s2
    80001e4e:	0937aa23          	sw	s3,148(a5)
}
    80001e52:	70a2                	ld	ra,40(sp)
    80001e54:	7402                	ld	s0,32(sp)
    80001e56:	64e2                	ld	s1,24(sp)
    80001e58:	6942                	ld	s2,16(sp)
    80001e5a:	69a2                	ld	s3,8(sp)
    80001e5c:	6145                	addi	sp,sp,48
    80001e5e:	8082                	ret
    panic("sched p->lock");
    80001e60:	00004517          	auipc	a0,0x4
    80001e64:	4a050513          	addi	a0,a0,1184 # 80006300 <userret+0x270>
    80001e68:	ffffe097          	auipc	ra,0xffffe
    80001e6c:	6e6080e7          	jalr	1766(ra) # 8000054e <panic>
    panic("sched locks");
    80001e70:	00004517          	auipc	a0,0x4
    80001e74:	4a050513          	addi	a0,a0,1184 # 80006310 <userret+0x280>
    80001e78:	ffffe097          	auipc	ra,0xffffe
    80001e7c:	6d6080e7          	jalr	1750(ra) # 8000054e <panic>
    panic("sched running");
    80001e80:	00004517          	auipc	a0,0x4
    80001e84:	4a050513          	addi	a0,a0,1184 # 80006320 <userret+0x290>
    80001e88:	ffffe097          	auipc	ra,0xffffe
    80001e8c:	6c6080e7          	jalr	1734(ra) # 8000054e <panic>
    panic("sched interruptible");
    80001e90:	00004517          	auipc	a0,0x4
    80001e94:	4a050513          	addi	a0,a0,1184 # 80006330 <userret+0x2a0>
    80001e98:	ffffe097          	auipc	ra,0xffffe
    80001e9c:	6b6080e7          	jalr	1718(ra) # 8000054e <panic>

0000000080001ea0 <exit>:
{
    80001ea0:	7179                	addi	sp,sp,-48
    80001ea2:	f406                	sd	ra,40(sp)
    80001ea4:	f022                	sd	s0,32(sp)
    80001ea6:	ec26                	sd	s1,24(sp)
    80001ea8:	e84a                	sd	s2,16(sp)
    80001eaa:	e44e                	sd	s3,8(sp)
    80001eac:	e052                	sd	s4,0(sp)
    80001eae:	1800                	addi	s0,sp,48
    80001eb0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	992080e7          	jalr	-1646(ra) # 80001844 <myproc>
    80001eba:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ebc:	00023797          	auipc	a5,0x23
    80001ec0:	1547b783          	ld	a5,340(a5) # 80025010 <initproc>
    80001ec4:	0d050493          	addi	s1,a0,208
    80001ec8:	15050913          	addi	s2,a0,336
    80001ecc:	02a79363          	bne	a5,a0,80001ef2 <exit+0x52>
    panic("init exiting");
    80001ed0:	00004517          	auipc	a0,0x4
    80001ed4:	47850513          	addi	a0,a0,1144 # 80006348 <userret+0x2b8>
    80001ed8:	ffffe097          	auipc	ra,0xffffe
    80001edc:	676080e7          	jalr	1654(ra) # 8000054e <panic>
      fileclose(f);
    80001ee0:	00002097          	auipc	ra,0x2
    80001ee4:	382080e7          	jalr	898(ra) # 80004262 <fileclose>
      p->ofile[fd] = 0;
    80001ee8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001eec:	04a1                	addi	s1,s1,8
    80001eee:	01248563          	beq	s1,s2,80001ef8 <exit+0x58>
    if(p->ofile[fd]){
    80001ef2:	6088                	ld	a0,0(s1)
    80001ef4:	f575                	bnez	a0,80001ee0 <exit+0x40>
    80001ef6:	bfdd                	j	80001eec <exit+0x4c>
  begin_op();
    80001ef8:	00002097          	auipc	ra,0x2
    80001efc:	e98080e7          	jalr	-360(ra) # 80003d90 <begin_op>
  iput(p->cwd);
    80001f00:	1509b503          	ld	a0,336(s3)
    80001f04:	00001097          	auipc	ra,0x1
    80001f08:	604080e7          	jalr	1540(ra) # 80003508 <iput>
  end_op();
    80001f0c:	00002097          	auipc	ra,0x2
    80001f10:	f04080e7          	jalr	-252(ra) # 80003e10 <end_op>
  p->cwd = 0;
    80001f14:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80001f18:	00023497          	auipc	s1,0x23
    80001f1c:	0f848493          	addi	s1,s1,248 # 80025010 <initproc>
    80001f20:	6088                	ld	a0,0(s1)
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	bb0080e7          	jalr	-1104(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    80001f2a:	6088                	ld	a0,0(s1)
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	7d8080e7          	jalr	2008(ra) # 80001704 <wakeup1>
  release(&initproc->lock);
    80001f34:	6088                	ld	a0,0(s1)
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	bf0080e7          	jalr	-1040(ra) # 80000b26 <release>
  acquire(&p->lock);
    80001f3e:	854e                	mv	a0,s3
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	b92080e7          	jalr	-1134(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    80001f48:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80001f4c:	854e                	mv	a0,s3
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	bd8080e7          	jalr	-1064(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    80001f56:	8526                	mv	a0,s1
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	b7a080e7          	jalr	-1158(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    80001f60:	854e                	mv	a0,s3
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	b70080e7          	jalr	-1168(ra) # 80000ad2 <acquire>
  reparent(p);
    80001f6a:	854e                	mv	a0,s3
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	d4c080e7          	jalr	-692(ra) # 80001cb8 <reparent>
  wakeup1(original_parent);
    80001f74:	8526                	mv	a0,s1
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	78e080e7          	jalr	1934(ra) # 80001704 <wakeup1>
  p->xstate = status;
    80001f7e:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001f82:	4791                	li	a5,4
    80001f84:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	b9c080e7          	jalr	-1124(ra) # 80000b26 <release>
  sched();
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	e38080e7          	jalr	-456(ra) # 80001dca <sched>
  panic("zombie exit");
    80001f9a:	00004517          	auipc	a0,0x4
    80001f9e:	3be50513          	addi	a0,a0,958 # 80006358 <userret+0x2c8>
    80001fa2:	ffffe097          	auipc	ra,0xffffe
    80001fa6:	5ac080e7          	jalr	1452(ra) # 8000054e <panic>

0000000080001faa <yield>:
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	890080e7          	jalr	-1904(ra) # 80001844 <myproc>
    80001fbc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	b14080e7          	jalr	-1260(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    80001fc6:	4789                	li	a5,2
    80001fc8:	cc9c                	sw	a5,24(s1)
  sched();
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	e00080e7          	jalr	-512(ra) # 80001dca <sched>
  release(&p->lock);
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	b52080e7          	jalr	-1198(ra) # 80000b26 <release>
}
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <sleep>:
{
    80001fe6:	7179                	addi	sp,sp,-48
    80001fe8:	f406                	sd	ra,40(sp)
    80001fea:	f022                	sd	s0,32(sp)
    80001fec:	ec26                	sd	s1,24(sp)
    80001fee:	e84a                	sd	s2,16(sp)
    80001ff0:	e44e                	sd	s3,8(sp)
    80001ff2:	1800                	addi	s0,sp,48
    80001ff4:	89aa                	mv	s3,a0
    80001ff6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	84c080e7          	jalr	-1972(ra) # 80001844 <myproc>
    80002000:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002002:	05250663          	beq	a0,s2,8000204e <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	acc080e7          	jalr	-1332(ra) # 80000ad2 <acquire>
    release(lk);
    8000200e:	854a                	mv	a0,s2
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	b16080e7          	jalr	-1258(ra) # 80000b26 <release>
  p->chan = chan;
    80002018:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000201c:	4785                	li	a5,1
    8000201e:	cc9c                	sw	a5,24(s1)
  sched();
    80002020:	00000097          	auipc	ra,0x0
    80002024:	daa080e7          	jalr	-598(ra) # 80001dca <sched>
  p->chan = 0;
    80002028:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000202c:	8526                	mv	a0,s1
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	af8080e7          	jalr	-1288(ra) # 80000b26 <release>
    acquire(lk);
    80002036:	854a                	mv	a0,s2
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	a9a080e7          	jalr	-1382(ra) # 80000ad2 <acquire>
}
    80002040:	70a2                	ld	ra,40(sp)
    80002042:	7402                	ld	s0,32(sp)
    80002044:	64e2                	ld	s1,24(sp)
    80002046:	6942                	ld	s2,16(sp)
    80002048:	69a2                	ld	s3,8(sp)
    8000204a:	6145                	addi	sp,sp,48
    8000204c:	8082                	ret
  p->chan = chan;
    8000204e:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002052:	4785                	li	a5,1
    80002054:	cd1c                	sw	a5,24(a0)
  sched();
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	d74080e7          	jalr	-652(ra) # 80001dca <sched>
  p->chan = 0;
    8000205e:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002062:	bff9                	j	80002040 <sleep+0x5a>

0000000080002064 <wait>:
{
    80002064:	715d                	addi	sp,sp,-80
    80002066:	e486                	sd	ra,72(sp)
    80002068:	e0a2                	sd	s0,64(sp)
    8000206a:	fc26                	sd	s1,56(sp)
    8000206c:	f84a                	sd	s2,48(sp)
    8000206e:	f44e                	sd	s3,40(sp)
    80002070:	f052                	sd	s4,32(sp)
    80002072:	ec56                	sd	s5,24(sp)
    80002074:	e85a                	sd	s6,16(sp)
    80002076:	e45e                	sd	s7,8(sp)
    80002078:	e062                	sd	s8,0(sp)
    8000207a:	0880                	addi	s0,sp,80
    8000207c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	7c6080e7          	jalr	1990(ra) # 80001844 <myproc>
    80002086:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002088:	8c2a                	mv	s8,a0
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	a48080e7          	jalr	-1464(ra) # 80000ad2 <acquire>
    havekids = 0;
    80002092:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002094:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002096:	00014997          	auipc	s3,0x14
    8000209a:	66a98993          	addi	s3,s3,1642 # 80016700 <tickslock>
        havekids = 1;
    8000209e:	4a85                	li	s5,1
    havekids = 0;
    800020a0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800020a2:	0000f497          	auipc	s1,0xf
    800020a6:	c5e48493          	addi	s1,s1,-930 # 80010d00 <proc>
    800020aa:	a08d                	j	8000210c <wait+0xa8>
          pid = np->pid;
    800020ac:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800020b0:	000b0e63          	beqz	s6,800020cc <wait+0x68>
    800020b4:	4691                	li	a3,4
    800020b6:	03448613          	addi	a2,s1,52
    800020ba:	85da                	mv	a1,s6
    800020bc:	05093503          	ld	a0,80(s2)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	478080e7          	jalr	1144(ra) # 80001538 <copyout>
    800020c8:	02054263          	bltz	a0,800020ec <wait+0x88>
          freeproc(np);
    800020cc:	8526                	mv	a0,s1
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	992080e7          	jalr	-1646(ra) # 80001a60 <freeproc>
          release(&np->lock);
    800020d6:	8526                	mv	a0,s1
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	a4e080e7          	jalr	-1458(ra) # 80000b26 <release>
          release(&p->lock);
    800020e0:	854a                	mv	a0,s2
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	a44080e7          	jalr	-1468(ra) # 80000b26 <release>
          return pid;
    800020ea:	a8a9                	j	80002144 <wait+0xe0>
            release(&np->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	a38080e7          	jalr	-1480(ra) # 80000b26 <release>
            release(&p->lock);
    800020f6:	854a                	mv	a0,s2
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	a2e080e7          	jalr	-1490(ra) # 80000b26 <release>
            return -1;
    80002100:	59fd                	li	s3,-1
    80002102:	a089                	j	80002144 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002104:	16848493          	addi	s1,s1,360
    80002108:	03348463          	beq	s1,s3,80002130 <wait+0xcc>
      if(np->parent == p){
    8000210c:	709c                	ld	a5,32(s1)
    8000210e:	ff279be3          	bne	a5,s2,80002104 <wait+0xa0>
        acquire(&np->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	9be080e7          	jalr	-1602(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    8000211c:	4c9c                	lw	a5,24(s1)
    8000211e:	f94787e3          	beq	a5,s4,800020ac <wait+0x48>
        release(&np->lock);
    80002122:	8526                	mv	a0,s1
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	a02080e7          	jalr	-1534(ra) # 80000b26 <release>
        havekids = 1;
    8000212c:	8756                	mv	a4,s5
    8000212e:	bfd9                	j	80002104 <wait+0xa0>
    if(!havekids || p->killed){
    80002130:	c701                	beqz	a4,80002138 <wait+0xd4>
    80002132:	03092783          	lw	a5,48(s2)
    80002136:	c785                	beqz	a5,8000215e <wait+0xfa>
      release(&p->lock);
    80002138:	854a                	mv	a0,s2
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	9ec080e7          	jalr	-1556(ra) # 80000b26 <release>
      return -1;
    80002142:	59fd                	li	s3,-1
}
    80002144:	854e                	mv	a0,s3
    80002146:	60a6                	ld	ra,72(sp)
    80002148:	6406                	ld	s0,64(sp)
    8000214a:	74e2                	ld	s1,56(sp)
    8000214c:	7942                	ld	s2,48(sp)
    8000214e:	79a2                	ld	s3,40(sp)
    80002150:	7a02                	ld	s4,32(sp)
    80002152:	6ae2                	ld	s5,24(sp)
    80002154:	6b42                	ld	s6,16(sp)
    80002156:	6ba2                	ld	s7,8(sp)
    80002158:	6c02                	ld	s8,0(sp)
    8000215a:	6161                	addi	sp,sp,80
    8000215c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000215e:	85e2                	mv	a1,s8
    80002160:	854a                	mv	a0,s2
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e84080e7          	jalr	-380(ra) # 80001fe6 <sleep>
    havekids = 0;
    8000216a:	bf1d                	j	800020a0 <wait+0x3c>

000000008000216c <wakeup>:
{
    8000216c:	7139                	addi	sp,sp,-64
    8000216e:	fc06                	sd	ra,56(sp)
    80002170:	f822                	sd	s0,48(sp)
    80002172:	f426                	sd	s1,40(sp)
    80002174:	f04a                	sd	s2,32(sp)
    80002176:	ec4e                	sd	s3,24(sp)
    80002178:	e852                	sd	s4,16(sp)
    8000217a:	e456                	sd	s5,8(sp)
    8000217c:	0080                	addi	s0,sp,64
    8000217e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002180:	0000f497          	auipc	s1,0xf
    80002184:	b8048493          	addi	s1,s1,-1152 # 80010d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002188:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000218a:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218c:	00014917          	auipc	s2,0x14
    80002190:	57490913          	addi	s2,s2,1396 # 80016700 <tickslock>
    80002194:	a821                	j	800021ac <wakeup+0x40>
      p->state = RUNNABLE;
    80002196:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    8000219a:	8526                	mv	a0,s1
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	98a080e7          	jalr	-1654(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021a4:	16848493          	addi	s1,s1,360
    800021a8:	01248e63          	beq	s1,s2,800021c4 <wakeup+0x58>
    acquire(&p->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	924080e7          	jalr	-1756(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800021b6:	4c9c                	lw	a5,24(s1)
    800021b8:	ff3791e3          	bne	a5,s3,8000219a <wakeup+0x2e>
    800021bc:	749c                	ld	a5,40(s1)
    800021be:	fd479ee3          	bne	a5,s4,8000219a <wakeup+0x2e>
    800021c2:	bfd1                	j	80002196 <wakeup+0x2a>
}
    800021c4:	70e2                	ld	ra,56(sp)
    800021c6:	7442                	ld	s0,48(sp)
    800021c8:	74a2                	ld	s1,40(sp)
    800021ca:	7902                	ld	s2,32(sp)
    800021cc:	69e2                	ld	s3,24(sp)
    800021ce:	6a42                	ld	s4,16(sp)
    800021d0:	6aa2                	ld	s5,8(sp)
    800021d2:	6121                	addi	sp,sp,64
    800021d4:	8082                	ret

00000000800021d6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	1800                	addi	s0,sp,48
    800021e4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800021e6:	0000f497          	auipc	s1,0xf
    800021ea:	b1a48493          	addi	s1,s1,-1254 # 80010d00 <proc>
    800021ee:	00014997          	auipc	s3,0x14
    800021f2:	51298993          	addi	s3,s3,1298 # 80016700 <tickslock>
    acquire(&p->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	8da080e7          	jalr	-1830(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    80002200:	5c9c                	lw	a5,56(s1)
    80002202:	01278d63          	beq	a5,s2,8000221c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	91e080e7          	jalr	-1762(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002210:	16848493          	addi	s1,s1,360
    80002214:	ff3491e3          	bne	s1,s3,800021f6 <kill+0x20>
  }
  return -1;
    80002218:	557d                	li	a0,-1
    8000221a:	a821                	j	80002232 <kill+0x5c>
      p->killed = 1;
    8000221c:	4785                	li	a5,1
    8000221e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002220:	4c98                	lw	a4,24(s1)
    80002222:	00f70f63          	beq	a4,a5,80002240 <kill+0x6a>
      release(&p->lock);
    80002226:	8526                	mv	a0,s1
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	8fe080e7          	jalr	-1794(ra) # 80000b26 <release>
      return 0;
    80002230:	4501                	li	a0,0
}
    80002232:	70a2                	ld	ra,40(sp)
    80002234:	7402                	ld	s0,32(sp)
    80002236:	64e2                	ld	s1,24(sp)
    80002238:	6942                	ld	s2,16(sp)
    8000223a:	69a2                	ld	s3,8(sp)
    8000223c:	6145                	addi	sp,sp,48
    8000223e:	8082                	ret
        p->state = RUNNABLE;
    80002240:	4789                	li	a5,2
    80002242:	cc9c                	sw	a5,24(s1)
    80002244:	b7cd                	j	80002226 <kill+0x50>

0000000080002246 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002246:	7179                	addi	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	addi	s0,sp,48
    80002256:	84aa                	mv	s1,a0
    80002258:	892e                	mv	s2,a1
    8000225a:	89b2                	mv	s3,a2
    8000225c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	5e6080e7          	jalr	1510(ra) # 80001844 <myproc>
  if(user_dst){
    80002266:	c08d                	beqz	s1,80002288 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002268:	86d2                	mv	a3,s4
    8000226a:	864e                	mv	a2,s3
    8000226c:	85ca                	mv	a1,s2
    8000226e:	6928                	ld	a0,80(a0)
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	2c8080e7          	jalr	712(ra) # 80001538 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002278:	70a2                	ld	ra,40(sp)
    8000227a:	7402                	ld	s0,32(sp)
    8000227c:	64e2                	ld	s1,24(sp)
    8000227e:	6942                	ld	s2,16(sp)
    80002280:	69a2                	ld	s3,8(sp)
    80002282:	6a02                	ld	s4,0(sp)
    80002284:	6145                	addi	sp,sp,48
    80002286:	8082                	ret
    memmove((char *)dst, src, len);
    80002288:	000a061b          	sext.w	a2,s4
    8000228c:	85ce                	mv	a1,s3
    8000228e:	854a                	mv	a0,s2
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	93e080e7          	jalr	-1730(ra) # 80000bce <memmove>
    return 0;
    80002298:	8526                	mv	a0,s1
    8000229a:	bff9                	j	80002278 <either_copyout+0x32>

000000008000229c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000229c:	7179                	addi	sp,sp,-48
    8000229e:	f406                	sd	ra,40(sp)
    800022a0:	f022                	sd	s0,32(sp)
    800022a2:	ec26                	sd	s1,24(sp)
    800022a4:	e84a                	sd	s2,16(sp)
    800022a6:	e44e                	sd	s3,8(sp)
    800022a8:	e052                	sd	s4,0(sp)
    800022aa:	1800                	addi	s0,sp,48
    800022ac:	892a                	mv	s2,a0
    800022ae:	84ae                	mv	s1,a1
    800022b0:	89b2                	mv	s3,a2
    800022b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	590080e7          	jalr	1424(ra) # 80001844 <myproc>
  if(user_src){
    800022bc:	c08d                	beqz	s1,800022de <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800022be:	86d2                	mv	a3,s4
    800022c0:	864e                	mv	a2,s3
    800022c2:	85ca                	mv	a1,s2
    800022c4:	6928                	ld	a0,80(a0)
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	2fe080e7          	jalr	766(ra) # 800015c4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022ce:	70a2                	ld	ra,40(sp)
    800022d0:	7402                	ld	s0,32(sp)
    800022d2:	64e2                	ld	s1,24(sp)
    800022d4:	6942                	ld	s2,16(sp)
    800022d6:	69a2                	ld	s3,8(sp)
    800022d8:	6a02                	ld	s4,0(sp)
    800022da:	6145                	addi	sp,sp,48
    800022dc:	8082                	ret
    memmove(dst, (char*)src, len);
    800022de:	000a061b          	sext.w	a2,s4
    800022e2:	85ce                	mv	a1,s3
    800022e4:	854a                	mv	a0,s2
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	8e8080e7          	jalr	-1816(ra) # 80000bce <memmove>
    return 0;
    800022ee:	8526                	mv	a0,s1
    800022f0:	bff9                	j	800022ce <either_copyin+0x32>

00000000800022f2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022f2:	715d                	addi	sp,sp,-80
    800022f4:	e486                	sd	ra,72(sp)
    800022f6:	e0a2                	sd	s0,64(sp)
    800022f8:	fc26                	sd	s1,56(sp)
    800022fa:	f84a                	sd	s2,48(sp)
    800022fc:	f44e                	sd	s3,40(sp)
    800022fe:	f052                	sd	s4,32(sp)
    80002300:	ec56                	sd	s5,24(sp)
    80002302:	e85a                	sd	s6,16(sp)
    80002304:	e45e                	sd	s7,8(sp)
    80002306:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002308:	00004517          	auipc	a0,0x4
    8000230c:	ea850513          	addi	a0,a0,-344 # 800061b0 <userret+0x120>
    80002310:	ffffe097          	auipc	ra,0xffffe
    80002314:	288080e7          	jalr	648(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002318:	0000f497          	auipc	s1,0xf
    8000231c:	b4048493          	addi	s1,s1,-1216 # 80010e58 <proc+0x158>
    80002320:	00014917          	auipc	s2,0x14
    80002324:	53890913          	addi	s2,s2,1336 # 80016858 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002328:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000232a:	00004997          	auipc	s3,0x4
    8000232e:	03e98993          	addi	s3,s3,62 # 80006368 <userret+0x2d8>
    printf("%d %s %s", p->pid, state, p->name);
    80002332:	00004a97          	auipc	s5,0x4
    80002336:	03ea8a93          	addi	s5,s5,62 # 80006370 <userret+0x2e0>
    printf("\n");
    8000233a:	00004a17          	auipc	s4,0x4
    8000233e:	e76a0a13          	addi	s4,s4,-394 # 800061b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002342:	00004b97          	auipc	s7,0x4
    80002346:	4e6b8b93          	addi	s7,s7,1254 # 80006828 <states.1693>
    8000234a:	a00d                	j	8000236c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000234c:	ee06a583          	lw	a1,-288(a3)
    80002350:	8556                	mv	a0,s5
    80002352:	ffffe097          	auipc	ra,0xffffe
    80002356:	246080e7          	jalr	582(ra) # 80000598 <printf>
    printf("\n");
    8000235a:	8552                	mv	a0,s4
    8000235c:	ffffe097          	auipc	ra,0xffffe
    80002360:	23c080e7          	jalr	572(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002364:	16848493          	addi	s1,s1,360
    80002368:	03248163          	beq	s1,s2,8000238a <procdump+0x98>
    if(p->state == UNUSED)
    8000236c:	86a6                	mv	a3,s1
    8000236e:	ec04a783          	lw	a5,-320(s1)
    80002372:	dbed                	beqz	a5,80002364 <procdump+0x72>
      state = "???";
    80002374:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002376:	fcfb6be3          	bltu	s6,a5,8000234c <procdump+0x5a>
    8000237a:	1782                	slli	a5,a5,0x20
    8000237c:	9381                	srli	a5,a5,0x20
    8000237e:	078e                	slli	a5,a5,0x3
    80002380:	97de                	add	a5,a5,s7
    80002382:	6390                	ld	a2,0(a5)
    80002384:	f661                	bnez	a2,8000234c <procdump+0x5a>
      state = "???";
    80002386:	864e                	mv	a2,s3
    80002388:	b7d1                	j	8000234c <procdump+0x5a>
  }
}
    8000238a:	60a6                	ld	ra,72(sp)
    8000238c:	6406                	ld	s0,64(sp)
    8000238e:	74e2                	ld	s1,56(sp)
    80002390:	7942                	ld	s2,48(sp)
    80002392:	79a2                	ld	s3,40(sp)
    80002394:	7a02                	ld	s4,32(sp)
    80002396:	6ae2                	ld	s5,24(sp)
    80002398:	6b42                	ld	s6,16(sp)
    8000239a:	6ba2                	ld	s7,8(sp)
    8000239c:	6161                	addi	sp,sp,80
    8000239e:	8082                	ret

00000000800023a0 <swtch>:
    800023a0:	00153023          	sd	ra,0(a0)
    800023a4:	00253423          	sd	sp,8(a0)
    800023a8:	e900                	sd	s0,16(a0)
    800023aa:	ed04                	sd	s1,24(a0)
    800023ac:	03253023          	sd	s2,32(a0)
    800023b0:	03353423          	sd	s3,40(a0)
    800023b4:	03453823          	sd	s4,48(a0)
    800023b8:	03553c23          	sd	s5,56(a0)
    800023bc:	05653023          	sd	s6,64(a0)
    800023c0:	05753423          	sd	s7,72(a0)
    800023c4:	05853823          	sd	s8,80(a0)
    800023c8:	05953c23          	sd	s9,88(a0)
    800023cc:	07a53023          	sd	s10,96(a0)
    800023d0:	07b53423          	sd	s11,104(a0)
    800023d4:	0005b083          	ld	ra,0(a1)
    800023d8:	0085b103          	ld	sp,8(a1)
    800023dc:	6980                	ld	s0,16(a1)
    800023de:	6d84                	ld	s1,24(a1)
    800023e0:	0205b903          	ld	s2,32(a1)
    800023e4:	0285b983          	ld	s3,40(a1)
    800023e8:	0305ba03          	ld	s4,48(a1)
    800023ec:	0385ba83          	ld	s5,56(a1)
    800023f0:	0405bb03          	ld	s6,64(a1)
    800023f4:	0485bb83          	ld	s7,72(a1)
    800023f8:	0505bc03          	ld	s8,80(a1)
    800023fc:	0585bc83          	ld	s9,88(a1)
    80002400:	0605bd03          	ld	s10,96(a1)
    80002404:	0685bd83          	ld	s11,104(a1)
    80002408:	8082                	ret

000000008000240a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000240a:	1141                	addi	sp,sp,-16
    8000240c:	e406                	sd	ra,8(sp)
    8000240e:	e022                	sd	s0,0(sp)
    80002410:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002412:	00004597          	auipc	a1,0x4
    80002416:	f9658593          	addi	a1,a1,-106 # 800063a8 <userret+0x318>
    8000241a:	00014517          	auipc	a0,0x14
    8000241e:	2e650513          	addi	a0,a0,742 # 80016700 <tickslock>
    80002422:	ffffe097          	auipc	ra,0xffffe
    80002426:	59e080e7          	jalr	1438(ra) # 800009c0 <initlock>
}
    8000242a:	60a2                	ld	ra,8(sp)
    8000242c:	6402                	ld	s0,0(sp)
    8000242e:	0141                	addi	sp,sp,16
    80002430:	8082                	ret

0000000080002432 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002432:	1141                	addi	sp,sp,-16
    80002434:	e422                	sd	s0,8(sp)
    80002436:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002438:	00003797          	auipc	a5,0x3
    8000243c:	45878793          	addi	a5,a5,1112 # 80005890 <kernelvec>
    80002440:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002444:	6422                	ld	s0,8(sp)
    80002446:	0141                	addi	sp,sp,16
    80002448:	8082                	ret

000000008000244a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000244a:	1141                	addi	sp,sp,-16
    8000244c:	e406                	sd	ra,8(sp)
    8000244e:	e022                	sd	s0,0(sp)
    80002450:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002452:	fffff097          	auipc	ra,0xfffff
    80002456:	3f2080e7          	jalr	1010(ra) # 80001844 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000245a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000245e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002460:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002464:	00004617          	auipc	a2,0x4
    80002468:	b9c60613          	addi	a2,a2,-1124 # 80006000 <trampoline>
    8000246c:	00004697          	auipc	a3,0x4
    80002470:	b9468693          	addi	a3,a3,-1132 # 80006000 <trampoline>
    80002474:	8e91                	sub	a3,a3,a2
    80002476:	040007b7          	lui	a5,0x4000
    8000247a:	17fd                	addi	a5,a5,-1
    8000247c:	07b2                	slli	a5,a5,0xc
    8000247e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002480:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    80002484:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002486:	180026f3          	csrr	a3,satp
    8000248a:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000248c:	6d38                	ld	a4,88(a0)
    8000248e:	6134                	ld	a3,64(a0)
    80002490:	6585                	lui	a1,0x1
    80002492:	96ae                	add	a3,a3,a1
    80002494:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    80002496:	6d38                	ld	a4,88(a0)
    80002498:	00000697          	auipc	a3,0x0
    8000249c:	12268693          	addi	a3,a3,290 # 800025ba <usertrap>
    800024a0:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800024a2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024a4:	8692                	mv	a3,tp
    800024a6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024a8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024ac:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024b0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024b4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800024b8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024ba:	6f18                	ld	a4,24(a4)
    800024bc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024c0:	692c                	ld	a1,80(a0)
    800024c2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800024c4:	00004717          	auipc	a4,0x4
    800024c8:	bcc70713          	addi	a4,a4,-1076 # 80006090 <userret>
    800024cc:	8f11                	sub	a4,a4,a2
    800024ce:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800024d0:	577d                	li	a4,-1
    800024d2:	177e                	slli	a4,a4,0x3f
    800024d4:	8dd9                	or	a1,a1,a4
    800024d6:	02000537          	lui	a0,0x2000
    800024da:	157d                	addi	a0,a0,-1
    800024dc:	0536                	slli	a0,a0,0xd
    800024de:	9782                	jalr	a5
}
    800024e0:	60a2                	ld	ra,8(sp)
    800024e2:	6402                	ld	s0,0(sp)
    800024e4:	0141                	addi	sp,sp,16
    800024e6:	8082                	ret

00000000800024e8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024e8:	1101                	addi	sp,sp,-32
    800024ea:	ec06                	sd	ra,24(sp)
    800024ec:	e822                	sd	s0,16(sp)
    800024ee:	e426                	sd	s1,8(sp)
    800024f0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800024f2:	00014497          	auipc	s1,0x14
    800024f6:	20e48493          	addi	s1,s1,526 # 80016700 <tickslock>
    800024fa:	8526                	mv	a0,s1
    800024fc:	ffffe097          	auipc	ra,0xffffe
    80002500:	5d6080e7          	jalr	1494(ra) # 80000ad2 <acquire>
  ticks++;
    80002504:	00023517          	auipc	a0,0x23
    80002508:	b1450513          	addi	a0,a0,-1260 # 80025018 <ticks>
    8000250c:	411c                	lw	a5,0(a0)
    8000250e:	2785                	addiw	a5,a5,1
    80002510:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002512:	00000097          	auipc	ra,0x0
    80002516:	c5a080e7          	jalr	-934(ra) # 8000216c <wakeup>
  release(&tickslock);
    8000251a:	8526                	mv	a0,s1
    8000251c:	ffffe097          	auipc	ra,0xffffe
    80002520:	60a080e7          	jalr	1546(ra) # 80000b26 <release>
}
    80002524:	60e2                	ld	ra,24(sp)
    80002526:	6442                	ld	s0,16(sp)
    80002528:	64a2                	ld	s1,8(sp)
    8000252a:	6105                	addi	sp,sp,32
    8000252c:	8082                	ret

000000008000252e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000252e:	1101                	addi	sp,sp,-32
    80002530:	ec06                	sd	ra,24(sp)
    80002532:	e822                	sd	s0,16(sp)
    80002534:	e426                	sd	s1,8(sp)
    80002536:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002538:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000253c:	00074d63          	bltz	a4,80002556 <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    80002540:	57fd                	li	a5,-1
    80002542:	17fe                	slli	a5,a5,0x3f
    80002544:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002546:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002548:	04f70863          	beq	a4,a5,80002598 <devintr+0x6a>
  }
}
    8000254c:	60e2                	ld	ra,24(sp)
    8000254e:	6442                	ld	s0,16(sp)
    80002550:	64a2                	ld	s1,8(sp)
    80002552:	6105                	addi	sp,sp,32
    80002554:	8082                	ret
     (scause & 0xff) == 9){
    80002556:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000255a:	46a5                	li	a3,9
    8000255c:	fed792e3          	bne	a5,a3,80002540 <devintr+0x12>
    int irq = plic_claim();
    80002560:	00003097          	auipc	ra,0x3
    80002564:	44a080e7          	jalr	1098(ra) # 800059aa <plic_claim>
    80002568:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000256a:	47a9                	li	a5,10
    8000256c:	00f50c63          	beq	a0,a5,80002584 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    80002570:	4785                	li	a5,1
    80002572:	00f50e63          	beq	a0,a5,8000258e <devintr+0x60>
    plic_complete(irq);
    80002576:	8526                	mv	a0,s1
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	456080e7          	jalr	1110(ra) # 800059ce <plic_complete>
    return 1;
    80002580:	4505                	li	a0,1
    80002582:	b7e9                	j	8000254c <devintr+0x1e>
      uartintr();
    80002584:	ffffe097          	auipc	ra,0xffffe
    80002588:	2b4080e7          	jalr	692(ra) # 80000838 <uartintr>
    8000258c:	b7ed                	j	80002576 <devintr+0x48>
      virtio_disk_intr();
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	8d0080e7          	jalr	-1840(ra) # 80005e5e <virtio_disk_intr>
    80002596:	b7c5                	j	80002576 <devintr+0x48>
    if(cpuid() == 0){
    80002598:	fffff097          	auipc	ra,0xfffff
    8000259c:	280080e7          	jalr	640(ra) # 80001818 <cpuid>
    800025a0:	c901                	beqz	a0,800025b0 <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800025a2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800025a6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800025a8:	14479073          	csrw	sip,a5
    return 2;
    800025ac:	4509                	li	a0,2
    800025ae:	bf79                	j	8000254c <devintr+0x1e>
      clockintr();
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	f38080e7          	jalr	-200(ra) # 800024e8 <clockintr>
    800025b8:	b7ed                	j	800025a2 <devintr+0x74>

00000000800025ba <usertrap>:
{
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec06                	sd	ra,24(sp)
    800025be:	e822                	sd	s0,16(sp)
    800025c0:	e426                	sd	s1,8(sp)
    800025c2:	e04a                	sd	s2,0(sp)
    800025c4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025ca:	1007f793          	andi	a5,a5,256
    800025ce:	e7bd                	bnez	a5,8000263c <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025d0:	00003797          	auipc	a5,0x3
    800025d4:	2c078793          	addi	a5,a5,704 # 80005890 <kernelvec>
    800025d8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025dc:	fffff097          	auipc	ra,0xfffff
    800025e0:	268080e7          	jalr	616(ra) # 80001844 <myproc>
    800025e4:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    800025e6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025e8:	14102773          	csrr	a4,sepc
    800025ec:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025ee:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025f2:	47a1                	li	a5,8
    800025f4:	06f71263          	bne	a4,a5,80002658 <usertrap+0x9e>
    if(p->killed)
    800025f8:	591c                	lw	a5,48(a0)
    800025fa:	eba9                	bnez	a5,8000264c <usertrap+0x92>
    p->tf->epc += 4;
    800025fc:	6cb8                	ld	a4,88(s1)
    800025fe:	6f1c                	ld	a5,24(a4)
    80002600:	0791                	addi	a5,a5,4
    80002602:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002604:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80002608:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000260c:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002610:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002614:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002618:	10079073          	csrw	sstatus,a5
    syscall();
    8000261c:	00000097          	auipc	ra,0x0
    80002620:	2e0080e7          	jalr	736(ra) # 800028fc <syscall>
  if(p->killed)
    80002624:	589c                	lw	a5,48(s1)
    80002626:	ebc1                	bnez	a5,800026b6 <usertrap+0xfc>
  usertrapret();
    80002628:	00000097          	auipc	ra,0x0
    8000262c:	e22080e7          	jalr	-478(ra) # 8000244a <usertrapret>
}
    80002630:	60e2                	ld	ra,24(sp)
    80002632:	6442                	ld	s0,16(sp)
    80002634:	64a2                	ld	s1,8(sp)
    80002636:	6902                	ld	s2,0(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret
    panic("usertrap: not from user mode");
    8000263c:	00004517          	auipc	a0,0x4
    80002640:	d7450513          	addi	a0,a0,-652 # 800063b0 <userret+0x320>
    80002644:	ffffe097          	auipc	ra,0xffffe
    80002648:	f0a080e7          	jalr	-246(ra) # 8000054e <panic>
      exit(-1);
    8000264c:	557d                	li	a0,-1
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	852080e7          	jalr	-1966(ra) # 80001ea0 <exit>
    80002656:	b75d                	j	800025fc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	ed6080e7          	jalr	-298(ra) # 8000252e <devintr>
    80002660:	892a                	mv	s2,a0
    80002662:	c501                	beqz	a0,8000266a <usertrap+0xb0>
  if(p->killed)
    80002664:	589c                	lw	a5,48(s1)
    80002666:	c3a1                	beqz	a5,800026a6 <usertrap+0xec>
    80002668:	a815                	j	8000269c <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000266a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000266e:	5c90                	lw	a2,56(s1)
    80002670:	00004517          	auipc	a0,0x4
    80002674:	d6050513          	addi	a0,a0,-672 # 800063d0 <userret+0x340>
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	f20080e7          	jalr	-224(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002680:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002684:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002688:	00004517          	auipc	a0,0x4
    8000268c:	d7850513          	addi	a0,a0,-648 # 80006400 <userret+0x370>
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	f08080e7          	jalr	-248(ra) # 80000598 <printf>
    p->killed = 1;
    80002698:	4785                	li	a5,1
    8000269a:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000269c:	557d                	li	a0,-1
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	802080e7          	jalr	-2046(ra) # 80001ea0 <exit>
  if(which_dev == 2)
    800026a6:	4789                	li	a5,2
    800026a8:	f8f910e3          	bne	s2,a5,80002628 <usertrap+0x6e>
    yield();
    800026ac:	00000097          	auipc	ra,0x0
    800026b0:	8fe080e7          	jalr	-1794(ra) # 80001faa <yield>
    800026b4:	bf95                	j	80002628 <usertrap+0x6e>
  int which_dev = 0;
    800026b6:	4901                	li	s2,0
    800026b8:	b7d5                	j	8000269c <usertrap+0xe2>

00000000800026ba <kerneltrap>:
{
    800026ba:	7179                	addi	sp,sp,-48
    800026bc:	f406                	sd	ra,40(sp)
    800026be:	f022                	sd	s0,32(sp)
    800026c0:	ec26                	sd	s1,24(sp)
    800026c2:	e84a                	sd	s2,16(sp)
    800026c4:	e44e                	sd	s3,8(sp)
    800026c6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026c8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026cc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026d4:	1004f793          	andi	a5,s1,256
    800026d8:	cb85                	beqz	a5,80002708 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026de:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026e0:	ef85                	bnez	a5,80002718 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	e4c080e7          	jalr	-436(ra) # 8000252e <devintr>
    800026ea:	cd1d                	beqz	a0,80002728 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800026ec:	4789                	li	a5,2
    800026ee:	06f50a63          	beq	a0,a5,80002762 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026f2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026f6:	10049073          	csrw	sstatus,s1
}
    800026fa:	70a2                	ld	ra,40(sp)
    800026fc:	7402                	ld	s0,32(sp)
    800026fe:	64e2                	ld	s1,24(sp)
    80002700:	6942                	ld	s2,16(sp)
    80002702:	69a2                	ld	s3,8(sp)
    80002704:	6145                	addi	sp,sp,48
    80002706:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002708:	00004517          	auipc	a0,0x4
    8000270c:	d1850513          	addi	a0,a0,-744 # 80006420 <userret+0x390>
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	e3e080e7          	jalr	-450(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    80002718:	00004517          	auipc	a0,0x4
    8000271c:	d3050513          	addi	a0,a0,-720 # 80006448 <userret+0x3b8>
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	e2e080e7          	jalr	-466(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    80002728:	85ce                	mv	a1,s3
    8000272a:	00004517          	auipc	a0,0x4
    8000272e:	d3e50513          	addi	a0,a0,-706 # 80006468 <userret+0x3d8>
    80002732:	ffffe097          	auipc	ra,0xffffe
    80002736:	e66080e7          	jalr	-410(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000273a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000273e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002742:	00004517          	auipc	a0,0x4
    80002746:	d3650513          	addi	a0,a0,-714 # 80006478 <userret+0x3e8>
    8000274a:	ffffe097          	auipc	ra,0xffffe
    8000274e:	e4e080e7          	jalr	-434(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002752:	00004517          	auipc	a0,0x4
    80002756:	d3e50513          	addi	a0,a0,-706 # 80006490 <userret+0x400>
    8000275a:	ffffe097          	auipc	ra,0xffffe
    8000275e:	df4080e7          	jalr	-524(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002762:	fffff097          	auipc	ra,0xfffff
    80002766:	0e2080e7          	jalr	226(ra) # 80001844 <myproc>
    8000276a:	d541                	beqz	a0,800026f2 <kerneltrap+0x38>
    8000276c:	fffff097          	auipc	ra,0xfffff
    80002770:	0d8080e7          	jalr	216(ra) # 80001844 <myproc>
    80002774:	4d18                	lw	a4,24(a0)
    80002776:	478d                	li	a5,3
    80002778:	f6f71de3          	bne	a4,a5,800026f2 <kerneltrap+0x38>
    yield();
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	82e080e7          	jalr	-2002(ra) # 80001faa <yield>
    80002784:	b7bd                	j	800026f2 <kerneltrap+0x38>

0000000080002786 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002786:	1101                	addi	sp,sp,-32
    80002788:	ec06                	sd	ra,24(sp)
    8000278a:	e822                	sd	s0,16(sp)
    8000278c:	e426                	sd	s1,8(sp)
    8000278e:	1000                	addi	s0,sp,32
    80002790:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002792:	fffff097          	auipc	ra,0xfffff
    80002796:	0b2080e7          	jalr	178(ra) # 80001844 <myproc>
  switch (n) {
    8000279a:	4795                	li	a5,5
    8000279c:	0497e163          	bltu	a5,s1,800027de <argraw+0x58>
    800027a0:	048a                	slli	s1,s1,0x2
    800027a2:	00004717          	auipc	a4,0x4
    800027a6:	0ae70713          	addi	a4,a4,174 # 80006850 <states.1693+0x28>
    800027aa:	94ba                	add	s1,s1,a4
    800027ac:	409c                	lw	a5,0(s1)
    800027ae:	97ba                	add	a5,a5,a4
    800027b0:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    800027b2:	6d3c                	ld	a5,88(a0)
    800027b4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6105                	addi	sp,sp,32
    800027be:	8082                	ret
    return p->tf->a1;
    800027c0:	6d3c                	ld	a5,88(a0)
    800027c2:	7fa8                	ld	a0,120(a5)
    800027c4:	bfcd                	j	800027b6 <argraw+0x30>
    return p->tf->a2;
    800027c6:	6d3c                	ld	a5,88(a0)
    800027c8:	63c8                	ld	a0,128(a5)
    800027ca:	b7f5                	j	800027b6 <argraw+0x30>
    return p->tf->a3;
    800027cc:	6d3c                	ld	a5,88(a0)
    800027ce:	67c8                	ld	a0,136(a5)
    800027d0:	b7dd                	j	800027b6 <argraw+0x30>
    return p->tf->a4;
    800027d2:	6d3c                	ld	a5,88(a0)
    800027d4:	6bc8                	ld	a0,144(a5)
    800027d6:	b7c5                	j	800027b6 <argraw+0x30>
    return p->tf->a5;
    800027d8:	6d3c                	ld	a5,88(a0)
    800027da:	6fc8                	ld	a0,152(a5)
    800027dc:	bfe9                	j	800027b6 <argraw+0x30>
  panic("argraw");
    800027de:	00004517          	auipc	a0,0x4
    800027e2:	cc250513          	addi	a0,a0,-830 # 800064a0 <userret+0x410>
    800027e6:	ffffe097          	auipc	ra,0xffffe
    800027ea:	d68080e7          	jalr	-664(ra) # 8000054e <panic>

00000000800027ee <fetchaddr>:
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	e04a                	sd	s2,0(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
    800027fc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027fe:	fffff097          	auipc	ra,0xfffff
    80002802:	046080e7          	jalr	70(ra) # 80001844 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002806:	653c                	ld	a5,72(a0)
    80002808:	02f4f863          	bgeu	s1,a5,80002838 <fetchaddr+0x4a>
    8000280c:	00848713          	addi	a4,s1,8
    80002810:	02e7e663          	bltu	a5,a4,8000283c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002814:	46a1                	li	a3,8
    80002816:	8626                	mv	a2,s1
    80002818:	85ca                	mv	a1,s2
    8000281a:	6928                	ld	a0,80(a0)
    8000281c:	fffff097          	auipc	ra,0xfffff
    80002820:	da8080e7          	jalr	-600(ra) # 800015c4 <copyin>
    80002824:	00a03533          	snez	a0,a0
    80002828:	40a00533          	neg	a0,a0
}
    8000282c:	60e2                	ld	ra,24(sp)
    8000282e:	6442                	ld	s0,16(sp)
    80002830:	64a2                	ld	s1,8(sp)
    80002832:	6902                	ld	s2,0(sp)
    80002834:	6105                	addi	sp,sp,32
    80002836:	8082                	ret
    return -1;
    80002838:	557d                	li	a0,-1
    8000283a:	bfcd                	j	8000282c <fetchaddr+0x3e>
    8000283c:	557d                	li	a0,-1
    8000283e:	b7fd                	j	8000282c <fetchaddr+0x3e>

0000000080002840 <fetchstr>:
{
    80002840:	7179                	addi	sp,sp,-48
    80002842:	f406                	sd	ra,40(sp)
    80002844:	f022                	sd	s0,32(sp)
    80002846:	ec26                	sd	s1,24(sp)
    80002848:	e84a                	sd	s2,16(sp)
    8000284a:	e44e                	sd	s3,8(sp)
    8000284c:	1800                	addi	s0,sp,48
    8000284e:	892a                	mv	s2,a0
    80002850:	84ae                	mv	s1,a1
    80002852:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002854:	fffff097          	auipc	ra,0xfffff
    80002858:	ff0080e7          	jalr	-16(ra) # 80001844 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000285c:	86ce                	mv	a3,s3
    8000285e:	864a                	mv	a2,s2
    80002860:	85a6                	mv	a1,s1
    80002862:	6928                	ld	a0,80(a0)
    80002864:	fffff097          	auipc	ra,0xfffff
    80002868:	dec080e7          	jalr	-532(ra) # 80001650 <copyinstr>
  if(err < 0)
    8000286c:	00054763          	bltz	a0,8000287a <fetchstr+0x3a>
  return strlen(buf);
    80002870:	8526                	mv	a0,s1
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	484080e7          	jalr	1156(ra) # 80000cf6 <strlen>
}
    8000287a:	70a2                	ld	ra,40(sp)
    8000287c:	7402                	ld	s0,32(sp)
    8000287e:	64e2                	ld	s1,24(sp)
    80002880:	6942                	ld	s2,16(sp)
    80002882:	69a2                	ld	s3,8(sp)
    80002884:	6145                	addi	sp,sp,48
    80002886:	8082                	ret

0000000080002888 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	e426                	sd	s1,8(sp)
    80002890:	1000                	addi	s0,sp,32
    80002892:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002894:	00000097          	auipc	ra,0x0
    80002898:	ef2080e7          	jalr	-270(ra) # 80002786 <argraw>
    8000289c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000289e:	4501                	li	a0,0
    800028a0:	60e2                	ld	ra,24(sp)
    800028a2:	6442                	ld	s0,16(sp)
    800028a4:	64a2                	ld	s1,8(sp)
    800028a6:	6105                	addi	sp,sp,32
    800028a8:	8082                	ret

00000000800028aa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800028aa:	1101                	addi	sp,sp,-32
    800028ac:	ec06                	sd	ra,24(sp)
    800028ae:	e822                	sd	s0,16(sp)
    800028b0:	e426                	sd	s1,8(sp)
    800028b2:	1000                	addi	s0,sp,32
    800028b4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	ed0080e7          	jalr	-304(ra) # 80002786 <argraw>
    800028be:	e088                	sd	a0,0(s1)
  return 0;
}
    800028c0:	4501                	li	a0,0
    800028c2:	60e2                	ld	ra,24(sp)
    800028c4:	6442                	ld	s0,16(sp)
    800028c6:	64a2                	ld	s1,8(sp)
    800028c8:	6105                	addi	sp,sp,32
    800028ca:	8082                	ret

00000000800028cc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028cc:	1101                	addi	sp,sp,-32
    800028ce:	ec06                	sd	ra,24(sp)
    800028d0:	e822                	sd	s0,16(sp)
    800028d2:	e426                	sd	s1,8(sp)
    800028d4:	e04a                	sd	s2,0(sp)
    800028d6:	1000                	addi	s0,sp,32
    800028d8:	84ae                	mv	s1,a1
    800028da:	8932                	mv	s2,a2
  *ip = argraw(n);
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	eaa080e7          	jalr	-342(ra) # 80002786 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800028e4:	864a                	mv	a2,s2
    800028e6:	85a6                	mv	a1,s1
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	f58080e7          	jalr	-168(ra) # 80002840 <fetchstr>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret

00000000800028fc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800028fc:	1101                	addi	sp,sp,-32
    800028fe:	ec06                	sd	ra,24(sp)
    80002900:	e822                	sd	s0,16(sp)
    80002902:	e426                	sd	s1,8(sp)
    80002904:	e04a                	sd	s2,0(sp)
    80002906:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002908:	fffff097          	auipc	ra,0xfffff
    8000290c:	f3c080e7          	jalr	-196(ra) # 80001844 <myproc>
    80002910:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002912:	05853903          	ld	s2,88(a0)
    80002916:	0a893783          	ld	a5,168(s2)
    8000291a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000291e:	37fd                	addiw	a5,a5,-1
    80002920:	4751                	li	a4,20
    80002922:	00f76f63          	bltu	a4,a5,80002940 <syscall+0x44>
    80002926:	00369713          	slli	a4,a3,0x3
    8000292a:	00004797          	auipc	a5,0x4
    8000292e:	f3e78793          	addi	a5,a5,-194 # 80006868 <syscalls>
    80002932:	97ba                	add	a5,a5,a4
    80002934:	639c                	ld	a5,0(a5)
    80002936:	c789                	beqz	a5,80002940 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002938:	9782                	jalr	a5
    8000293a:	06a93823          	sd	a0,112(s2)
    8000293e:	a839                	j	8000295c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002940:	15848613          	addi	a2,s1,344
    80002944:	5c8c                	lw	a1,56(s1)
    80002946:	00004517          	auipc	a0,0x4
    8000294a:	b6250513          	addi	a0,a0,-1182 # 800064a8 <userret+0x418>
    8000294e:	ffffe097          	auipc	ra,0xffffe
    80002952:	c4a080e7          	jalr	-950(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002956:	6cbc                	ld	a5,88(s1)
    80002958:	577d                	li	a4,-1
    8000295a:	fbb8                	sd	a4,112(a5)
  }
}
    8000295c:	60e2                	ld	ra,24(sp)
    8000295e:	6442                	ld	s0,16(sp)
    80002960:	64a2                	ld	s1,8(sp)
    80002962:	6902                	ld	s2,0(sp)
    80002964:	6105                	addi	sp,sp,32
    80002966:	8082                	ret

0000000080002968 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002968:	1101                	addi	sp,sp,-32
    8000296a:	ec06                	sd	ra,24(sp)
    8000296c:	e822                	sd	s0,16(sp)
    8000296e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002970:	fec40593          	addi	a1,s0,-20
    80002974:	4501                	li	a0,0
    80002976:	00000097          	auipc	ra,0x0
    8000297a:	f12080e7          	jalr	-238(ra) # 80002888 <argint>
    return -1;
    8000297e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002980:	00054963          	bltz	a0,80002992 <sys_exit+0x2a>
  exit(n);
    80002984:	fec42503          	lw	a0,-20(s0)
    80002988:	fffff097          	auipc	ra,0xfffff
    8000298c:	518080e7          	jalr	1304(ra) # 80001ea0 <exit>
  return 0;  // not reached
    80002990:	4781                	li	a5,0
}
    80002992:	853e                	mv	a0,a5
    80002994:	60e2                	ld	ra,24(sp)
    80002996:	6442                	ld	s0,16(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret

000000008000299c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000299c:	1141                	addi	sp,sp,-16
    8000299e:	e406                	sd	ra,8(sp)
    800029a0:	e022                	sd	s0,0(sp)
    800029a2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029a4:	fffff097          	auipc	ra,0xfffff
    800029a8:	ea0080e7          	jalr	-352(ra) # 80001844 <myproc>
}
    800029ac:	5d08                	lw	a0,56(a0)
    800029ae:	60a2                	ld	ra,8(sp)
    800029b0:	6402                	ld	s0,0(sp)
    800029b2:	0141                	addi	sp,sp,16
    800029b4:	8082                	ret

00000000800029b6 <sys_fork>:

uint64
sys_fork(void)
{
    800029b6:	1141                	addi	sp,sp,-16
    800029b8:	e406                	sd	ra,8(sp)
    800029ba:	e022                	sd	s0,0(sp)
    800029bc:	0800                	addi	s0,sp,16
  return fork();
    800029be:	fffff097          	auipc	ra,0xfffff
    800029c2:	1f0080e7          	jalr	496(ra) # 80001bae <fork>
}
    800029c6:	60a2                	ld	ra,8(sp)
    800029c8:	6402                	ld	s0,0(sp)
    800029ca:	0141                	addi	sp,sp,16
    800029cc:	8082                	ret

00000000800029ce <sys_wait>:

uint64
sys_wait(void)
{
    800029ce:	1101                	addi	sp,sp,-32
    800029d0:	ec06                	sd	ra,24(sp)
    800029d2:	e822                	sd	s0,16(sp)
    800029d4:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800029d6:	fe840593          	addi	a1,s0,-24
    800029da:	4501                	li	a0,0
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	ece080e7          	jalr	-306(ra) # 800028aa <argaddr>
    800029e4:	87aa                	mv	a5,a0
    return -1;
    800029e6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800029e8:	0007c863          	bltz	a5,800029f8 <sys_wait+0x2a>
  return wait(p);
    800029ec:	fe843503          	ld	a0,-24(s0)
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	674080e7          	jalr	1652(ra) # 80002064 <wait>
}
    800029f8:	60e2                	ld	ra,24(sp)
    800029fa:	6442                	ld	s0,16(sp)
    800029fc:	6105                	addi	sp,sp,32
    800029fe:	8082                	ret

0000000080002a00 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a00:	7179                	addi	sp,sp,-48
    80002a02:	f406                	sd	ra,40(sp)
    80002a04:	f022                	sd	s0,32(sp)
    80002a06:	ec26                	sd	s1,24(sp)
    80002a08:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002a0a:	fdc40593          	addi	a1,s0,-36
    80002a0e:	4501                	li	a0,0
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	e78080e7          	jalr	-392(ra) # 80002888 <argint>
    80002a18:	87aa                	mv	a5,a0
    return -1;
    80002a1a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002a1c:	0207c063          	bltz	a5,80002a3c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002a20:	fffff097          	auipc	ra,0xfffff
    80002a24:	e24080e7          	jalr	-476(ra) # 80001844 <myproc>
    80002a28:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002a2a:	fdc42503          	lw	a0,-36(s0)
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	10c080e7          	jalr	268(ra) # 80001b3a <growproc>
    80002a36:	00054863          	bltz	a0,80002a46 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002a3a:	8526                	mv	a0,s1
}
    80002a3c:	70a2                	ld	ra,40(sp)
    80002a3e:	7402                	ld	s0,32(sp)
    80002a40:	64e2                	ld	s1,24(sp)
    80002a42:	6145                	addi	sp,sp,48
    80002a44:	8082                	ret
    return -1;
    80002a46:	557d                	li	a0,-1
    80002a48:	bfd5                	j	80002a3c <sys_sbrk+0x3c>

0000000080002a4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a4a:	7139                	addi	sp,sp,-64
    80002a4c:	fc06                	sd	ra,56(sp)
    80002a4e:	f822                	sd	s0,48(sp)
    80002a50:	f426                	sd	s1,40(sp)
    80002a52:	f04a                	sd	s2,32(sp)
    80002a54:	ec4e                	sd	s3,24(sp)
    80002a56:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002a58:	fcc40593          	addi	a1,s0,-52
    80002a5c:	4501                	li	a0,0
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	e2a080e7          	jalr	-470(ra) # 80002888 <argint>
    return -1;
    80002a66:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002a68:	06054563          	bltz	a0,80002ad2 <sys_sleep+0x88>
  acquire(&tickslock);
    80002a6c:	00014517          	auipc	a0,0x14
    80002a70:	c9450513          	addi	a0,a0,-876 # 80016700 <tickslock>
    80002a74:	ffffe097          	auipc	ra,0xffffe
    80002a78:	05e080e7          	jalr	94(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    80002a7c:	00022917          	auipc	s2,0x22
    80002a80:	59c92903          	lw	s2,1436(s2) # 80025018 <ticks>
  while(ticks - ticks0 < n){
    80002a84:	fcc42783          	lw	a5,-52(s0)
    80002a88:	cf85                	beqz	a5,80002ac0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a8a:	00014997          	auipc	s3,0x14
    80002a8e:	c7698993          	addi	s3,s3,-906 # 80016700 <tickslock>
    80002a92:	00022497          	auipc	s1,0x22
    80002a96:	58648493          	addi	s1,s1,1414 # 80025018 <ticks>
    if(myproc()->killed){
    80002a9a:	fffff097          	auipc	ra,0xfffff
    80002a9e:	daa080e7          	jalr	-598(ra) # 80001844 <myproc>
    80002aa2:	591c                	lw	a5,48(a0)
    80002aa4:	ef9d                	bnez	a5,80002ae2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002aa6:	85ce                	mv	a1,s3
    80002aa8:	8526                	mv	a0,s1
    80002aaa:	fffff097          	auipc	ra,0xfffff
    80002aae:	53c080e7          	jalr	1340(ra) # 80001fe6 <sleep>
  while(ticks - ticks0 < n){
    80002ab2:	409c                	lw	a5,0(s1)
    80002ab4:	412787bb          	subw	a5,a5,s2
    80002ab8:	fcc42703          	lw	a4,-52(s0)
    80002abc:	fce7efe3          	bltu	a5,a4,80002a9a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002ac0:	00014517          	auipc	a0,0x14
    80002ac4:	c4050513          	addi	a0,a0,-960 # 80016700 <tickslock>
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	05e080e7          	jalr	94(ra) # 80000b26 <release>
  return 0;
    80002ad0:	4781                	li	a5,0
}
    80002ad2:	853e                	mv	a0,a5
    80002ad4:	70e2                	ld	ra,56(sp)
    80002ad6:	7442                	ld	s0,48(sp)
    80002ad8:	74a2                	ld	s1,40(sp)
    80002ada:	7902                	ld	s2,32(sp)
    80002adc:	69e2                	ld	s3,24(sp)
    80002ade:	6121                	addi	sp,sp,64
    80002ae0:	8082                	ret
      release(&tickslock);
    80002ae2:	00014517          	auipc	a0,0x14
    80002ae6:	c1e50513          	addi	a0,a0,-994 # 80016700 <tickslock>
    80002aea:	ffffe097          	auipc	ra,0xffffe
    80002aee:	03c080e7          	jalr	60(ra) # 80000b26 <release>
      return -1;
    80002af2:	57fd                	li	a5,-1
    80002af4:	bff9                	j	80002ad2 <sys_sleep+0x88>

0000000080002af6 <sys_kill>:

uint64
sys_kill(void)
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002afe:	fec40593          	addi	a1,s0,-20
    80002b02:	4501                	li	a0,0
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	d84080e7          	jalr	-636(ra) # 80002888 <argint>
    80002b0c:	87aa                	mv	a5,a0
    return -1;
    80002b0e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002b10:	0007c863          	bltz	a5,80002b20 <sys_kill+0x2a>
  return kill(pid);
    80002b14:	fec42503          	lw	a0,-20(s0)
    80002b18:	fffff097          	auipc	ra,0xfffff
    80002b1c:	6be080e7          	jalr	1726(ra) # 800021d6 <kill>
}
    80002b20:	60e2                	ld	ra,24(sp)
    80002b22:	6442                	ld	s0,16(sp)
    80002b24:	6105                	addi	sp,sp,32
    80002b26:	8082                	ret

0000000080002b28 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b32:	00014517          	auipc	a0,0x14
    80002b36:	bce50513          	addi	a0,a0,-1074 # 80016700 <tickslock>
    80002b3a:	ffffe097          	auipc	ra,0xffffe
    80002b3e:	f98080e7          	jalr	-104(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80002b42:	00022497          	auipc	s1,0x22
    80002b46:	4d64a483          	lw	s1,1238(s1) # 80025018 <ticks>
  release(&tickslock);
    80002b4a:	00014517          	auipc	a0,0x14
    80002b4e:	bb650513          	addi	a0,a0,-1098 # 80016700 <tickslock>
    80002b52:	ffffe097          	auipc	ra,0xffffe
    80002b56:	fd4080e7          	jalr	-44(ra) # 80000b26 <release>
  return xticks;
}
    80002b5a:	02049513          	slli	a0,s1,0x20
    80002b5e:	9101                	srli	a0,a0,0x20
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	64a2                	ld	s1,8(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret

0000000080002b6a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b6a:	7179                	addi	sp,sp,-48
    80002b6c:	f406                	sd	ra,40(sp)
    80002b6e:	f022                	sd	s0,32(sp)
    80002b70:	ec26                	sd	s1,24(sp)
    80002b72:	e84a                	sd	s2,16(sp)
    80002b74:	e44e                	sd	s3,8(sp)
    80002b76:	e052                	sd	s4,0(sp)
    80002b78:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b7a:	00004597          	auipc	a1,0x4
    80002b7e:	94e58593          	addi	a1,a1,-1714 # 800064c8 <userret+0x438>
    80002b82:	00014517          	auipc	a0,0x14
    80002b86:	b9650513          	addi	a0,a0,-1130 # 80016718 <bcache>
    80002b8a:	ffffe097          	auipc	ra,0xffffe
    80002b8e:	e36080e7          	jalr	-458(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b92:	0001c797          	auipc	a5,0x1c
    80002b96:	b8678793          	addi	a5,a5,-1146 # 8001e718 <bcache+0x8000>
    80002b9a:	0001c717          	auipc	a4,0x1c
    80002b9e:	ed670713          	addi	a4,a4,-298 # 8001ea70 <bcache+0x8358>
    80002ba2:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002ba6:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002baa:	00014497          	auipc	s1,0x14
    80002bae:	b8648493          	addi	s1,s1,-1146 # 80016730 <bcache+0x18>
    b->next = bcache.head.next;
    80002bb2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002bb4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bb6:	00004a17          	auipc	s4,0x4
    80002bba:	91aa0a13          	addi	s4,s4,-1766 # 800064d0 <userret+0x440>
    b->next = bcache.head.next;
    80002bbe:	3a893783          	ld	a5,936(s2)
    80002bc2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bc4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bc8:	85d2                	mv	a1,s4
    80002bca:	01048513          	addi	a0,s1,16
    80002bce:	00001097          	auipc	ra,0x1
    80002bd2:	486080e7          	jalr	1158(ra) # 80004054 <initsleeplock>
    bcache.head.next->prev = b;
    80002bd6:	3a893783          	ld	a5,936(s2)
    80002bda:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bdc:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002be0:	46048493          	addi	s1,s1,1120
    80002be4:	fd349de3          	bne	s1,s3,80002bbe <binit+0x54>
  }
}
    80002be8:	70a2                	ld	ra,40(sp)
    80002bea:	7402                	ld	s0,32(sp)
    80002bec:	64e2                	ld	s1,24(sp)
    80002bee:	6942                	ld	s2,16(sp)
    80002bf0:	69a2                	ld	s3,8(sp)
    80002bf2:	6a02                	ld	s4,0(sp)
    80002bf4:	6145                	addi	sp,sp,48
    80002bf6:	8082                	ret

0000000080002bf8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002bf8:	7179                	addi	sp,sp,-48
    80002bfa:	f406                	sd	ra,40(sp)
    80002bfc:	f022                	sd	s0,32(sp)
    80002bfe:	ec26                	sd	s1,24(sp)
    80002c00:	e84a                	sd	s2,16(sp)
    80002c02:	e44e                	sd	s3,8(sp)
    80002c04:	1800                	addi	s0,sp,48
    80002c06:	89aa                	mv	s3,a0
    80002c08:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002c0a:	00014517          	auipc	a0,0x14
    80002c0e:	b0e50513          	addi	a0,a0,-1266 # 80016718 <bcache>
    80002c12:	ffffe097          	auipc	ra,0xffffe
    80002c16:	ec0080e7          	jalr	-320(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c1a:	0001c497          	auipc	s1,0x1c
    80002c1e:	ea64b483          	ld	s1,-346(s1) # 8001eac0 <bcache+0x83a8>
    80002c22:	0001c797          	auipc	a5,0x1c
    80002c26:	e4e78793          	addi	a5,a5,-434 # 8001ea70 <bcache+0x8358>
    80002c2a:	02f48f63          	beq	s1,a5,80002c68 <bread+0x70>
    80002c2e:	873e                	mv	a4,a5
    80002c30:	a021                	j	80002c38 <bread+0x40>
    80002c32:	68a4                	ld	s1,80(s1)
    80002c34:	02e48a63          	beq	s1,a4,80002c68 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002c38:	449c                	lw	a5,8(s1)
    80002c3a:	ff379ce3          	bne	a5,s3,80002c32 <bread+0x3a>
    80002c3e:	44dc                	lw	a5,12(s1)
    80002c40:	ff2799e3          	bne	a5,s2,80002c32 <bread+0x3a>
      b->refcnt++;
    80002c44:	40bc                	lw	a5,64(s1)
    80002c46:	2785                	addiw	a5,a5,1
    80002c48:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c4a:	00014517          	auipc	a0,0x14
    80002c4e:	ace50513          	addi	a0,a0,-1330 # 80016718 <bcache>
    80002c52:	ffffe097          	auipc	ra,0xffffe
    80002c56:	ed4080e7          	jalr	-300(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002c5a:	01048513          	addi	a0,s1,16
    80002c5e:	00001097          	auipc	ra,0x1
    80002c62:	430080e7          	jalr	1072(ra) # 8000408e <acquiresleep>
      return b;
    80002c66:	a8b9                	j	80002cc4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c68:	0001c497          	auipc	s1,0x1c
    80002c6c:	e504b483          	ld	s1,-432(s1) # 8001eab8 <bcache+0x83a0>
    80002c70:	0001c797          	auipc	a5,0x1c
    80002c74:	e0078793          	addi	a5,a5,-512 # 8001ea70 <bcache+0x8358>
    80002c78:	00f48863          	beq	s1,a5,80002c88 <bread+0x90>
    80002c7c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c7e:	40bc                	lw	a5,64(s1)
    80002c80:	cf81                	beqz	a5,80002c98 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c82:	64a4                	ld	s1,72(s1)
    80002c84:	fee49de3          	bne	s1,a4,80002c7e <bread+0x86>
  panic("bget: no buffers");
    80002c88:	00004517          	auipc	a0,0x4
    80002c8c:	85050513          	addi	a0,a0,-1968 # 800064d8 <userret+0x448>
    80002c90:	ffffe097          	auipc	ra,0xffffe
    80002c94:	8be080e7          	jalr	-1858(ra) # 8000054e <panic>
      b->dev = dev;
    80002c98:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002c9c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002ca0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ca4:	4785                	li	a5,1
    80002ca6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ca8:	00014517          	auipc	a0,0x14
    80002cac:	a7050513          	addi	a0,a0,-1424 # 80016718 <bcache>
    80002cb0:	ffffe097          	auipc	ra,0xffffe
    80002cb4:	e76080e7          	jalr	-394(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002cb8:	01048513          	addi	a0,s1,16
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	3d2080e7          	jalr	978(ra) # 8000408e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cc4:	409c                	lw	a5,0(s1)
    80002cc6:	cb89                	beqz	a5,80002cd8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cc8:	8526                	mv	a0,s1
    80002cca:	70a2                	ld	ra,40(sp)
    80002ccc:	7402                	ld	s0,32(sp)
    80002cce:	64e2                	ld	s1,24(sp)
    80002cd0:	6942                	ld	s2,16(sp)
    80002cd2:	69a2                	ld	s3,8(sp)
    80002cd4:	6145                	addi	sp,sp,48
    80002cd6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cd8:	4581                	li	a1,0
    80002cda:	8526                	mv	a0,s1
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	ee2080e7          	jalr	-286(ra) # 80005bbe <virtio_disk_rw>
    b->valid = 1;
    80002ce4:	4785                	li	a5,1
    80002ce6:	c09c                	sw	a5,0(s1)
  return b;
    80002ce8:	b7c5                	j	80002cc8 <bread+0xd0>

0000000080002cea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cea:	1101                	addi	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	e426                	sd	s1,8(sp)
    80002cf2:	1000                	addi	s0,sp,32
    80002cf4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cf6:	0541                	addi	a0,a0,16
    80002cf8:	00001097          	auipc	ra,0x1
    80002cfc:	430080e7          	jalr	1072(ra) # 80004128 <holdingsleep>
    80002d00:	cd01                	beqz	a0,80002d18 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d02:	4585                	li	a1,1
    80002d04:	8526                	mv	a0,s1
    80002d06:	00003097          	auipc	ra,0x3
    80002d0a:	eb8080e7          	jalr	-328(ra) # 80005bbe <virtio_disk_rw>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret
    panic("bwrite");
    80002d18:	00003517          	auipc	a0,0x3
    80002d1c:	7d850513          	addi	a0,a0,2008 # 800064f0 <userret+0x460>
    80002d20:	ffffe097          	auipc	ra,0xffffe
    80002d24:	82e080e7          	jalr	-2002(ra) # 8000054e <panic>

0000000080002d28 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002d28:	1101                	addi	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	e04a                	sd	s2,0(sp)
    80002d32:	1000                	addi	s0,sp,32
    80002d34:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d36:	01050913          	addi	s2,a0,16
    80002d3a:	854a                	mv	a0,s2
    80002d3c:	00001097          	auipc	ra,0x1
    80002d40:	3ec080e7          	jalr	1004(ra) # 80004128 <holdingsleep>
    80002d44:	c92d                	beqz	a0,80002db6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002d46:	854a                	mv	a0,s2
    80002d48:	00001097          	auipc	ra,0x1
    80002d4c:	39c080e7          	jalr	924(ra) # 800040e4 <releasesleep>

  acquire(&bcache.lock);
    80002d50:	00014517          	auipc	a0,0x14
    80002d54:	9c850513          	addi	a0,a0,-1592 # 80016718 <bcache>
    80002d58:	ffffe097          	auipc	ra,0xffffe
    80002d5c:	d7a080e7          	jalr	-646(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002d60:	40bc                	lw	a5,64(s1)
    80002d62:	37fd                	addiw	a5,a5,-1
    80002d64:	0007871b          	sext.w	a4,a5
    80002d68:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d6a:	eb05                	bnez	a4,80002d9a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d6c:	68bc                	ld	a5,80(s1)
    80002d6e:	64b8                	ld	a4,72(s1)
    80002d70:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002d72:	64bc                	ld	a5,72(s1)
    80002d74:	68b8                	ld	a4,80(s1)
    80002d76:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d78:	0001c797          	auipc	a5,0x1c
    80002d7c:	9a078793          	addi	a5,a5,-1632 # 8001e718 <bcache+0x8000>
    80002d80:	3a87b703          	ld	a4,936(a5)
    80002d84:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d86:	0001c717          	auipc	a4,0x1c
    80002d8a:	cea70713          	addi	a4,a4,-790 # 8001ea70 <bcache+0x8358>
    80002d8e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d90:	3a87b703          	ld	a4,936(a5)
    80002d94:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d96:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002d9a:	00014517          	auipc	a0,0x14
    80002d9e:	97e50513          	addi	a0,a0,-1666 # 80016718 <bcache>
    80002da2:	ffffe097          	auipc	ra,0xffffe
    80002da6:	d84080e7          	jalr	-636(ra) # 80000b26 <release>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	64a2                	ld	s1,8(sp)
    80002db0:	6902                	ld	s2,0(sp)
    80002db2:	6105                	addi	sp,sp,32
    80002db4:	8082                	ret
    panic("brelse");
    80002db6:	00003517          	auipc	a0,0x3
    80002dba:	74250513          	addi	a0,a0,1858 # 800064f8 <userret+0x468>
    80002dbe:	ffffd097          	auipc	ra,0xffffd
    80002dc2:	790080e7          	jalr	1936(ra) # 8000054e <panic>

0000000080002dc6 <bpin>:

void
bpin(struct buf *b) {
    80002dc6:	1101                	addi	sp,sp,-32
    80002dc8:	ec06                	sd	ra,24(sp)
    80002dca:	e822                	sd	s0,16(sp)
    80002dcc:	e426                	sd	s1,8(sp)
    80002dce:	1000                	addi	s0,sp,32
    80002dd0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dd2:	00014517          	auipc	a0,0x14
    80002dd6:	94650513          	addi	a0,a0,-1722 # 80016718 <bcache>
    80002dda:	ffffe097          	auipc	ra,0xffffe
    80002dde:	cf8080e7          	jalr	-776(ra) # 80000ad2 <acquire>
  b->refcnt++;
    80002de2:	40bc                	lw	a5,64(s1)
    80002de4:	2785                	addiw	a5,a5,1
    80002de6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002de8:	00014517          	auipc	a0,0x14
    80002dec:	93050513          	addi	a0,a0,-1744 # 80016718 <bcache>
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	d36080e7          	jalr	-714(ra) # 80000b26 <release>
}
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret

0000000080002e02 <bunpin>:

void
bunpin(struct buf *b) {
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	e426                	sd	s1,8(sp)
    80002e0a:	1000                	addi	s0,sp,32
    80002e0c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e0e:	00014517          	auipc	a0,0x14
    80002e12:	90a50513          	addi	a0,a0,-1782 # 80016718 <bcache>
    80002e16:	ffffe097          	auipc	ra,0xffffe
    80002e1a:	cbc080e7          	jalr	-836(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002e1e:	40bc                	lw	a5,64(s1)
    80002e20:	37fd                	addiw	a5,a5,-1
    80002e22:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e24:	00014517          	auipc	a0,0x14
    80002e28:	8f450513          	addi	a0,a0,-1804 # 80016718 <bcache>
    80002e2c:	ffffe097          	auipc	ra,0xffffe
    80002e30:	cfa080e7          	jalr	-774(ra) # 80000b26 <release>
}
    80002e34:	60e2                	ld	ra,24(sp)
    80002e36:	6442                	ld	s0,16(sp)
    80002e38:	64a2                	ld	s1,8(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret

0000000080002e3e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e3e:	1101                	addi	sp,sp,-32
    80002e40:	ec06                	sd	ra,24(sp)
    80002e42:	e822                	sd	s0,16(sp)
    80002e44:	e426                	sd	s1,8(sp)
    80002e46:	e04a                	sd	s2,0(sp)
    80002e48:	1000                	addi	s0,sp,32
    80002e4a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e4c:	00d5d59b          	srliw	a1,a1,0xd
    80002e50:	0001c797          	auipc	a5,0x1c
    80002e54:	09c7a783          	lw	a5,156(a5) # 8001eeec <sb+0x1c>
    80002e58:	9dbd                	addw	a1,a1,a5
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	d9e080e7          	jalr	-610(ra) # 80002bf8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e62:	0074f713          	andi	a4,s1,7
    80002e66:	4785                	li	a5,1
    80002e68:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e6c:	14ce                	slli	s1,s1,0x33
    80002e6e:	90d9                	srli	s1,s1,0x36
    80002e70:	00950733          	add	a4,a0,s1
    80002e74:	06074703          	lbu	a4,96(a4)
    80002e78:	00e7f6b3          	and	a3,a5,a4
    80002e7c:	c69d                	beqz	a3,80002eaa <bfree+0x6c>
    80002e7e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e80:	94aa                	add	s1,s1,a0
    80002e82:	fff7c793          	not	a5,a5
    80002e86:	8ff9                	and	a5,a5,a4
    80002e88:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002e8c:	00001097          	auipc	ra,0x1
    80002e90:	0da080e7          	jalr	218(ra) # 80003f66 <log_write>
  brelse(bp);
    80002e94:	854a                	mv	a0,s2
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	e92080e7          	jalr	-366(ra) # 80002d28 <brelse>
}
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	6902                	ld	s2,0(sp)
    80002ea6:	6105                	addi	sp,sp,32
    80002ea8:	8082                	ret
    panic("freeing free block");
    80002eaa:	00003517          	auipc	a0,0x3
    80002eae:	65650513          	addi	a0,a0,1622 # 80006500 <userret+0x470>
    80002eb2:	ffffd097          	auipc	ra,0xffffd
    80002eb6:	69c080e7          	jalr	1692(ra) # 8000054e <panic>

0000000080002eba <balloc>:
{
    80002eba:	711d                	addi	sp,sp,-96
    80002ebc:	ec86                	sd	ra,88(sp)
    80002ebe:	e8a2                	sd	s0,80(sp)
    80002ec0:	e4a6                	sd	s1,72(sp)
    80002ec2:	e0ca                	sd	s2,64(sp)
    80002ec4:	fc4e                	sd	s3,56(sp)
    80002ec6:	f852                	sd	s4,48(sp)
    80002ec8:	f456                	sd	s5,40(sp)
    80002eca:	f05a                	sd	s6,32(sp)
    80002ecc:	ec5e                	sd	s7,24(sp)
    80002ece:	e862                	sd	s8,16(sp)
    80002ed0:	e466                	sd	s9,8(sp)
    80002ed2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002ed4:	0001c797          	auipc	a5,0x1c
    80002ed8:	0007a783          	lw	a5,0(a5) # 8001eed4 <sb+0x4>
    80002edc:	cbd1                	beqz	a5,80002f70 <balloc+0xb6>
    80002ede:	8baa                	mv	s7,a0
    80002ee0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ee2:	0001cb17          	auipc	s6,0x1c
    80002ee6:	feeb0b13          	addi	s6,s6,-18 # 8001eed0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eea:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002eec:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eee:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002ef0:	6c89                	lui	s9,0x2
    80002ef2:	a831                	j	80002f0e <balloc+0x54>
    brelse(bp);
    80002ef4:	854a                	mv	a0,s2
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	e32080e7          	jalr	-462(ra) # 80002d28 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002efe:	015c87bb          	addw	a5,s9,s5
    80002f02:	00078a9b          	sext.w	s5,a5
    80002f06:	004b2703          	lw	a4,4(s6)
    80002f0a:	06eaf363          	bgeu	s5,a4,80002f70 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002f0e:	41fad79b          	sraiw	a5,s5,0x1f
    80002f12:	0137d79b          	srliw	a5,a5,0x13
    80002f16:	015787bb          	addw	a5,a5,s5
    80002f1a:	40d7d79b          	sraiw	a5,a5,0xd
    80002f1e:	01cb2583          	lw	a1,28(s6)
    80002f22:	9dbd                	addw	a1,a1,a5
    80002f24:	855e                	mv	a0,s7
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	cd2080e7          	jalr	-814(ra) # 80002bf8 <bread>
    80002f2e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f30:	004b2503          	lw	a0,4(s6)
    80002f34:	000a849b          	sext.w	s1,s5
    80002f38:	8662                	mv	a2,s8
    80002f3a:	faa4fde3          	bgeu	s1,a0,80002ef4 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002f3e:	41f6579b          	sraiw	a5,a2,0x1f
    80002f42:	01d7d69b          	srliw	a3,a5,0x1d
    80002f46:	00c6873b          	addw	a4,a3,a2
    80002f4a:	00777793          	andi	a5,a4,7
    80002f4e:	9f95                	subw	a5,a5,a3
    80002f50:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f54:	4037571b          	sraiw	a4,a4,0x3
    80002f58:	00e906b3          	add	a3,s2,a4
    80002f5c:	0606c683          	lbu	a3,96(a3)
    80002f60:	00d7f5b3          	and	a1,a5,a3
    80002f64:	cd91                	beqz	a1,80002f80 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f66:	2605                	addiw	a2,a2,1
    80002f68:	2485                	addiw	s1,s1,1
    80002f6a:	fd4618e3          	bne	a2,s4,80002f3a <balloc+0x80>
    80002f6e:	b759                	j	80002ef4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002f70:	00003517          	auipc	a0,0x3
    80002f74:	5a850513          	addi	a0,a0,1448 # 80006518 <userret+0x488>
    80002f78:	ffffd097          	auipc	ra,0xffffd
    80002f7c:	5d6080e7          	jalr	1494(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f80:	974a                	add	a4,a4,s2
    80002f82:	8fd5                	or	a5,a5,a3
    80002f84:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002f88:	854a                	mv	a0,s2
    80002f8a:	00001097          	auipc	ra,0x1
    80002f8e:	fdc080e7          	jalr	-36(ra) # 80003f66 <log_write>
        brelse(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	d94080e7          	jalr	-620(ra) # 80002d28 <brelse>
  bp = bread(dev, bno);
    80002f9c:	85a6                	mv	a1,s1
    80002f9e:	855e                	mv	a0,s7
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	c58080e7          	jalr	-936(ra) # 80002bf8 <bread>
    80002fa8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002faa:	40000613          	li	a2,1024
    80002fae:	4581                	li	a1,0
    80002fb0:	06050513          	addi	a0,a0,96
    80002fb4:	ffffe097          	auipc	ra,0xffffe
    80002fb8:	bba080e7          	jalr	-1094(ra) # 80000b6e <memset>
  log_write(bp);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	00001097          	auipc	ra,0x1
    80002fc2:	fa8080e7          	jalr	-88(ra) # 80003f66 <log_write>
  brelse(bp);
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	d60080e7          	jalr	-672(ra) # 80002d28 <brelse>
}
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	60e6                	ld	ra,88(sp)
    80002fd4:	6446                	ld	s0,80(sp)
    80002fd6:	64a6                	ld	s1,72(sp)
    80002fd8:	6906                	ld	s2,64(sp)
    80002fda:	79e2                	ld	s3,56(sp)
    80002fdc:	7a42                	ld	s4,48(sp)
    80002fde:	7aa2                	ld	s5,40(sp)
    80002fe0:	7b02                	ld	s6,32(sp)
    80002fe2:	6be2                	ld	s7,24(sp)
    80002fe4:	6c42                	ld	s8,16(sp)
    80002fe6:	6ca2                	ld	s9,8(sp)
    80002fe8:	6125                	addi	sp,sp,96
    80002fea:	8082                	ret

0000000080002fec <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fec:	7179                	addi	sp,sp,-48
    80002fee:	f406                	sd	ra,40(sp)
    80002ff0:	f022                	sd	s0,32(sp)
    80002ff2:	ec26                	sd	s1,24(sp)
    80002ff4:	e84a                	sd	s2,16(sp)
    80002ff6:	e44e                	sd	s3,8(sp)
    80002ff8:	e052                	sd	s4,0(sp)
    80002ffa:	1800                	addi	s0,sp,48
    80002ffc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ffe:	47ad                	li	a5,11
    80003000:	04b7fe63          	bgeu	a5,a1,8000305c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003004:	ff45849b          	addiw	s1,a1,-12
    80003008:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000300c:	0ff00793          	li	a5,255
    80003010:	0ae7e363          	bltu	a5,a4,800030b6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003014:	08052583          	lw	a1,128(a0)
    80003018:	c5ad                	beqz	a1,80003082 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000301a:	00092503          	lw	a0,0(s2)
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	bda080e7          	jalr	-1062(ra) # 80002bf8 <bread>
    80003026:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003028:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    8000302c:	02049593          	slli	a1,s1,0x20
    80003030:	9181                	srli	a1,a1,0x20
    80003032:	058a                	slli	a1,a1,0x2
    80003034:	00b784b3          	add	s1,a5,a1
    80003038:	0004a983          	lw	s3,0(s1)
    8000303c:	04098d63          	beqz	s3,80003096 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003040:	8552                	mv	a0,s4
    80003042:	00000097          	auipc	ra,0x0
    80003046:	ce6080e7          	jalr	-794(ra) # 80002d28 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000304a:	854e                	mv	a0,s3
    8000304c:	70a2                	ld	ra,40(sp)
    8000304e:	7402                	ld	s0,32(sp)
    80003050:	64e2                	ld	s1,24(sp)
    80003052:	6942                	ld	s2,16(sp)
    80003054:	69a2                	ld	s3,8(sp)
    80003056:	6a02                	ld	s4,0(sp)
    80003058:	6145                	addi	sp,sp,48
    8000305a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000305c:	02059493          	slli	s1,a1,0x20
    80003060:	9081                	srli	s1,s1,0x20
    80003062:	048a                	slli	s1,s1,0x2
    80003064:	94aa                	add	s1,s1,a0
    80003066:	0504a983          	lw	s3,80(s1)
    8000306a:	fe0990e3          	bnez	s3,8000304a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000306e:	4108                	lw	a0,0(a0)
    80003070:	00000097          	auipc	ra,0x0
    80003074:	e4a080e7          	jalr	-438(ra) # 80002eba <balloc>
    80003078:	0005099b          	sext.w	s3,a0
    8000307c:	0534a823          	sw	s3,80(s1)
    80003080:	b7e9                	j	8000304a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003082:	4108                	lw	a0,0(a0)
    80003084:	00000097          	auipc	ra,0x0
    80003088:	e36080e7          	jalr	-458(ra) # 80002eba <balloc>
    8000308c:	0005059b          	sext.w	a1,a0
    80003090:	08b92023          	sw	a1,128(s2)
    80003094:	b759                	j	8000301a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003096:	00092503          	lw	a0,0(s2)
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	e20080e7          	jalr	-480(ra) # 80002eba <balloc>
    800030a2:	0005099b          	sext.w	s3,a0
    800030a6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800030aa:	8552                	mv	a0,s4
    800030ac:	00001097          	auipc	ra,0x1
    800030b0:	eba080e7          	jalr	-326(ra) # 80003f66 <log_write>
    800030b4:	b771                	j	80003040 <bmap+0x54>
  panic("bmap: out of range");
    800030b6:	00003517          	auipc	a0,0x3
    800030ba:	47a50513          	addi	a0,a0,1146 # 80006530 <userret+0x4a0>
    800030be:	ffffd097          	auipc	ra,0xffffd
    800030c2:	490080e7          	jalr	1168(ra) # 8000054e <panic>

00000000800030c6 <iget>:
{
    800030c6:	7179                	addi	sp,sp,-48
    800030c8:	f406                	sd	ra,40(sp)
    800030ca:	f022                	sd	s0,32(sp)
    800030cc:	ec26                	sd	s1,24(sp)
    800030ce:	e84a                	sd	s2,16(sp)
    800030d0:	e44e                	sd	s3,8(sp)
    800030d2:	e052                	sd	s4,0(sp)
    800030d4:	1800                	addi	s0,sp,48
    800030d6:	89aa                	mv	s3,a0
    800030d8:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800030da:	0001c517          	auipc	a0,0x1c
    800030de:	e1650513          	addi	a0,a0,-490 # 8001eef0 <icache>
    800030e2:	ffffe097          	auipc	ra,0xffffe
    800030e6:	9f0080e7          	jalr	-1552(ra) # 80000ad2 <acquire>
  empty = 0;
    800030ea:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800030ec:	0001c497          	auipc	s1,0x1c
    800030f0:	e1c48493          	addi	s1,s1,-484 # 8001ef08 <icache+0x18>
    800030f4:	0001e697          	auipc	a3,0x1e
    800030f8:	8a468693          	addi	a3,a3,-1884 # 80020998 <log>
    800030fc:	a039                	j	8000310a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030fe:	02090b63          	beqz	s2,80003134 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003102:	08848493          	addi	s1,s1,136
    80003106:	02d48a63          	beq	s1,a3,8000313a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000310a:	449c                	lw	a5,8(s1)
    8000310c:	fef059e3          	blez	a5,800030fe <iget+0x38>
    80003110:	4098                	lw	a4,0(s1)
    80003112:	ff3716e3          	bne	a4,s3,800030fe <iget+0x38>
    80003116:	40d8                	lw	a4,4(s1)
    80003118:	ff4713e3          	bne	a4,s4,800030fe <iget+0x38>
      ip->ref++;
    8000311c:	2785                	addiw	a5,a5,1
    8000311e:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003120:	0001c517          	auipc	a0,0x1c
    80003124:	dd050513          	addi	a0,a0,-560 # 8001eef0 <icache>
    80003128:	ffffe097          	auipc	ra,0xffffe
    8000312c:	9fe080e7          	jalr	-1538(ra) # 80000b26 <release>
      return ip;
    80003130:	8926                	mv	s2,s1
    80003132:	a03d                	j	80003160 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003134:	f7f9                	bnez	a5,80003102 <iget+0x3c>
    80003136:	8926                	mv	s2,s1
    80003138:	b7e9                	j	80003102 <iget+0x3c>
  if(empty == 0)
    8000313a:	02090c63          	beqz	s2,80003172 <iget+0xac>
  ip->dev = dev;
    8000313e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003142:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003146:	4785                	li	a5,1
    80003148:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000314c:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003150:	0001c517          	auipc	a0,0x1c
    80003154:	da050513          	addi	a0,a0,-608 # 8001eef0 <icache>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	9ce080e7          	jalr	-1586(ra) # 80000b26 <release>
}
    80003160:	854a                	mv	a0,s2
    80003162:	70a2                	ld	ra,40(sp)
    80003164:	7402                	ld	s0,32(sp)
    80003166:	64e2                	ld	s1,24(sp)
    80003168:	6942                	ld	s2,16(sp)
    8000316a:	69a2                	ld	s3,8(sp)
    8000316c:	6a02                	ld	s4,0(sp)
    8000316e:	6145                	addi	sp,sp,48
    80003170:	8082                	ret
    panic("iget: no inodes");
    80003172:	00003517          	auipc	a0,0x3
    80003176:	3d650513          	addi	a0,a0,982 # 80006548 <userret+0x4b8>
    8000317a:	ffffd097          	auipc	ra,0xffffd
    8000317e:	3d4080e7          	jalr	980(ra) # 8000054e <panic>

0000000080003182 <fsinit>:
fsinit(int dev) {
    80003182:	7179                	addi	sp,sp,-48
    80003184:	f406                	sd	ra,40(sp)
    80003186:	f022                	sd	s0,32(sp)
    80003188:	ec26                	sd	s1,24(sp)
    8000318a:	e84a                	sd	s2,16(sp)
    8000318c:	e44e                	sd	s3,8(sp)
    8000318e:	1800                	addi	s0,sp,48
    80003190:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003192:	4585                	li	a1,1
    80003194:	00000097          	auipc	ra,0x0
    80003198:	a64080e7          	jalr	-1436(ra) # 80002bf8 <bread>
    8000319c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000319e:	0001c997          	auipc	s3,0x1c
    800031a2:	d3298993          	addi	s3,s3,-718 # 8001eed0 <sb>
    800031a6:	02000613          	li	a2,32
    800031aa:	06050593          	addi	a1,a0,96
    800031ae:	854e                	mv	a0,s3
    800031b0:	ffffe097          	auipc	ra,0xffffe
    800031b4:	a1e080e7          	jalr	-1506(ra) # 80000bce <memmove>
  brelse(bp);
    800031b8:	8526                	mv	a0,s1
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	b6e080e7          	jalr	-1170(ra) # 80002d28 <brelse>
  if(sb.magic != FSMAGIC)
    800031c2:	0009a703          	lw	a4,0(s3)
    800031c6:	102037b7          	lui	a5,0x10203
    800031ca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031ce:	02f71263          	bne	a4,a5,800031f2 <fsinit+0x70>
  initlog(dev, &sb);
    800031d2:	0001c597          	auipc	a1,0x1c
    800031d6:	cfe58593          	addi	a1,a1,-770 # 8001eed0 <sb>
    800031da:	854a                	mv	a0,s2
    800031dc:	00001097          	auipc	ra,0x1
    800031e0:	b12080e7          	jalr	-1262(ra) # 80003cee <initlog>
}
    800031e4:	70a2                	ld	ra,40(sp)
    800031e6:	7402                	ld	s0,32(sp)
    800031e8:	64e2                	ld	s1,24(sp)
    800031ea:	6942                	ld	s2,16(sp)
    800031ec:	69a2                	ld	s3,8(sp)
    800031ee:	6145                	addi	sp,sp,48
    800031f0:	8082                	ret
    panic("invalid file system");
    800031f2:	00003517          	auipc	a0,0x3
    800031f6:	36650513          	addi	a0,a0,870 # 80006558 <userret+0x4c8>
    800031fa:	ffffd097          	auipc	ra,0xffffd
    800031fe:	354080e7          	jalr	852(ra) # 8000054e <panic>

0000000080003202 <iinit>:
{
    80003202:	7179                	addi	sp,sp,-48
    80003204:	f406                	sd	ra,40(sp)
    80003206:	f022                	sd	s0,32(sp)
    80003208:	ec26                	sd	s1,24(sp)
    8000320a:	e84a                	sd	s2,16(sp)
    8000320c:	e44e                	sd	s3,8(sp)
    8000320e:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003210:	00003597          	auipc	a1,0x3
    80003214:	36058593          	addi	a1,a1,864 # 80006570 <userret+0x4e0>
    80003218:	0001c517          	auipc	a0,0x1c
    8000321c:	cd850513          	addi	a0,a0,-808 # 8001eef0 <icache>
    80003220:	ffffd097          	auipc	ra,0xffffd
    80003224:	7a0080e7          	jalr	1952(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003228:	0001c497          	auipc	s1,0x1c
    8000322c:	cf048493          	addi	s1,s1,-784 # 8001ef18 <icache+0x28>
    80003230:	0001d997          	auipc	s3,0x1d
    80003234:	77898993          	addi	s3,s3,1912 # 800209a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003238:	00003917          	auipc	s2,0x3
    8000323c:	34090913          	addi	s2,s2,832 # 80006578 <userret+0x4e8>
    80003240:	85ca                	mv	a1,s2
    80003242:	8526                	mv	a0,s1
    80003244:	00001097          	auipc	ra,0x1
    80003248:	e10080e7          	jalr	-496(ra) # 80004054 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000324c:	08848493          	addi	s1,s1,136
    80003250:	ff3498e3          	bne	s1,s3,80003240 <iinit+0x3e>
}
    80003254:	70a2                	ld	ra,40(sp)
    80003256:	7402                	ld	s0,32(sp)
    80003258:	64e2                	ld	s1,24(sp)
    8000325a:	6942                	ld	s2,16(sp)
    8000325c:	69a2                	ld	s3,8(sp)
    8000325e:	6145                	addi	sp,sp,48
    80003260:	8082                	ret

0000000080003262 <ialloc>:
{
    80003262:	715d                	addi	sp,sp,-80
    80003264:	e486                	sd	ra,72(sp)
    80003266:	e0a2                	sd	s0,64(sp)
    80003268:	fc26                	sd	s1,56(sp)
    8000326a:	f84a                	sd	s2,48(sp)
    8000326c:	f44e                	sd	s3,40(sp)
    8000326e:	f052                	sd	s4,32(sp)
    80003270:	ec56                	sd	s5,24(sp)
    80003272:	e85a                	sd	s6,16(sp)
    80003274:	e45e                	sd	s7,8(sp)
    80003276:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003278:	0001c717          	auipc	a4,0x1c
    8000327c:	c6472703          	lw	a4,-924(a4) # 8001eedc <sb+0xc>
    80003280:	4785                	li	a5,1
    80003282:	04e7fa63          	bgeu	a5,a4,800032d6 <ialloc+0x74>
    80003286:	8aaa                	mv	s5,a0
    80003288:	8bae                	mv	s7,a1
    8000328a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000328c:	0001ca17          	auipc	s4,0x1c
    80003290:	c44a0a13          	addi	s4,s4,-956 # 8001eed0 <sb>
    80003294:	00048b1b          	sext.w	s6,s1
    80003298:	0044d593          	srli	a1,s1,0x4
    8000329c:	018a2783          	lw	a5,24(s4)
    800032a0:	9dbd                	addw	a1,a1,a5
    800032a2:	8556                	mv	a0,s5
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	954080e7          	jalr	-1708(ra) # 80002bf8 <bread>
    800032ac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800032ae:	06050993          	addi	s3,a0,96
    800032b2:	00f4f793          	andi	a5,s1,15
    800032b6:	079a                	slli	a5,a5,0x6
    800032b8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800032ba:	00099783          	lh	a5,0(s3)
    800032be:	c785                	beqz	a5,800032e6 <ialloc+0x84>
    brelse(bp);
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	a68080e7          	jalr	-1432(ra) # 80002d28 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800032c8:	0485                	addi	s1,s1,1
    800032ca:	00ca2703          	lw	a4,12(s4)
    800032ce:	0004879b          	sext.w	a5,s1
    800032d2:	fce7e1e3          	bltu	a5,a4,80003294 <ialloc+0x32>
  panic("ialloc: no inodes");
    800032d6:	00003517          	auipc	a0,0x3
    800032da:	2aa50513          	addi	a0,a0,682 # 80006580 <userret+0x4f0>
    800032de:	ffffd097          	auipc	ra,0xffffd
    800032e2:	270080e7          	jalr	624(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    800032e6:	04000613          	li	a2,64
    800032ea:	4581                	li	a1,0
    800032ec:	854e                	mv	a0,s3
    800032ee:	ffffe097          	auipc	ra,0xffffe
    800032f2:	880080e7          	jalr	-1920(ra) # 80000b6e <memset>
      dip->type = type;
    800032f6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032fa:	854a                	mv	a0,s2
    800032fc:	00001097          	auipc	ra,0x1
    80003300:	c6a080e7          	jalr	-918(ra) # 80003f66 <log_write>
      brelse(bp);
    80003304:	854a                	mv	a0,s2
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	a22080e7          	jalr	-1502(ra) # 80002d28 <brelse>
      return iget(dev, inum);
    8000330e:	85da                	mv	a1,s6
    80003310:	8556                	mv	a0,s5
    80003312:	00000097          	auipc	ra,0x0
    80003316:	db4080e7          	jalr	-588(ra) # 800030c6 <iget>
}
    8000331a:	60a6                	ld	ra,72(sp)
    8000331c:	6406                	ld	s0,64(sp)
    8000331e:	74e2                	ld	s1,56(sp)
    80003320:	7942                	ld	s2,48(sp)
    80003322:	79a2                	ld	s3,40(sp)
    80003324:	7a02                	ld	s4,32(sp)
    80003326:	6ae2                	ld	s5,24(sp)
    80003328:	6b42                	ld	s6,16(sp)
    8000332a:	6ba2                	ld	s7,8(sp)
    8000332c:	6161                	addi	sp,sp,80
    8000332e:	8082                	ret

0000000080003330 <iupdate>:
{
    80003330:	1101                	addi	sp,sp,-32
    80003332:	ec06                	sd	ra,24(sp)
    80003334:	e822                	sd	s0,16(sp)
    80003336:	e426                	sd	s1,8(sp)
    80003338:	e04a                	sd	s2,0(sp)
    8000333a:	1000                	addi	s0,sp,32
    8000333c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000333e:	415c                	lw	a5,4(a0)
    80003340:	0047d79b          	srliw	a5,a5,0x4
    80003344:	0001c597          	auipc	a1,0x1c
    80003348:	ba45a583          	lw	a1,-1116(a1) # 8001eee8 <sb+0x18>
    8000334c:	9dbd                	addw	a1,a1,a5
    8000334e:	4108                	lw	a0,0(a0)
    80003350:	00000097          	auipc	ra,0x0
    80003354:	8a8080e7          	jalr	-1880(ra) # 80002bf8 <bread>
    80003358:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000335a:	06050793          	addi	a5,a0,96
    8000335e:	40c8                	lw	a0,4(s1)
    80003360:	893d                	andi	a0,a0,15
    80003362:	051a                	slli	a0,a0,0x6
    80003364:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003366:	04449703          	lh	a4,68(s1)
    8000336a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000336e:	04649703          	lh	a4,70(s1)
    80003372:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003376:	04849703          	lh	a4,72(s1)
    8000337a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000337e:	04a49703          	lh	a4,74(s1)
    80003382:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003386:	44f8                	lw	a4,76(s1)
    80003388:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000338a:	03400613          	li	a2,52
    8000338e:	05048593          	addi	a1,s1,80
    80003392:	0531                	addi	a0,a0,12
    80003394:	ffffe097          	auipc	ra,0xffffe
    80003398:	83a080e7          	jalr	-1990(ra) # 80000bce <memmove>
  log_write(bp);
    8000339c:	854a                	mv	a0,s2
    8000339e:	00001097          	auipc	ra,0x1
    800033a2:	bc8080e7          	jalr	-1080(ra) # 80003f66 <log_write>
  brelse(bp);
    800033a6:	854a                	mv	a0,s2
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	980080e7          	jalr	-1664(ra) # 80002d28 <brelse>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6902                	ld	s2,0(sp)
    800033b8:	6105                	addi	sp,sp,32
    800033ba:	8082                	ret

00000000800033bc <idup>:
{
    800033bc:	1101                	addi	sp,sp,-32
    800033be:	ec06                	sd	ra,24(sp)
    800033c0:	e822                	sd	s0,16(sp)
    800033c2:	e426                	sd	s1,8(sp)
    800033c4:	1000                	addi	s0,sp,32
    800033c6:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800033c8:	0001c517          	auipc	a0,0x1c
    800033cc:	b2850513          	addi	a0,a0,-1240 # 8001eef0 <icache>
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	702080e7          	jalr	1794(ra) # 80000ad2 <acquire>
  ip->ref++;
    800033d8:	449c                	lw	a5,8(s1)
    800033da:	2785                	addiw	a5,a5,1
    800033dc:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800033de:	0001c517          	auipc	a0,0x1c
    800033e2:	b1250513          	addi	a0,a0,-1262 # 8001eef0 <icache>
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	740080e7          	jalr	1856(ra) # 80000b26 <release>
}
    800033ee:	8526                	mv	a0,s1
    800033f0:	60e2                	ld	ra,24(sp)
    800033f2:	6442                	ld	s0,16(sp)
    800033f4:	64a2                	ld	s1,8(sp)
    800033f6:	6105                	addi	sp,sp,32
    800033f8:	8082                	ret

00000000800033fa <ilock>:
{
    800033fa:	1101                	addi	sp,sp,-32
    800033fc:	ec06                	sd	ra,24(sp)
    800033fe:	e822                	sd	s0,16(sp)
    80003400:	e426                	sd	s1,8(sp)
    80003402:	e04a                	sd	s2,0(sp)
    80003404:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003406:	c115                	beqz	a0,8000342a <ilock+0x30>
    80003408:	84aa                	mv	s1,a0
    8000340a:	451c                	lw	a5,8(a0)
    8000340c:	00f05f63          	blez	a5,8000342a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003410:	0541                	addi	a0,a0,16
    80003412:	00001097          	auipc	ra,0x1
    80003416:	c7c080e7          	jalr	-900(ra) # 8000408e <acquiresleep>
  if(ip->valid == 0){
    8000341a:	40bc                	lw	a5,64(s1)
    8000341c:	cf99                	beqz	a5,8000343a <ilock+0x40>
}
    8000341e:	60e2                	ld	ra,24(sp)
    80003420:	6442                	ld	s0,16(sp)
    80003422:	64a2                	ld	s1,8(sp)
    80003424:	6902                	ld	s2,0(sp)
    80003426:	6105                	addi	sp,sp,32
    80003428:	8082                	ret
    panic("ilock");
    8000342a:	00003517          	auipc	a0,0x3
    8000342e:	16e50513          	addi	a0,a0,366 # 80006598 <userret+0x508>
    80003432:	ffffd097          	auipc	ra,0xffffd
    80003436:	11c080e7          	jalr	284(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000343a:	40dc                	lw	a5,4(s1)
    8000343c:	0047d79b          	srliw	a5,a5,0x4
    80003440:	0001c597          	auipc	a1,0x1c
    80003444:	aa85a583          	lw	a1,-1368(a1) # 8001eee8 <sb+0x18>
    80003448:	9dbd                	addw	a1,a1,a5
    8000344a:	4088                	lw	a0,0(s1)
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	7ac080e7          	jalr	1964(ra) # 80002bf8 <bread>
    80003454:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003456:	06050593          	addi	a1,a0,96
    8000345a:	40dc                	lw	a5,4(s1)
    8000345c:	8bbd                	andi	a5,a5,15
    8000345e:	079a                	slli	a5,a5,0x6
    80003460:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003462:	00059783          	lh	a5,0(a1)
    80003466:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000346a:	00259783          	lh	a5,2(a1)
    8000346e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003472:	00459783          	lh	a5,4(a1)
    80003476:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000347a:	00659783          	lh	a5,6(a1)
    8000347e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003482:	459c                	lw	a5,8(a1)
    80003484:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003486:	03400613          	li	a2,52
    8000348a:	05b1                	addi	a1,a1,12
    8000348c:	05048513          	addi	a0,s1,80
    80003490:	ffffd097          	auipc	ra,0xffffd
    80003494:	73e080e7          	jalr	1854(ra) # 80000bce <memmove>
    brelse(bp);
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	88e080e7          	jalr	-1906(ra) # 80002d28 <brelse>
    ip->valid = 1;
    800034a2:	4785                	li	a5,1
    800034a4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800034a6:	04449783          	lh	a5,68(s1)
    800034aa:	fbb5                	bnez	a5,8000341e <ilock+0x24>
      panic("ilock: no type");
    800034ac:	00003517          	auipc	a0,0x3
    800034b0:	0f450513          	addi	a0,a0,244 # 800065a0 <userret+0x510>
    800034b4:	ffffd097          	auipc	ra,0xffffd
    800034b8:	09a080e7          	jalr	154(ra) # 8000054e <panic>

00000000800034bc <iunlock>:
{
    800034bc:	1101                	addi	sp,sp,-32
    800034be:	ec06                	sd	ra,24(sp)
    800034c0:	e822                	sd	s0,16(sp)
    800034c2:	e426                	sd	s1,8(sp)
    800034c4:	e04a                	sd	s2,0(sp)
    800034c6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034c8:	c905                	beqz	a0,800034f8 <iunlock+0x3c>
    800034ca:	84aa                	mv	s1,a0
    800034cc:	01050913          	addi	s2,a0,16
    800034d0:	854a                	mv	a0,s2
    800034d2:	00001097          	auipc	ra,0x1
    800034d6:	c56080e7          	jalr	-938(ra) # 80004128 <holdingsleep>
    800034da:	cd19                	beqz	a0,800034f8 <iunlock+0x3c>
    800034dc:	449c                	lw	a5,8(s1)
    800034de:	00f05d63          	blez	a5,800034f8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800034e2:	854a                	mv	a0,s2
    800034e4:	00001097          	auipc	ra,0x1
    800034e8:	c00080e7          	jalr	-1024(ra) # 800040e4 <releasesleep>
}
    800034ec:	60e2                	ld	ra,24(sp)
    800034ee:	6442                	ld	s0,16(sp)
    800034f0:	64a2                	ld	s1,8(sp)
    800034f2:	6902                	ld	s2,0(sp)
    800034f4:	6105                	addi	sp,sp,32
    800034f6:	8082                	ret
    panic("iunlock");
    800034f8:	00003517          	auipc	a0,0x3
    800034fc:	0b850513          	addi	a0,a0,184 # 800065b0 <userret+0x520>
    80003500:	ffffd097          	auipc	ra,0xffffd
    80003504:	04e080e7          	jalr	78(ra) # 8000054e <panic>

0000000080003508 <iput>:
{
    80003508:	7139                	addi	sp,sp,-64
    8000350a:	fc06                	sd	ra,56(sp)
    8000350c:	f822                	sd	s0,48(sp)
    8000350e:	f426                	sd	s1,40(sp)
    80003510:	f04a                	sd	s2,32(sp)
    80003512:	ec4e                	sd	s3,24(sp)
    80003514:	e852                	sd	s4,16(sp)
    80003516:	e456                	sd	s5,8(sp)
    80003518:	0080                	addi	s0,sp,64
    8000351a:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000351c:	0001c517          	auipc	a0,0x1c
    80003520:	9d450513          	addi	a0,a0,-1580 # 8001eef0 <icache>
    80003524:	ffffd097          	auipc	ra,0xffffd
    80003528:	5ae080e7          	jalr	1454(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000352c:	4498                	lw	a4,8(s1)
    8000352e:	4785                	li	a5,1
    80003530:	02f70663          	beq	a4,a5,8000355c <iput+0x54>
  ip->ref--;
    80003534:	449c                	lw	a5,8(s1)
    80003536:	37fd                	addiw	a5,a5,-1
    80003538:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000353a:	0001c517          	auipc	a0,0x1c
    8000353e:	9b650513          	addi	a0,a0,-1610 # 8001eef0 <icache>
    80003542:	ffffd097          	auipc	ra,0xffffd
    80003546:	5e4080e7          	jalr	1508(ra) # 80000b26 <release>
}
    8000354a:	70e2                	ld	ra,56(sp)
    8000354c:	7442                	ld	s0,48(sp)
    8000354e:	74a2                	ld	s1,40(sp)
    80003550:	7902                	ld	s2,32(sp)
    80003552:	69e2                	ld	s3,24(sp)
    80003554:	6a42                	ld	s4,16(sp)
    80003556:	6aa2                	ld	s5,8(sp)
    80003558:	6121                	addi	sp,sp,64
    8000355a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000355c:	40bc                	lw	a5,64(s1)
    8000355e:	dbf9                	beqz	a5,80003534 <iput+0x2c>
    80003560:	04a49783          	lh	a5,74(s1)
    80003564:	fbe1                	bnez	a5,80003534 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003566:	01048a13          	addi	s4,s1,16
    8000356a:	8552                	mv	a0,s4
    8000356c:	00001097          	auipc	ra,0x1
    80003570:	b22080e7          	jalr	-1246(ra) # 8000408e <acquiresleep>
    release(&icache.lock);
    80003574:	0001c517          	auipc	a0,0x1c
    80003578:	97c50513          	addi	a0,a0,-1668 # 8001eef0 <icache>
    8000357c:	ffffd097          	auipc	ra,0xffffd
    80003580:	5aa080e7          	jalr	1450(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003584:	05048913          	addi	s2,s1,80
    80003588:	08048993          	addi	s3,s1,128
    8000358c:	a819                	j	800035a2 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    8000358e:	4088                	lw	a0,0(s1)
    80003590:	00000097          	auipc	ra,0x0
    80003594:	8ae080e7          	jalr	-1874(ra) # 80002e3e <bfree>
      ip->addrs[i] = 0;
    80003598:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    8000359c:	0911                	addi	s2,s2,4
    8000359e:	01390663          	beq	s2,s3,800035aa <iput+0xa2>
    if(ip->addrs[i]){
    800035a2:	00092583          	lw	a1,0(s2)
    800035a6:	d9fd                	beqz	a1,8000359c <iput+0x94>
    800035a8:	b7dd                	j	8000358e <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    800035aa:	0804a583          	lw	a1,128(s1)
    800035ae:	ed9d                	bnez	a1,800035ec <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800035b0:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    800035b4:	8526                	mv	a0,s1
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	d7a080e7          	jalr	-646(ra) # 80003330 <iupdate>
    ip->type = 0;
    800035be:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800035c2:	8526                	mv	a0,s1
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	d6c080e7          	jalr	-660(ra) # 80003330 <iupdate>
    ip->valid = 0;
    800035cc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800035d0:	8552                	mv	a0,s4
    800035d2:	00001097          	auipc	ra,0x1
    800035d6:	b12080e7          	jalr	-1262(ra) # 800040e4 <releasesleep>
    acquire(&icache.lock);
    800035da:	0001c517          	auipc	a0,0x1c
    800035de:	91650513          	addi	a0,a0,-1770 # 8001eef0 <icache>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	4f0080e7          	jalr	1264(ra) # 80000ad2 <acquire>
    800035ea:	b7a9                	j	80003534 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800035ec:	4088                	lw	a0,0(s1)
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	60a080e7          	jalr	1546(ra) # 80002bf8 <bread>
    800035f6:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    800035f8:	06050913          	addi	s2,a0,96
    800035fc:	46050993          	addi	s3,a0,1120
    80003600:	a809                	j	80003612 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003602:	4088                	lw	a0,0(s1)
    80003604:	00000097          	auipc	ra,0x0
    80003608:	83a080e7          	jalr	-1990(ra) # 80002e3e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000360c:	0911                	addi	s2,s2,4
    8000360e:	01390663          	beq	s2,s3,8000361a <iput+0x112>
      if(a[j])
    80003612:	00092583          	lw	a1,0(s2)
    80003616:	d9fd                	beqz	a1,8000360c <iput+0x104>
    80003618:	b7ed                	j	80003602 <iput+0xfa>
    brelse(bp);
    8000361a:	8556                	mv	a0,s5
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	70c080e7          	jalr	1804(ra) # 80002d28 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003624:	0804a583          	lw	a1,128(s1)
    80003628:	4088                	lw	a0,0(s1)
    8000362a:	00000097          	auipc	ra,0x0
    8000362e:	814080e7          	jalr	-2028(ra) # 80002e3e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003632:	0804a023          	sw	zero,128(s1)
    80003636:	bfad                	j	800035b0 <iput+0xa8>

0000000080003638 <iunlockput>:
{
    80003638:	1101                	addi	sp,sp,-32
    8000363a:	ec06                	sd	ra,24(sp)
    8000363c:	e822                	sd	s0,16(sp)
    8000363e:	e426                	sd	s1,8(sp)
    80003640:	1000                	addi	s0,sp,32
    80003642:	84aa                	mv	s1,a0
  iunlock(ip);
    80003644:	00000097          	auipc	ra,0x0
    80003648:	e78080e7          	jalr	-392(ra) # 800034bc <iunlock>
  iput(ip);
    8000364c:	8526                	mv	a0,s1
    8000364e:	00000097          	auipc	ra,0x0
    80003652:	eba080e7          	jalr	-326(ra) # 80003508 <iput>
}
    80003656:	60e2                	ld	ra,24(sp)
    80003658:	6442                	ld	s0,16(sp)
    8000365a:	64a2                	ld	s1,8(sp)
    8000365c:	6105                	addi	sp,sp,32
    8000365e:	8082                	ret

0000000080003660 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003660:	1141                	addi	sp,sp,-16
    80003662:	e422                	sd	s0,8(sp)
    80003664:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003666:	411c                	lw	a5,0(a0)
    80003668:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000366a:	415c                	lw	a5,4(a0)
    8000366c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000366e:	04451783          	lh	a5,68(a0)
    80003672:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003676:	04a51783          	lh	a5,74(a0)
    8000367a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000367e:	04c56783          	lwu	a5,76(a0)
    80003682:	e99c                	sd	a5,16(a1)
}
    80003684:	6422                	ld	s0,8(sp)
    80003686:	0141                	addi	sp,sp,16
    80003688:	8082                	ret

000000008000368a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000368a:	457c                	lw	a5,76(a0)
    8000368c:	0ed7e563          	bltu	a5,a3,80003776 <readi+0xec>
{
    80003690:	7159                	addi	sp,sp,-112
    80003692:	f486                	sd	ra,104(sp)
    80003694:	f0a2                	sd	s0,96(sp)
    80003696:	eca6                	sd	s1,88(sp)
    80003698:	e8ca                	sd	s2,80(sp)
    8000369a:	e4ce                	sd	s3,72(sp)
    8000369c:	e0d2                	sd	s4,64(sp)
    8000369e:	fc56                	sd	s5,56(sp)
    800036a0:	f85a                	sd	s6,48(sp)
    800036a2:	f45e                	sd	s7,40(sp)
    800036a4:	f062                	sd	s8,32(sp)
    800036a6:	ec66                	sd	s9,24(sp)
    800036a8:	e86a                	sd	s10,16(sp)
    800036aa:	e46e                	sd	s11,8(sp)
    800036ac:	1880                	addi	s0,sp,112
    800036ae:	8baa                	mv	s7,a0
    800036b0:	8c2e                	mv	s8,a1
    800036b2:	8ab2                	mv	s5,a2
    800036b4:	8936                	mv	s2,a3
    800036b6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036b8:	9f35                	addw	a4,a4,a3
    800036ba:	0cd76063          	bltu	a4,a3,8000377a <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    800036be:	00e7f463          	bgeu	a5,a4,800036c6 <readi+0x3c>
    n = ip->size - off;
    800036c2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036c6:	080b0763          	beqz	s6,80003754 <readi+0xca>
    800036ca:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800036cc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036d0:	5cfd                	li	s9,-1
    800036d2:	a82d                	j	8000370c <readi+0x82>
    800036d4:	02099d93          	slli	s11,s3,0x20
    800036d8:	020ddd93          	srli	s11,s11,0x20
    800036dc:	06048613          	addi	a2,s1,96
    800036e0:	86ee                	mv	a3,s11
    800036e2:	963a                	add	a2,a2,a4
    800036e4:	85d6                	mv	a1,s5
    800036e6:	8562                	mv	a0,s8
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	b5e080e7          	jalr	-1186(ra) # 80002246 <either_copyout>
    800036f0:	05950d63          	beq	a0,s9,8000374a <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    800036f4:	8526                	mv	a0,s1
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	632080e7          	jalr	1586(ra) # 80002d28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036fe:	01498a3b          	addw	s4,s3,s4
    80003702:	0129893b          	addw	s2,s3,s2
    80003706:	9aee                	add	s5,s5,s11
    80003708:	056a7663          	bgeu	s4,s6,80003754 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000370c:	000ba483          	lw	s1,0(s7)
    80003710:	00a9559b          	srliw	a1,s2,0xa
    80003714:	855e                	mv	a0,s7
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	8d6080e7          	jalr	-1834(ra) # 80002fec <bmap>
    8000371e:	0005059b          	sext.w	a1,a0
    80003722:	8526                	mv	a0,s1
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	4d4080e7          	jalr	1236(ra) # 80002bf8 <bread>
    8000372c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000372e:	3ff97713          	andi	a4,s2,1023
    80003732:	40ed07bb          	subw	a5,s10,a4
    80003736:	414b06bb          	subw	a3,s6,s4
    8000373a:	89be                	mv	s3,a5
    8000373c:	2781                	sext.w	a5,a5
    8000373e:	0006861b          	sext.w	a2,a3
    80003742:	f8f679e3          	bgeu	a2,a5,800036d4 <readi+0x4a>
    80003746:	89b6                	mv	s3,a3
    80003748:	b771                	j	800036d4 <readi+0x4a>
      brelse(bp);
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	5dc080e7          	jalr	1500(ra) # 80002d28 <brelse>
  }
  return n;
    80003754:	000b051b          	sext.w	a0,s6
}
    80003758:	70a6                	ld	ra,104(sp)
    8000375a:	7406                	ld	s0,96(sp)
    8000375c:	64e6                	ld	s1,88(sp)
    8000375e:	6946                	ld	s2,80(sp)
    80003760:	69a6                	ld	s3,72(sp)
    80003762:	6a06                	ld	s4,64(sp)
    80003764:	7ae2                	ld	s5,56(sp)
    80003766:	7b42                	ld	s6,48(sp)
    80003768:	7ba2                	ld	s7,40(sp)
    8000376a:	7c02                	ld	s8,32(sp)
    8000376c:	6ce2                	ld	s9,24(sp)
    8000376e:	6d42                	ld	s10,16(sp)
    80003770:	6da2                	ld	s11,8(sp)
    80003772:	6165                	addi	sp,sp,112
    80003774:	8082                	ret
    return -1;
    80003776:	557d                	li	a0,-1
}
    80003778:	8082                	ret
    return -1;
    8000377a:	557d                	li	a0,-1
    8000377c:	bff1                	j	80003758 <readi+0xce>

000000008000377e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000377e:	457c                	lw	a5,76(a0)
    80003780:	10d7e663          	bltu	a5,a3,8000388c <writei+0x10e>
{
    80003784:	7159                	addi	sp,sp,-112
    80003786:	f486                	sd	ra,104(sp)
    80003788:	f0a2                	sd	s0,96(sp)
    8000378a:	eca6                	sd	s1,88(sp)
    8000378c:	e8ca                	sd	s2,80(sp)
    8000378e:	e4ce                	sd	s3,72(sp)
    80003790:	e0d2                	sd	s4,64(sp)
    80003792:	fc56                	sd	s5,56(sp)
    80003794:	f85a                	sd	s6,48(sp)
    80003796:	f45e                	sd	s7,40(sp)
    80003798:	f062                	sd	s8,32(sp)
    8000379a:	ec66                	sd	s9,24(sp)
    8000379c:	e86a                	sd	s10,16(sp)
    8000379e:	e46e                	sd	s11,8(sp)
    800037a0:	1880                	addi	s0,sp,112
    800037a2:	8baa                	mv	s7,a0
    800037a4:	8c2e                	mv	s8,a1
    800037a6:	8ab2                	mv	s5,a2
    800037a8:	8936                	mv	s2,a3
    800037aa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800037ac:	00e687bb          	addw	a5,a3,a4
    800037b0:	0ed7e063          	bltu	a5,a3,80003890 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037b4:	00043737          	lui	a4,0x43
    800037b8:	0cf76e63          	bltu	a4,a5,80003894 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037bc:	0a0b0763          	beqz	s6,8000386a <writei+0xec>
    800037c0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800037c2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037c6:	5cfd                	li	s9,-1
    800037c8:	a091                	j	8000380c <writei+0x8e>
    800037ca:	02099d93          	slli	s11,s3,0x20
    800037ce:	020ddd93          	srli	s11,s11,0x20
    800037d2:	06048513          	addi	a0,s1,96
    800037d6:	86ee                	mv	a3,s11
    800037d8:	8656                	mv	a2,s5
    800037da:	85e2                	mv	a1,s8
    800037dc:	953a                	add	a0,a0,a4
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	abe080e7          	jalr	-1346(ra) # 8000229c <either_copyin>
    800037e6:	07950263          	beq	a0,s9,8000384a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800037ea:	8526                	mv	a0,s1
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	77a080e7          	jalr	1914(ra) # 80003f66 <log_write>
    brelse(bp);
    800037f4:	8526                	mv	a0,s1
    800037f6:	fffff097          	auipc	ra,0xfffff
    800037fa:	532080e7          	jalr	1330(ra) # 80002d28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037fe:	01498a3b          	addw	s4,s3,s4
    80003802:	0129893b          	addw	s2,s3,s2
    80003806:	9aee                	add	s5,s5,s11
    80003808:	056a7663          	bgeu	s4,s6,80003854 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000380c:	000ba483          	lw	s1,0(s7)
    80003810:	00a9559b          	srliw	a1,s2,0xa
    80003814:	855e                	mv	a0,s7
    80003816:	fffff097          	auipc	ra,0xfffff
    8000381a:	7d6080e7          	jalr	2006(ra) # 80002fec <bmap>
    8000381e:	0005059b          	sext.w	a1,a0
    80003822:	8526                	mv	a0,s1
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	3d4080e7          	jalr	980(ra) # 80002bf8 <bread>
    8000382c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000382e:	3ff97713          	andi	a4,s2,1023
    80003832:	40ed07bb          	subw	a5,s10,a4
    80003836:	414b06bb          	subw	a3,s6,s4
    8000383a:	89be                	mv	s3,a5
    8000383c:	2781                	sext.w	a5,a5
    8000383e:	0006861b          	sext.w	a2,a3
    80003842:	f8f674e3          	bgeu	a2,a5,800037ca <writei+0x4c>
    80003846:	89b6                	mv	s3,a3
    80003848:	b749                	j	800037ca <writei+0x4c>
      brelse(bp);
    8000384a:	8526                	mv	a0,s1
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	4dc080e7          	jalr	1244(ra) # 80002d28 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003854:	04cba783          	lw	a5,76(s7)
    80003858:	0127f463          	bgeu	a5,s2,80003860 <writei+0xe2>
      ip->size = off;
    8000385c:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003860:	855e                	mv	a0,s7
    80003862:	00000097          	auipc	ra,0x0
    80003866:	ace080e7          	jalr	-1330(ra) # 80003330 <iupdate>
  }

  return n;
    8000386a:	000b051b          	sext.w	a0,s6
}
    8000386e:	70a6                	ld	ra,104(sp)
    80003870:	7406                	ld	s0,96(sp)
    80003872:	64e6                	ld	s1,88(sp)
    80003874:	6946                	ld	s2,80(sp)
    80003876:	69a6                	ld	s3,72(sp)
    80003878:	6a06                	ld	s4,64(sp)
    8000387a:	7ae2                	ld	s5,56(sp)
    8000387c:	7b42                	ld	s6,48(sp)
    8000387e:	7ba2                	ld	s7,40(sp)
    80003880:	7c02                	ld	s8,32(sp)
    80003882:	6ce2                	ld	s9,24(sp)
    80003884:	6d42                	ld	s10,16(sp)
    80003886:	6da2                	ld	s11,8(sp)
    80003888:	6165                	addi	sp,sp,112
    8000388a:	8082                	ret
    return -1;
    8000388c:	557d                	li	a0,-1
}
    8000388e:	8082                	ret
    return -1;
    80003890:	557d                	li	a0,-1
    80003892:	bff1                	j	8000386e <writei+0xf0>
    return -1;
    80003894:	557d                	li	a0,-1
    80003896:	bfe1                	j	8000386e <writei+0xf0>

0000000080003898 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003898:	1141                	addi	sp,sp,-16
    8000389a:	e406                	sd	ra,8(sp)
    8000389c:	e022                	sd	s0,0(sp)
    8000389e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038a0:	4639                	li	a2,14
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	3a8080e7          	jalr	936(ra) # 80000c4a <strncmp>
}
    800038aa:	60a2                	ld	ra,8(sp)
    800038ac:	6402                	ld	s0,0(sp)
    800038ae:	0141                	addi	sp,sp,16
    800038b0:	8082                	ret

00000000800038b2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038b2:	7139                	addi	sp,sp,-64
    800038b4:	fc06                	sd	ra,56(sp)
    800038b6:	f822                	sd	s0,48(sp)
    800038b8:	f426                	sd	s1,40(sp)
    800038ba:	f04a                	sd	s2,32(sp)
    800038bc:	ec4e                	sd	s3,24(sp)
    800038be:	e852                	sd	s4,16(sp)
    800038c0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038c2:	04451703          	lh	a4,68(a0)
    800038c6:	4785                	li	a5,1
    800038c8:	00f71a63          	bne	a4,a5,800038dc <dirlookup+0x2a>
    800038cc:	892a                	mv	s2,a0
    800038ce:	89ae                	mv	s3,a1
    800038d0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800038d2:	457c                	lw	a5,76(a0)
    800038d4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038d6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038d8:	e79d                	bnez	a5,80003906 <dirlookup+0x54>
    800038da:	a8a5                	j	80003952 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800038dc:	00003517          	auipc	a0,0x3
    800038e0:	cdc50513          	addi	a0,a0,-804 # 800065b8 <userret+0x528>
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	c6a080e7          	jalr	-918(ra) # 8000054e <panic>
      panic("dirlookup read");
    800038ec:	00003517          	auipc	a0,0x3
    800038f0:	ce450513          	addi	a0,a0,-796 # 800065d0 <userret+0x540>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	c5a080e7          	jalr	-934(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038fc:	24c1                	addiw	s1,s1,16
    800038fe:	04c92783          	lw	a5,76(s2)
    80003902:	04f4f763          	bgeu	s1,a5,80003950 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003906:	4741                	li	a4,16
    80003908:	86a6                	mv	a3,s1
    8000390a:	fc040613          	addi	a2,s0,-64
    8000390e:	4581                	li	a1,0
    80003910:	854a                	mv	a0,s2
    80003912:	00000097          	auipc	ra,0x0
    80003916:	d78080e7          	jalr	-648(ra) # 8000368a <readi>
    8000391a:	47c1                	li	a5,16
    8000391c:	fcf518e3          	bne	a0,a5,800038ec <dirlookup+0x3a>
    if(de.inum == 0)
    80003920:	fc045783          	lhu	a5,-64(s0)
    80003924:	dfe1                	beqz	a5,800038fc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003926:	fc240593          	addi	a1,s0,-62
    8000392a:	854e                	mv	a0,s3
    8000392c:	00000097          	auipc	ra,0x0
    80003930:	f6c080e7          	jalr	-148(ra) # 80003898 <namecmp>
    80003934:	f561                	bnez	a0,800038fc <dirlookup+0x4a>
      if(poff)
    80003936:	000a0463          	beqz	s4,8000393e <dirlookup+0x8c>
        *poff = off;
    8000393a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000393e:	fc045583          	lhu	a1,-64(s0)
    80003942:	00092503          	lw	a0,0(s2)
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	780080e7          	jalr	1920(ra) # 800030c6 <iget>
    8000394e:	a011                	j	80003952 <dirlookup+0xa0>
  return 0;
    80003950:	4501                	li	a0,0
}
    80003952:	70e2                	ld	ra,56(sp)
    80003954:	7442                	ld	s0,48(sp)
    80003956:	74a2                	ld	s1,40(sp)
    80003958:	7902                	ld	s2,32(sp)
    8000395a:	69e2                	ld	s3,24(sp)
    8000395c:	6a42                	ld	s4,16(sp)
    8000395e:	6121                	addi	sp,sp,64
    80003960:	8082                	ret

0000000080003962 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003962:	711d                	addi	sp,sp,-96
    80003964:	ec86                	sd	ra,88(sp)
    80003966:	e8a2                	sd	s0,80(sp)
    80003968:	e4a6                	sd	s1,72(sp)
    8000396a:	e0ca                	sd	s2,64(sp)
    8000396c:	fc4e                	sd	s3,56(sp)
    8000396e:	f852                	sd	s4,48(sp)
    80003970:	f456                	sd	s5,40(sp)
    80003972:	f05a                	sd	s6,32(sp)
    80003974:	ec5e                	sd	s7,24(sp)
    80003976:	e862                	sd	s8,16(sp)
    80003978:	e466                	sd	s9,8(sp)
    8000397a:	1080                	addi	s0,sp,96
    8000397c:	84aa                	mv	s1,a0
    8000397e:	8b2e                	mv	s6,a1
    80003980:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003982:	00054703          	lbu	a4,0(a0)
    80003986:	02f00793          	li	a5,47
    8000398a:	02f70363          	beq	a4,a5,800039b0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000398e:	ffffe097          	auipc	ra,0xffffe
    80003992:	eb6080e7          	jalr	-330(ra) # 80001844 <myproc>
    80003996:	15053503          	ld	a0,336(a0)
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	a22080e7          	jalr	-1502(ra) # 800033bc <idup>
    800039a2:	89aa                	mv	s3,a0
  while(*path == '/')
    800039a4:	02f00913          	li	s2,47
  len = path - s;
    800039a8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800039aa:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800039ac:	4c05                	li	s8,1
    800039ae:	a865                	j	80003a66 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800039b0:	4585                	li	a1,1
    800039b2:	4505                	li	a0,1
    800039b4:	fffff097          	auipc	ra,0xfffff
    800039b8:	712080e7          	jalr	1810(ra) # 800030c6 <iget>
    800039bc:	89aa                	mv	s3,a0
    800039be:	b7dd                	j	800039a4 <namex+0x42>
      iunlockput(ip);
    800039c0:	854e                	mv	a0,s3
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	c76080e7          	jalr	-906(ra) # 80003638 <iunlockput>
      return 0;
    800039ca:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039cc:	854e                	mv	a0,s3
    800039ce:	60e6                	ld	ra,88(sp)
    800039d0:	6446                	ld	s0,80(sp)
    800039d2:	64a6                	ld	s1,72(sp)
    800039d4:	6906                	ld	s2,64(sp)
    800039d6:	79e2                	ld	s3,56(sp)
    800039d8:	7a42                	ld	s4,48(sp)
    800039da:	7aa2                	ld	s5,40(sp)
    800039dc:	7b02                	ld	s6,32(sp)
    800039de:	6be2                	ld	s7,24(sp)
    800039e0:	6c42                	ld	s8,16(sp)
    800039e2:	6ca2                	ld	s9,8(sp)
    800039e4:	6125                	addi	sp,sp,96
    800039e6:	8082                	ret
      iunlock(ip);
    800039e8:	854e                	mv	a0,s3
    800039ea:	00000097          	auipc	ra,0x0
    800039ee:	ad2080e7          	jalr	-1326(ra) # 800034bc <iunlock>
      return ip;
    800039f2:	bfe9                	j	800039cc <namex+0x6a>
      iunlockput(ip);
    800039f4:	854e                	mv	a0,s3
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	c42080e7          	jalr	-958(ra) # 80003638 <iunlockput>
      return 0;
    800039fe:	89d2                	mv	s3,s4
    80003a00:	b7f1                	j	800039cc <namex+0x6a>
  len = path - s;
    80003a02:	40b48633          	sub	a2,s1,a1
    80003a06:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003a0a:	094cd463          	bge	s9,s4,80003a92 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003a0e:	4639                	li	a2,14
    80003a10:	8556                	mv	a0,s5
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	1bc080e7          	jalr	444(ra) # 80000bce <memmove>
  while(*path == '/')
    80003a1a:	0004c783          	lbu	a5,0(s1)
    80003a1e:	01279763          	bne	a5,s2,80003a2c <namex+0xca>
    path++;
    80003a22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a24:	0004c783          	lbu	a5,0(s1)
    80003a28:	ff278de3          	beq	a5,s2,80003a22 <namex+0xc0>
    ilock(ip);
    80003a2c:	854e                	mv	a0,s3
    80003a2e:	00000097          	auipc	ra,0x0
    80003a32:	9cc080e7          	jalr	-1588(ra) # 800033fa <ilock>
    if(ip->type != T_DIR){
    80003a36:	04499783          	lh	a5,68(s3)
    80003a3a:	f98793e3          	bne	a5,s8,800039c0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003a3e:	000b0563          	beqz	s6,80003a48 <namex+0xe6>
    80003a42:	0004c783          	lbu	a5,0(s1)
    80003a46:	d3cd                	beqz	a5,800039e8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a48:	865e                	mv	a2,s7
    80003a4a:	85d6                	mv	a1,s5
    80003a4c:	854e                	mv	a0,s3
    80003a4e:	00000097          	auipc	ra,0x0
    80003a52:	e64080e7          	jalr	-412(ra) # 800038b2 <dirlookup>
    80003a56:	8a2a                	mv	s4,a0
    80003a58:	dd51                	beqz	a0,800039f4 <namex+0x92>
    iunlockput(ip);
    80003a5a:	854e                	mv	a0,s3
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	bdc080e7          	jalr	-1060(ra) # 80003638 <iunlockput>
    ip = next;
    80003a64:	89d2                	mv	s3,s4
  while(*path == '/')
    80003a66:	0004c783          	lbu	a5,0(s1)
    80003a6a:	05279763          	bne	a5,s2,80003ab8 <namex+0x156>
    path++;
    80003a6e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a70:	0004c783          	lbu	a5,0(s1)
    80003a74:	ff278de3          	beq	a5,s2,80003a6e <namex+0x10c>
  if(*path == 0)
    80003a78:	c79d                	beqz	a5,80003aa6 <namex+0x144>
    path++;
    80003a7a:	85a6                	mv	a1,s1
  len = path - s;
    80003a7c:	8a5e                	mv	s4,s7
    80003a7e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003a80:	01278963          	beq	a5,s2,80003a92 <namex+0x130>
    80003a84:	dfbd                	beqz	a5,80003a02 <namex+0xa0>
    path++;
    80003a86:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003a88:	0004c783          	lbu	a5,0(s1)
    80003a8c:	ff279ce3          	bne	a5,s2,80003a84 <namex+0x122>
    80003a90:	bf8d                	j	80003a02 <namex+0xa0>
    memmove(name, s, len);
    80003a92:	2601                	sext.w	a2,a2
    80003a94:	8556                	mv	a0,s5
    80003a96:	ffffd097          	auipc	ra,0xffffd
    80003a9a:	138080e7          	jalr	312(ra) # 80000bce <memmove>
    name[len] = 0;
    80003a9e:	9a56                	add	s4,s4,s5
    80003aa0:	000a0023          	sb	zero,0(s4)
    80003aa4:	bf9d                	j	80003a1a <namex+0xb8>
  if(nameiparent){
    80003aa6:	f20b03e3          	beqz	s6,800039cc <namex+0x6a>
    iput(ip);
    80003aaa:	854e                	mv	a0,s3
    80003aac:	00000097          	auipc	ra,0x0
    80003ab0:	a5c080e7          	jalr	-1444(ra) # 80003508 <iput>
    return 0;
    80003ab4:	4981                	li	s3,0
    80003ab6:	bf19                	j	800039cc <namex+0x6a>
  if(*path == 0)
    80003ab8:	d7fd                	beqz	a5,80003aa6 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003aba:	0004c783          	lbu	a5,0(s1)
    80003abe:	85a6                	mv	a1,s1
    80003ac0:	b7d1                	j	80003a84 <namex+0x122>

0000000080003ac2 <dirlink>:
{
    80003ac2:	7139                	addi	sp,sp,-64
    80003ac4:	fc06                	sd	ra,56(sp)
    80003ac6:	f822                	sd	s0,48(sp)
    80003ac8:	f426                	sd	s1,40(sp)
    80003aca:	f04a                	sd	s2,32(sp)
    80003acc:	ec4e                	sd	s3,24(sp)
    80003ace:	e852                	sd	s4,16(sp)
    80003ad0:	0080                	addi	s0,sp,64
    80003ad2:	892a                	mv	s2,a0
    80003ad4:	8a2e                	mv	s4,a1
    80003ad6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ad8:	4601                	li	a2,0
    80003ada:	00000097          	auipc	ra,0x0
    80003ade:	dd8080e7          	jalr	-552(ra) # 800038b2 <dirlookup>
    80003ae2:	e93d                	bnez	a0,80003b58 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ae4:	04c92483          	lw	s1,76(s2)
    80003ae8:	c49d                	beqz	s1,80003b16 <dirlink+0x54>
    80003aea:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003aec:	4741                	li	a4,16
    80003aee:	86a6                	mv	a3,s1
    80003af0:	fc040613          	addi	a2,s0,-64
    80003af4:	4581                	li	a1,0
    80003af6:	854a                	mv	a0,s2
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	b92080e7          	jalr	-1134(ra) # 8000368a <readi>
    80003b00:	47c1                	li	a5,16
    80003b02:	06f51163          	bne	a0,a5,80003b64 <dirlink+0xa2>
    if(de.inum == 0)
    80003b06:	fc045783          	lhu	a5,-64(s0)
    80003b0a:	c791                	beqz	a5,80003b16 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b0c:	24c1                	addiw	s1,s1,16
    80003b0e:	04c92783          	lw	a5,76(s2)
    80003b12:	fcf4ede3          	bltu	s1,a5,80003aec <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003b16:	4639                	li	a2,14
    80003b18:	85d2                	mv	a1,s4
    80003b1a:	fc240513          	addi	a0,s0,-62
    80003b1e:	ffffd097          	auipc	ra,0xffffd
    80003b22:	168080e7          	jalr	360(ra) # 80000c86 <strncpy>
  de.inum = inum;
    80003b26:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b2a:	4741                	li	a4,16
    80003b2c:	86a6                	mv	a3,s1
    80003b2e:	fc040613          	addi	a2,s0,-64
    80003b32:	4581                	li	a1,0
    80003b34:	854a                	mv	a0,s2
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	c48080e7          	jalr	-952(ra) # 8000377e <writei>
    80003b3e:	872a                	mv	a4,a0
    80003b40:	47c1                	li	a5,16
  return 0;
    80003b42:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b44:	02f71863          	bne	a4,a5,80003b74 <dirlink+0xb2>
}
    80003b48:	70e2                	ld	ra,56(sp)
    80003b4a:	7442                	ld	s0,48(sp)
    80003b4c:	74a2                	ld	s1,40(sp)
    80003b4e:	7902                	ld	s2,32(sp)
    80003b50:	69e2                	ld	s3,24(sp)
    80003b52:	6a42                	ld	s4,16(sp)
    80003b54:	6121                	addi	sp,sp,64
    80003b56:	8082                	ret
    iput(ip);
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	9b0080e7          	jalr	-1616(ra) # 80003508 <iput>
    return -1;
    80003b60:	557d                	li	a0,-1
    80003b62:	b7dd                	j	80003b48 <dirlink+0x86>
      panic("dirlink read");
    80003b64:	00003517          	auipc	a0,0x3
    80003b68:	a7c50513          	addi	a0,a0,-1412 # 800065e0 <userret+0x550>
    80003b6c:	ffffd097          	auipc	ra,0xffffd
    80003b70:	9e2080e7          	jalr	-1566(ra) # 8000054e <panic>
    panic("dirlink");
    80003b74:	00003517          	auipc	a0,0x3
    80003b78:	b8c50513          	addi	a0,a0,-1140 # 80006700 <userret+0x670>
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	9d2080e7          	jalr	-1582(ra) # 8000054e <panic>

0000000080003b84 <namei>:

struct inode*
namei(char *path)
{
    80003b84:	1101                	addi	sp,sp,-32
    80003b86:	ec06                	sd	ra,24(sp)
    80003b88:	e822                	sd	s0,16(sp)
    80003b8a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b8c:	fe040613          	addi	a2,s0,-32
    80003b90:	4581                	li	a1,0
    80003b92:	00000097          	auipc	ra,0x0
    80003b96:	dd0080e7          	jalr	-560(ra) # 80003962 <namex>
}
    80003b9a:	60e2                	ld	ra,24(sp)
    80003b9c:	6442                	ld	s0,16(sp)
    80003b9e:	6105                	addi	sp,sp,32
    80003ba0:	8082                	ret

0000000080003ba2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ba2:	1141                	addi	sp,sp,-16
    80003ba4:	e406                	sd	ra,8(sp)
    80003ba6:	e022                	sd	s0,0(sp)
    80003ba8:	0800                	addi	s0,sp,16
    80003baa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003bac:	4585                	li	a1,1
    80003bae:	00000097          	auipc	ra,0x0
    80003bb2:	db4080e7          	jalr	-588(ra) # 80003962 <namex>
}
    80003bb6:	60a2                	ld	ra,8(sp)
    80003bb8:	6402                	ld	s0,0(sp)
    80003bba:	0141                	addi	sp,sp,16
    80003bbc:	8082                	ret

0000000080003bbe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003bbe:	1101                	addi	sp,sp,-32
    80003bc0:	ec06                	sd	ra,24(sp)
    80003bc2:	e822                	sd	s0,16(sp)
    80003bc4:	e426                	sd	s1,8(sp)
    80003bc6:	e04a                	sd	s2,0(sp)
    80003bc8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003bca:	0001d917          	auipc	s2,0x1d
    80003bce:	dce90913          	addi	s2,s2,-562 # 80020998 <log>
    80003bd2:	01892583          	lw	a1,24(s2)
    80003bd6:	02892503          	lw	a0,40(s2)
    80003bda:	fffff097          	auipc	ra,0xfffff
    80003bde:	01e080e7          	jalr	30(ra) # 80002bf8 <bread>
    80003be2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003be4:	02c92683          	lw	a3,44(s2)
    80003be8:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003bea:	02d05763          	blez	a3,80003c18 <write_head+0x5a>
    80003bee:	0001d797          	auipc	a5,0x1d
    80003bf2:	dda78793          	addi	a5,a5,-550 # 800209c8 <log+0x30>
    80003bf6:	06450713          	addi	a4,a0,100
    80003bfa:	36fd                	addiw	a3,a3,-1
    80003bfc:	1682                	slli	a3,a3,0x20
    80003bfe:	9281                	srli	a3,a3,0x20
    80003c00:	068a                	slli	a3,a3,0x2
    80003c02:	0001d617          	auipc	a2,0x1d
    80003c06:	dca60613          	addi	a2,a2,-566 # 800209cc <log+0x34>
    80003c0a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003c0c:	4390                	lw	a2,0(a5)
    80003c0e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c10:	0791                	addi	a5,a5,4
    80003c12:	0711                	addi	a4,a4,4
    80003c14:	fed79ce3          	bne	a5,a3,80003c0c <write_head+0x4e>
  }
  bwrite(buf);
    80003c18:	8526                	mv	a0,s1
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	0d0080e7          	jalr	208(ra) # 80002cea <bwrite>
  brelse(buf);
    80003c22:	8526                	mv	a0,s1
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	104080e7          	jalr	260(ra) # 80002d28 <brelse>
}
    80003c2c:	60e2                	ld	ra,24(sp)
    80003c2e:	6442                	ld	s0,16(sp)
    80003c30:	64a2                	ld	s1,8(sp)
    80003c32:	6902                	ld	s2,0(sp)
    80003c34:	6105                	addi	sp,sp,32
    80003c36:	8082                	ret

0000000080003c38 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c38:	0001d797          	auipc	a5,0x1d
    80003c3c:	d8c7a783          	lw	a5,-628(a5) # 800209c4 <log+0x2c>
    80003c40:	0af05663          	blez	a5,80003cec <install_trans+0xb4>
{
    80003c44:	7139                	addi	sp,sp,-64
    80003c46:	fc06                	sd	ra,56(sp)
    80003c48:	f822                	sd	s0,48(sp)
    80003c4a:	f426                	sd	s1,40(sp)
    80003c4c:	f04a                	sd	s2,32(sp)
    80003c4e:	ec4e                	sd	s3,24(sp)
    80003c50:	e852                	sd	s4,16(sp)
    80003c52:	e456                	sd	s5,8(sp)
    80003c54:	0080                	addi	s0,sp,64
    80003c56:	0001da97          	auipc	s5,0x1d
    80003c5a:	d72a8a93          	addi	s5,s5,-654 # 800209c8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c5e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c60:	0001d997          	auipc	s3,0x1d
    80003c64:	d3898993          	addi	s3,s3,-712 # 80020998 <log>
    80003c68:	0189a583          	lw	a1,24(s3)
    80003c6c:	014585bb          	addw	a1,a1,s4
    80003c70:	2585                	addiw	a1,a1,1
    80003c72:	0289a503          	lw	a0,40(s3)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	f82080e7          	jalr	-126(ra) # 80002bf8 <bread>
    80003c7e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003c80:	000aa583          	lw	a1,0(s5)
    80003c84:	0289a503          	lw	a0,40(s3)
    80003c88:	fffff097          	auipc	ra,0xfffff
    80003c8c:	f70080e7          	jalr	-144(ra) # 80002bf8 <bread>
    80003c90:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003c92:	40000613          	li	a2,1024
    80003c96:	06090593          	addi	a1,s2,96
    80003c9a:	06050513          	addi	a0,a0,96
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	f30080e7          	jalr	-208(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ca6:	8526                	mv	a0,s1
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	042080e7          	jalr	66(ra) # 80002cea <bwrite>
    bunpin(dbuf);
    80003cb0:	8526                	mv	a0,s1
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	150080e7          	jalr	336(ra) # 80002e02 <bunpin>
    brelse(lbuf);
    80003cba:	854a                	mv	a0,s2
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	06c080e7          	jalr	108(ra) # 80002d28 <brelse>
    brelse(dbuf);
    80003cc4:	8526                	mv	a0,s1
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	062080e7          	jalr	98(ra) # 80002d28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cce:	2a05                	addiw	s4,s4,1
    80003cd0:	0a91                	addi	s5,s5,4
    80003cd2:	02c9a783          	lw	a5,44(s3)
    80003cd6:	f8fa49e3          	blt	s4,a5,80003c68 <install_trans+0x30>
}
    80003cda:	70e2                	ld	ra,56(sp)
    80003cdc:	7442                	ld	s0,48(sp)
    80003cde:	74a2                	ld	s1,40(sp)
    80003ce0:	7902                	ld	s2,32(sp)
    80003ce2:	69e2                	ld	s3,24(sp)
    80003ce4:	6a42                	ld	s4,16(sp)
    80003ce6:	6aa2                	ld	s5,8(sp)
    80003ce8:	6121                	addi	sp,sp,64
    80003cea:	8082                	ret
    80003cec:	8082                	ret

0000000080003cee <initlog>:
{
    80003cee:	7179                	addi	sp,sp,-48
    80003cf0:	f406                	sd	ra,40(sp)
    80003cf2:	f022                	sd	s0,32(sp)
    80003cf4:	ec26                	sd	s1,24(sp)
    80003cf6:	e84a                	sd	s2,16(sp)
    80003cf8:	e44e                	sd	s3,8(sp)
    80003cfa:	1800                	addi	s0,sp,48
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d00:	0001d497          	auipc	s1,0x1d
    80003d04:	c9848493          	addi	s1,s1,-872 # 80020998 <log>
    80003d08:	00003597          	auipc	a1,0x3
    80003d0c:	8e858593          	addi	a1,a1,-1816 # 800065f0 <userret+0x560>
    80003d10:	8526                	mv	a0,s1
    80003d12:	ffffd097          	auipc	ra,0xffffd
    80003d16:	cae080e7          	jalr	-850(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    80003d1a:	0149a583          	lw	a1,20(s3)
    80003d1e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003d20:	0109a783          	lw	a5,16(s3)
    80003d24:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003d26:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003d2a:	854a                	mv	a0,s2
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	ecc080e7          	jalr	-308(ra) # 80002bf8 <bread>
  log.lh.n = lh->n;
    80003d34:	513c                	lw	a5,96(a0)
    80003d36:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003d38:	02f05563          	blez	a5,80003d62 <initlog+0x74>
    80003d3c:	06450713          	addi	a4,a0,100
    80003d40:	0001d697          	auipc	a3,0x1d
    80003d44:	c8868693          	addi	a3,a3,-888 # 800209c8 <log+0x30>
    80003d48:	37fd                	addiw	a5,a5,-1
    80003d4a:	1782                	slli	a5,a5,0x20
    80003d4c:	9381                	srli	a5,a5,0x20
    80003d4e:	078a                	slli	a5,a5,0x2
    80003d50:	06850613          	addi	a2,a0,104
    80003d54:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003d56:	4310                	lw	a2,0(a4)
    80003d58:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003d5a:	0711                	addi	a4,a4,4
    80003d5c:	0691                	addi	a3,a3,4
    80003d5e:	fef71ce3          	bne	a4,a5,80003d56 <initlog+0x68>
  brelse(buf);
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	fc6080e7          	jalr	-58(ra) # 80002d28 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	ece080e7          	jalr	-306(ra) # 80003c38 <install_trans>
  log.lh.n = 0;
    80003d72:	0001d797          	auipc	a5,0x1d
    80003d76:	c407a923          	sw	zero,-942(a5) # 800209c4 <log+0x2c>
  write_head(); // clear the log
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	e44080e7          	jalr	-444(ra) # 80003bbe <write_head>
}
    80003d82:	70a2                	ld	ra,40(sp)
    80003d84:	7402                	ld	s0,32(sp)
    80003d86:	64e2                	ld	s1,24(sp)
    80003d88:	6942                	ld	s2,16(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
    80003d8c:	6145                	addi	sp,sp,48
    80003d8e:	8082                	ret

0000000080003d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d90:	1101                	addi	sp,sp,-32
    80003d92:	ec06                	sd	ra,24(sp)
    80003d94:	e822                	sd	s0,16(sp)
    80003d96:	e426                	sd	s1,8(sp)
    80003d98:	e04a                	sd	s2,0(sp)
    80003d9a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d9c:	0001d517          	auipc	a0,0x1d
    80003da0:	bfc50513          	addi	a0,a0,-1028 # 80020998 <log>
    80003da4:	ffffd097          	auipc	ra,0xffffd
    80003da8:	d2e080e7          	jalr	-722(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    80003dac:	0001d497          	auipc	s1,0x1d
    80003db0:	bec48493          	addi	s1,s1,-1044 # 80020998 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003db4:	4979                	li	s2,30
    80003db6:	a039                	j	80003dc4 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003db8:	85a6                	mv	a1,s1
    80003dba:	8526                	mv	a0,s1
    80003dbc:	ffffe097          	auipc	ra,0xffffe
    80003dc0:	22a080e7          	jalr	554(ra) # 80001fe6 <sleep>
    if(log.committing){
    80003dc4:	50dc                	lw	a5,36(s1)
    80003dc6:	fbed                	bnez	a5,80003db8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003dc8:	509c                	lw	a5,32(s1)
    80003dca:	0017871b          	addiw	a4,a5,1
    80003dce:	0007069b          	sext.w	a3,a4
    80003dd2:	0027179b          	slliw	a5,a4,0x2
    80003dd6:	9fb9                	addw	a5,a5,a4
    80003dd8:	0017979b          	slliw	a5,a5,0x1
    80003ddc:	54d8                	lw	a4,44(s1)
    80003dde:	9fb9                	addw	a5,a5,a4
    80003de0:	00f95963          	bge	s2,a5,80003df2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003de4:	85a6                	mv	a1,s1
    80003de6:	8526                	mv	a0,s1
    80003de8:	ffffe097          	auipc	ra,0xffffe
    80003dec:	1fe080e7          	jalr	510(ra) # 80001fe6 <sleep>
    80003df0:	bfd1                	j	80003dc4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003df2:	0001d517          	auipc	a0,0x1d
    80003df6:	ba650513          	addi	a0,a0,-1114 # 80020998 <log>
    80003dfa:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003dfc:	ffffd097          	auipc	ra,0xffffd
    80003e00:	d2a080e7          	jalr	-726(ra) # 80000b26 <release>
      break;
    }
  }
}
    80003e04:	60e2                	ld	ra,24(sp)
    80003e06:	6442                	ld	s0,16(sp)
    80003e08:	64a2                	ld	s1,8(sp)
    80003e0a:	6902                	ld	s2,0(sp)
    80003e0c:	6105                	addi	sp,sp,32
    80003e0e:	8082                	ret

0000000080003e10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e10:	7139                	addi	sp,sp,-64
    80003e12:	fc06                	sd	ra,56(sp)
    80003e14:	f822                	sd	s0,48(sp)
    80003e16:	f426                	sd	s1,40(sp)
    80003e18:	f04a                	sd	s2,32(sp)
    80003e1a:	ec4e                	sd	s3,24(sp)
    80003e1c:	e852                	sd	s4,16(sp)
    80003e1e:	e456                	sd	s5,8(sp)
    80003e20:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e22:	0001d497          	auipc	s1,0x1d
    80003e26:	b7648493          	addi	s1,s1,-1162 # 80020998 <log>
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	ffffd097          	auipc	ra,0xffffd
    80003e30:	ca6080e7          	jalr	-858(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    80003e34:	509c                	lw	a5,32(s1)
    80003e36:	37fd                	addiw	a5,a5,-1
    80003e38:	0007891b          	sext.w	s2,a5
    80003e3c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003e3e:	50dc                	lw	a5,36(s1)
    80003e40:	efb9                	bnez	a5,80003e9e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e42:	06091663          	bnez	s2,80003eae <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003e46:	0001d497          	auipc	s1,0x1d
    80003e4a:	b5248493          	addi	s1,s1,-1198 # 80020998 <log>
    80003e4e:	4785                	li	a5,1
    80003e50:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e52:	8526                	mv	a0,s1
    80003e54:	ffffd097          	auipc	ra,0xffffd
    80003e58:	cd2080e7          	jalr	-814(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e5c:	54dc                	lw	a5,44(s1)
    80003e5e:	06f04763          	bgtz	a5,80003ecc <end_op+0xbc>
    acquire(&log.lock);
    80003e62:	0001d497          	auipc	s1,0x1d
    80003e66:	b3648493          	addi	s1,s1,-1226 # 80020998 <log>
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	ffffd097          	auipc	ra,0xffffd
    80003e70:	c66080e7          	jalr	-922(ra) # 80000ad2 <acquire>
    log.committing = 0;
    80003e74:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	ffffe097          	auipc	ra,0xffffe
    80003e7e:	2f2080e7          	jalr	754(ra) # 8000216c <wakeup>
    release(&log.lock);
    80003e82:	8526                	mv	a0,s1
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	ca2080e7          	jalr	-862(ra) # 80000b26 <release>
}
    80003e8c:	70e2                	ld	ra,56(sp)
    80003e8e:	7442                	ld	s0,48(sp)
    80003e90:	74a2                	ld	s1,40(sp)
    80003e92:	7902                	ld	s2,32(sp)
    80003e94:	69e2                	ld	s3,24(sp)
    80003e96:	6a42                	ld	s4,16(sp)
    80003e98:	6aa2                	ld	s5,8(sp)
    80003e9a:	6121                	addi	sp,sp,64
    80003e9c:	8082                	ret
    panic("log.committing");
    80003e9e:	00002517          	auipc	a0,0x2
    80003ea2:	75a50513          	addi	a0,a0,1882 # 800065f8 <userret+0x568>
    80003ea6:	ffffc097          	auipc	ra,0xffffc
    80003eaa:	6a8080e7          	jalr	1704(ra) # 8000054e <panic>
    wakeup(&log);
    80003eae:	0001d497          	auipc	s1,0x1d
    80003eb2:	aea48493          	addi	s1,s1,-1302 # 80020998 <log>
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	ffffe097          	auipc	ra,0xffffe
    80003ebc:	2b4080e7          	jalr	692(ra) # 8000216c <wakeup>
  release(&log.lock);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	c64080e7          	jalr	-924(ra) # 80000b26 <release>
  if(do_commit){
    80003eca:	b7c9                	j	80003e8c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ecc:	0001da97          	auipc	s5,0x1d
    80003ed0:	afca8a93          	addi	s5,s5,-1284 # 800209c8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003ed4:	0001da17          	auipc	s4,0x1d
    80003ed8:	ac4a0a13          	addi	s4,s4,-1340 # 80020998 <log>
    80003edc:	018a2583          	lw	a1,24(s4)
    80003ee0:	012585bb          	addw	a1,a1,s2
    80003ee4:	2585                	addiw	a1,a1,1
    80003ee6:	028a2503          	lw	a0,40(s4)
    80003eea:	fffff097          	auipc	ra,0xfffff
    80003eee:	d0e080e7          	jalr	-754(ra) # 80002bf8 <bread>
    80003ef2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003ef4:	000aa583          	lw	a1,0(s5)
    80003ef8:	028a2503          	lw	a0,40(s4)
    80003efc:	fffff097          	auipc	ra,0xfffff
    80003f00:	cfc080e7          	jalr	-772(ra) # 80002bf8 <bread>
    80003f04:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f06:	40000613          	li	a2,1024
    80003f0a:	06050593          	addi	a1,a0,96
    80003f0e:	06048513          	addi	a0,s1,96
    80003f12:	ffffd097          	auipc	ra,0xffffd
    80003f16:	cbc080e7          	jalr	-836(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	fffff097          	auipc	ra,0xfffff
    80003f20:	dce080e7          	jalr	-562(ra) # 80002cea <bwrite>
    brelse(from);
    80003f24:	854e                	mv	a0,s3
    80003f26:	fffff097          	auipc	ra,0xfffff
    80003f2a:	e02080e7          	jalr	-510(ra) # 80002d28 <brelse>
    brelse(to);
    80003f2e:	8526                	mv	a0,s1
    80003f30:	fffff097          	auipc	ra,0xfffff
    80003f34:	df8080e7          	jalr	-520(ra) # 80002d28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f38:	2905                	addiw	s2,s2,1
    80003f3a:	0a91                	addi	s5,s5,4
    80003f3c:	02ca2783          	lw	a5,44(s4)
    80003f40:	f8f94ee3          	blt	s2,a5,80003edc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	c7a080e7          	jalr	-902(ra) # 80003bbe <write_head>
    install_trans(); // Now install writes to home locations
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	cec080e7          	jalr	-788(ra) # 80003c38 <install_trans>
    log.lh.n = 0;
    80003f54:	0001d797          	auipc	a5,0x1d
    80003f58:	a607a823          	sw	zero,-1424(a5) # 800209c4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003f5c:	00000097          	auipc	ra,0x0
    80003f60:	c62080e7          	jalr	-926(ra) # 80003bbe <write_head>
    80003f64:	bdfd                	j	80003e62 <end_op+0x52>

0000000080003f66 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f66:	1101                	addi	sp,sp,-32
    80003f68:	ec06                	sd	ra,24(sp)
    80003f6a:	e822                	sd	s0,16(sp)
    80003f6c:	e426                	sd	s1,8(sp)
    80003f6e:	e04a                	sd	s2,0(sp)
    80003f70:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003f72:	0001d717          	auipc	a4,0x1d
    80003f76:	a5272703          	lw	a4,-1454(a4) # 800209c4 <log+0x2c>
    80003f7a:	47f5                	li	a5,29
    80003f7c:	08e7c063          	blt	a5,a4,80003ffc <log_write+0x96>
    80003f80:	84aa                	mv	s1,a0
    80003f82:	0001d797          	auipc	a5,0x1d
    80003f86:	a327a783          	lw	a5,-1486(a5) # 800209b4 <log+0x1c>
    80003f8a:	37fd                	addiw	a5,a5,-1
    80003f8c:	06f75863          	bge	a4,a5,80003ffc <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f90:	0001d797          	auipc	a5,0x1d
    80003f94:	a287a783          	lw	a5,-1496(a5) # 800209b8 <log+0x20>
    80003f98:	06f05a63          	blez	a5,8000400c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80003f9c:	0001d917          	auipc	s2,0x1d
    80003fa0:	9fc90913          	addi	s2,s2,-1540 # 80020998 <log>
    80003fa4:	854a                	mv	a0,s2
    80003fa6:	ffffd097          	auipc	ra,0xffffd
    80003faa:	b2c080e7          	jalr	-1236(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80003fae:	02c92603          	lw	a2,44(s2)
    80003fb2:	06c05563          	blez	a2,8000401c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80003fb6:	44cc                	lw	a1,12(s1)
    80003fb8:	0001d717          	auipc	a4,0x1d
    80003fbc:	a1070713          	addi	a4,a4,-1520 # 800209c8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003fc0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80003fc2:	4314                	lw	a3,0(a4)
    80003fc4:	04b68d63          	beq	a3,a1,8000401e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80003fc8:	2785                	addiw	a5,a5,1
    80003fca:	0711                	addi	a4,a4,4
    80003fcc:	fec79be3          	bne	a5,a2,80003fc2 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003fd0:	0621                	addi	a2,a2,8
    80003fd2:	060a                	slli	a2,a2,0x2
    80003fd4:	0001d797          	auipc	a5,0x1d
    80003fd8:	9c478793          	addi	a5,a5,-1596 # 80020998 <log>
    80003fdc:	963e                	add	a2,a2,a5
    80003fde:	44dc                	lw	a5,12(s1)
    80003fe0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	de2080e7          	jalr	-542(ra) # 80002dc6 <bpin>
    log.lh.n++;
    80003fec:	0001d717          	auipc	a4,0x1d
    80003ff0:	9ac70713          	addi	a4,a4,-1620 # 80020998 <log>
    80003ff4:	575c                	lw	a5,44(a4)
    80003ff6:	2785                	addiw	a5,a5,1
    80003ff8:	d75c                	sw	a5,44(a4)
    80003ffa:	a83d                	j	80004038 <log_write+0xd2>
    panic("too big a transaction");
    80003ffc:	00002517          	auipc	a0,0x2
    80004000:	60c50513          	addi	a0,a0,1548 # 80006608 <userret+0x578>
    80004004:	ffffc097          	auipc	ra,0xffffc
    80004008:	54a080e7          	jalr	1354(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    8000400c:	00002517          	auipc	a0,0x2
    80004010:	61450513          	addi	a0,a0,1556 # 80006620 <userret+0x590>
    80004014:	ffffc097          	auipc	ra,0xffffc
    80004018:	53a080e7          	jalr	1338(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000401c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000401e:	00878713          	addi	a4,a5,8
    80004022:	00271693          	slli	a3,a4,0x2
    80004026:	0001d717          	auipc	a4,0x1d
    8000402a:	97270713          	addi	a4,a4,-1678 # 80020998 <log>
    8000402e:	9736                	add	a4,a4,a3
    80004030:	44d4                	lw	a3,12(s1)
    80004032:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004034:	faf607e3          	beq	a2,a5,80003fe2 <log_write+0x7c>
  }
  release(&log.lock);
    80004038:	0001d517          	auipc	a0,0x1d
    8000403c:	96050513          	addi	a0,a0,-1696 # 80020998 <log>
    80004040:	ffffd097          	auipc	ra,0xffffd
    80004044:	ae6080e7          	jalr	-1306(ra) # 80000b26 <release>
}
    80004048:	60e2                	ld	ra,24(sp)
    8000404a:	6442                	ld	s0,16(sp)
    8000404c:	64a2                	ld	s1,8(sp)
    8000404e:	6902                	ld	s2,0(sp)
    80004050:	6105                	addi	sp,sp,32
    80004052:	8082                	ret

0000000080004054 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004054:	1101                	addi	sp,sp,-32
    80004056:	ec06                	sd	ra,24(sp)
    80004058:	e822                	sd	s0,16(sp)
    8000405a:	e426                	sd	s1,8(sp)
    8000405c:	e04a                	sd	s2,0(sp)
    8000405e:	1000                	addi	s0,sp,32
    80004060:	84aa                	mv	s1,a0
    80004062:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004064:	00002597          	auipc	a1,0x2
    80004068:	5dc58593          	addi	a1,a1,1500 # 80006640 <userret+0x5b0>
    8000406c:	0521                	addi	a0,a0,8
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	952080e7          	jalr	-1710(ra) # 800009c0 <initlock>
  lk->name = name;
    80004076:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000407a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000407e:	0204a423          	sw	zero,40(s1)
}
    80004082:	60e2                	ld	ra,24(sp)
    80004084:	6442                	ld	s0,16(sp)
    80004086:	64a2                	ld	s1,8(sp)
    80004088:	6902                	ld	s2,0(sp)
    8000408a:	6105                	addi	sp,sp,32
    8000408c:	8082                	ret

000000008000408e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000408e:	1101                	addi	sp,sp,-32
    80004090:	ec06                	sd	ra,24(sp)
    80004092:	e822                	sd	s0,16(sp)
    80004094:	e426                	sd	s1,8(sp)
    80004096:	e04a                	sd	s2,0(sp)
    80004098:	1000                	addi	s0,sp,32
    8000409a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000409c:	00850913          	addi	s2,a0,8
    800040a0:	854a                	mv	a0,s2
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	a30080e7          	jalr	-1488(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    800040aa:	409c                	lw	a5,0(s1)
    800040ac:	cb89                	beqz	a5,800040be <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800040ae:	85ca                	mv	a1,s2
    800040b0:	8526                	mv	a0,s1
    800040b2:	ffffe097          	auipc	ra,0xffffe
    800040b6:	f34080e7          	jalr	-204(ra) # 80001fe6 <sleep>
  while (lk->locked) {
    800040ba:	409c                	lw	a5,0(s1)
    800040bc:	fbed                	bnez	a5,800040ae <acquiresleep+0x20>
  }
  lk->locked = 1;
    800040be:	4785                	li	a5,1
    800040c0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	782080e7          	jalr	1922(ra) # 80001844 <myproc>
    800040ca:	5d1c                	lw	a5,56(a0)
    800040cc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800040ce:	854a                	mv	a0,s2
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	a56080e7          	jalr	-1450(ra) # 80000b26 <release>
}
    800040d8:	60e2                	ld	ra,24(sp)
    800040da:	6442                	ld	s0,16(sp)
    800040dc:	64a2                	ld	s1,8(sp)
    800040de:	6902                	ld	s2,0(sp)
    800040e0:	6105                	addi	sp,sp,32
    800040e2:	8082                	ret

00000000800040e4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800040e4:	1101                	addi	sp,sp,-32
    800040e6:	ec06                	sd	ra,24(sp)
    800040e8:	e822                	sd	s0,16(sp)
    800040ea:	e426                	sd	s1,8(sp)
    800040ec:	e04a                	sd	s2,0(sp)
    800040ee:	1000                	addi	s0,sp,32
    800040f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040f2:	00850913          	addi	s2,a0,8
    800040f6:	854a                	mv	a0,s2
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	9da080e7          	jalr	-1574(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004100:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004104:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004108:	8526                	mv	a0,s1
    8000410a:	ffffe097          	auipc	ra,0xffffe
    8000410e:	062080e7          	jalr	98(ra) # 8000216c <wakeup>
  release(&lk->lk);
    80004112:	854a                	mv	a0,s2
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	a12080e7          	jalr	-1518(ra) # 80000b26 <release>
}
    8000411c:	60e2                	ld	ra,24(sp)
    8000411e:	6442                	ld	s0,16(sp)
    80004120:	64a2                	ld	s1,8(sp)
    80004122:	6902                	ld	s2,0(sp)
    80004124:	6105                	addi	sp,sp,32
    80004126:	8082                	ret

0000000080004128 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004128:	7179                	addi	sp,sp,-48
    8000412a:	f406                	sd	ra,40(sp)
    8000412c:	f022                	sd	s0,32(sp)
    8000412e:	ec26                	sd	s1,24(sp)
    80004130:	e84a                	sd	s2,16(sp)
    80004132:	e44e                	sd	s3,8(sp)
    80004134:	1800                	addi	s0,sp,48
    80004136:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004138:	00850913          	addi	s2,a0,8
    8000413c:	854a                	mv	a0,s2
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	994080e7          	jalr	-1644(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004146:	409c                	lw	a5,0(s1)
    80004148:	ef99                	bnez	a5,80004166 <holdingsleep+0x3e>
    8000414a:	4481                	li	s1,0
  release(&lk->lk);
    8000414c:	854a                	mv	a0,s2
    8000414e:	ffffd097          	auipc	ra,0xffffd
    80004152:	9d8080e7          	jalr	-1576(ra) # 80000b26 <release>
  return r;
}
    80004156:	8526                	mv	a0,s1
    80004158:	70a2                	ld	ra,40(sp)
    8000415a:	7402                	ld	s0,32(sp)
    8000415c:	64e2                	ld	s1,24(sp)
    8000415e:	6942                	ld	s2,16(sp)
    80004160:	69a2                	ld	s3,8(sp)
    80004162:	6145                	addi	sp,sp,48
    80004164:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004166:	0284a983          	lw	s3,40(s1)
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	6da080e7          	jalr	1754(ra) # 80001844 <myproc>
    80004172:	5d04                	lw	s1,56(a0)
    80004174:	413484b3          	sub	s1,s1,s3
    80004178:	0014b493          	seqz	s1,s1
    8000417c:	bfc1                	j	8000414c <holdingsleep+0x24>

000000008000417e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000417e:	1141                	addi	sp,sp,-16
    80004180:	e406                	sd	ra,8(sp)
    80004182:	e022                	sd	s0,0(sp)
    80004184:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004186:	00002597          	auipc	a1,0x2
    8000418a:	4ca58593          	addi	a1,a1,1226 # 80006650 <userret+0x5c0>
    8000418e:	0001d517          	auipc	a0,0x1d
    80004192:	95250513          	addi	a0,a0,-1710 # 80020ae0 <ftable>
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	82a080e7          	jalr	-2006(ra) # 800009c0 <initlock>
}
    8000419e:	60a2                	ld	ra,8(sp)
    800041a0:	6402                	ld	s0,0(sp)
    800041a2:	0141                	addi	sp,sp,16
    800041a4:	8082                	ret

00000000800041a6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041a6:	1101                	addi	sp,sp,-32
    800041a8:	ec06                	sd	ra,24(sp)
    800041aa:	e822                	sd	s0,16(sp)
    800041ac:	e426                	sd	s1,8(sp)
    800041ae:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041b0:	0001d517          	auipc	a0,0x1d
    800041b4:	93050513          	addi	a0,a0,-1744 # 80020ae0 <ftable>
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	91a080e7          	jalr	-1766(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041c0:	0001d497          	auipc	s1,0x1d
    800041c4:	93848493          	addi	s1,s1,-1736 # 80020af8 <ftable+0x18>
    800041c8:	0001e717          	auipc	a4,0x1e
    800041cc:	8d070713          	addi	a4,a4,-1840 # 80021a98 <ftable+0xfb8>
    if(f->ref == 0){
    800041d0:	40dc                	lw	a5,4(s1)
    800041d2:	cf99                	beqz	a5,800041f0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041d4:	02848493          	addi	s1,s1,40
    800041d8:	fee49ce3          	bne	s1,a4,800041d0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800041dc:	0001d517          	auipc	a0,0x1d
    800041e0:	90450513          	addi	a0,a0,-1788 # 80020ae0 <ftable>
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	942080e7          	jalr	-1726(ra) # 80000b26 <release>
  return 0;
    800041ec:	4481                	li	s1,0
    800041ee:	a819                	j	80004204 <filealloc+0x5e>
      f->ref = 1;
    800041f0:	4785                	li	a5,1
    800041f2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800041f4:	0001d517          	auipc	a0,0x1d
    800041f8:	8ec50513          	addi	a0,a0,-1812 # 80020ae0 <ftable>
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	92a080e7          	jalr	-1750(ra) # 80000b26 <release>
}
    80004204:	8526                	mv	a0,s1
    80004206:	60e2                	ld	ra,24(sp)
    80004208:	6442                	ld	s0,16(sp)
    8000420a:	64a2                	ld	s1,8(sp)
    8000420c:	6105                	addi	sp,sp,32
    8000420e:	8082                	ret

0000000080004210 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004210:	1101                	addi	sp,sp,-32
    80004212:	ec06                	sd	ra,24(sp)
    80004214:	e822                	sd	s0,16(sp)
    80004216:	e426                	sd	s1,8(sp)
    80004218:	1000                	addi	s0,sp,32
    8000421a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000421c:	0001d517          	auipc	a0,0x1d
    80004220:	8c450513          	addi	a0,a0,-1852 # 80020ae0 <ftable>
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	8ae080e7          	jalr	-1874(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    8000422c:	40dc                	lw	a5,4(s1)
    8000422e:	02f05263          	blez	a5,80004252 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004232:	2785                	addiw	a5,a5,1
    80004234:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004236:	0001d517          	auipc	a0,0x1d
    8000423a:	8aa50513          	addi	a0,a0,-1878 # 80020ae0 <ftable>
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	8e8080e7          	jalr	-1816(ra) # 80000b26 <release>
  return f;
}
    80004246:	8526                	mv	a0,s1
    80004248:	60e2                	ld	ra,24(sp)
    8000424a:	6442                	ld	s0,16(sp)
    8000424c:	64a2                	ld	s1,8(sp)
    8000424e:	6105                	addi	sp,sp,32
    80004250:	8082                	ret
    panic("filedup");
    80004252:	00002517          	auipc	a0,0x2
    80004256:	40650513          	addi	a0,a0,1030 # 80006658 <userret+0x5c8>
    8000425a:	ffffc097          	auipc	ra,0xffffc
    8000425e:	2f4080e7          	jalr	756(ra) # 8000054e <panic>

0000000080004262 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004262:	7139                	addi	sp,sp,-64
    80004264:	fc06                	sd	ra,56(sp)
    80004266:	f822                	sd	s0,48(sp)
    80004268:	f426                	sd	s1,40(sp)
    8000426a:	f04a                	sd	s2,32(sp)
    8000426c:	ec4e                	sd	s3,24(sp)
    8000426e:	e852                	sd	s4,16(sp)
    80004270:	e456                	sd	s5,8(sp)
    80004272:	0080                	addi	s0,sp,64
    80004274:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004276:	0001d517          	auipc	a0,0x1d
    8000427a:	86a50513          	addi	a0,a0,-1942 # 80020ae0 <ftable>
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	854080e7          	jalr	-1964(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    80004286:	40dc                	lw	a5,4(s1)
    80004288:	06f05163          	blez	a5,800042ea <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000428c:	37fd                	addiw	a5,a5,-1
    8000428e:	0007871b          	sext.w	a4,a5
    80004292:	c0dc                	sw	a5,4(s1)
    80004294:	06e04363          	bgtz	a4,800042fa <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004298:	0004a903          	lw	s2,0(s1)
    8000429c:	0094ca83          	lbu	s5,9(s1)
    800042a0:	0104ba03          	ld	s4,16(s1)
    800042a4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800042a8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042ac:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042b0:	0001d517          	auipc	a0,0x1d
    800042b4:	83050513          	addi	a0,a0,-2000 # 80020ae0 <ftable>
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	86e080e7          	jalr	-1938(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    800042c0:	4785                	li	a5,1
    800042c2:	04f90d63          	beq	s2,a5,8000431c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042c6:	3979                	addiw	s2,s2,-2
    800042c8:	4785                	li	a5,1
    800042ca:	0527e063          	bltu	a5,s2,8000430a <fileclose+0xa8>
    begin_op();
    800042ce:	00000097          	auipc	ra,0x0
    800042d2:	ac2080e7          	jalr	-1342(ra) # 80003d90 <begin_op>
    iput(ff.ip);
    800042d6:	854e                	mv	a0,s3
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	230080e7          	jalr	560(ra) # 80003508 <iput>
    end_op();
    800042e0:	00000097          	auipc	ra,0x0
    800042e4:	b30080e7          	jalr	-1232(ra) # 80003e10 <end_op>
    800042e8:	a00d                	j	8000430a <fileclose+0xa8>
    panic("fileclose");
    800042ea:	00002517          	auipc	a0,0x2
    800042ee:	37650513          	addi	a0,a0,886 # 80006660 <userret+0x5d0>
    800042f2:	ffffc097          	auipc	ra,0xffffc
    800042f6:	25c080e7          	jalr	604(ra) # 8000054e <panic>
    release(&ftable.lock);
    800042fa:	0001c517          	auipc	a0,0x1c
    800042fe:	7e650513          	addi	a0,a0,2022 # 80020ae0 <ftable>
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	824080e7          	jalr	-2012(ra) # 80000b26 <release>
  }
}
    8000430a:	70e2                	ld	ra,56(sp)
    8000430c:	7442                	ld	s0,48(sp)
    8000430e:	74a2                	ld	s1,40(sp)
    80004310:	7902                	ld	s2,32(sp)
    80004312:	69e2                	ld	s3,24(sp)
    80004314:	6a42                	ld	s4,16(sp)
    80004316:	6aa2                	ld	s5,8(sp)
    80004318:	6121                	addi	sp,sp,64
    8000431a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000431c:	85d6                	mv	a1,s5
    8000431e:	8552                	mv	a0,s4
    80004320:	00000097          	auipc	ra,0x0
    80004324:	372080e7          	jalr	882(ra) # 80004692 <pipeclose>
    80004328:	b7cd                	j	8000430a <fileclose+0xa8>

000000008000432a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000432a:	715d                	addi	sp,sp,-80
    8000432c:	e486                	sd	ra,72(sp)
    8000432e:	e0a2                	sd	s0,64(sp)
    80004330:	fc26                	sd	s1,56(sp)
    80004332:	f84a                	sd	s2,48(sp)
    80004334:	f44e                	sd	s3,40(sp)
    80004336:	0880                	addi	s0,sp,80
    80004338:	84aa                	mv	s1,a0
    8000433a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	508080e7          	jalr	1288(ra) # 80001844 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004344:	409c                	lw	a5,0(s1)
    80004346:	37f9                	addiw	a5,a5,-2
    80004348:	4705                	li	a4,1
    8000434a:	04f76763          	bltu	a4,a5,80004398 <filestat+0x6e>
    8000434e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004350:	6c88                	ld	a0,24(s1)
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	0a8080e7          	jalr	168(ra) # 800033fa <ilock>
    stati(f->ip, &st);
    8000435a:	fb840593          	addi	a1,s0,-72
    8000435e:	6c88                	ld	a0,24(s1)
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	300080e7          	jalr	768(ra) # 80003660 <stati>
    iunlock(f->ip);
    80004368:	6c88                	ld	a0,24(s1)
    8000436a:	fffff097          	auipc	ra,0xfffff
    8000436e:	152080e7          	jalr	338(ra) # 800034bc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004372:	46e1                	li	a3,24
    80004374:	fb840613          	addi	a2,s0,-72
    80004378:	85ce                	mv	a1,s3
    8000437a:	05093503          	ld	a0,80(s2)
    8000437e:	ffffd097          	auipc	ra,0xffffd
    80004382:	1ba080e7          	jalr	442(ra) # 80001538 <copyout>
    80004386:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000438a:	60a6                	ld	ra,72(sp)
    8000438c:	6406                	ld	s0,64(sp)
    8000438e:	74e2                	ld	s1,56(sp)
    80004390:	7942                	ld	s2,48(sp)
    80004392:	79a2                	ld	s3,40(sp)
    80004394:	6161                	addi	sp,sp,80
    80004396:	8082                	ret
  return -1;
    80004398:	557d                	li	a0,-1
    8000439a:	bfc5                	j	8000438a <filestat+0x60>

000000008000439c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000439c:	7179                	addi	sp,sp,-48
    8000439e:	f406                	sd	ra,40(sp)
    800043a0:	f022                	sd	s0,32(sp)
    800043a2:	ec26                	sd	s1,24(sp)
    800043a4:	e84a                	sd	s2,16(sp)
    800043a6:	e44e                	sd	s3,8(sp)
    800043a8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800043aa:	00854783          	lbu	a5,8(a0)
    800043ae:	c3d5                	beqz	a5,80004452 <fileread+0xb6>
    800043b0:	84aa                	mv	s1,a0
    800043b2:	89ae                	mv	s3,a1
    800043b4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800043b6:	411c                	lw	a5,0(a0)
    800043b8:	4705                	li	a4,1
    800043ba:	04e78963          	beq	a5,a4,8000440c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043be:	470d                	li	a4,3
    800043c0:	04e78d63          	beq	a5,a4,8000441a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800043c4:	4709                	li	a4,2
    800043c6:	06e79e63          	bne	a5,a4,80004442 <fileread+0xa6>
    ilock(f->ip);
    800043ca:	6d08                	ld	a0,24(a0)
    800043cc:	fffff097          	auipc	ra,0xfffff
    800043d0:	02e080e7          	jalr	46(ra) # 800033fa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800043d4:	874a                	mv	a4,s2
    800043d6:	5094                	lw	a3,32(s1)
    800043d8:	864e                	mv	a2,s3
    800043da:	4585                	li	a1,1
    800043dc:	6c88                	ld	a0,24(s1)
    800043de:	fffff097          	auipc	ra,0xfffff
    800043e2:	2ac080e7          	jalr	684(ra) # 8000368a <readi>
    800043e6:	892a                	mv	s2,a0
    800043e8:	00a05563          	blez	a0,800043f2 <fileread+0x56>
      f->off += r;
    800043ec:	509c                	lw	a5,32(s1)
    800043ee:	9fa9                	addw	a5,a5,a0
    800043f0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800043f2:	6c88                	ld	a0,24(s1)
    800043f4:	fffff097          	auipc	ra,0xfffff
    800043f8:	0c8080e7          	jalr	200(ra) # 800034bc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800043fc:	854a                	mv	a0,s2
    800043fe:	70a2                	ld	ra,40(sp)
    80004400:	7402                	ld	s0,32(sp)
    80004402:	64e2                	ld	s1,24(sp)
    80004404:	6942                	ld	s2,16(sp)
    80004406:	69a2                	ld	s3,8(sp)
    80004408:	6145                	addi	sp,sp,48
    8000440a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000440c:	6908                	ld	a0,16(a0)
    8000440e:	00000097          	auipc	ra,0x0
    80004412:	408080e7          	jalr	1032(ra) # 80004816 <piperead>
    80004416:	892a                	mv	s2,a0
    80004418:	b7d5                	j	800043fc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000441a:	02451783          	lh	a5,36(a0)
    8000441e:	03079693          	slli	a3,a5,0x30
    80004422:	92c1                	srli	a3,a3,0x30
    80004424:	4725                	li	a4,9
    80004426:	02d76863          	bltu	a4,a3,80004456 <fileread+0xba>
    8000442a:	0792                	slli	a5,a5,0x4
    8000442c:	0001c717          	auipc	a4,0x1c
    80004430:	61470713          	addi	a4,a4,1556 # 80020a40 <devsw>
    80004434:	97ba                	add	a5,a5,a4
    80004436:	639c                	ld	a5,0(a5)
    80004438:	c38d                	beqz	a5,8000445a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000443a:	4505                	li	a0,1
    8000443c:	9782                	jalr	a5
    8000443e:	892a                	mv	s2,a0
    80004440:	bf75                	j	800043fc <fileread+0x60>
    panic("fileread");
    80004442:	00002517          	auipc	a0,0x2
    80004446:	22e50513          	addi	a0,a0,558 # 80006670 <userret+0x5e0>
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	104080e7          	jalr	260(ra) # 8000054e <panic>
    return -1;
    80004452:	597d                	li	s2,-1
    80004454:	b765                	j	800043fc <fileread+0x60>
      return -1;
    80004456:	597d                	li	s2,-1
    80004458:	b755                	j	800043fc <fileread+0x60>
    8000445a:	597d                	li	s2,-1
    8000445c:	b745                	j	800043fc <fileread+0x60>

000000008000445e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000445e:	00954783          	lbu	a5,9(a0)
    80004462:	14078563          	beqz	a5,800045ac <filewrite+0x14e>
{
    80004466:	715d                	addi	sp,sp,-80
    80004468:	e486                	sd	ra,72(sp)
    8000446a:	e0a2                	sd	s0,64(sp)
    8000446c:	fc26                	sd	s1,56(sp)
    8000446e:	f84a                	sd	s2,48(sp)
    80004470:	f44e                	sd	s3,40(sp)
    80004472:	f052                	sd	s4,32(sp)
    80004474:	ec56                	sd	s5,24(sp)
    80004476:	e85a                	sd	s6,16(sp)
    80004478:	e45e                	sd	s7,8(sp)
    8000447a:	e062                	sd	s8,0(sp)
    8000447c:	0880                	addi	s0,sp,80
    8000447e:	892a                	mv	s2,a0
    80004480:	8aae                	mv	s5,a1
    80004482:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004484:	411c                	lw	a5,0(a0)
    80004486:	4705                	li	a4,1
    80004488:	02e78263          	beq	a5,a4,800044ac <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000448c:	470d                	li	a4,3
    8000448e:	02e78563          	beq	a5,a4,800044b8 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004492:	4709                	li	a4,2
    80004494:	10e79463          	bne	a5,a4,8000459c <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004498:	0ec05e63          	blez	a2,80004594 <filewrite+0x136>
    int i = 0;
    8000449c:	4981                	li	s3,0
    8000449e:	6b05                	lui	s6,0x1
    800044a0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800044a4:	6b85                	lui	s7,0x1
    800044a6:	c00b8b9b          	addiw	s7,s7,-1024
    800044aa:	a851                	j	8000453e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800044ac:	6908                	ld	a0,16(a0)
    800044ae:	00000097          	auipc	ra,0x0
    800044b2:	254080e7          	jalr	596(ra) # 80004702 <pipewrite>
    800044b6:	a85d                	j	8000456c <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044b8:	02451783          	lh	a5,36(a0)
    800044bc:	03079693          	slli	a3,a5,0x30
    800044c0:	92c1                	srli	a3,a3,0x30
    800044c2:	4725                	li	a4,9
    800044c4:	0ed76663          	bltu	a4,a3,800045b0 <filewrite+0x152>
    800044c8:	0792                	slli	a5,a5,0x4
    800044ca:	0001c717          	auipc	a4,0x1c
    800044ce:	57670713          	addi	a4,a4,1398 # 80020a40 <devsw>
    800044d2:	97ba                	add	a5,a5,a4
    800044d4:	679c                	ld	a5,8(a5)
    800044d6:	cff9                	beqz	a5,800045b4 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    800044d8:	4505                	li	a0,1
    800044da:	9782                	jalr	a5
    800044dc:	a841                	j	8000456c <filewrite+0x10e>
    800044de:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800044e2:	00000097          	auipc	ra,0x0
    800044e6:	8ae080e7          	jalr	-1874(ra) # 80003d90 <begin_op>
      ilock(f->ip);
    800044ea:	01893503          	ld	a0,24(s2)
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	f0c080e7          	jalr	-244(ra) # 800033fa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800044f6:	8762                	mv	a4,s8
    800044f8:	02092683          	lw	a3,32(s2)
    800044fc:	01598633          	add	a2,s3,s5
    80004500:	4585                	li	a1,1
    80004502:	01893503          	ld	a0,24(s2)
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	278080e7          	jalr	632(ra) # 8000377e <writei>
    8000450e:	84aa                	mv	s1,a0
    80004510:	02a05f63          	blez	a0,8000454e <filewrite+0xf0>
        f->off += r;
    80004514:	02092783          	lw	a5,32(s2)
    80004518:	9fa9                	addw	a5,a5,a0
    8000451a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000451e:	01893503          	ld	a0,24(s2)
    80004522:	fffff097          	auipc	ra,0xfffff
    80004526:	f9a080e7          	jalr	-102(ra) # 800034bc <iunlock>
      end_op();
    8000452a:	00000097          	auipc	ra,0x0
    8000452e:	8e6080e7          	jalr	-1818(ra) # 80003e10 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004532:	049c1963          	bne	s8,s1,80004584 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004536:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000453a:	0349d663          	bge	s3,s4,80004566 <filewrite+0x108>
      int n1 = n - i;
    8000453e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004542:	84be                	mv	s1,a5
    80004544:	2781                	sext.w	a5,a5
    80004546:	f8fb5ce3          	bge	s6,a5,800044de <filewrite+0x80>
    8000454a:	84de                	mv	s1,s7
    8000454c:	bf49                	j	800044de <filewrite+0x80>
      iunlock(f->ip);
    8000454e:	01893503          	ld	a0,24(s2)
    80004552:	fffff097          	auipc	ra,0xfffff
    80004556:	f6a080e7          	jalr	-150(ra) # 800034bc <iunlock>
      end_op();
    8000455a:	00000097          	auipc	ra,0x0
    8000455e:	8b6080e7          	jalr	-1866(ra) # 80003e10 <end_op>
      if(r < 0)
    80004562:	fc04d8e3          	bgez	s1,80004532 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004566:	8552                	mv	a0,s4
    80004568:	033a1863          	bne	s4,s3,80004598 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000456c:	60a6                	ld	ra,72(sp)
    8000456e:	6406                	ld	s0,64(sp)
    80004570:	74e2                	ld	s1,56(sp)
    80004572:	7942                	ld	s2,48(sp)
    80004574:	79a2                	ld	s3,40(sp)
    80004576:	7a02                	ld	s4,32(sp)
    80004578:	6ae2                	ld	s5,24(sp)
    8000457a:	6b42                	ld	s6,16(sp)
    8000457c:	6ba2                	ld	s7,8(sp)
    8000457e:	6c02                	ld	s8,0(sp)
    80004580:	6161                	addi	sp,sp,80
    80004582:	8082                	ret
        panic("short filewrite");
    80004584:	00002517          	auipc	a0,0x2
    80004588:	0fc50513          	addi	a0,a0,252 # 80006680 <userret+0x5f0>
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	fc2080e7          	jalr	-62(ra) # 8000054e <panic>
    int i = 0;
    80004594:	4981                	li	s3,0
    80004596:	bfc1                	j	80004566 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004598:	557d                	li	a0,-1
    8000459a:	bfc9                	j	8000456c <filewrite+0x10e>
    panic("filewrite");
    8000459c:	00002517          	auipc	a0,0x2
    800045a0:	0f450513          	addi	a0,a0,244 # 80006690 <userret+0x600>
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	faa080e7          	jalr	-86(ra) # 8000054e <panic>
    return -1;
    800045ac:	557d                	li	a0,-1
}
    800045ae:	8082                	ret
      return -1;
    800045b0:	557d                	li	a0,-1
    800045b2:	bf6d                	j	8000456c <filewrite+0x10e>
    800045b4:	557d                	li	a0,-1
    800045b6:	bf5d                	j	8000456c <filewrite+0x10e>

00000000800045b8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045b8:	7179                	addi	sp,sp,-48
    800045ba:	f406                	sd	ra,40(sp)
    800045bc:	f022                	sd	s0,32(sp)
    800045be:	ec26                	sd	s1,24(sp)
    800045c0:	e84a                	sd	s2,16(sp)
    800045c2:	e44e                	sd	s3,8(sp)
    800045c4:	e052                	sd	s4,0(sp)
    800045c6:	1800                	addi	s0,sp,48
    800045c8:	84aa                	mv	s1,a0
    800045ca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045cc:	0005b023          	sd	zero,0(a1)
    800045d0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	bd2080e7          	jalr	-1070(ra) # 800041a6 <filealloc>
    800045dc:	e088                	sd	a0,0(s1)
    800045de:	c551                	beqz	a0,8000466a <pipealloc+0xb2>
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	bc6080e7          	jalr	-1082(ra) # 800041a6 <filealloc>
    800045e8:	00aa3023          	sd	a0,0(s4)
    800045ec:	c92d                	beqz	a0,8000465e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800045ee:	ffffc097          	auipc	ra,0xffffc
    800045f2:	372080e7          	jalr	882(ra) # 80000960 <kalloc>
    800045f6:	892a                	mv	s2,a0
    800045f8:	c125                	beqz	a0,80004658 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800045fa:	4985                	li	s3,1
    800045fc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004600:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004604:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004608:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000460c:	00002597          	auipc	a1,0x2
    80004610:	09458593          	addi	a1,a1,148 # 800066a0 <userret+0x610>
    80004614:	ffffc097          	auipc	ra,0xffffc
    80004618:	3ac080e7          	jalr	940(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    8000461c:	609c                	ld	a5,0(s1)
    8000461e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004622:	609c                	ld	a5,0(s1)
    80004624:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004628:	609c                	ld	a5,0(s1)
    8000462a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000462e:	609c                	ld	a5,0(s1)
    80004630:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004634:	000a3783          	ld	a5,0(s4)
    80004638:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000463c:	000a3783          	ld	a5,0(s4)
    80004640:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004644:	000a3783          	ld	a5,0(s4)
    80004648:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000464c:	000a3783          	ld	a5,0(s4)
    80004650:	0127b823          	sd	s2,16(a5)
  return 0;
    80004654:	4501                	li	a0,0
    80004656:	a025                	j	8000467e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004658:	6088                	ld	a0,0(s1)
    8000465a:	e501                	bnez	a0,80004662 <pipealloc+0xaa>
    8000465c:	a039                	j	8000466a <pipealloc+0xb2>
    8000465e:	6088                	ld	a0,0(s1)
    80004660:	c51d                	beqz	a0,8000468e <pipealloc+0xd6>
    fileclose(*f0);
    80004662:	00000097          	auipc	ra,0x0
    80004666:	c00080e7          	jalr	-1024(ra) # 80004262 <fileclose>
  if(*f1)
    8000466a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000466e:	557d                	li	a0,-1
  if(*f1)
    80004670:	c799                	beqz	a5,8000467e <pipealloc+0xc6>
    fileclose(*f1);
    80004672:	853e                	mv	a0,a5
    80004674:	00000097          	auipc	ra,0x0
    80004678:	bee080e7          	jalr	-1042(ra) # 80004262 <fileclose>
  return -1;
    8000467c:	557d                	li	a0,-1
}
    8000467e:	70a2                	ld	ra,40(sp)
    80004680:	7402                	ld	s0,32(sp)
    80004682:	64e2                	ld	s1,24(sp)
    80004684:	6942                	ld	s2,16(sp)
    80004686:	69a2                	ld	s3,8(sp)
    80004688:	6a02                	ld	s4,0(sp)
    8000468a:	6145                	addi	sp,sp,48
    8000468c:	8082                	ret
  return -1;
    8000468e:	557d                	li	a0,-1
    80004690:	b7fd                	j	8000467e <pipealloc+0xc6>

0000000080004692 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004692:	1101                	addi	sp,sp,-32
    80004694:	ec06                	sd	ra,24(sp)
    80004696:	e822                	sd	s0,16(sp)
    80004698:	e426                	sd	s1,8(sp)
    8000469a:	e04a                	sd	s2,0(sp)
    8000469c:	1000                	addi	s0,sp,32
    8000469e:	84aa                	mv	s1,a0
    800046a0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046a2:	ffffc097          	auipc	ra,0xffffc
    800046a6:	430080e7          	jalr	1072(ra) # 80000ad2 <acquire>
  if(writable){
    800046aa:	02090d63          	beqz	s2,800046e4 <pipeclose+0x52>
    pi->writeopen = 0;
    800046ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046b2:	21848513          	addi	a0,s1,536
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	ab6080e7          	jalr	-1354(ra) # 8000216c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046be:	2204b783          	ld	a5,544(s1)
    800046c2:	eb95                	bnez	a5,800046f6 <pipeclose+0x64>
    release(&pi->lock);
    800046c4:	8526                	mv	a0,s1
    800046c6:	ffffc097          	auipc	ra,0xffffc
    800046ca:	460080e7          	jalr	1120(ra) # 80000b26 <release>
    kfree((char*)pi);
    800046ce:	8526                	mv	a0,s1
    800046d0:	ffffc097          	auipc	ra,0xffffc
    800046d4:	194080e7          	jalr	404(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    800046d8:	60e2                	ld	ra,24(sp)
    800046da:	6442                	ld	s0,16(sp)
    800046dc:	64a2                	ld	s1,8(sp)
    800046de:	6902                	ld	s2,0(sp)
    800046e0:	6105                	addi	sp,sp,32
    800046e2:	8082                	ret
    pi->readopen = 0;
    800046e4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800046e8:	21c48513          	addi	a0,s1,540
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	a80080e7          	jalr	-1408(ra) # 8000216c <wakeup>
    800046f4:	b7e9                	j	800046be <pipeclose+0x2c>
    release(&pi->lock);
    800046f6:	8526                	mv	a0,s1
    800046f8:	ffffc097          	auipc	ra,0xffffc
    800046fc:	42e080e7          	jalr	1070(ra) # 80000b26 <release>
}
    80004700:	bfe1                	j	800046d8 <pipeclose+0x46>

0000000080004702 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004702:	7159                	addi	sp,sp,-112
    80004704:	f486                	sd	ra,104(sp)
    80004706:	f0a2                	sd	s0,96(sp)
    80004708:	eca6                	sd	s1,88(sp)
    8000470a:	e8ca                	sd	s2,80(sp)
    8000470c:	e4ce                	sd	s3,72(sp)
    8000470e:	e0d2                	sd	s4,64(sp)
    80004710:	fc56                	sd	s5,56(sp)
    80004712:	f85a                	sd	s6,48(sp)
    80004714:	f45e                	sd	s7,40(sp)
    80004716:	f062                	sd	s8,32(sp)
    80004718:	ec66                	sd	s9,24(sp)
    8000471a:	1880                	addi	s0,sp,112
    8000471c:	84aa                	mv	s1,a0
    8000471e:	8b2e                	mv	s6,a1
    80004720:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004722:	ffffd097          	auipc	ra,0xffffd
    80004726:	122080e7          	jalr	290(ra) # 80001844 <myproc>
    8000472a:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffc097          	auipc	ra,0xffffc
    80004732:	3a4080e7          	jalr	932(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    80004736:	0b505063          	blez	s5,800047d6 <pipewrite+0xd4>
    8000473a:	8926                	mv	s2,s1
    8000473c:	fffa8b9b          	addiw	s7,s5,-1
    80004740:	1b82                	slli	s7,s7,0x20
    80004742:	020bdb93          	srli	s7,s7,0x20
    80004746:	001b0793          	addi	a5,s6,1
    8000474a:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000474c:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004750:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004754:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004756:	2184a783          	lw	a5,536(s1)
    8000475a:	21c4a703          	lw	a4,540(s1)
    8000475e:	2007879b          	addiw	a5,a5,512
    80004762:	02f71e63          	bne	a4,a5,8000479e <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004766:	2204a783          	lw	a5,544(s1)
    8000476a:	c3d9                	beqz	a5,800047f0 <pipewrite+0xee>
    8000476c:	ffffd097          	auipc	ra,0xffffd
    80004770:	0d8080e7          	jalr	216(ra) # 80001844 <myproc>
    80004774:	591c                	lw	a5,48(a0)
    80004776:	efad                	bnez	a5,800047f0 <pipewrite+0xee>
      wakeup(&pi->nread);
    80004778:	8552                	mv	a0,s4
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	9f2080e7          	jalr	-1550(ra) # 8000216c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004782:	85ca                	mv	a1,s2
    80004784:	854e                	mv	a0,s3
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	860080e7          	jalr	-1952(ra) # 80001fe6 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000478e:	2184a783          	lw	a5,536(s1)
    80004792:	21c4a703          	lw	a4,540(s1)
    80004796:	2007879b          	addiw	a5,a5,512
    8000479a:	fcf706e3          	beq	a4,a5,80004766 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000479e:	4685                	li	a3,1
    800047a0:	865a                	mv	a2,s6
    800047a2:	f9f40593          	addi	a1,s0,-97
    800047a6:	050c3503          	ld	a0,80(s8)
    800047aa:	ffffd097          	auipc	ra,0xffffd
    800047ae:	e1a080e7          	jalr	-486(ra) # 800015c4 <copyin>
    800047b2:	03950263          	beq	a0,s9,800047d6 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047b6:	21c4a783          	lw	a5,540(s1)
    800047ba:	0017871b          	addiw	a4,a5,1
    800047be:	20e4ae23          	sw	a4,540(s1)
    800047c2:	1ff7f793          	andi	a5,a5,511
    800047c6:	97a6                	add	a5,a5,s1
    800047c8:	f9f44703          	lbu	a4,-97(s0)
    800047cc:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800047d0:	0b05                	addi	s6,s6,1
    800047d2:	f97b12e3          	bne	s6,s7,80004756 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    800047d6:	21848513          	addi	a0,s1,536
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	992080e7          	jalr	-1646(ra) # 8000216c <wakeup>
  release(&pi->lock);
    800047e2:	8526                	mv	a0,s1
    800047e4:	ffffc097          	auipc	ra,0xffffc
    800047e8:	342080e7          	jalr	834(ra) # 80000b26 <release>
  return n;
    800047ec:	8556                	mv	a0,s5
    800047ee:	a039                	j	800047fc <pipewrite+0xfa>
        release(&pi->lock);
    800047f0:	8526                	mv	a0,s1
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	334080e7          	jalr	820(ra) # 80000b26 <release>
        return -1;
    800047fa:	557d                	li	a0,-1
}
    800047fc:	70a6                	ld	ra,104(sp)
    800047fe:	7406                	ld	s0,96(sp)
    80004800:	64e6                	ld	s1,88(sp)
    80004802:	6946                	ld	s2,80(sp)
    80004804:	69a6                	ld	s3,72(sp)
    80004806:	6a06                	ld	s4,64(sp)
    80004808:	7ae2                	ld	s5,56(sp)
    8000480a:	7b42                	ld	s6,48(sp)
    8000480c:	7ba2                	ld	s7,40(sp)
    8000480e:	7c02                	ld	s8,32(sp)
    80004810:	6ce2                	ld	s9,24(sp)
    80004812:	6165                	addi	sp,sp,112
    80004814:	8082                	ret

0000000080004816 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004816:	715d                	addi	sp,sp,-80
    80004818:	e486                	sd	ra,72(sp)
    8000481a:	e0a2                	sd	s0,64(sp)
    8000481c:	fc26                	sd	s1,56(sp)
    8000481e:	f84a                	sd	s2,48(sp)
    80004820:	f44e                	sd	s3,40(sp)
    80004822:	f052                	sd	s4,32(sp)
    80004824:	ec56                	sd	s5,24(sp)
    80004826:	e85a                	sd	s6,16(sp)
    80004828:	0880                	addi	s0,sp,80
    8000482a:	84aa                	mv	s1,a0
    8000482c:	892e                	mv	s2,a1
    8000482e:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004830:	ffffd097          	auipc	ra,0xffffd
    80004834:	014080e7          	jalr	20(ra) # 80001844 <myproc>
    80004838:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    8000483a:	8b26                	mv	s6,s1
    8000483c:	8526                	mv	a0,s1
    8000483e:	ffffc097          	auipc	ra,0xffffc
    80004842:	294080e7          	jalr	660(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004846:	2184a703          	lw	a4,536(s1)
    8000484a:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000484e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004852:	02f71763          	bne	a4,a5,80004880 <piperead+0x6a>
    80004856:	2244a783          	lw	a5,548(s1)
    8000485a:	c39d                	beqz	a5,80004880 <piperead+0x6a>
    if(myproc()->killed){
    8000485c:	ffffd097          	auipc	ra,0xffffd
    80004860:	fe8080e7          	jalr	-24(ra) # 80001844 <myproc>
    80004864:	591c                	lw	a5,48(a0)
    80004866:	ebc1                	bnez	a5,800048f6 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004868:	85da                	mv	a1,s6
    8000486a:	854e                	mv	a0,s3
    8000486c:	ffffd097          	auipc	ra,0xffffd
    80004870:	77a080e7          	jalr	1914(ra) # 80001fe6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004874:	2184a703          	lw	a4,536(s1)
    80004878:	21c4a783          	lw	a5,540(s1)
    8000487c:	fcf70de3          	beq	a4,a5,80004856 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004880:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004882:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004884:	05405363          	blez	s4,800048ca <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004888:	2184a783          	lw	a5,536(s1)
    8000488c:	21c4a703          	lw	a4,540(s1)
    80004890:	02f70d63          	beq	a4,a5,800048ca <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004894:	0017871b          	addiw	a4,a5,1
    80004898:	20e4ac23          	sw	a4,536(s1)
    8000489c:	1ff7f793          	andi	a5,a5,511
    800048a0:	97a6                	add	a5,a5,s1
    800048a2:	0187c783          	lbu	a5,24(a5)
    800048a6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800048aa:	4685                	li	a3,1
    800048ac:	fbf40613          	addi	a2,s0,-65
    800048b0:	85ca                	mv	a1,s2
    800048b2:	050ab503          	ld	a0,80(s5)
    800048b6:	ffffd097          	auipc	ra,0xffffd
    800048ba:	c82080e7          	jalr	-894(ra) # 80001538 <copyout>
    800048be:	01650663          	beq	a0,s6,800048ca <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800048c2:	2985                	addiw	s3,s3,1
    800048c4:	0905                	addi	s2,s2,1
    800048c6:	fd3a11e3          	bne	s4,s3,80004888 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800048ca:	21c48513          	addi	a0,s1,540
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	89e080e7          	jalr	-1890(ra) # 8000216c <wakeup>
  release(&pi->lock);
    800048d6:	8526                	mv	a0,s1
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	24e080e7          	jalr	590(ra) # 80000b26 <release>
  return i;
}
    800048e0:	854e                	mv	a0,s3
    800048e2:	60a6                	ld	ra,72(sp)
    800048e4:	6406                	ld	s0,64(sp)
    800048e6:	74e2                	ld	s1,56(sp)
    800048e8:	7942                	ld	s2,48(sp)
    800048ea:	79a2                	ld	s3,40(sp)
    800048ec:	7a02                	ld	s4,32(sp)
    800048ee:	6ae2                	ld	s5,24(sp)
    800048f0:	6b42                	ld	s6,16(sp)
    800048f2:	6161                	addi	sp,sp,80
    800048f4:	8082                	ret
      release(&pi->lock);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	22e080e7          	jalr	558(ra) # 80000b26 <release>
      return -1;
    80004900:	59fd                	li	s3,-1
    80004902:	bff9                	j	800048e0 <piperead+0xca>

0000000080004904 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004904:	df010113          	addi	sp,sp,-528
    80004908:	20113423          	sd	ra,520(sp)
    8000490c:	20813023          	sd	s0,512(sp)
    80004910:	ffa6                	sd	s1,504(sp)
    80004912:	fbca                	sd	s2,496(sp)
    80004914:	f7ce                	sd	s3,488(sp)
    80004916:	f3d2                	sd	s4,480(sp)
    80004918:	efd6                	sd	s5,472(sp)
    8000491a:	ebda                	sd	s6,464(sp)
    8000491c:	e7de                	sd	s7,456(sp)
    8000491e:	e3e2                	sd	s8,448(sp)
    80004920:	ff66                	sd	s9,440(sp)
    80004922:	fb6a                	sd	s10,432(sp)
    80004924:	f76e                	sd	s11,424(sp)
    80004926:	0c00                	addi	s0,sp,528
    80004928:	84aa                	mv	s1,a0
    8000492a:	dea43c23          	sd	a0,-520(s0)
    8000492e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004932:	ffffd097          	auipc	ra,0xffffd
    80004936:	f12080e7          	jalr	-238(ra) # 80001844 <myproc>
    8000493a:	892a                	mv	s2,a0

  begin_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	454080e7          	jalr	1108(ra) # 80003d90 <begin_op>

  if((ip = namei(path)) == 0){
    80004944:	8526                	mv	a0,s1
    80004946:	fffff097          	auipc	ra,0xfffff
    8000494a:	23e080e7          	jalr	574(ra) # 80003b84 <namei>
    8000494e:	c92d                	beqz	a0,800049c0 <exec+0xbc>
    80004950:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	aa8080e7          	jalr	-1368(ra) # 800033fa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000495a:	04000713          	li	a4,64
    8000495e:	4681                	li	a3,0
    80004960:	e4840613          	addi	a2,s0,-440
    80004964:	4581                	li	a1,0
    80004966:	8526                	mv	a0,s1
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	d22080e7          	jalr	-734(ra) # 8000368a <readi>
    80004970:	04000793          	li	a5,64
    80004974:	00f51a63          	bne	a0,a5,80004988 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004978:	e4842703          	lw	a4,-440(s0)
    8000497c:	464c47b7          	lui	a5,0x464c4
    80004980:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004984:	04f70463          	beq	a4,a5,800049cc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	cae080e7          	jalr	-850(ra) # 80003638 <iunlockput>
    end_op();
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	47e080e7          	jalr	1150(ra) # 80003e10 <end_op>
  }
  return -1;
    8000499a:	557d                	li	a0,-1
}
    8000499c:	20813083          	ld	ra,520(sp)
    800049a0:	20013403          	ld	s0,512(sp)
    800049a4:	74fe                	ld	s1,504(sp)
    800049a6:	795e                	ld	s2,496(sp)
    800049a8:	79be                	ld	s3,488(sp)
    800049aa:	7a1e                	ld	s4,480(sp)
    800049ac:	6afe                	ld	s5,472(sp)
    800049ae:	6b5e                	ld	s6,464(sp)
    800049b0:	6bbe                	ld	s7,456(sp)
    800049b2:	6c1e                	ld	s8,448(sp)
    800049b4:	7cfa                	ld	s9,440(sp)
    800049b6:	7d5a                	ld	s10,432(sp)
    800049b8:	7dba                	ld	s11,424(sp)
    800049ba:	21010113          	addi	sp,sp,528
    800049be:	8082                	ret
    end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	450080e7          	jalr	1104(ra) # 80003e10 <end_op>
    return -1;
    800049c8:	557d                	li	a0,-1
    800049ca:	bfc9                	j	8000499c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800049cc:	854a                	mv	a0,s2
    800049ce:	ffffd097          	auipc	ra,0xffffd
    800049d2:	f3a080e7          	jalr	-198(ra) # 80001908 <proc_pagetable>
    800049d6:	8c2a                	mv	s8,a0
    800049d8:	d945                	beqz	a0,80004988 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049da:	e6842983          	lw	s3,-408(s0)
    800049de:	e8045783          	lhu	a5,-384(s0)
    800049e2:	c7fd                	beqz	a5,80004ad0 <exec+0x1cc>
  sz = 0;
    800049e4:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800049e8:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    800049ea:	6b05                	lui	s6,0x1
    800049ec:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    800049f0:	def43823          	sd	a5,-528(s0)
    800049f4:	a0a5                	j	80004a5c <exec+0x158>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800049f6:	00002517          	auipc	a0,0x2
    800049fa:	cb250513          	addi	a0,a0,-846 # 800066a8 <userret+0x618>
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	b50080e7          	jalr	-1200(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004a06:	8756                	mv	a4,s5
    80004a08:	012d86bb          	addw	a3,s11,s2
    80004a0c:	4581                	li	a1,0
    80004a0e:	8526                	mv	a0,s1
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	c7a080e7          	jalr	-902(ra) # 8000368a <readi>
    80004a18:	2501                	sext.w	a0,a0
    80004a1a:	10aa9163          	bne	s5,a0,80004b1c <exec+0x218>
  for(i = 0; i < sz; i += PGSIZE){
    80004a1e:	6785                	lui	a5,0x1
    80004a20:	0127893b          	addw	s2,a5,s2
    80004a24:	77fd                	lui	a5,0xfffff
    80004a26:	01478a3b          	addw	s4,a5,s4
    80004a2a:	03997263          	bgeu	s2,s9,80004a4e <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004a2e:	02091593          	slli	a1,s2,0x20
    80004a32:	9181                	srli	a1,a1,0x20
    80004a34:	95ea                	add	a1,a1,s10
    80004a36:	8562                	mv	a0,s8
    80004a38:	ffffc097          	auipc	ra,0xffffc
    80004a3c:	532080e7          	jalr	1330(ra) # 80000f6a <walkaddr>
    80004a40:	862a                	mv	a2,a0
    if(pa == 0)
    80004a42:	d955                	beqz	a0,800049f6 <exec+0xf2>
      n = PGSIZE;
    80004a44:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004a46:	fd6a70e3          	bgeu	s4,s6,80004a06 <exec+0x102>
      n = sz - i;
    80004a4a:	8ad2                	mv	s5,s4
    80004a4c:	bf6d                	j	80004a06 <exec+0x102>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a4e:	2b85                	addiw	s7,s7,1
    80004a50:	0389899b          	addiw	s3,s3,56
    80004a54:	e8045783          	lhu	a5,-384(s0)
    80004a58:	06fbde63          	bge	s7,a5,80004ad4 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004a5c:	2981                	sext.w	s3,s3
    80004a5e:	03800713          	li	a4,56
    80004a62:	86ce                	mv	a3,s3
    80004a64:	e1040613          	addi	a2,s0,-496
    80004a68:	4581                	li	a1,0
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	c1e080e7          	jalr	-994(ra) # 8000368a <readi>
    80004a74:	03800793          	li	a5,56
    80004a78:	0af51263          	bne	a0,a5,80004b1c <exec+0x218>
    if(ph.type != ELF_PROG_LOAD)
    80004a7c:	e1042783          	lw	a5,-496(s0)
    80004a80:	4705                	li	a4,1
    80004a82:	fce796e3          	bne	a5,a4,80004a4e <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80004a86:	e3843603          	ld	a2,-456(s0)
    80004a8a:	e3043783          	ld	a5,-464(s0)
    80004a8e:	08f66763          	bltu	a2,a5,80004b1c <exec+0x218>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004a92:	e2043783          	ld	a5,-480(s0)
    80004a96:	963e                	add	a2,a2,a5
    80004a98:	08f66263          	bltu	a2,a5,80004b1c <exec+0x218>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004a9c:	e0843583          	ld	a1,-504(s0)
    80004aa0:	8562                	mv	a0,s8
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	8bc080e7          	jalr	-1860(ra) # 8000135e <uvmalloc>
    80004aaa:	e0a43423          	sd	a0,-504(s0)
    80004aae:	c53d                	beqz	a0,80004b1c <exec+0x218>
    if(ph.vaddr % PGSIZE != 0)
    80004ab0:	e2043d03          	ld	s10,-480(s0)
    80004ab4:	df043783          	ld	a5,-528(s0)
    80004ab8:	00fd77b3          	and	a5,s10,a5
    80004abc:	e3a5                	bnez	a5,80004b1c <exec+0x218>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004abe:	e1842d83          	lw	s11,-488(s0)
    80004ac2:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ac6:	f80c84e3          	beqz	s9,80004a4e <exec+0x14a>
    80004aca:	8a66                	mv	s4,s9
    80004acc:	4901                	li	s2,0
    80004ace:	b785                	j	80004a2e <exec+0x12a>
  sz = 0;
    80004ad0:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	b62080e7          	jalr	-1182(ra) # 80003638 <iunlockput>
  end_op();
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	332080e7          	jalr	818(ra) # 80003e10 <end_op>
  p = myproc();
    80004ae6:	ffffd097          	auipc	ra,0xffffd
    80004aea:	d5e080e7          	jalr	-674(ra) # 80001844 <myproc>
    80004aee:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004af0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004af4:	6585                	lui	a1,0x1
    80004af6:	15fd                	addi	a1,a1,-1
    80004af8:	e0843783          	ld	a5,-504(s0)
    80004afc:	00b78b33          	add	s6,a5,a1
    80004b00:	75fd                	lui	a1,0xfffff
    80004b02:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004b06:	6609                	lui	a2,0x2
    80004b08:	962e                	add	a2,a2,a1
    80004b0a:	8562                	mv	a0,s8
    80004b0c:	ffffd097          	auipc	ra,0xffffd
    80004b10:	852080e7          	jalr	-1966(ra) # 8000135e <uvmalloc>
    80004b14:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004b18:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004b1a:	ed01                	bnez	a0,80004b32 <exec+0x22e>
    proc_freepagetable(pagetable, sz);
    80004b1c:	e0843583          	ld	a1,-504(s0)
    80004b20:	8562                	mv	a0,s8
    80004b22:	ffffd097          	auipc	ra,0xffffd
    80004b26:	ee6080e7          	jalr	-282(ra) # 80001a08 <proc_freepagetable>
  if(ip){
    80004b2a:	e4049fe3          	bnez	s1,80004988 <exec+0x84>
  return -1;
    80004b2e:	557d                	li	a0,-1
    80004b30:	b5b5                	j	8000499c <exec+0x98>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004b32:	75f9                	lui	a1,0xffffe
    80004b34:	84aa                	mv	s1,a0
    80004b36:	95aa                	add	a1,a1,a0
    80004b38:	8562                	mv	a0,s8
    80004b3a:	ffffd097          	auipc	ra,0xffffd
    80004b3e:	9cc080e7          	jalr	-1588(ra) # 80001506 <uvmclear>
  stackbase = sp - PGSIZE;
    80004b42:	7afd                	lui	s5,0xfffff
    80004b44:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004b46:	e0043783          	ld	a5,-512(s0)
    80004b4a:	6388                	ld	a0,0(a5)
    80004b4c:	c135                	beqz	a0,80004bb0 <exec+0x2ac>
    80004b4e:	e8840993          	addi	s3,s0,-376
    80004b52:	f8840c93          	addi	s9,s0,-120
    80004b56:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	19e080e7          	jalr	414(ra) # 80000cf6 <strlen>
    80004b60:	2505                	addiw	a0,a0,1
    80004b62:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004b64:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004b66:	0f54ea63          	bltu	s1,s5,80004c5a <exec+0x356>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004b6a:	e0043b03          	ld	s6,-512(s0)
    80004b6e:	000b3a03          	ld	s4,0(s6)
    80004b72:	8552                	mv	a0,s4
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	182080e7          	jalr	386(ra) # 80000cf6 <strlen>
    80004b7c:	0015069b          	addiw	a3,a0,1
    80004b80:	8652                	mv	a2,s4
    80004b82:	85a6                	mv	a1,s1
    80004b84:	8562                	mv	a0,s8
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	9b2080e7          	jalr	-1614(ra) # 80001538 <copyout>
    80004b8e:	0c054863          	bltz	a0,80004c5e <exec+0x35a>
    ustack[argc] = sp;
    80004b92:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004b96:	0905                	addi	s2,s2,1
    80004b98:	008b0793          	addi	a5,s6,8
    80004b9c:	e0f43023          	sd	a5,-512(s0)
    80004ba0:	008b3503          	ld	a0,8(s6)
    80004ba4:	c909                	beqz	a0,80004bb6 <exec+0x2b2>
    if(argc >= MAXARG)
    80004ba6:	09a1                	addi	s3,s3,8
    80004ba8:	fb3c98e3          	bne	s9,s3,80004b58 <exec+0x254>
  ip = 0;
    80004bac:	4481                	li	s1,0
    80004bae:	b7bd                	j	80004b1c <exec+0x218>
  sp = sz;
    80004bb0:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004bb4:	4901                	li	s2,0
  ustack[argc] = 0;
    80004bb6:	00391793          	slli	a5,s2,0x3
    80004bba:	f9040713          	addi	a4,s0,-112
    80004bbe:	97ba                	add	a5,a5,a4
    80004bc0:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd9edc>
  sp -= (argc+1) * sizeof(uint64);
    80004bc4:	00190693          	addi	a3,s2,1
    80004bc8:	068e                	slli	a3,a3,0x3
    80004bca:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004bcc:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004bd0:	4481                	li	s1,0
  if(sp < stackbase)
    80004bd2:	f559e5e3          	bltu	s3,s5,80004b1c <exec+0x218>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004bd6:	e8840613          	addi	a2,s0,-376
    80004bda:	85ce                	mv	a1,s3
    80004bdc:	8562                	mv	a0,s8
    80004bde:	ffffd097          	auipc	ra,0xffffd
    80004be2:	95a080e7          	jalr	-1702(ra) # 80001538 <copyout>
    80004be6:	06054e63          	bltz	a0,80004c62 <exec+0x35e>
  p->tf->a1 = sp;
    80004bea:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004bee:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80004bf2:	df843783          	ld	a5,-520(s0)
    80004bf6:	0007c703          	lbu	a4,0(a5)
    80004bfa:	cf11                	beqz	a4,80004c16 <exec+0x312>
    80004bfc:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004bfe:	02f00693          	li	a3,47
    80004c02:	a029                	j	80004c0c <exec+0x308>
  for(last=s=path; *s; s++)
    80004c04:	0785                	addi	a5,a5,1
    80004c06:	fff7c703          	lbu	a4,-1(a5)
    80004c0a:	c711                	beqz	a4,80004c16 <exec+0x312>
    if(*s == '/')
    80004c0c:	fed71ce3          	bne	a4,a3,80004c04 <exec+0x300>
      last = s+1;
    80004c10:	def43c23          	sd	a5,-520(s0)
    80004c14:	bfc5                	j	80004c04 <exec+0x300>
  safestrcpy(p->name, last, sizeof(p->name));
    80004c16:	4641                	li	a2,16
    80004c18:	df843583          	ld	a1,-520(s0)
    80004c1c:	158b8513          	addi	a0,s7,344
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	0a4080e7          	jalr	164(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004c28:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004c2c:	058bb823          	sd	s8,80(s7)
  p->sz = sz;
    80004c30:	e0843783          	ld	a5,-504(s0)
    80004c34:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004c38:	058bb783          	ld	a5,88(s7)
    80004c3c:	e6043703          	ld	a4,-416(s0)
    80004c40:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004c42:	058bb783          	ld	a5,88(s7)
    80004c46:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004c4a:	85ea                	mv	a1,s10
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	dbc080e7          	jalr	-580(ra) # 80001a08 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004c54:	0009051b          	sext.w	a0,s2
    80004c58:	b391                	j	8000499c <exec+0x98>
  ip = 0;
    80004c5a:	4481                	li	s1,0
    80004c5c:	b5c1                	j	80004b1c <exec+0x218>
    80004c5e:	4481                	li	s1,0
    80004c60:	bd75                	j	80004b1c <exec+0x218>
    80004c62:	4481                	li	s1,0
    80004c64:	bd65                	j	80004b1c <exec+0x218>

0000000080004c66 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c66:	7179                	addi	sp,sp,-48
    80004c68:	f406                	sd	ra,40(sp)
    80004c6a:	f022                	sd	s0,32(sp)
    80004c6c:	ec26                	sd	s1,24(sp)
    80004c6e:	e84a                	sd	s2,16(sp)
    80004c70:	1800                	addi	s0,sp,48
    80004c72:	892e                	mv	s2,a1
    80004c74:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004c76:	fdc40593          	addi	a1,s0,-36
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	c0e080e7          	jalr	-1010(ra) # 80002888 <argint>
    80004c82:	04054063          	bltz	a0,80004cc2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004c86:	fdc42703          	lw	a4,-36(s0)
    80004c8a:	47bd                	li	a5,15
    80004c8c:	02e7ed63          	bltu	a5,a4,80004cc6 <argfd+0x60>
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	bb4080e7          	jalr	-1100(ra) # 80001844 <myproc>
    80004c98:	fdc42703          	lw	a4,-36(s0)
    80004c9c:	01a70793          	addi	a5,a4,26
    80004ca0:	078e                	slli	a5,a5,0x3
    80004ca2:	953e                	add	a0,a0,a5
    80004ca4:	611c                	ld	a5,0(a0)
    80004ca6:	c395                	beqz	a5,80004cca <argfd+0x64>
    return -1;
  if(pfd)
    80004ca8:	00090463          	beqz	s2,80004cb0 <argfd+0x4a>
    *pfd = fd;
    80004cac:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004cb0:	4501                	li	a0,0
  if(pf)
    80004cb2:	c091                	beqz	s1,80004cb6 <argfd+0x50>
    *pf = f;
    80004cb4:	e09c                	sd	a5,0(s1)
}
    80004cb6:	70a2                	ld	ra,40(sp)
    80004cb8:	7402                	ld	s0,32(sp)
    80004cba:	64e2                	ld	s1,24(sp)
    80004cbc:	6942                	ld	s2,16(sp)
    80004cbe:	6145                	addi	sp,sp,48
    80004cc0:	8082                	ret
    return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	bfcd                	j	80004cb6 <argfd+0x50>
    return -1;
    80004cc6:	557d                	li	a0,-1
    80004cc8:	b7fd                	j	80004cb6 <argfd+0x50>
    80004cca:	557d                	li	a0,-1
    80004ccc:	b7ed                	j	80004cb6 <argfd+0x50>

0000000080004cce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004cce:	1101                	addi	sp,sp,-32
    80004cd0:	ec06                	sd	ra,24(sp)
    80004cd2:	e822                	sd	s0,16(sp)
    80004cd4:	e426                	sd	s1,8(sp)
    80004cd6:	1000                	addi	s0,sp,32
    80004cd8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	b6a080e7          	jalr	-1174(ra) # 80001844 <myproc>
    80004ce2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ce4:	0d050793          	addi	a5,a0,208
    80004ce8:	4501                	li	a0,0
    80004cea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004cec:	6398                	ld	a4,0(a5)
    80004cee:	cb19                	beqz	a4,80004d04 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004cf0:	2505                	addiw	a0,a0,1
    80004cf2:	07a1                	addi	a5,a5,8
    80004cf4:	fed51ce3          	bne	a0,a3,80004cec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004cf8:	557d                	li	a0,-1
}
    80004cfa:	60e2                	ld	ra,24(sp)
    80004cfc:	6442                	ld	s0,16(sp)
    80004cfe:	64a2                	ld	s1,8(sp)
    80004d00:	6105                	addi	sp,sp,32
    80004d02:	8082                	ret
      p->ofile[fd] = f;
    80004d04:	01a50793          	addi	a5,a0,26
    80004d08:	078e                	slli	a5,a5,0x3
    80004d0a:	963e                	add	a2,a2,a5
    80004d0c:	e204                	sd	s1,0(a2)
      return fd;
    80004d0e:	b7f5                	j	80004cfa <fdalloc+0x2c>

0000000080004d10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004d10:	715d                	addi	sp,sp,-80
    80004d12:	e486                	sd	ra,72(sp)
    80004d14:	e0a2                	sd	s0,64(sp)
    80004d16:	fc26                	sd	s1,56(sp)
    80004d18:	f84a                	sd	s2,48(sp)
    80004d1a:	f44e                	sd	s3,40(sp)
    80004d1c:	f052                	sd	s4,32(sp)
    80004d1e:	ec56                	sd	s5,24(sp)
    80004d20:	0880                	addi	s0,sp,80
    80004d22:	89ae                	mv	s3,a1
    80004d24:	8ab2                	mv	s5,a2
    80004d26:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004d28:	fb040593          	addi	a1,s0,-80
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	e76080e7          	jalr	-394(ra) # 80003ba2 <nameiparent>
    80004d34:	892a                	mv	s2,a0
    80004d36:	12050e63          	beqz	a0,80004e72 <create+0x162>
    return 0;

  ilock(dp);
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	6c0080e7          	jalr	1728(ra) # 800033fa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004d42:	4601                	li	a2,0
    80004d44:	fb040593          	addi	a1,s0,-80
    80004d48:	854a                	mv	a0,s2
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	b68080e7          	jalr	-1176(ra) # 800038b2 <dirlookup>
    80004d52:	84aa                	mv	s1,a0
    80004d54:	c921                	beqz	a0,80004da4 <create+0x94>
    iunlockput(dp);
    80004d56:	854a                	mv	a0,s2
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	8e0080e7          	jalr	-1824(ra) # 80003638 <iunlockput>
    ilock(ip);
    80004d60:	8526                	mv	a0,s1
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	698080e7          	jalr	1688(ra) # 800033fa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004d6a:	2981                	sext.w	s3,s3
    80004d6c:	4789                	li	a5,2
    80004d6e:	02f99463          	bne	s3,a5,80004d96 <create+0x86>
    80004d72:	0444d783          	lhu	a5,68(s1)
    80004d76:	37f9                	addiw	a5,a5,-2
    80004d78:	17c2                	slli	a5,a5,0x30
    80004d7a:	93c1                	srli	a5,a5,0x30
    80004d7c:	4705                	li	a4,1
    80004d7e:	00f76c63          	bltu	a4,a5,80004d96 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004d82:	8526                	mv	a0,s1
    80004d84:	60a6                	ld	ra,72(sp)
    80004d86:	6406                	ld	s0,64(sp)
    80004d88:	74e2                	ld	s1,56(sp)
    80004d8a:	7942                	ld	s2,48(sp)
    80004d8c:	79a2                	ld	s3,40(sp)
    80004d8e:	7a02                	ld	s4,32(sp)
    80004d90:	6ae2                	ld	s5,24(sp)
    80004d92:	6161                	addi	sp,sp,80
    80004d94:	8082                	ret
    iunlockput(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	8a0080e7          	jalr	-1888(ra) # 80003638 <iunlockput>
    return 0;
    80004da0:	4481                	li	s1,0
    80004da2:	b7c5                	j	80004d82 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004da4:	85ce                	mv	a1,s3
    80004da6:	00092503          	lw	a0,0(s2)
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	4b8080e7          	jalr	1208(ra) # 80003262 <ialloc>
    80004db2:	84aa                	mv	s1,a0
    80004db4:	c521                	beqz	a0,80004dfc <create+0xec>
  ilock(ip);
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	644080e7          	jalr	1604(ra) # 800033fa <ilock>
  ip->major = major;
    80004dbe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004dc2:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004dc6:	4a05                	li	s4,1
    80004dc8:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004dcc:	8526                	mv	a0,s1
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	562080e7          	jalr	1378(ra) # 80003330 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004dd6:	2981                	sext.w	s3,s3
    80004dd8:	03498a63          	beq	s3,s4,80004e0c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ddc:	40d0                	lw	a2,4(s1)
    80004dde:	fb040593          	addi	a1,s0,-80
    80004de2:	854a                	mv	a0,s2
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	cde080e7          	jalr	-802(ra) # 80003ac2 <dirlink>
    80004dec:	06054b63          	bltz	a0,80004e62 <create+0x152>
  iunlockput(dp);
    80004df0:	854a                	mv	a0,s2
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	846080e7          	jalr	-1978(ra) # 80003638 <iunlockput>
  return ip;
    80004dfa:	b761                	j	80004d82 <create+0x72>
    panic("create: ialloc");
    80004dfc:	00002517          	auipc	a0,0x2
    80004e00:	8cc50513          	addi	a0,a0,-1844 # 800066c8 <userret+0x638>
    80004e04:	ffffb097          	auipc	ra,0xffffb
    80004e08:	74a080e7          	jalr	1866(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    80004e0c:	04a95783          	lhu	a5,74(s2)
    80004e10:	2785                	addiw	a5,a5,1
    80004e12:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004e16:	854a                	mv	a0,s2
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	518080e7          	jalr	1304(ra) # 80003330 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004e20:	40d0                	lw	a2,4(s1)
    80004e22:	00002597          	auipc	a1,0x2
    80004e26:	8b658593          	addi	a1,a1,-1866 # 800066d8 <userret+0x648>
    80004e2a:	8526                	mv	a0,s1
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	c96080e7          	jalr	-874(ra) # 80003ac2 <dirlink>
    80004e34:	00054f63          	bltz	a0,80004e52 <create+0x142>
    80004e38:	00492603          	lw	a2,4(s2)
    80004e3c:	00002597          	auipc	a1,0x2
    80004e40:	8a458593          	addi	a1,a1,-1884 # 800066e0 <userret+0x650>
    80004e44:	8526                	mv	a0,s1
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	c7c080e7          	jalr	-900(ra) # 80003ac2 <dirlink>
    80004e4e:	f80557e3          	bgez	a0,80004ddc <create+0xcc>
      panic("create dots");
    80004e52:	00002517          	auipc	a0,0x2
    80004e56:	89650513          	addi	a0,a0,-1898 # 800066e8 <userret+0x658>
    80004e5a:	ffffb097          	auipc	ra,0xffffb
    80004e5e:	6f4080e7          	jalr	1780(ra) # 8000054e <panic>
    panic("create: dirlink");
    80004e62:	00002517          	auipc	a0,0x2
    80004e66:	89650513          	addi	a0,a0,-1898 # 800066f8 <userret+0x668>
    80004e6a:	ffffb097          	auipc	ra,0xffffb
    80004e6e:	6e4080e7          	jalr	1764(ra) # 8000054e <panic>
    return 0;
    80004e72:	84aa                	mv	s1,a0
    80004e74:	b739                	j	80004d82 <create+0x72>

0000000080004e76 <sys_dup>:
{
    80004e76:	7179                	addi	sp,sp,-48
    80004e78:	f406                	sd	ra,40(sp)
    80004e7a:	f022                	sd	s0,32(sp)
    80004e7c:	ec26                	sd	s1,24(sp)
    80004e7e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004e80:	fd840613          	addi	a2,s0,-40
    80004e84:	4581                	li	a1,0
    80004e86:	4501                	li	a0,0
    80004e88:	00000097          	auipc	ra,0x0
    80004e8c:	dde080e7          	jalr	-546(ra) # 80004c66 <argfd>
    return -1;
    80004e90:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004e92:	02054363          	bltz	a0,80004eb8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004e96:	fd843503          	ld	a0,-40(s0)
    80004e9a:	00000097          	auipc	ra,0x0
    80004e9e:	e34080e7          	jalr	-460(ra) # 80004cce <fdalloc>
    80004ea2:	84aa                	mv	s1,a0
    return -1;
    80004ea4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004ea6:	00054963          	bltz	a0,80004eb8 <sys_dup+0x42>
  filedup(f);
    80004eaa:	fd843503          	ld	a0,-40(s0)
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	362080e7          	jalr	866(ra) # 80004210 <filedup>
  return fd;
    80004eb6:	87a6                	mv	a5,s1
}
    80004eb8:	853e                	mv	a0,a5
    80004eba:	70a2                	ld	ra,40(sp)
    80004ebc:	7402                	ld	s0,32(sp)
    80004ebe:	64e2                	ld	s1,24(sp)
    80004ec0:	6145                	addi	sp,sp,48
    80004ec2:	8082                	ret

0000000080004ec4 <sys_read>:
{
    80004ec4:	7179                	addi	sp,sp,-48
    80004ec6:	f406                	sd	ra,40(sp)
    80004ec8:	f022                	sd	s0,32(sp)
    80004eca:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ecc:	fe840613          	addi	a2,s0,-24
    80004ed0:	4581                	li	a1,0
    80004ed2:	4501                	li	a0,0
    80004ed4:	00000097          	auipc	ra,0x0
    80004ed8:	d92080e7          	jalr	-622(ra) # 80004c66 <argfd>
    return -1;
    80004edc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ede:	04054163          	bltz	a0,80004f20 <sys_read+0x5c>
    80004ee2:	fe440593          	addi	a1,s0,-28
    80004ee6:	4509                	li	a0,2
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	9a0080e7          	jalr	-1632(ra) # 80002888 <argint>
    return -1;
    80004ef0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ef2:	02054763          	bltz	a0,80004f20 <sys_read+0x5c>
    80004ef6:	fd840593          	addi	a1,s0,-40
    80004efa:	4505                	li	a0,1
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	9ae080e7          	jalr	-1618(ra) # 800028aa <argaddr>
    return -1;
    80004f04:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f06:	00054d63          	bltz	a0,80004f20 <sys_read+0x5c>
  return fileread(f, p, n);
    80004f0a:	fe442603          	lw	a2,-28(s0)
    80004f0e:	fd843583          	ld	a1,-40(s0)
    80004f12:	fe843503          	ld	a0,-24(s0)
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	486080e7          	jalr	1158(ra) # 8000439c <fileread>
    80004f1e:	87aa                	mv	a5,a0
}
    80004f20:	853e                	mv	a0,a5
    80004f22:	70a2                	ld	ra,40(sp)
    80004f24:	7402                	ld	s0,32(sp)
    80004f26:	6145                	addi	sp,sp,48
    80004f28:	8082                	ret

0000000080004f2a <sys_write>:
{
    80004f2a:	7179                	addi	sp,sp,-48
    80004f2c:	f406                	sd	ra,40(sp)
    80004f2e:	f022                	sd	s0,32(sp)
    80004f30:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f32:	fe840613          	addi	a2,s0,-24
    80004f36:	4581                	li	a1,0
    80004f38:	4501                	li	a0,0
    80004f3a:	00000097          	auipc	ra,0x0
    80004f3e:	d2c080e7          	jalr	-724(ra) # 80004c66 <argfd>
    return -1;
    80004f42:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f44:	04054163          	bltz	a0,80004f86 <sys_write+0x5c>
    80004f48:	fe440593          	addi	a1,s0,-28
    80004f4c:	4509                	li	a0,2
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	93a080e7          	jalr	-1734(ra) # 80002888 <argint>
    return -1;
    80004f56:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f58:	02054763          	bltz	a0,80004f86 <sys_write+0x5c>
    80004f5c:	fd840593          	addi	a1,s0,-40
    80004f60:	4505                	li	a0,1
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	948080e7          	jalr	-1720(ra) # 800028aa <argaddr>
    return -1;
    80004f6a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f6c:	00054d63          	bltz	a0,80004f86 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004f70:	fe442603          	lw	a2,-28(s0)
    80004f74:	fd843583          	ld	a1,-40(s0)
    80004f78:	fe843503          	ld	a0,-24(s0)
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	4e2080e7          	jalr	1250(ra) # 8000445e <filewrite>
    80004f84:	87aa                	mv	a5,a0
}
    80004f86:	853e                	mv	a0,a5
    80004f88:	70a2                	ld	ra,40(sp)
    80004f8a:	7402                	ld	s0,32(sp)
    80004f8c:	6145                	addi	sp,sp,48
    80004f8e:	8082                	ret

0000000080004f90 <sys_close>:
{
    80004f90:	1101                	addi	sp,sp,-32
    80004f92:	ec06                	sd	ra,24(sp)
    80004f94:	e822                	sd	s0,16(sp)
    80004f96:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004f98:	fe040613          	addi	a2,s0,-32
    80004f9c:	fec40593          	addi	a1,s0,-20
    80004fa0:	4501                	li	a0,0
    80004fa2:	00000097          	auipc	ra,0x0
    80004fa6:	cc4080e7          	jalr	-828(ra) # 80004c66 <argfd>
    return -1;
    80004faa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004fac:	02054463          	bltz	a0,80004fd4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	894080e7          	jalr	-1900(ra) # 80001844 <myproc>
    80004fb8:	fec42783          	lw	a5,-20(s0)
    80004fbc:	07e9                	addi	a5,a5,26
    80004fbe:	078e                	slli	a5,a5,0x3
    80004fc0:	97aa                	add	a5,a5,a0
    80004fc2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004fc6:	fe043503          	ld	a0,-32(s0)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	298080e7          	jalr	664(ra) # 80004262 <fileclose>
  return 0;
    80004fd2:	4781                	li	a5,0
}
    80004fd4:	853e                	mv	a0,a5
    80004fd6:	60e2                	ld	ra,24(sp)
    80004fd8:	6442                	ld	s0,16(sp)
    80004fda:	6105                	addi	sp,sp,32
    80004fdc:	8082                	ret

0000000080004fde <sys_fstat>:
{
    80004fde:	1101                	addi	sp,sp,-32
    80004fe0:	ec06                	sd	ra,24(sp)
    80004fe2:	e822                	sd	s0,16(sp)
    80004fe4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004fe6:	fe840613          	addi	a2,s0,-24
    80004fea:	4581                	li	a1,0
    80004fec:	4501                	li	a0,0
    80004fee:	00000097          	auipc	ra,0x0
    80004ff2:	c78080e7          	jalr	-904(ra) # 80004c66 <argfd>
    return -1;
    80004ff6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004ff8:	02054563          	bltz	a0,80005022 <sys_fstat+0x44>
    80004ffc:	fe040593          	addi	a1,s0,-32
    80005000:	4505                	li	a0,1
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	8a8080e7          	jalr	-1880(ra) # 800028aa <argaddr>
    return -1;
    8000500a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000500c:	00054b63          	bltz	a0,80005022 <sys_fstat+0x44>
  return filestat(f, st);
    80005010:	fe043583          	ld	a1,-32(s0)
    80005014:	fe843503          	ld	a0,-24(s0)
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	312080e7          	jalr	786(ra) # 8000432a <filestat>
    80005020:	87aa                	mv	a5,a0
}
    80005022:	853e                	mv	a0,a5
    80005024:	60e2                	ld	ra,24(sp)
    80005026:	6442                	ld	s0,16(sp)
    80005028:	6105                	addi	sp,sp,32
    8000502a:	8082                	ret

000000008000502c <sys_link>:
{
    8000502c:	7169                	addi	sp,sp,-304
    8000502e:	f606                	sd	ra,296(sp)
    80005030:	f222                	sd	s0,288(sp)
    80005032:	ee26                	sd	s1,280(sp)
    80005034:	ea4a                	sd	s2,272(sp)
    80005036:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005038:	08000613          	li	a2,128
    8000503c:	ed040593          	addi	a1,s0,-304
    80005040:	4501                	li	a0,0
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	88a080e7          	jalr	-1910(ra) # 800028cc <argstr>
    return -1;
    8000504a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000504c:	10054e63          	bltz	a0,80005168 <sys_link+0x13c>
    80005050:	08000613          	li	a2,128
    80005054:	f5040593          	addi	a1,s0,-176
    80005058:	4505                	li	a0,1
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	872080e7          	jalr	-1934(ra) # 800028cc <argstr>
    return -1;
    80005062:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005064:	10054263          	bltz	a0,80005168 <sys_link+0x13c>
  begin_op();
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	d28080e7          	jalr	-728(ra) # 80003d90 <begin_op>
  if((ip = namei(old)) == 0){
    80005070:	ed040513          	addi	a0,s0,-304
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	b10080e7          	jalr	-1264(ra) # 80003b84 <namei>
    8000507c:	84aa                	mv	s1,a0
    8000507e:	c551                	beqz	a0,8000510a <sys_link+0xde>
  ilock(ip);
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	37a080e7          	jalr	890(ra) # 800033fa <ilock>
  if(ip->type == T_DIR){
    80005088:	04449703          	lh	a4,68(s1)
    8000508c:	4785                	li	a5,1
    8000508e:	08f70463          	beq	a4,a5,80005116 <sys_link+0xea>
  ip->nlink++;
    80005092:	04a4d783          	lhu	a5,74(s1)
    80005096:	2785                	addiw	a5,a5,1
    80005098:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	292080e7          	jalr	658(ra) # 80003330 <iupdate>
  iunlock(ip);
    800050a6:	8526                	mv	a0,s1
    800050a8:	ffffe097          	auipc	ra,0xffffe
    800050ac:	414080e7          	jalr	1044(ra) # 800034bc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800050b0:	fd040593          	addi	a1,s0,-48
    800050b4:	f5040513          	addi	a0,s0,-176
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	aea080e7          	jalr	-1302(ra) # 80003ba2 <nameiparent>
    800050c0:	892a                	mv	s2,a0
    800050c2:	c935                	beqz	a0,80005136 <sys_link+0x10a>
  ilock(dp);
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	336080e7          	jalr	822(ra) # 800033fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800050cc:	00092703          	lw	a4,0(s2)
    800050d0:	409c                	lw	a5,0(s1)
    800050d2:	04f71d63          	bne	a4,a5,8000512c <sys_link+0x100>
    800050d6:	40d0                	lw	a2,4(s1)
    800050d8:	fd040593          	addi	a1,s0,-48
    800050dc:	854a                	mv	a0,s2
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	9e4080e7          	jalr	-1564(ra) # 80003ac2 <dirlink>
    800050e6:	04054363          	bltz	a0,8000512c <sys_link+0x100>
  iunlockput(dp);
    800050ea:	854a                	mv	a0,s2
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	54c080e7          	jalr	1356(ra) # 80003638 <iunlockput>
  iput(ip);
    800050f4:	8526                	mv	a0,s1
    800050f6:	ffffe097          	auipc	ra,0xffffe
    800050fa:	412080e7          	jalr	1042(ra) # 80003508 <iput>
  end_op();
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	d12080e7          	jalr	-750(ra) # 80003e10 <end_op>
  return 0;
    80005106:	4781                	li	a5,0
    80005108:	a085                	j	80005168 <sys_link+0x13c>
    end_op();
    8000510a:	fffff097          	auipc	ra,0xfffff
    8000510e:	d06080e7          	jalr	-762(ra) # 80003e10 <end_op>
    return -1;
    80005112:	57fd                	li	a5,-1
    80005114:	a891                	j	80005168 <sys_link+0x13c>
    iunlockput(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	520080e7          	jalr	1312(ra) # 80003638 <iunlockput>
    end_op();
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	cf0080e7          	jalr	-784(ra) # 80003e10 <end_op>
    return -1;
    80005128:	57fd                	li	a5,-1
    8000512a:	a83d                	j	80005168 <sys_link+0x13c>
    iunlockput(dp);
    8000512c:	854a                	mv	a0,s2
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	50a080e7          	jalr	1290(ra) # 80003638 <iunlockput>
  ilock(ip);
    80005136:	8526                	mv	a0,s1
    80005138:	ffffe097          	auipc	ra,0xffffe
    8000513c:	2c2080e7          	jalr	706(ra) # 800033fa <ilock>
  ip->nlink--;
    80005140:	04a4d783          	lhu	a5,74(s1)
    80005144:	37fd                	addiw	a5,a5,-1
    80005146:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000514a:	8526                	mv	a0,s1
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	1e4080e7          	jalr	484(ra) # 80003330 <iupdate>
  iunlockput(ip);
    80005154:	8526                	mv	a0,s1
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	4e2080e7          	jalr	1250(ra) # 80003638 <iunlockput>
  end_op();
    8000515e:	fffff097          	auipc	ra,0xfffff
    80005162:	cb2080e7          	jalr	-846(ra) # 80003e10 <end_op>
  return -1;
    80005166:	57fd                	li	a5,-1
}
    80005168:	853e                	mv	a0,a5
    8000516a:	70b2                	ld	ra,296(sp)
    8000516c:	7412                	ld	s0,288(sp)
    8000516e:	64f2                	ld	s1,280(sp)
    80005170:	6952                	ld	s2,272(sp)
    80005172:	6155                	addi	sp,sp,304
    80005174:	8082                	ret

0000000080005176 <sys_unlink>:
{
    80005176:	7151                	addi	sp,sp,-240
    80005178:	f586                	sd	ra,232(sp)
    8000517a:	f1a2                	sd	s0,224(sp)
    8000517c:	eda6                	sd	s1,216(sp)
    8000517e:	e9ca                	sd	s2,208(sp)
    80005180:	e5ce                	sd	s3,200(sp)
    80005182:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005184:	08000613          	li	a2,128
    80005188:	f3040593          	addi	a1,s0,-208
    8000518c:	4501                	li	a0,0
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	73e080e7          	jalr	1854(ra) # 800028cc <argstr>
    80005196:	18054163          	bltz	a0,80005318 <sys_unlink+0x1a2>
  begin_op();
    8000519a:	fffff097          	auipc	ra,0xfffff
    8000519e:	bf6080e7          	jalr	-1034(ra) # 80003d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800051a2:	fb040593          	addi	a1,s0,-80
    800051a6:	f3040513          	addi	a0,s0,-208
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	9f8080e7          	jalr	-1544(ra) # 80003ba2 <nameiparent>
    800051b2:	84aa                	mv	s1,a0
    800051b4:	c979                	beqz	a0,8000528a <sys_unlink+0x114>
  ilock(dp);
    800051b6:	ffffe097          	auipc	ra,0xffffe
    800051ba:	244080e7          	jalr	580(ra) # 800033fa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800051be:	00001597          	auipc	a1,0x1
    800051c2:	51a58593          	addi	a1,a1,1306 # 800066d8 <userret+0x648>
    800051c6:	fb040513          	addi	a0,s0,-80
    800051ca:	ffffe097          	auipc	ra,0xffffe
    800051ce:	6ce080e7          	jalr	1742(ra) # 80003898 <namecmp>
    800051d2:	14050a63          	beqz	a0,80005326 <sys_unlink+0x1b0>
    800051d6:	00001597          	auipc	a1,0x1
    800051da:	50a58593          	addi	a1,a1,1290 # 800066e0 <userret+0x650>
    800051de:	fb040513          	addi	a0,s0,-80
    800051e2:	ffffe097          	auipc	ra,0xffffe
    800051e6:	6b6080e7          	jalr	1718(ra) # 80003898 <namecmp>
    800051ea:	12050e63          	beqz	a0,80005326 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800051ee:	f2c40613          	addi	a2,s0,-212
    800051f2:	fb040593          	addi	a1,s0,-80
    800051f6:	8526                	mv	a0,s1
    800051f8:	ffffe097          	auipc	ra,0xffffe
    800051fc:	6ba080e7          	jalr	1722(ra) # 800038b2 <dirlookup>
    80005200:	892a                	mv	s2,a0
    80005202:	12050263          	beqz	a0,80005326 <sys_unlink+0x1b0>
  ilock(ip);
    80005206:	ffffe097          	auipc	ra,0xffffe
    8000520a:	1f4080e7          	jalr	500(ra) # 800033fa <ilock>
  if(ip->nlink < 1)
    8000520e:	04a91783          	lh	a5,74(s2)
    80005212:	08f05263          	blez	a5,80005296 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005216:	04491703          	lh	a4,68(s2)
    8000521a:	4785                	li	a5,1
    8000521c:	08f70563          	beq	a4,a5,800052a6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005220:	4641                	li	a2,16
    80005222:	4581                	li	a1,0
    80005224:	fc040513          	addi	a0,s0,-64
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	946080e7          	jalr	-1722(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005230:	4741                	li	a4,16
    80005232:	f2c42683          	lw	a3,-212(s0)
    80005236:	fc040613          	addi	a2,s0,-64
    8000523a:	4581                	li	a1,0
    8000523c:	8526                	mv	a0,s1
    8000523e:	ffffe097          	auipc	ra,0xffffe
    80005242:	540080e7          	jalr	1344(ra) # 8000377e <writei>
    80005246:	47c1                	li	a5,16
    80005248:	0af51563          	bne	a0,a5,800052f2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000524c:	04491703          	lh	a4,68(s2)
    80005250:	4785                	li	a5,1
    80005252:	0af70863          	beq	a4,a5,80005302 <sys_unlink+0x18c>
  iunlockput(dp);
    80005256:	8526                	mv	a0,s1
    80005258:	ffffe097          	auipc	ra,0xffffe
    8000525c:	3e0080e7          	jalr	992(ra) # 80003638 <iunlockput>
  ip->nlink--;
    80005260:	04a95783          	lhu	a5,74(s2)
    80005264:	37fd                	addiw	a5,a5,-1
    80005266:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000526a:	854a                	mv	a0,s2
    8000526c:	ffffe097          	auipc	ra,0xffffe
    80005270:	0c4080e7          	jalr	196(ra) # 80003330 <iupdate>
  iunlockput(ip);
    80005274:	854a                	mv	a0,s2
    80005276:	ffffe097          	auipc	ra,0xffffe
    8000527a:	3c2080e7          	jalr	962(ra) # 80003638 <iunlockput>
  end_op();
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	b92080e7          	jalr	-1134(ra) # 80003e10 <end_op>
  return 0;
    80005286:	4501                	li	a0,0
    80005288:	a84d                	j	8000533a <sys_unlink+0x1c4>
    end_op();
    8000528a:	fffff097          	auipc	ra,0xfffff
    8000528e:	b86080e7          	jalr	-1146(ra) # 80003e10 <end_op>
    return -1;
    80005292:	557d                	li	a0,-1
    80005294:	a05d                	j	8000533a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005296:	00001517          	auipc	a0,0x1
    8000529a:	47250513          	addi	a0,a0,1138 # 80006708 <userret+0x678>
    8000529e:	ffffb097          	auipc	ra,0xffffb
    800052a2:	2b0080e7          	jalr	688(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800052a6:	04c92703          	lw	a4,76(s2)
    800052aa:	02000793          	li	a5,32
    800052ae:	f6e7f9e3          	bgeu	a5,a4,80005220 <sys_unlink+0xaa>
    800052b2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052b6:	4741                	li	a4,16
    800052b8:	86ce                	mv	a3,s3
    800052ba:	f1840613          	addi	a2,s0,-232
    800052be:	4581                	li	a1,0
    800052c0:	854a                	mv	a0,s2
    800052c2:	ffffe097          	auipc	ra,0xffffe
    800052c6:	3c8080e7          	jalr	968(ra) # 8000368a <readi>
    800052ca:	47c1                	li	a5,16
    800052cc:	00f51b63          	bne	a0,a5,800052e2 <sys_unlink+0x16c>
    if(de.inum != 0)
    800052d0:	f1845783          	lhu	a5,-232(s0)
    800052d4:	e7a1                	bnez	a5,8000531c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800052d6:	29c1                	addiw	s3,s3,16
    800052d8:	04c92783          	lw	a5,76(s2)
    800052dc:	fcf9ede3          	bltu	s3,a5,800052b6 <sys_unlink+0x140>
    800052e0:	b781                	j	80005220 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800052e2:	00001517          	auipc	a0,0x1
    800052e6:	43e50513          	addi	a0,a0,1086 # 80006720 <userret+0x690>
    800052ea:	ffffb097          	auipc	ra,0xffffb
    800052ee:	264080e7          	jalr	612(ra) # 8000054e <panic>
    panic("unlink: writei");
    800052f2:	00001517          	auipc	a0,0x1
    800052f6:	44650513          	addi	a0,a0,1094 # 80006738 <userret+0x6a8>
    800052fa:	ffffb097          	auipc	ra,0xffffb
    800052fe:	254080e7          	jalr	596(ra) # 8000054e <panic>
    dp->nlink--;
    80005302:	04a4d783          	lhu	a5,74(s1)
    80005306:	37fd                	addiw	a5,a5,-1
    80005308:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000530c:	8526                	mv	a0,s1
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	022080e7          	jalr	34(ra) # 80003330 <iupdate>
    80005316:	b781                	j	80005256 <sys_unlink+0xe0>
    return -1;
    80005318:	557d                	li	a0,-1
    8000531a:	a005                	j	8000533a <sys_unlink+0x1c4>
    iunlockput(ip);
    8000531c:	854a                	mv	a0,s2
    8000531e:	ffffe097          	auipc	ra,0xffffe
    80005322:	31a080e7          	jalr	794(ra) # 80003638 <iunlockput>
  iunlockput(dp);
    80005326:	8526                	mv	a0,s1
    80005328:	ffffe097          	auipc	ra,0xffffe
    8000532c:	310080e7          	jalr	784(ra) # 80003638 <iunlockput>
  end_op();
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	ae0080e7          	jalr	-1312(ra) # 80003e10 <end_op>
  return -1;
    80005338:	557d                	li	a0,-1
}
    8000533a:	70ae                	ld	ra,232(sp)
    8000533c:	740e                	ld	s0,224(sp)
    8000533e:	64ee                	ld	s1,216(sp)
    80005340:	694e                	ld	s2,208(sp)
    80005342:	69ae                	ld	s3,200(sp)
    80005344:	616d                	addi	sp,sp,240
    80005346:	8082                	ret

0000000080005348 <sys_open>:

uint64
sys_open(void)
{
    80005348:	7131                	addi	sp,sp,-192
    8000534a:	fd06                	sd	ra,184(sp)
    8000534c:	f922                	sd	s0,176(sp)
    8000534e:	f526                	sd	s1,168(sp)
    80005350:	f14a                	sd	s2,160(sp)
    80005352:	ed4e                	sd	s3,152(sp)
    80005354:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005356:	08000613          	li	a2,128
    8000535a:	f5040593          	addi	a1,s0,-176
    8000535e:	4501                	li	a0,0
    80005360:	ffffd097          	auipc	ra,0xffffd
    80005364:	56c080e7          	jalr	1388(ra) # 800028cc <argstr>
    return -1;
    80005368:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000536a:	0a054763          	bltz	a0,80005418 <sys_open+0xd0>
    8000536e:	f4c40593          	addi	a1,s0,-180
    80005372:	4505                	li	a0,1
    80005374:	ffffd097          	auipc	ra,0xffffd
    80005378:	514080e7          	jalr	1300(ra) # 80002888 <argint>
    8000537c:	08054e63          	bltz	a0,80005418 <sys_open+0xd0>

  begin_op();
    80005380:	fffff097          	auipc	ra,0xfffff
    80005384:	a10080e7          	jalr	-1520(ra) # 80003d90 <begin_op>

  if(omode & O_CREATE){
    80005388:	f4c42783          	lw	a5,-180(s0)
    8000538c:	2007f793          	andi	a5,a5,512
    80005390:	c3cd                	beqz	a5,80005432 <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    80005392:	4681                	li	a3,0
    80005394:	4601                	li	a2,0
    80005396:	4589                	li	a1,2
    80005398:	f5040513          	addi	a0,s0,-176
    8000539c:	00000097          	auipc	ra,0x0
    800053a0:	974080e7          	jalr	-1676(ra) # 80004d10 <create>
    800053a4:	892a                	mv	s2,a0
    if(ip == 0){
    800053a6:	c149                	beqz	a0,80005428 <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800053a8:	04491703          	lh	a4,68(s2)
    800053ac:	478d                	li	a5,3
    800053ae:	00f71763          	bne	a4,a5,800053bc <sys_open+0x74>
    800053b2:	04695703          	lhu	a4,70(s2)
    800053b6:	47a5                	li	a5,9
    800053b8:	0ce7e263          	bltu	a5,a4,8000547c <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800053bc:	fffff097          	auipc	ra,0xfffff
    800053c0:	dea080e7          	jalr	-534(ra) # 800041a6 <filealloc>
    800053c4:	89aa                	mv	s3,a0
    800053c6:	c175                	beqz	a0,800054aa <sys_open+0x162>
    800053c8:	00000097          	auipc	ra,0x0
    800053cc:	906080e7          	jalr	-1786(ra) # 80004cce <fdalloc>
    800053d0:	84aa                	mv	s1,a0
    800053d2:	0c054763          	bltz	a0,800054a0 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800053d6:	04491703          	lh	a4,68(s2)
    800053da:	478d                	li	a5,3
    800053dc:	0af70b63          	beq	a4,a5,80005492 <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800053e0:	4789                	li	a5,2
    800053e2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800053e6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800053ea:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800053ee:	f4c42783          	lw	a5,-180(s0)
    800053f2:	0017c713          	xori	a4,a5,1
    800053f6:	8b05                	andi	a4,a4,1
    800053f8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800053fc:	8b8d                	andi	a5,a5,3
    800053fe:	00f037b3          	snez	a5,a5
    80005402:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    80005406:	854a                	mv	a0,s2
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	0b4080e7          	jalr	180(ra) # 800034bc <iunlock>
  end_op();
    80005410:	fffff097          	auipc	ra,0xfffff
    80005414:	a00080e7          	jalr	-1536(ra) # 80003e10 <end_op>

  return fd;
}
    80005418:	8526                	mv	a0,s1
    8000541a:	70ea                	ld	ra,184(sp)
    8000541c:	744a                	ld	s0,176(sp)
    8000541e:	74aa                	ld	s1,168(sp)
    80005420:	790a                	ld	s2,160(sp)
    80005422:	69ea                	ld	s3,152(sp)
    80005424:	6129                	addi	sp,sp,192
    80005426:	8082                	ret
      end_op();
    80005428:	fffff097          	auipc	ra,0xfffff
    8000542c:	9e8080e7          	jalr	-1560(ra) # 80003e10 <end_op>
      return -1;
    80005430:	b7e5                	j	80005418 <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    80005432:	f5040513          	addi	a0,s0,-176
    80005436:	ffffe097          	auipc	ra,0xffffe
    8000543a:	74e080e7          	jalr	1870(ra) # 80003b84 <namei>
    8000543e:	892a                	mv	s2,a0
    80005440:	c905                	beqz	a0,80005470 <sys_open+0x128>
    ilock(ip);
    80005442:	ffffe097          	auipc	ra,0xffffe
    80005446:	fb8080e7          	jalr	-72(ra) # 800033fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000544a:	04491703          	lh	a4,68(s2)
    8000544e:	4785                	li	a5,1
    80005450:	f4f71ce3          	bne	a4,a5,800053a8 <sys_open+0x60>
    80005454:	f4c42783          	lw	a5,-180(s0)
    80005458:	d3b5                	beqz	a5,800053bc <sys_open+0x74>
      iunlockput(ip);
    8000545a:	854a                	mv	a0,s2
    8000545c:	ffffe097          	auipc	ra,0xffffe
    80005460:	1dc080e7          	jalr	476(ra) # 80003638 <iunlockput>
      end_op();
    80005464:	fffff097          	auipc	ra,0xfffff
    80005468:	9ac080e7          	jalr	-1620(ra) # 80003e10 <end_op>
      return -1;
    8000546c:	54fd                	li	s1,-1
    8000546e:	b76d                	j	80005418 <sys_open+0xd0>
      end_op();
    80005470:	fffff097          	auipc	ra,0xfffff
    80005474:	9a0080e7          	jalr	-1632(ra) # 80003e10 <end_op>
      return -1;
    80005478:	54fd                	li	s1,-1
    8000547a:	bf79                	j	80005418 <sys_open+0xd0>
    iunlockput(ip);
    8000547c:	854a                	mv	a0,s2
    8000547e:	ffffe097          	auipc	ra,0xffffe
    80005482:	1ba080e7          	jalr	442(ra) # 80003638 <iunlockput>
    end_op();
    80005486:	fffff097          	auipc	ra,0xfffff
    8000548a:	98a080e7          	jalr	-1654(ra) # 80003e10 <end_op>
    return -1;
    8000548e:	54fd                	li	s1,-1
    80005490:	b761                	j	80005418 <sys_open+0xd0>
    f->type = FD_DEVICE;
    80005492:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005496:	04691783          	lh	a5,70(s2)
    8000549a:	02f99223          	sh	a5,36(s3)
    8000549e:	b7b1                	j	800053ea <sys_open+0xa2>
      fileclose(f);
    800054a0:	854e                	mv	a0,s3
    800054a2:	fffff097          	auipc	ra,0xfffff
    800054a6:	dc0080e7          	jalr	-576(ra) # 80004262 <fileclose>
    iunlockput(ip);
    800054aa:	854a                	mv	a0,s2
    800054ac:	ffffe097          	auipc	ra,0xffffe
    800054b0:	18c080e7          	jalr	396(ra) # 80003638 <iunlockput>
    end_op();
    800054b4:	fffff097          	auipc	ra,0xfffff
    800054b8:	95c080e7          	jalr	-1700(ra) # 80003e10 <end_op>
    return -1;
    800054bc:	54fd                	li	s1,-1
    800054be:	bfa9                	j	80005418 <sys_open+0xd0>

00000000800054c0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800054c0:	7175                	addi	sp,sp,-144
    800054c2:	e506                	sd	ra,136(sp)
    800054c4:	e122                	sd	s0,128(sp)
    800054c6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800054c8:	fffff097          	auipc	ra,0xfffff
    800054cc:	8c8080e7          	jalr	-1848(ra) # 80003d90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800054d0:	08000613          	li	a2,128
    800054d4:	f7040593          	addi	a1,s0,-144
    800054d8:	4501                	li	a0,0
    800054da:	ffffd097          	auipc	ra,0xffffd
    800054de:	3f2080e7          	jalr	1010(ra) # 800028cc <argstr>
    800054e2:	02054963          	bltz	a0,80005514 <sys_mkdir+0x54>
    800054e6:	4681                	li	a3,0
    800054e8:	4601                	li	a2,0
    800054ea:	4585                	li	a1,1
    800054ec:	f7040513          	addi	a0,s0,-144
    800054f0:	00000097          	auipc	ra,0x0
    800054f4:	820080e7          	jalr	-2016(ra) # 80004d10 <create>
    800054f8:	cd11                	beqz	a0,80005514 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	13e080e7          	jalr	318(ra) # 80003638 <iunlockput>
  end_op();
    80005502:	fffff097          	auipc	ra,0xfffff
    80005506:	90e080e7          	jalr	-1778(ra) # 80003e10 <end_op>
  return 0;
    8000550a:	4501                	li	a0,0
}
    8000550c:	60aa                	ld	ra,136(sp)
    8000550e:	640a                	ld	s0,128(sp)
    80005510:	6149                	addi	sp,sp,144
    80005512:	8082                	ret
    end_op();
    80005514:	fffff097          	auipc	ra,0xfffff
    80005518:	8fc080e7          	jalr	-1796(ra) # 80003e10 <end_op>
    return -1;
    8000551c:	557d                	li	a0,-1
    8000551e:	b7fd                	j	8000550c <sys_mkdir+0x4c>

0000000080005520 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005520:	7135                	addi	sp,sp,-160
    80005522:	ed06                	sd	ra,152(sp)
    80005524:	e922                	sd	s0,144(sp)
    80005526:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005528:	fffff097          	auipc	ra,0xfffff
    8000552c:	868080e7          	jalr	-1944(ra) # 80003d90 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005530:	08000613          	li	a2,128
    80005534:	f7040593          	addi	a1,s0,-144
    80005538:	4501                	li	a0,0
    8000553a:	ffffd097          	auipc	ra,0xffffd
    8000553e:	392080e7          	jalr	914(ra) # 800028cc <argstr>
    80005542:	04054a63          	bltz	a0,80005596 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005546:	f6c40593          	addi	a1,s0,-148
    8000554a:	4505                	li	a0,1
    8000554c:	ffffd097          	auipc	ra,0xffffd
    80005550:	33c080e7          	jalr	828(ra) # 80002888 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005554:	04054163          	bltz	a0,80005596 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005558:	f6840593          	addi	a1,s0,-152
    8000555c:	4509                	li	a0,2
    8000555e:	ffffd097          	auipc	ra,0xffffd
    80005562:	32a080e7          	jalr	810(ra) # 80002888 <argint>
     argint(1, &major) < 0 ||
    80005566:	02054863          	bltz	a0,80005596 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000556a:	f6841683          	lh	a3,-152(s0)
    8000556e:	f6c41603          	lh	a2,-148(s0)
    80005572:	458d                	li	a1,3
    80005574:	f7040513          	addi	a0,s0,-144
    80005578:	fffff097          	auipc	ra,0xfffff
    8000557c:	798080e7          	jalr	1944(ra) # 80004d10 <create>
     argint(2, &minor) < 0 ||
    80005580:	c919                	beqz	a0,80005596 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	0b6080e7          	jalr	182(ra) # 80003638 <iunlockput>
  end_op();
    8000558a:	fffff097          	auipc	ra,0xfffff
    8000558e:	886080e7          	jalr	-1914(ra) # 80003e10 <end_op>
  return 0;
    80005592:	4501                	li	a0,0
    80005594:	a031                	j	800055a0 <sys_mknod+0x80>
    end_op();
    80005596:	fffff097          	auipc	ra,0xfffff
    8000559a:	87a080e7          	jalr	-1926(ra) # 80003e10 <end_op>
    return -1;
    8000559e:	557d                	li	a0,-1
}
    800055a0:	60ea                	ld	ra,152(sp)
    800055a2:	644a                	ld	s0,144(sp)
    800055a4:	610d                	addi	sp,sp,160
    800055a6:	8082                	ret

00000000800055a8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800055a8:	7135                	addi	sp,sp,-160
    800055aa:	ed06                	sd	ra,152(sp)
    800055ac:	e922                	sd	s0,144(sp)
    800055ae:	e526                	sd	s1,136(sp)
    800055b0:	e14a                	sd	s2,128(sp)
    800055b2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800055b4:	ffffc097          	auipc	ra,0xffffc
    800055b8:	290080e7          	jalr	656(ra) # 80001844 <myproc>
    800055bc:	892a                	mv	s2,a0
  
  begin_op();
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	7d2080e7          	jalr	2002(ra) # 80003d90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800055c6:	08000613          	li	a2,128
    800055ca:	f6040593          	addi	a1,s0,-160
    800055ce:	4501                	li	a0,0
    800055d0:	ffffd097          	auipc	ra,0xffffd
    800055d4:	2fc080e7          	jalr	764(ra) # 800028cc <argstr>
    800055d8:	04054b63          	bltz	a0,8000562e <sys_chdir+0x86>
    800055dc:	f6040513          	addi	a0,s0,-160
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	5a4080e7          	jalr	1444(ra) # 80003b84 <namei>
    800055e8:	84aa                	mv	s1,a0
    800055ea:	c131                	beqz	a0,8000562e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800055ec:	ffffe097          	auipc	ra,0xffffe
    800055f0:	e0e080e7          	jalr	-498(ra) # 800033fa <ilock>
  if(ip->type != T_DIR){
    800055f4:	04449703          	lh	a4,68(s1)
    800055f8:	4785                	li	a5,1
    800055fa:	04f71063          	bne	a4,a5,8000563a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800055fe:	8526                	mv	a0,s1
    80005600:	ffffe097          	auipc	ra,0xffffe
    80005604:	ebc080e7          	jalr	-324(ra) # 800034bc <iunlock>
  iput(p->cwd);
    80005608:	15093503          	ld	a0,336(s2)
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	efc080e7          	jalr	-260(ra) # 80003508 <iput>
  end_op();
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	7fc080e7          	jalr	2044(ra) # 80003e10 <end_op>
  p->cwd = ip;
    8000561c:	14993823          	sd	s1,336(s2)
  return 0;
    80005620:	4501                	li	a0,0
}
    80005622:	60ea                	ld	ra,152(sp)
    80005624:	644a                	ld	s0,144(sp)
    80005626:	64aa                	ld	s1,136(sp)
    80005628:	690a                	ld	s2,128(sp)
    8000562a:	610d                	addi	sp,sp,160
    8000562c:	8082                	ret
    end_op();
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	7e2080e7          	jalr	2018(ra) # 80003e10 <end_op>
    return -1;
    80005636:	557d                	li	a0,-1
    80005638:	b7ed                	j	80005622 <sys_chdir+0x7a>
    iunlockput(ip);
    8000563a:	8526                	mv	a0,s1
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	ffc080e7          	jalr	-4(ra) # 80003638 <iunlockput>
    end_op();
    80005644:	ffffe097          	auipc	ra,0xffffe
    80005648:	7cc080e7          	jalr	1996(ra) # 80003e10 <end_op>
    return -1;
    8000564c:	557d                	li	a0,-1
    8000564e:	bfd1                	j	80005622 <sys_chdir+0x7a>

0000000080005650 <sys_exec>:

uint64
sys_exec(void)
{
    80005650:	7145                	addi	sp,sp,-464
    80005652:	e786                	sd	ra,456(sp)
    80005654:	e3a2                	sd	s0,448(sp)
    80005656:	ff26                	sd	s1,440(sp)
    80005658:	fb4a                	sd	s2,432(sp)
    8000565a:	f74e                	sd	s3,424(sp)
    8000565c:	f352                	sd	s4,416(sp)
    8000565e:	ef56                	sd	s5,408(sp)
    80005660:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005662:	08000613          	li	a2,128
    80005666:	f4040593          	addi	a1,s0,-192
    8000566a:	4501                	li	a0,0
    8000566c:	ffffd097          	auipc	ra,0xffffd
    80005670:	260080e7          	jalr	608(ra) # 800028cc <argstr>
    80005674:	0e054663          	bltz	a0,80005760 <sys_exec+0x110>
    80005678:	e3840593          	addi	a1,s0,-456
    8000567c:	4505                	li	a0,1
    8000567e:	ffffd097          	auipc	ra,0xffffd
    80005682:	22c080e7          	jalr	556(ra) # 800028aa <argaddr>
    80005686:	0e054763          	bltz	a0,80005774 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    8000568a:	10000613          	li	a2,256
    8000568e:	4581                	li	a1,0
    80005690:	e4040513          	addi	a0,s0,-448
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	4da080e7          	jalr	1242(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000569c:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    800056a0:	89ca                	mv	s3,s2
    800056a2:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    800056a4:	02000a13          	li	s4,32
    800056a8:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800056ac:	00349513          	slli	a0,s1,0x3
    800056b0:	e3040593          	addi	a1,s0,-464
    800056b4:	e3843783          	ld	a5,-456(s0)
    800056b8:	953e                	add	a0,a0,a5
    800056ba:	ffffd097          	auipc	ra,0xffffd
    800056be:	134080e7          	jalr	308(ra) # 800027ee <fetchaddr>
    800056c2:	02054a63          	bltz	a0,800056f6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800056c6:	e3043783          	ld	a5,-464(s0)
    800056ca:	c7a1                	beqz	a5,80005712 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800056cc:	ffffb097          	auipc	ra,0xffffb
    800056d0:	294080e7          	jalr	660(ra) # 80000960 <kalloc>
    800056d4:	85aa                	mv	a1,a0
    800056d6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800056da:	c92d                	beqz	a0,8000574c <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    800056dc:	6605                	lui	a2,0x1
    800056de:	e3043503          	ld	a0,-464(s0)
    800056e2:	ffffd097          	auipc	ra,0xffffd
    800056e6:	15e080e7          	jalr	350(ra) # 80002840 <fetchstr>
    800056ea:	00054663          	bltz	a0,800056f6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800056ee:	0485                	addi	s1,s1,1
    800056f0:	09a1                	addi	s3,s3,8
    800056f2:	fb449be3          	bne	s1,s4,800056a8 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056f6:	10090493          	addi	s1,s2,256
    800056fa:	00093503          	ld	a0,0(s2)
    800056fe:	cd39                	beqz	a0,8000575c <sys_exec+0x10c>
    kfree(argv[i]);
    80005700:	ffffb097          	auipc	ra,0xffffb
    80005704:	164080e7          	jalr	356(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005708:	0921                	addi	s2,s2,8
    8000570a:	fe9918e3          	bne	s2,s1,800056fa <sys_exec+0xaa>
  return -1;
    8000570e:	557d                	li	a0,-1
    80005710:	a889                	j	80005762 <sys_exec+0x112>
      argv[i] = 0;
    80005712:	0a8e                	slli	s5,s5,0x3
    80005714:	fc040793          	addi	a5,s0,-64
    80005718:	9abe                	add	s5,s5,a5
    8000571a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd9e64>
  int ret = exec(path, argv);
    8000571e:	e4040593          	addi	a1,s0,-448
    80005722:	f4040513          	addi	a0,s0,-192
    80005726:	fffff097          	auipc	ra,0xfffff
    8000572a:	1de080e7          	jalr	478(ra) # 80004904 <exec>
    8000572e:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005730:	10090993          	addi	s3,s2,256
    80005734:	00093503          	ld	a0,0(s2)
    80005738:	c901                	beqz	a0,80005748 <sys_exec+0xf8>
    kfree(argv[i]);
    8000573a:	ffffb097          	auipc	ra,0xffffb
    8000573e:	12a080e7          	jalr	298(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005742:	0921                	addi	s2,s2,8
    80005744:	ff3918e3          	bne	s2,s3,80005734 <sys_exec+0xe4>
  return ret;
    80005748:	8526                	mv	a0,s1
    8000574a:	a821                	j	80005762 <sys_exec+0x112>
      panic("sys_exec kalloc");
    8000574c:	00001517          	auipc	a0,0x1
    80005750:	ffc50513          	addi	a0,a0,-4 # 80006748 <userret+0x6b8>
    80005754:	ffffb097          	auipc	ra,0xffffb
    80005758:	dfa080e7          	jalr	-518(ra) # 8000054e <panic>
  return -1;
    8000575c:	557d                	li	a0,-1
    8000575e:	a011                	j	80005762 <sys_exec+0x112>
    return -1;
    80005760:	557d                	li	a0,-1
}
    80005762:	60be                	ld	ra,456(sp)
    80005764:	641e                	ld	s0,448(sp)
    80005766:	74fa                	ld	s1,440(sp)
    80005768:	795a                	ld	s2,432(sp)
    8000576a:	79ba                	ld	s3,424(sp)
    8000576c:	7a1a                	ld	s4,416(sp)
    8000576e:	6afa                	ld	s5,408(sp)
    80005770:	6179                	addi	sp,sp,464
    80005772:	8082                	ret
    return -1;
    80005774:	557d                	li	a0,-1
    80005776:	b7f5                	j	80005762 <sys_exec+0x112>

0000000080005778 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005778:	7139                	addi	sp,sp,-64
    8000577a:	fc06                	sd	ra,56(sp)
    8000577c:	f822                	sd	s0,48(sp)
    8000577e:	f426                	sd	s1,40(sp)
    80005780:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005782:	ffffc097          	auipc	ra,0xffffc
    80005786:	0c2080e7          	jalr	194(ra) # 80001844 <myproc>
    8000578a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000578c:	fd840593          	addi	a1,s0,-40
    80005790:	4501                	li	a0,0
    80005792:	ffffd097          	auipc	ra,0xffffd
    80005796:	118080e7          	jalr	280(ra) # 800028aa <argaddr>
    return -1;
    8000579a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000579c:	0e054063          	bltz	a0,8000587c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800057a0:	fc840593          	addi	a1,s0,-56
    800057a4:	fd040513          	addi	a0,s0,-48
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	e10080e7          	jalr	-496(ra) # 800045b8 <pipealloc>
    return -1;
    800057b0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800057b2:	0c054563          	bltz	a0,8000587c <sys_pipe+0x104>
  fd0 = -1;
    800057b6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800057ba:	fd043503          	ld	a0,-48(s0)
    800057be:	fffff097          	auipc	ra,0xfffff
    800057c2:	510080e7          	jalr	1296(ra) # 80004cce <fdalloc>
    800057c6:	fca42223          	sw	a0,-60(s0)
    800057ca:	08054c63          	bltz	a0,80005862 <sys_pipe+0xea>
    800057ce:	fc843503          	ld	a0,-56(s0)
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	4fc080e7          	jalr	1276(ra) # 80004cce <fdalloc>
    800057da:	fca42023          	sw	a0,-64(s0)
    800057de:	06054863          	bltz	a0,8000584e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057e2:	4691                	li	a3,4
    800057e4:	fc440613          	addi	a2,s0,-60
    800057e8:	fd843583          	ld	a1,-40(s0)
    800057ec:	68a8                	ld	a0,80(s1)
    800057ee:	ffffc097          	auipc	ra,0xffffc
    800057f2:	d4a080e7          	jalr	-694(ra) # 80001538 <copyout>
    800057f6:	02054063          	bltz	a0,80005816 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800057fa:	4691                	li	a3,4
    800057fc:	fc040613          	addi	a2,s0,-64
    80005800:	fd843583          	ld	a1,-40(s0)
    80005804:	0591                	addi	a1,a1,4
    80005806:	68a8                	ld	a0,80(s1)
    80005808:	ffffc097          	auipc	ra,0xffffc
    8000580c:	d30080e7          	jalr	-720(ra) # 80001538 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005810:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005812:	06055563          	bgez	a0,8000587c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005816:	fc442783          	lw	a5,-60(s0)
    8000581a:	07e9                	addi	a5,a5,26
    8000581c:	078e                	slli	a5,a5,0x3
    8000581e:	97a6                	add	a5,a5,s1
    80005820:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005824:	fc042503          	lw	a0,-64(s0)
    80005828:	0569                	addi	a0,a0,26
    8000582a:	050e                	slli	a0,a0,0x3
    8000582c:	9526                	add	a0,a0,s1
    8000582e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005832:	fd043503          	ld	a0,-48(s0)
    80005836:	fffff097          	auipc	ra,0xfffff
    8000583a:	a2c080e7          	jalr	-1492(ra) # 80004262 <fileclose>
    fileclose(wf);
    8000583e:	fc843503          	ld	a0,-56(s0)
    80005842:	fffff097          	auipc	ra,0xfffff
    80005846:	a20080e7          	jalr	-1504(ra) # 80004262 <fileclose>
    return -1;
    8000584a:	57fd                	li	a5,-1
    8000584c:	a805                	j	8000587c <sys_pipe+0x104>
    if(fd0 >= 0)
    8000584e:	fc442783          	lw	a5,-60(s0)
    80005852:	0007c863          	bltz	a5,80005862 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005856:	01a78513          	addi	a0,a5,26
    8000585a:	050e                	slli	a0,a0,0x3
    8000585c:	9526                	add	a0,a0,s1
    8000585e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005862:	fd043503          	ld	a0,-48(s0)
    80005866:	fffff097          	auipc	ra,0xfffff
    8000586a:	9fc080e7          	jalr	-1540(ra) # 80004262 <fileclose>
    fileclose(wf);
    8000586e:	fc843503          	ld	a0,-56(s0)
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	9f0080e7          	jalr	-1552(ra) # 80004262 <fileclose>
    return -1;
    8000587a:	57fd                	li	a5,-1
}
    8000587c:	853e                	mv	a0,a5
    8000587e:	70e2                	ld	ra,56(sp)
    80005880:	7442                	ld	s0,48(sp)
    80005882:	74a2                	ld	s1,40(sp)
    80005884:	6121                	addi	sp,sp,64
    80005886:	8082                	ret
	...

0000000080005890 <kernelvec>:
    80005890:	7111                	addi	sp,sp,-256
    80005892:	e006                	sd	ra,0(sp)
    80005894:	e40a                	sd	sp,8(sp)
    80005896:	e80e                	sd	gp,16(sp)
    80005898:	ec12                	sd	tp,24(sp)
    8000589a:	f016                	sd	t0,32(sp)
    8000589c:	f41a                	sd	t1,40(sp)
    8000589e:	f81e                	sd	t2,48(sp)
    800058a0:	fc22                	sd	s0,56(sp)
    800058a2:	e0a6                	sd	s1,64(sp)
    800058a4:	e4aa                	sd	a0,72(sp)
    800058a6:	e8ae                	sd	a1,80(sp)
    800058a8:	ecb2                	sd	a2,88(sp)
    800058aa:	f0b6                	sd	a3,96(sp)
    800058ac:	f4ba                	sd	a4,104(sp)
    800058ae:	f8be                	sd	a5,112(sp)
    800058b0:	fcc2                	sd	a6,120(sp)
    800058b2:	e146                	sd	a7,128(sp)
    800058b4:	e54a                	sd	s2,136(sp)
    800058b6:	e94e                	sd	s3,144(sp)
    800058b8:	ed52                	sd	s4,152(sp)
    800058ba:	f156                	sd	s5,160(sp)
    800058bc:	f55a                	sd	s6,168(sp)
    800058be:	f95e                	sd	s7,176(sp)
    800058c0:	fd62                	sd	s8,184(sp)
    800058c2:	e1e6                	sd	s9,192(sp)
    800058c4:	e5ea                	sd	s10,200(sp)
    800058c6:	e9ee                	sd	s11,208(sp)
    800058c8:	edf2                	sd	t3,216(sp)
    800058ca:	f1f6                	sd	t4,224(sp)
    800058cc:	f5fa                	sd	t5,232(sp)
    800058ce:	f9fe                	sd	t6,240(sp)
    800058d0:	debfc0ef          	jal	ra,800026ba <kerneltrap>
    800058d4:	6082                	ld	ra,0(sp)
    800058d6:	6122                	ld	sp,8(sp)
    800058d8:	61c2                	ld	gp,16(sp)
    800058da:	7282                	ld	t0,32(sp)
    800058dc:	7322                	ld	t1,40(sp)
    800058de:	73c2                	ld	t2,48(sp)
    800058e0:	7462                	ld	s0,56(sp)
    800058e2:	6486                	ld	s1,64(sp)
    800058e4:	6526                	ld	a0,72(sp)
    800058e6:	65c6                	ld	a1,80(sp)
    800058e8:	6666                	ld	a2,88(sp)
    800058ea:	7686                	ld	a3,96(sp)
    800058ec:	7726                	ld	a4,104(sp)
    800058ee:	77c6                	ld	a5,112(sp)
    800058f0:	7866                	ld	a6,120(sp)
    800058f2:	688a                	ld	a7,128(sp)
    800058f4:	692a                	ld	s2,136(sp)
    800058f6:	69ca                	ld	s3,144(sp)
    800058f8:	6a6a                	ld	s4,152(sp)
    800058fa:	7a8a                	ld	s5,160(sp)
    800058fc:	7b2a                	ld	s6,168(sp)
    800058fe:	7bca                	ld	s7,176(sp)
    80005900:	7c6a                	ld	s8,184(sp)
    80005902:	6c8e                	ld	s9,192(sp)
    80005904:	6d2e                	ld	s10,200(sp)
    80005906:	6dce                	ld	s11,208(sp)
    80005908:	6e6e                	ld	t3,216(sp)
    8000590a:	7e8e                	ld	t4,224(sp)
    8000590c:	7f2e                	ld	t5,232(sp)
    8000590e:	7fce                	ld	t6,240(sp)
    80005910:	6111                	addi	sp,sp,256
    80005912:	10200073          	sret
    80005916:	00000013          	nop
    8000591a:	00000013          	nop
    8000591e:	0001                	nop

0000000080005920 <timervec>:
    80005920:	34051573          	csrrw	a0,mscratch,a0
    80005924:	e10c                	sd	a1,0(a0)
    80005926:	e510                	sd	a2,8(a0)
    80005928:	e914                	sd	a3,16(a0)
    8000592a:	710c                	ld	a1,32(a0)
    8000592c:	7510                	ld	a2,40(a0)
    8000592e:	6194                	ld	a3,0(a1)
    80005930:	96b2                	add	a3,a3,a2
    80005932:	e194                	sd	a3,0(a1)
    80005934:	4589                	li	a1,2
    80005936:	14459073          	csrw	sip,a1
    8000593a:	6914                	ld	a3,16(a0)
    8000593c:	6510                	ld	a2,8(a0)
    8000593e:	610c                	ld	a1,0(a0)
    80005940:	34051573          	csrrw	a0,mscratch,a0
    80005944:	30200073          	mret
	...

000000008000594a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000594a:	1141                	addi	sp,sp,-16
    8000594c:	e422                	sd	s0,8(sp)
    8000594e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005950:	0c0007b7          	lui	a5,0xc000
    80005954:	4705                	li	a4,1
    80005956:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005958:	c3d8                	sw	a4,4(a5)
}
    8000595a:	6422                	ld	s0,8(sp)
    8000595c:	0141                	addi	sp,sp,16
    8000595e:	8082                	ret

0000000080005960 <plicinithart>:

void
plicinithart(void)
{
    80005960:	1141                	addi	sp,sp,-16
    80005962:	e406                	sd	ra,8(sp)
    80005964:	e022                	sd	s0,0(sp)
    80005966:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005968:	ffffc097          	auipc	ra,0xffffc
    8000596c:	eb0080e7          	jalr	-336(ra) # 80001818 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005970:	0085171b          	slliw	a4,a0,0x8
    80005974:	0c0027b7          	lui	a5,0xc002
    80005978:	97ba                	add	a5,a5,a4
    8000597a:	40200713          	li	a4,1026
    8000597e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005982:	00d5151b          	slliw	a0,a0,0xd
    80005986:	0c2017b7          	lui	a5,0xc201
    8000598a:	953e                	add	a0,a0,a5
    8000598c:	00052023          	sw	zero,0(a0)
}
    80005990:	60a2                	ld	ra,8(sp)
    80005992:	6402                	ld	s0,0(sp)
    80005994:	0141                	addi	sp,sp,16
    80005996:	8082                	ret

0000000080005998 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    80005998:	1141                	addi	sp,sp,-16
    8000599a:	e422                	sd	s0,8(sp)
    8000599c:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    8000599e:	0c0017b7          	lui	a5,0xc001
    800059a2:	6388                	ld	a0,0(a5)
    800059a4:	6422                	ld	s0,8(sp)
    800059a6:	0141                	addi	sp,sp,16
    800059a8:	8082                	ret

00000000800059aa <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800059aa:	1141                	addi	sp,sp,-16
    800059ac:	e406                	sd	ra,8(sp)
    800059ae:	e022                	sd	s0,0(sp)
    800059b0:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059b2:	ffffc097          	auipc	ra,0xffffc
    800059b6:	e66080e7          	jalr	-410(ra) # 80001818 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800059ba:	00d5179b          	slliw	a5,a0,0xd
    800059be:	0c201537          	lui	a0,0xc201
    800059c2:	953e                	add	a0,a0,a5
  return irq;
}
    800059c4:	4148                	lw	a0,4(a0)
    800059c6:	60a2                	ld	ra,8(sp)
    800059c8:	6402                	ld	s0,0(sp)
    800059ca:	0141                	addi	sp,sp,16
    800059cc:	8082                	ret

00000000800059ce <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800059ce:	1101                	addi	sp,sp,-32
    800059d0:	ec06                	sd	ra,24(sp)
    800059d2:	e822                	sd	s0,16(sp)
    800059d4:	e426                	sd	s1,8(sp)
    800059d6:	1000                	addi	s0,sp,32
    800059d8:	84aa                	mv	s1,a0
  int hart = cpuid();
    800059da:	ffffc097          	auipc	ra,0xffffc
    800059de:	e3e080e7          	jalr	-450(ra) # 80001818 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800059e2:	00d5151b          	slliw	a0,a0,0xd
    800059e6:	0c2017b7          	lui	a5,0xc201
    800059ea:	97aa                	add	a5,a5,a0
    800059ec:	c3c4                	sw	s1,4(a5)
}
    800059ee:	60e2                	ld	ra,24(sp)
    800059f0:	6442                	ld	s0,16(sp)
    800059f2:	64a2                	ld	s1,8(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret

00000000800059f8 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800059f8:	1141                	addi	sp,sp,-16
    800059fa:	e406                	sd	ra,8(sp)
    800059fc:	e022                	sd	s0,0(sp)
    800059fe:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005a00:	479d                	li	a5,7
    80005a02:	04a7cc63          	blt	a5,a0,80005a5a <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005a06:	0001c797          	auipc	a5,0x1c
    80005a0a:	5fa78793          	addi	a5,a5,1530 # 80022000 <disk>
    80005a0e:	00a78733          	add	a4,a5,a0
    80005a12:	6789                	lui	a5,0x2
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005a1a:	eba1                	bnez	a5,80005a6a <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005a1c:	00451713          	slli	a4,a0,0x4
    80005a20:	0001e797          	auipc	a5,0x1e
    80005a24:	5e07b783          	ld	a5,1504(a5) # 80024000 <disk+0x2000>
    80005a28:	97ba                	add	a5,a5,a4
    80005a2a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005a2e:	0001c797          	auipc	a5,0x1c
    80005a32:	5d278793          	addi	a5,a5,1490 # 80022000 <disk>
    80005a36:	97aa                	add	a5,a5,a0
    80005a38:	6509                	lui	a0,0x2
    80005a3a:	953e                	add	a0,a0,a5
    80005a3c:	4785                	li	a5,1
    80005a3e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005a42:	0001e517          	auipc	a0,0x1e
    80005a46:	5d650513          	addi	a0,a0,1494 # 80024018 <disk+0x2018>
    80005a4a:	ffffc097          	auipc	ra,0xffffc
    80005a4e:	722080e7          	jalr	1826(ra) # 8000216c <wakeup>
}
    80005a52:	60a2                	ld	ra,8(sp)
    80005a54:	6402                	ld	s0,0(sp)
    80005a56:	0141                	addi	sp,sp,16
    80005a58:	8082                	ret
    panic("virtio_disk_intr 1");
    80005a5a:	00001517          	auipc	a0,0x1
    80005a5e:	cfe50513          	addi	a0,a0,-770 # 80006758 <userret+0x6c8>
    80005a62:	ffffb097          	auipc	ra,0xffffb
    80005a66:	aec080e7          	jalr	-1300(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005a6a:	00001517          	auipc	a0,0x1
    80005a6e:	d0650513          	addi	a0,a0,-762 # 80006770 <userret+0x6e0>
    80005a72:	ffffb097          	auipc	ra,0xffffb
    80005a76:	adc080e7          	jalr	-1316(ra) # 8000054e <panic>

0000000080005a7a <virtio_disk_init>:
{
    80005a7a:	1101                	addi	sp,sp,-32
    80005a7c:	ec06                	sd	ra,24(sp)
    80005a7e:	e822                	sd	s0,16(sp)
    80005a80:	e426                	sd	s1,8(sp)
    80005a82:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005a84:	00001597          	auipc	a1,0x1
    80005a88:	d0458593          	addi	a1,a1,-764 # 80006788 <userret+0x6f8>
    80005a8c:	0001e517          	auipc	a0,0x1e
    80005a90:	61c50513          	addi	a0,a0,1564 # 800240a8 <disk+0x20a8>
    80005a94:	ffffb097          	auipc	ra,0xffffb
    80005a98:	f2c080e7          	jalr	-212(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005a9c:	100017b7          	lui	a5,0x10001
    80005aa0:	4398                	lw	a4,0(a5)
    80005aa2:	2701                	sext.w	a4,a4
    80005aa4:	747277b7          	lui	a5,0x74727
    80005aa8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005aac:	0ef71163          	bne	a4,a5,80005b8e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ab0:	100017b7          	lui	a5,0x10001
    80005ab4:	43dc                	lw	a5,4(a5)
    80005ab6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ab8:	4705                	li	a4,1
    80005aba:	0ce79a63          	bne	a5,a4,80005b8e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005abe:	100017b7          	lui	a5,0x10001
    80005ac2:	479c                	lw	a5,8(a5)
    80005ac4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ac6:	4709                	li	a4,2
    80005ac8:	0ce79363          	bne	a5,a4,80005b8e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005acc:	100017b7          	lui	a5,0x10001
    80005ad0:	47d8                	lw	a4,12(a5)
    80005ad2:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ad4:	554d47b7          	lui	a5,0x554d4
    80005ad8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005adc:	0af71963          	bne	a4,a5,80005b8e <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ae0:	100017b7          	lui	a5,0x10001
    80005ae4:	4705                	li	a4,1
    80005ae6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ae8:	470d                	li	a4,3
    80005aea:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005aec:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005aee:	c7ffe737          	lui	a4,0xc7ffe
    80005af2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9743>
    80005af6:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005af8:	2701                	sext.w	a4,a4
    80005afa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005afc:	472d                	li	a4,11
    80005afe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b00:	473d                	li	a4,15
    80005b02:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005b04:	6705                	lui	a4,0x1
    80005b06:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005b08:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005b0c:	5bdc                	lw	a5,52(a5)
    80005b0e:	2781                	sext.w	a5,a5
  if(max == 0)
    80005b10:	c7d9                	beqz	a5,80005b9e <virtio_disk_init+0x124>
  if(max < NUM)
    80005b12:	471d                	li	a4,7
    80005b14:	08f77d63          	bgeu	a4,a5,80005bae <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005b18:	100014b7          	lui	s1,0x10001
    80005b1c:	47a1                	li	a5,8
    80005b1e:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005b20:	6609                	lui	a2,0x2
    80005b22:	4581                	li	a1,0
    80005b24:	0001c517          	auipc	a0,0x1c
    80005b28:	4dc50513          	addi	a0,a0,1244 # 80022000 <disk>
    80005b2c:	ffffb097          	auipc	ra,0xffffb
    80005b30:	042080e7          	jalr	66(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005b34:	0001c717          	auipc	a4,0x1c
    80005b38:	4cc70713          	addi	a4,a4,1228 # 80022000 <disk>
    80005b3c:	00c75793          	srli	a5,a4,0xc
    80005b40:	2781                	sext.w	a5,a5
    80005b42:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005b44:	0001e797          	auipc	a5,0x1e
    80005b48:	4bc78793          	addi	a5,a5,1212 # 80024000 <disk+0x2000>
    80005b4c:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005b4e:	0001c717          	auipc	a4,0x1c
    80005b52:	53270713          	addi	a4,a4,1330 # 80022080 <disk+0x80>
    80005b56:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005b58:	0001d717          	auipc	a4,0x1d
    80005b5c:	4a870713          	addi	a4,a4,1192 # 80023000 <disk+0x1000>
    80005b60:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005b62:	4705                	li	a4,1
    80005b64:	00e78c23          	sb	a4,24(a5)
    80005b68:	00e78ca3          	sb	a4,25(a5)
    80005b6c:	00e78d23          	sb	a4,26(a5)
    80005b70:	00e78da3          	sb	a4,27(a5)
    80005b74:	00e78e23          	sb	a4,28(a5)
    80005b78:	00e78ea3          	sb	a4,29(a5)
    80005b7c:	00e78f23          	sb	a4,30(a5)
    80005b80:	00e78fa3          	sb	a4,31(a5)
}
    80005b84:	60e2                	ld	ra,24(sp)
    80005b86:	6442                	ld	s0,16(sp)
    80005b88:	64a2                	ld	s1,8(sp)
    80005b8a:	6105                	addi	sp,sp,32
    80005b8c:	8082                	ret
    panic("could not find virtio disk");
    80005b8e:	00001517          	auipc	a0,0x1
    80005b92:	c0a50513          	addi	a0,a0,-1014 # 80006798 <userret+0x708>
    80005b96:	ffffb097          	auipc	ra,0xffffb
    80005b9a:	9b8080e7          	jalr	-1608(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    80005b9e:	00001517          	auipc	a0,0x1
    80005ba2:	c1a50513          	addi	a0,a0,-998 # 800067b8 <userret+0x728>
    80005ba6:	ffffb097          	auipc	ra,0xffffb
    80005baa:	9a8080e7          	jalr	-1624(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    80005bae:	00001517          	auipc	a0,0x1
    80005bb2:	c2a50513          	addi	a0,a0,-982 # 800067d8 <userret+0x748>
    80005bb6:	ffffb097          	auipc	ra,0xffffb
    80005bba:	998080e7          	jalr	-1640(ra) # 8000054e <panic>

0000000080005bbe <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005bbe:	7119                	addi	sp,sp,-128
    80005bc0:	fc86                	sd	ra,120(sp)
    80005bc2:	f8a2                	sd	s0,112(sp)
    80005bc4:	f4a6                	sd	s1,104(sp)
    80005bc6:	f0ca                	sd	s2,96(sp)
    80005bc8:	ecce                	sd	s3,88(sp)
    80005bca:	e8d2                	sd	s4,80(sp)
    80005bcc:	e4d6                	sd	s5,72(sp)
    80005bce:	e0da                	sd	s6,64(sp)
    80005bd0:	fc5e                	sd	s7,56(sp)
    80005bd2:	f862                	sd	s8,48(sp)
    80005bd4:	f466                	sd	s9,40(sp)
    80005bd6:	f06a                	sd	s10,32(sp)
    80005bd8:	0100                	addi	s0,sp,128
    80005bda:	892a                	mv	s2,a0
    80005bdc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005bde:	00c52c83          	lw	s9,12(a0)
    80005be2:	001c9c9b          	slliw	s9,s9,0x1
    80005be6:	1c82                	slli	s9,s9,0x20
    80005be8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005bec:	0001e517          	auipc	a0,0x1e
    80005bf0:	4bc50513          	addi	a0,a0,1212 # 800240a8 <disk+0x20a8>
    80005bf4:	ffffb097          	auipc	ra,0xffffb
    80005bf8:	ede080e7          	jalr	-290(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    80005bfc:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005bfe:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005c00:	0001cb97          	auipc	s7,0x1c
    80005c04:	400b8b93          	addi	s7,s7,1024 # 80022000 <disk>
    80005c08:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005c0a:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005c0c:	8a4e                	mv	s4,s3
    80005c0e:	a051                	j	80005c92 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005c10:	00fb86b3          	add	a3,s7,a5
    80005c14:	96da                	add	a3,a3,s6
    80005c16:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005c1a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005c1c:	0207c563          	bltz	a5,80005c46 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005c20:	2485                	addiw	s1,s1,1
    80005c22:	0711                	addi	a4,a4,4
    80005c24:	1b548863          	beq	s1,s5,80005dd4 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80005c28:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005c2a:	0001e697          	auipc	a3,0x1e
    80005c2e:	3ee68693          	addi	a3,a3,1006 # 80024018 <disk+0x2018>
    80005c32:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005c34:	0006c583          	lbu	a1,0(a3)
    80005c38:	fde1                	bnez	a1,80005c10 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005c3a:	2785                	addiw	a5,a5,1
    80005c3c:	0685                	addi	a3,a3,1
    80005c3e:	ff879be3          	bne	a5,s8,80005c34 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005c42:	57fd                	li	a5,-1
    80005c44:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005c46:	02905a63          	blez	s1,80005c7a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c4a:	f9042503          	lw	a0,-112(s0)
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	daa080e7          	jalr	-598(ra) # 800059f8 <free_desc>
      for(int j = 0; j < i; j++)
    80005c56:	4785                	li	a5,1
    80005c58:	0297d163          	bge	a5,s1,80005c7a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c5c:	f9442503          	lw	a0,-108(s0)
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	d98080e7          	jalr	-616(ra) # 800059f8 <free_desc>
      for(int j = 0; j < i; j++)
    80005c68:	4789                	li	a5,2
    80005c6a:	0097d863          	bge	a5,s1,80005c7a <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c6e:	f9842503          	lw	a0,-104(s0)
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	d86080e7          	jalr	-634(ra) # 800059f8 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005c7a:	0001e597          	auipc	a1,0x1e
    80005c7e:	42e58593          	addi	a1,a1,1070 # 800240a8 <disk+0x20a8>
    80005c82:	0001e517          	auipc	a0,0x1e
    80005c86:	39650513          	addi	a0,a0,918 # 80024018 <disk+0x2018>
    80005c8a:	ffffc097          	auipc	ra,0xffffc
    80005c8e:	35c080e7          	jalr	860(ra) # 80001fe6 <sleep>
  for(int i = 0; i < 3; i++){
    80005c92:	f9040713          	addi	a4,s0,-112
    80005c96:	84ce                	mv	s1,s3
    80005c98:	bf41                	j	80005c28 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005c9a:	0001e717          	auipc	a4,0x1e
    80005c9e:	36673703          	ld	a4,870(a4) # 80024000 <disk+0x2000>
    80005ca2:	973e                	add	a4,a4,a5
    80005ca4:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005ca8:	0001c517          	auipc	a0,0x1c
    80005cac:	35850513          	addi	a0,a0,856 # 80022000 <disk>
    80005cb0:	0001e717          	auipc	a4,0x1e
    80005cb4:	35070713          	addi	a4,a4,848 # 80024000 <disk+0x2000>
    80005cb8:	6310                	ld	a2,0(a4)
    80005cba:	963e                	add	a2,a2,a5
    80005cbc:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005cc0:	0015e593          	ori	a1,a1,1
    80005cc4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005cc8:	f9842683          	lw	a3,-104(s0)
    80005ccc:	6310                	ld	a2,0(a4)
    80005cce:	97b2                	add	a5,a5,a2
    80005cd0:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005cd4:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005cd8:	0612                	slli	a2,a2,0x4
    80005cda:	962a                	add	a2,a2,a0
    80005cdc:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005ce0:	00469793          	slli	a5,a3,0x4
    80005ce4:	630c                	ld	a1,0(a4)
    80005ce6:	95be                	add	a1,a1,a5
    80005ce8:	6689                	lui	a3,0x2
    80005cea:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005cee:	96ce                	add	a3,a3,s3
    80005cf0:	96aa                	add	a3,a3,a0
    80005cf2:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005cf4:	6314                	ld	a3,0(a4)
    80005cf6:	96be                	add	a3,a3,a5
    80005cf8:	4585                	li	a1,1
    80005cfa:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005cfc:	6314                	ld	a3,0(a4)
    80005cfe:	96be                	add	a3,a3,a5
    80005d00:	4509                	li	a0,2
    80005d02:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005d06:	6314                	ld	a3,0(a4)
    80005d08:	97b6                	add	a5,a5,a3
    80005d0a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005d0e:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005d12:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005d16:	6714                	ld	a3,8(a4)
    80005d18:	0026d783          	lhu	a5,2(a3)
    80005d1c:	8b9d                	andi	a5,a5,7
    80005d1e:	2789                	addiw	a5,a5,2
    80005d20:	0786                	slli	a5,a5,0x1
    80005d22:	97b6                	add	a5,a5,a3
    80005d24:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80005d28:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005d2c:	6718                	ld	a4,8(a4)
    80005d2e:	00275783          	lhu	a5,2(a4)
    80005d32:	2785                	addiw	a5,a5,1
    80005d34:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d38:	100017b7          	lui	a5,0x10001
    80005d3c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005d40:	00492783          	lw	a5,4(s2)
    80005d44:	02b79163          	bne	a5,a1,80005d66 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    80005d48:	0001e997          	auipc	s3,0x1e
    80005d4c:	36098993          	addi	s3,s3,864 # 800240a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005d50:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005d52:	85ce                	mv	a1,s3
    80005d54:	854a                	mv	a0,s2
    80005d56:	ffffc097          	auipc	ra,0xffffc
    80005d5a:	290080e7          	jalr	656(ra) # 80001fe6 <sleep>
  while(b->disk == 1) {
    80005d5e:	00492783          	lw	a5,4(s2)
    80005d62:	fe9788e3          	beq	a5,s1,80005d52 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    80005d66:	f9042483          	lw	s1,-112(s0)
    80005d6a:	20048793          	addi	a5,s1,512
    80005d6e:	00479713          	slli	a4,a5,0x4
    80005d72:	0001c797          	auipc	a5,0x1c
    80005d76:	28e78793          	addi	a5,a5,654 # 80022000 <disk>
    80005d7a:	97ba                	add	a5,a5,a4
    80005d7c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005d80:	0001e917          	auipc	s2,0x1e
    80005d84:	28090913          	addi	s2,s2,640 # 80024000 <disk+0x2000>
    free_desc(i);
    80005d88:	8526                	mv	a0,s1
    80005d8a:	00000097          	auipc	ra,0x0
    80005d8e:	c6e080e7          	jalr	-914(ra) # 800059f8 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005d92:	0492                	slli	s1,s1,0x4
    80005d94:	00093783          	ld	a5,0(s2)
    80005d98:	94be                	add	s1,s1,a5
    80005d9a:	00c4d783          	lhu	a5,12(s1)
    80005d9e:	8b85                	andi	a5,a5,1
    80005da0:	c781                	beqz	a5,80005da8 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    80005da2:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80005da6:	b7cd                	j	80005d88 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005da8:	0001e517          	auipc	a0,0x1e
    80005dac:	30050513          	addi	a0,a0,768 # 800240a8 <disk+0x20a8>
    80005db0:	ffffb097          	auipc	ra,0xffffb
    80005db4:	d76080e7          	jalr	-650(ra) # 80000b26 <release>
}
    80005db8:	70e6                	ld	ra,120(sp)
    80005dba:	7446                	ld	s0,112(sp)
    80005dbc:	74a6                	ld	s1,104(sp)
    80005dbe:	7906                	ld	s2,96(sp)
    80005dc0:	69e6                	ld	s3,88(sp)
    80005dc2:	6a46                	ld	s4,80(sp)
    80005dc4:	6aa6                	ld	s5,72(sp)
    80005dc6:	6b06                	ld	s6,64(sp)
    80005dc8:	7be2                	ld	s7,56(sp)
    80005dca:	7c42                	ld	s8,48(sp)
    80005dcc:	7ca2                	ld	s9,40(sp)
    80005dce:	7d02                	ld	s10,32(sp)
    80005dd0:	6109                	addi	sp,sp,128
    80005dd2:	8082                	ret
  if(write)
    80005dd4:	01a037b3          	snez	a5,s10
    80005dd8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    80005ddc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80005de0:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80005de4:	f9042483          	lw	s1,-112(s0)
    80005de8:	00449993          	slli	s3,s1,0x4
    80005dec:	0001ea17          	auipc	s4,0x1e
    80005df0:	214a0a13          	addi	s4,s4,532 # 80024000 <disk+0x2000>
    80005df4:	000a3a83          	ld	s5,0(s4)
    80005df8:	9ace                	add	s5,s5,s3
    80005dfa:	f8040513          	addi	a0,s0,-128
    80005dfe:	ffffb097          	auipc	ra,0xffffb
    80005e02:	1ae080e7          	jalr	430(ra) # 80000fac <kvmpa>
    80005e06:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80005e0a:	000a3783          	ld	a5,0(s4)
    80005e0e:	97ce                	add	a5,a5,s3
    80005e10:	4741                	li	a4,16
    80005e12:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005e14:	000a3783          	ld	a5,0(s4)
    80005e18:	97ce                	add	a5,a5,s3
    80005e1a:	4705                	li	a4,1
    80005e1c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005e20:	f9442783          	lw	a5,-108(s0)
    80005e24:	000a3703          	ld	a4,0(s4)
    80005e28:	974e                	add	a4,a4,s3
    80005e2a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005e2e:	0792                	slli	a5,a5,0x4
    80005e30:	000a3703          	ld	a4,0(s4)
    80005e34:	973e                	add	a4,a4,a5
    80005e36:	06090693          	addi	a3,s2,96
    80005e3a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    80005e3c:	000a3703          	ld	a4,0(s4)
    80005e40:	973e                	add	a4,a4,a5
    80005e42:	40000693          	li	a3,1024
    80005e46:	c714                	sw	a3,8(a4)
  if(write)
    80005e48:	e40d19e3          	bnez	s10,80005c9a <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005e4c:	0001e717          	auipc	a4,0x1e
    80005e50:	1b473703          	ld	a4,436(a4) # 80024000 <disk+0x2000>
    80005e54:	973e                	add	a4,a4,a5
    80005e56:	4689                	li	a3,2
    80005e58:	00d71623          	sh	a3,12(a4)
    80005e5c:	b5b1                	j	80005ca8 <virtio_disk_rw+0xea>

0000000080005e5e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005e5e:	1101                	addi	sp,sp,-32
    80005e60:	ec06                	sd	ra,24(sp)
    80005e62:	e822                	sd	s0,16(sp)
    80005e64:	e426                	sd	s1,8(sp)
    80005e66:	e04a                	sd	s2,0(sp)
    80005e68:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005e6a:	0001e517          	auipc	a0,0x1e
    80005e6e:	23e50513          	addi	a0,a0,574 # 800240a8 <disk+0x20a8>
    80005e72:	ffffb097          	auipc	ra,0xffffb
    80005e76:	c60080e7          	jalr	-928(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80005e7a:	0001e717          	auipc	a4,0x1e
    80005e7e:	18670713          	addi	a4,a4,390 # 80024000 <disk+0x2000>
    80005e82:	02075783          	lhu	a5,32(a4)
    80005e86:	6b18                	ld	a4,16(a4)
    80005e88:	00275683          	lhu	a3,2(a4)
    80005e8c:	8ebd                	xor	a3,a3,a5
    80005e8e:	8a9d                	andi	a3,a3,7
    80005e90:	cab9                	beqz	a3,80005ee6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80005e92:	0001c917          	auipc	s2,0x1c
    80005e96:	16e90913          	addi	s2,s2,366 # 80022000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80005e9a:	0001e497          	auipc	s1,0x1e
    80005e9e:	16648493          	addi	s1,s1,358 # 80024000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80005ea2:	078e                	slli	a5,a5,0x3
    80005ea4:	97ba                	add	a5,a5,a4
    80005ea6:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80005ea8:	20078713          	addi	a4,a5,512
    80005eac:	0712                	slli	a4,a4,0x4
    80005eae:	974a                	add	a4,a4,s2
    80005eb0:	03074703          	lbu	a4,48(a4)
    80005eb4:	e739                	bnez	a4,80005f02 <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80005eb6:	20078793          	addi	a5,a5,512
    80005eba:	0792                	slli	a5,a5,0x4
    80005ebc:	97ca                	add	a5,a5,s2
    80005ebe:	7798                	ld	a4,40(a5)
    80005ec0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80005ec4:	7788                	ld	a0,40(a5)
    80005ec6:	ffffc097          	auipc	ra,0xffffc
    80005eca:	2a6080e7          	jalr	678(ra) # 8000216c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80005ece:	0204d783          	lhu	a5,32(s1)
    80005ed2:	2785                	addiw	a5,a5,1
    80005ed4:	8b9d                	andi	a5,a5,7
    80005ed6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80005eda:	6898                	ld	a4,16(s1)
    80005edc:	00275683          	lhu	a3,2(a4)
    80005ee0:	8a9d                	andi	a3,a3,7
    80005ee2:	fcf690e3          	bne	a3,a5,80005ea2 <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    80005ee6:	0001e517          	auipc	a0,0x1e
    80005eea:	1c250513          	addi	a0,a0,450 # 800240a8 <disk+0x20a8>
    80005eee:	ffffb097          	auipc	ra,0xffffb
    80005ef2:	c38080e7          	jalr	-968(ra) # 80000b26 <release>
}
    80005ef6:	60e2                	ld	ra,24(sp)
    80005ef8:	6442                	ld	s0,16(sp)
    80005efa:	64a2                	ld	s1,8(sp)
    80005efc:	6902                	ld	s2,0(sp)
    80005efe:	6105                	addi	sp,sp,32
    80005f00:	8082                	ret
      panic("virtio_disk_intr status");
    80005f02:	00001517          	auipc	a0,0x1
    80005f06:	8f650513          	addi	a0,a0,-1802 # 800067f8 <userret+0x768>
    80005f0a:	ffffa097          	auipc	ra,0xffffa
    80005f0e:	644080e7          	jalr	1604(ra) # 8000054e <panic>
	...

0000000080006000 <trampoline>:
    80006000:	14051573          	csrrw	a0,sscratch,a0
    80006004:	02153423          	sd	ra,40(a0)
    80006008:	02253823          	sd	sp,48(a0)
    8000600c:	02353c23          	sd	gp,56(a0)
    80006010:	04453023          	sd	tp,64(a0)
    80006014:	04553423          	sd	t0,72(a0)
    80006018:	04653823          	sd	t1,80(a0)
    8000601c:	04753c23          	sd	t2,88(a0)
    80006020:	f120                	sd	s0,96(a0)
    80006022:	f524                	sd	s1,104(a0)
    80006024:	fd2c                	sd	a1,120(a0)
    80006026:	e150                	sd	a2,128(a0)
    80006028:	e554                	sd	a3,136(a0)
    8000602a:	e958                	sd	a4,144(a0)
    8000602c:	ed5c                	sd	a5,152(a0)
    8000602e:	0b053023          	sd	a6,160(a0)
    80006032:	0b153423          	sd	a7,168(a0)
    80006036:	0b253823          	sd	s2,176(a0)
    8000603a:	0b353c23          	sd	s3,184(a0)
    8000603e:	0d453023          	sd	s4,192(a0)
    80006042:	0d553423          	sd	s5,200(a0)
    80006046:	0d653823          	sd	s6,208(a0)
    8000604a:	0d753c23          	sd	s7,216(a0)
    8000604e:	0f853023          	sd	s8,224(a0)
    80006052:	0f953423          	sd	s9,232(a0)
    80006056:	0fa53823          	sd	s10,240(a0)
    8000605a:	0fb53c23          	sd	s11,248(a0)
    8000605e:	11c53023          	sd	t3,256(a0)
    80006062:	11d53423          	sd	t4,264(a0)
    80006066:	11e53823          	sd	t5,272(a0)
    8000606a:	11f53c23          	sd	t6,280(a0)
    8000606e:	140022f3          	csrr	t0,sscratch
    80006072:	06553823          	sd	t0,112(a0)
    80006076:	00853103          	ld	sp,8(a0)
    8000607a:	02053203          	ld	tp,32(a0)
    8000607e:	01053283          	ld	t0,16(a0)
    80006082:	00053303          	ld	t1,0(a0)
    80006086:	18031073          	csrw	satp,t1
    8000608a:	12000073          	sfence.vma
    8000608e:	8282                	jr	t0

0000000080006090 <userret>:
    80006090:	18059073          	csrw	satp,a1
    80006094:	12000073          	sfence.vma
    80006098:	07053283          	ld	t0,112(a0)
    8000609c:	14029073          	csrw	sscratch,t0
    800060a0:	02853083          	ld	ra,40(a0)
    800060a4:	03053103          	ld	sp,48(a0)
    800060a8:	03853183          	ld	gp,56(a0)
    800060ac:	04053203          	ld	tp,64(a0)
    800060b0:	04853283          	ld	t0,72(a0)
    800060b4:	05053303          	ld	t1,80(a0)
    800060b8:	05853383          	ld	t2,88(a0)
    800060bc:	7120                	ld	s0,96(a0)
    800060be:	7524                	ld	s1,104(a0)
    800060c0:	7d2c                	ld	a1,120(a0)
    800060c2:	6150                	ld	a2,128(a0)
    800060c4:	6554                	ld	a3,136(a0)
    800060c6:	6958                	ld	a4,144(a0)
    800060c8:	6d5c                	ld	a5,152(a0)
    800060ca:	0a053803          	ld	a6,160(a0)
    800060ce:	0a853883          	ld	a7,168(a0)
    800060d2:	0b053903          	ld	s2,176(a0)
    800060d6:	0b853983          	ld	s3,184(a0)
    800060da:	0c053a03          	ld	s4,192(a0)
    800060de:	0c853a83          	ld	s5,200(a0)
    800060e2:	0d053b03          	ld	s6,208(a0)
    800060e6:	0d853b83          	ld	s7,216(a0)
    800060ea:	0e053c03          	ld	s8,224(a0)
    800060ee:	0e853c83          	ld	s9,232(a0)
    800060f2:	0f053d03          	ld	s10,240(a0)
    800060f6:	0f853d83          	ld	s11,248(a0)
    800060fa:	10053e03          	ld	t3,256(a0)
    800060fe:	10853e83          	ld	t4,264(a0)
    80006102:	11053f03          	ld	t5,272(a0)
    80006106:	11853f83          	ld	t6,280(a0)
    8000610a:	14051573          	csrrw	a0,sscratch,a0
    8000610e:	10200073          	sret
