
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1b2080e7          	jalr	434(ra) # 1da <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	25a080e7          	jalr	602(ra) # 28a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	21a080e7          	jalr	538(ra) # 25a <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	73058593          	addi	a1,a1,1840 # 778 <malloc+0xe8>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	552080e7          	jalr	1362(ra) # 5a4 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	1fe080e7          	jalr	510(ra) # 25a <exit>

0000000000000064 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	addi	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	4685                	li	a3,1
  be:	9e89                	subw	a3,a3,a0
  c0:	00f6853b          	addw	a0,a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	fb7d                	bnez	a4,c0 <strlen+0x14>
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for(n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  dc:	ce09                	beqz	a2,f6 <memset+0x20>
  de:	87aa                	mv	a5,a0
  e0:	fff6071b          	addiw	a4,a2,-1
  e4:	1702                	slli	a4,a4,0x20
  e6:	9301                	srli	a4,a4,0x20
  e8:	0705                	addi	a4,a4,1
  ea:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f0:	0785                	addi	a5,a5,1
  f2:	fee79de3          	bne	a5,a4,ec <memset+0x16>
  }
  return dst;
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  for(; *s; s++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cb99                	beqz	a5,11c <strchr+0x20>
    if(*s == c)
 108:	00f58763          	beq	a1,a5,116 <strchr+0x1a>
  for(; *s; s++)
 10c:	0505                	addi	a0,a0,1
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbfd                	bnez	a5,108 <strchr+0xc>
      return (char*)s;
  return 0;
 114:	4501                	li	a0,0
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  return 0;
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strchr+0x1a>

0000000000000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	711d                	addi	sp,sp,-96
 122:	ec86                	sd	ra,88(sp)
 124:	e8a2                	sd	s0,80(sp)
 126:	e4a6                	sd	s1,72(sp)
 128:	e0ca                	sd	s2,64(sp)
 12a:	fc4e                	sd	s3,56(sp)
 12c:	f852                	sd	s4,48(sp)
 12e:	f456                	sd	s5,40(sp)
 130:	f05a                	sd	s6,32(sp)
 132:	ec5e                	sd	s7,24(sp)
 134:	1080                	addi	s0,sp,96
 136:	8baa                	mv	s7,a0
 138:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	892a                	mv	s2,a0
 13c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13e:	4aa9                	li	s5,10
 140:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 142:	89a6                	mv	s3,s1
 144:	2485                	addiw	s1,s1,1
 146:	0344d863          	bge	s1,s4,176 <gets+0x56>
    cc = read(0, &c, 1);
 14a:	4605                	li	a2,1
 14c:	faf40593          	addi	a1,s0,-81
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	120080e7          	jalr	288(ra) # 272 <read>
    if(cc < 1)
 15a:	00a05e63          	blez	a0,176 <gets+0x56>
    buf[i++] = c;
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 166:	01578763          	beq	a5,s5,174 <gets+0x54>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679be3          	bne	a5,s6,142 <gets+0x22>
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x56>
 174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
  return buf;
}
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e426                	sd	s1,8(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	4581                	li	a1,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	0f6080e7          	jalr	246(ra) # 29a <open>
  if(fd < 0)
 1ac:	02054563          	bltz	a0,1d6 <stat+0x42>
 1b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b2:	85ca                	mv	a1,s2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	0fe080e7          	jalr	254(ra) # 2b2 <fstat>
 1bc:	892a                	mv	s2,a0
  close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	0c2080e7          	jalr	194(ra) # 282 <close>
  return r;
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	64a2                	ld	s1,8(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfc5                	j	1c8 <stat+0x34>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054603          	lbu	a2,0(a0)
 1e4:	fd06079b          	addiw	a5,a2,-48
 1e8:	0ff7f793          	andi	a5,a5,255
 1ec:	4725                	li	a4,9
 1ee:	02f76963          	bltu	a4,a5,220 <atoi+0x46>
 1f2:	86aa                	mv	a3,a0
  n = 0;
 1f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f8:	0685                	addi	a3,a3,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb1                	addw	a5,a5,a2
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	0006c603          	lbu	a2,0(a3)
 20e:	fd06071b          	addiw	a4,a2,-48
 212:	0ff77713          	andi	a4,a4,255
 216:	fee5f1e3          	bgeu	a1,a4,1f8 <atoi+0x1e>
  return n;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
  n = 0;
 220:	4501                	li	a0,0
 222:	bfe5                	j	21a <atoi+0x40>

0000000000000224 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22a:	02c05163          	blez	a2,24c <memmove+0x28>
 22e:	fff6071b          	addiw	a4,a2,-1
 232:	1702                	slli	a4,a4,0x20
 234:	9301                	srli	a4,a4,0x20
 236:	0705                	addi	a4,a4,1
 238:	972a                	add	a4,a4,a0
  dst = vdst;
 23a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 23c:	0585                	addi	a1,a1,1
 23e:	0785                	addi	a5,a5,1
 240:	fff5c683          	lbu	a3,-1(a1)
 244:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 248:	fee79ae3          	bne	a5,a4,23c <memmove+0x18>
  return vdst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 252:	4885                	li	a7,1
 ecall
 254:	00000073          	ecall
 ret
 258:	8082                	ret

000000000000025a <exit>:
.global exit
exit:
 li a7, SYS_exit
 25a:	4889                	li	a7,2
 ecall
 25c:	00000073          	ecall
 ret
 260:	8082                	ret

0000000000000262 <wait>:
.global wait
wait:
 li a7, SYS_wait
 262:	488d                	li	a7,3
 ecall
 264:	00000073          	ecall
 ret
 268:	8082                	ret

000000000000026a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 26a:	4891                	li	a7,4
 ecall
 26c:	00000073          	ecall
 ret
 270:	8082                	ret

0000000000000272 <read>:
.global read
read:
 li a7, SYS_read
 272:	4895                	li	a7,5
 ecall
 274:	00000073          	ecall
 ret
 278:	8082                	ret

000000000000027a <write>:
.global write
write:
 li a7, SYS_write
 27a:	48c1                	li	a7,16
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <close>:
.global close
close:
 li a7, SYS_close
 282:	48d5                	li	a7,21
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <kill>:
.global kill
kill:
 li a7, SYS_kill
 28a:	4899                	li	a7,6
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <exec>:
.global exec
exec:
 li a7, SYS_exec
 292:	489d                	li	a7,7
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <open>:
.global open
open:
 li a7, SYS_open
 29a:	48bd                	li	a7,15
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2a2:	48c5                	li	a7,17
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2aa:	48c9                	li	a7,18
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2b2:	48a1                	li	a7,8
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <link>:
.global link
link:
 li a7, SYS_link
 2ba:	48cd                	li	a7,19
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2c2:	48d1                	li	a7,20
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2ca:	48a5                	li	a7,9
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2d2:	48a9                	li	a7,10
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2da:	48ad                	li	a7,11
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2e2:	48b1                	li	a7,12
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2ea:	48b5                	li	a7,13
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2f2:	48b9                	li	a7,14
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 2fa:	1101                	addi	sp,sp,-32
 2fc:	ec06                	sd	ra,24(sp)
 2fe:	e822                	sd	s0,16(sp)
 300:	1000                	addi	s0,sp,32
 302:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 306:	4605                	li	a2,1
 308:	fef40593          	addi	a1,s0,-17
 30c:	00000097          	auipc	ra,0x0
 310:	f6e080e7          	jalr	-146(ra) # 27a <write>
}
 314:	60e2                	ld	ra,24(sp)
 316:	6442                	ld	s0,16(sp)
 318:	6105                	addi	sp,sp,32
 31a:	8082                	ret

000000000000031c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 31c:	7139                	addi	sp,sp,-64
 31e:	fc06                	sd	ra,56(sp)
 320:	f822                	sd	s0,48(sp)
 322:	f426                	sd	s1,40(sp)
 324:	f04a                	sd	s2,32(sp)
 326:	ec4e                	sd	s3,24(sp)
 328:	0080                	addi	s0,sp,64
 32a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32c:	c299                	beqz	a3,332 <printint+0x16>
 32e:	0805c863          	bltz	a1,3be <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 332:	2581                	sext.w	a1,a1
  neg = 0;
 334:	4881                	li	a7,0
 336:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 33a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 33c:	2601                	sext.w	a2,a2
 33e:	00000517          	auipc	a0,0x0
 342:	45a50513          	addi	a0,a0,1114 # 798 <digits>
 346:	883a                	mv	a6,a4
 348:	2705                	addiw	a4,a4,1
 34a:	02c5f7bb          	remuw	a5,a1,a2
 34e:	1782                	slli	a5,a5,0x20
 350:	9381                	srli	a5,a5,0x20
 352:	97aa                	add	a5,a5,a0
 354:	0007c783          	lbu	a5,0(a5)
 358:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 35c:	0005879b          	sext.w	a5,a1
 360:	02c5d5bb          	divuw	a1,a1,a2
 364:	0685                	addi	a3,a3,1
 366:	fec7f0e3          	bgeu	a5,a2,346 <printint+0x2a>
  if(neg)
 36a:	00088b63          	beqz	a7,380 <printint+0x64>
    buf[i++] = '-';
 36e:	fd040793          	addi	a5,s0,-48
 372:	973e                	add	a4,a4,a5
 374:	02d00793          	li	a5,45
 378:	fef70823          	sb	a5,-16(a4)
 37c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 380:	02e05863          	blez	a4,3b0 <printint+0x94>
 384:	fc040793          	addi	a5,s0,-64
 388:	00e78933          	add	s2,a5,a4
 38c:	fff78993          	addi	s3,a5,-1
 390:	99ba                	add	s3,s3,a4
 392:	377d                	addiw	a4,a4,-1
 394:	1702                	slli	a4,a4,0x20
 396:	9301                	srli	a4,a4,0x20
 398:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 39c:	fff94583          	lbu	a1,-1(s2)
 3a0:	8526                	mv	a0,s1
 3a2:	00000097          	auipc	ra,0x0
 3a6:	f58080e7          	jalr	-168(ra) # 2fa <putc>
  while(--i >= 0)
 3aa:	197d                	addi	s2,s2,-1
 3ac:	ff3918e3          	bne	s2,s3,39c <printint+0x80>
}
 3b0:	70e2                	ld	ra,56(sp)
 3b2:	7442                	ld	s0,48(sp)
 3b4:	74a2                	ld	s1,40(sp)
 3b6:	7902                	ld	s2,32(sp)
 3b8:	69e2                	ld	s3,24(sp)
 3ba:	6121                	addi	sp,sp,64
 3bc:	8082                	ret
    x = -xx;
 3be:	40b005bb          	negw	a1,a1
    neg = 1;
 3c2:	4885                	li	a7,1
    x = -xx;
 3c4:	bf8d                	j	336 <printint+0x1a>

00000000000003c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3c6:	7119                	addi	sp,sp,-128
 3c8:	fc86                	sd	ra,120(sp)
 3ca:	f8a2                	sd	s0,112(sp)
 3cc:	f4a6                	sd	s1,104(sp)
 3ce:	f0ca                	sd	s2,96(sp)
 3d0:	ecce                	sd	s3,88(sp)
 3d2:	e8d2                	sd	s4,80(sp)
 3d4:	e4d6                	sd	s5,72(sp)
 3d6:	e0da                	sd	s6,64(sp)
 3d8:	fc5e                	sd	s7,56(sp)
 3da:	f862                	sd	s8,48(sp)
 3dc:	f466                	sd	s9,40(sp)
 3de:	f06a                	sd	s10,32(sp)
 3e0:	ec6e                	sd	s11,24(sp)
 3e2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3e4:	0005c903          	lbu	s2,0(a1)
 3e8:	18090f63          	beqz	s2,586 <vprintf+0x1c0>
 3ec:	8aaa                	mv	s5,a0
 3ee:	8b32                	mv	s6,a2
 3f0:	00158493          	addi	s1,a1,1
  state = 0;
 3f4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3f6:	02500a13          	li	s4,37
      if(c == 'd'){
 3fa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 3fe:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 402:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 406:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 40a:	00000b97          	auipc	s7,0x0
 40e:	38eb8b93          	addi	s7,s7,910 # 798 <digits>
 412:	a839                	j	430 <vprintf+0x6a>
        putc(fd, c);
 414:	85ca                	mv	a1,s2
 416:	8556                	mv	a0,s5
 418:	00000097          	auipc	ra,0x0
 41c:	ee2080e7          	jalr	-286(ra) # 2fa <putc>
 420:	a019                	j	426 <vprintf+0x60>
    } else if(state == '%'){
 422:	01498f63          	beq	s3,s4,440 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 426:	0485                	addi	s1,s1,1
 428:	fff4c903          	lbu	s2,-1(s1)
 42c:	14090d63          	beqz	s2,586 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 430:	0009079b          	sext.w	a5,s2
    if(state == 0){
 434:	fe0997e3          	bnez	s3,422 <vprintf+0x5c>
      if(c == '%'){
 438:	fd479ee3          	bne	a5,s4,414 <vprintf+0x4e>
        state = '%';
 43c:	89be                	mv	s3,a5
 43e:	b7e5                	j	426 <vprintf+0x60>
      if(c == 'd'){
 440:	05878063          	beq	a5,s8,480 <vprintf+0xba>
      } else if(c == 'l') {
 444:	05978c63          	beq	a5,s9,49c <vprintf+0xd6>
      } else if(c == 'x') {
 448:	07a78863          	beq	a5,s10,4b8 <vprintf+0xf2>
      } else if(c == 'p') {
 44c:	09b78463          	beq	a5,s11,4d4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 450:	07300713          	li	a4,115
 454:	0ce78663          	beq	a5,a4,520 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 458:	06300713          	li	a4,99
 45c:	0ee78e63          	beq	a5,a4,558 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 460:	11478863          	beq	a5,s4,570 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 464:	85d2                	mv	a1,s4
 466:	8556                	mv	a0,s5
 468:	00000097          	auipc	ra,0x0
 46c:	e92080e7          	jalr	-366(ra) # 2fa <putc>
        putc(fd, c);
 470:	85ca                	mv	a1,s2
 472:	8556                	mv	a0,s5
 474:	00000097          	auipc	ra,0x0
 478:	e86080e7          	jalr	-378(ra) # 2fa <putc>
      }
      state = 0;
 47c:	4981                	li	s3,0
 47e:	b765                	j	426 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 480:	008b0913          	addi	s2,s6,8
 484:	4685                	li	a3,1
 486:	4629                	li	a2,10
 488:	000b2583          	lw	a1,0(s6)
 48c:	8556                	mv	a0,s5
 48e:	00000097          	auipc	ra,0x0
 492:	e8e080e7          	jalr	-370(ra) # 31c <printint>
 496:	8b4a                	mv	s6,s2
      state = 0;
 498:	4981                	li	s3,0
 49a:	b771                	j	426 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 49c:	008b0913          	addi	s2,s6,8
 4a0:	4681                	li	a3,0
 4a2:	4629                	li	a2,10
 4a4:	000b2583          	lw	a1,0(s6)
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e72080e7          	jalr	-398(ra) # 31c <printint>
 4b2:	8b4a                	mv	s6,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bf85                	j	426 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4b8:	008b0913          	addi	s2,s6,8
 4bc:	4681                	li	a3,0
 4be:	4641                	li	a2,16
 4c0:	000b2583          	lw	a1,0(s6)
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	e56080e7          	jalr	-426(ra) # 31c <printint>
 4ce:	8b4a                	mv	s6,s2
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	bf91                	j	426 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4d4:	008b0793          	addi	a5,s6,8
 4d8:	f8f43423          	sd	a5,-120(s0)
 4dc:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4e0:	03000593          	li	a1,48
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e14080e7          	jalr	-492(ra) # 2fa <putc>
  putc(fd, 'x');
 4ee:	85ea                	mv	a1,s10
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e08080e7          	jalr	-504(ra) # 2fa <putc>
 4fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fc:	03c9d793          	srli	a5,s3,0x3c
 500:	97de                	add	a5,a5,s7
 502:	0007c583          	lbu	a1,0(a5)
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	df2080e7          	jalr	-526(ra) # 2fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 510:	0992                	slli	s3,s3,0x4
 512:	397d                	addiw	s2,s2,-1
 514:	fe0914e3          	bnez	s2,4fc <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 518:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b721                	j	426 <vprintf+0x60>
        s = va_arg(ap, char*);
 520:	008b0993          	addi	s3,s6,8
 524:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 528:	02090163          	beqz	s2,54a <vprintf+0x184>
        while(*s != 0){
 52c:	00094583          	lbu	a1,0(s2)
 530:	c9a1                	beqz	a1,580 <vprintf+0x1ba>
          putc(fd, *s);
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	dc6080e7          	jalr	-570(ra) # 2fa <putc>
          s++;
 53c:	0905                	addi	s2,s2,1
        while(*s != 0){
 53e:	00094583          	lbu	a1,0(s2)
 542:	f9e5                	bnez	a1,532 <vprintf+0x16c>
        s = va_arg(ap, char*);
 544:	8b4e                	mv	s6,s3
      state = 0;
 546:	4981                	li	s3,0
 548:	bdf9                	j	426 <vprintf+0x60>
          s = "(null)";
 54a:	00000917          	auipc	s2,0x0
 54e:	24690913          	addi	s2,s2,582 # 790 <malloc+0x100>
        while(*s != 0){
 552:	02800593          	li	a1,40
 556:	bff1                	j	532 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 558:	008b0913          	addi	s2,s6,8
 55c:	000b4583          	lbu	a1,0(s6)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	d98080e7          	jalr	-616(ra) # 2fa <putc>
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bd65                	j	426 <vprintf+0x60>
        putc(fd, c);
 570:	85d2                	mv	a1,s4
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	d86080e7          	jalr	-634(ra) # 2fa <putc>
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b565                	j	426 <vprintf+0x60>
        s = va_arg(ap, char*);
 580:	8b4e                	mv	s6,s3
      state = 0;
 582:	4981                	li	s3,0
 584:	b54d                	j	426 <vprintf+0x60>
    }
  }
}
 586:	70e6                	ld	ra,120(sp)
 588:	7446                	ld	s0,112(sp)
 58a:	74a6                	ld	s1,104(sp)
 58c:	7906                	ld	s2,96(sp)
 58e:	69e6                	ld	s3,88(sp)
 590:	6a46                	ld	s4,80(sp)
 592:	6aa6                	ld	s5,72(sp)
 594:	6b06                	ld	s6,64(sp)
 596:	7be2                	ld	s7,56(sp)
 598:	7c42                	ld	s8,48(sp)
 59a:	7ca2                	ld	s9,40(sp)
 59c:	7d02                	ld	s10,32(sp)
 59e:	6de2                	ld	s11,24(sp)
 5a0:	6109                	addi	sp,sp,128
 5a2:	8082                	ret

00000000000005a4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5a4:	715d                	addi	sp,sp,-80
 5a6:	ec06                	sd	ra,24(sp)
 5a8:	e822                	sd	s0,16(sp)
 5aa:	1000                	addi	s0,sp,32
 5ac:	e010                	sd	a2,0(s0)
 5ae:	e414                	sd	a3,8(s0)
 5b0:	e818                	sd	a4,16(s0)
 5b2:	ec1c                	sd	a5,24(s0)
 5b4:	03043023          	sd	a6,32(s0)
 5b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5c0:	8622                	mv	a2,s0
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e04080e7          	jalr	-508(ra) # 3c6 <vprintf>
}
 5ca:	60e2                	ld	ra,24(sp)
 5cc:	6442                	ld	s0,16(sp)
 5ce:	6161                	addi	sp,sp,80
 5d0:	8082                	ret

00000000000005d2 <printf>:

void
printf(const char *fmt, ...)
{
 5d2:	711d                	addi	sp,sp,-96
 5d4:	ec06                	sd	ra,24(sp)
 5d6:	e822                	sd	s0,16(sp)
 5d8:	1000                	addi	s0,sp,32
 5da:	e40c                	sd	a1,8(s0)
 5dc:	e810                	sd	a2,16(s0)
 5de:	ec14                	sd	a3,24(s0)
 5e0:	f018                	sd	a4,32(s0)
 5e2:	f41c                	sd	a5,40(s0)
 5e4:	03043823          	sd	a6,48(s0)
 5e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5ec:	00840613          	addi	a2,s0,8
 5f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5f4:	85aa                	mv	a1,a0
 5f6:	4505                	li	a0,1
 5f8:	00000097          	auipc	ra,0x0
 5fc:	dce080e7          	jalr	-562(ra) # 3c6 <vprintf>
}
 600:	60e2                	ld	ra,24(sp)
 602:	6442                	ld	s0,16(sp)
 604:	6125                	addi	sp,sp,96
 606:	8082                	ret

0000000000000608 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 608:	1141                	addi	sp,sp,-16
 60a:	e422                	sd	s0,8(sp)
 60c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 612:	00000797          	auipc	a5,0x0
 616:	19e7b783          	ld	a5,414(a5) # 7b0 <freep>
 61a:	a805                	j	64a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 61c:	4618                	lw	a4,8(a2)
 61e:	9db9                	addw	a1,a1,a4
 620:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 624:	6398                	ld	a4,0(a5)
 626:	6318                	ld	a4,0(a4)
 628:	fee53823          	sd	a4,-16(a0)
 62c:	a091                	j	670 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 62e:	ff852703          	lw	a4,-8(a0)
 632:	9e39                	addw	a2,a2,a4
 634:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 636:	ff053703          	ld	a4,-16(a0)
 63a:	e398                	sd	a4,0(a5)
 63c:	a099                	j	682 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	6398                	ld	a4,0(a5)
 640:	00e7e463          	bltu	a5,a4,648 <free+0x40>
 644:	00e6ea63          	bltu	a3,a4,658 <free+0x50>
{
 648:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	fed7fae3          	bgeu	a5,a3,63e <free+0x36>
 64e:	6398                	ld	a4,0(a5)
 650:	00e6e463          	bltu	a3,a4,658 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	fee7eae3          	bltu	a5,a4,648 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 658:	ff852583          	lw	a1,-8(a0)
 65c:	6390                	ld	a2,0(a5)
 65e:	02059713          	slli	a4,a1,0x20
 662:	9301                	srli	a4,a4,0x20
 664:	0712                	slli	a4,a4,0x4
 666:	9736                	add	a4,a4,a3
 668:	fae60ae3          	beq	a2,a4,61c <free+0x14>
    bp->s.ptr = p->s.ptr;
 66c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 670:	4790                	lw	a2,8(a5)
 672:	02061713          	slli	a4,a2,0x20
 676:	9301                	srli	a4,a4,0x20
 678:	0712                	slli	a4,a4,0x4
 67a:	973e                	add	a4,a4,a5
 67c:	fae689e3          	beq	a3,a4,62e <free+0x26>
  } else
    p->s.ptr = bp;
 680:	e394                	sd	a3,0(a5)
  freep = p;
 682:	00000717          	auipc	a4,0x0
 686:	12f73723          	sd	a5,302(a4) # 7b0 <freep>
}
 68a:	6422                	ld	s0,8(sp)
 68c:	0141                	addi	sp,sp,16
 68e:	8082                	ret

0000000000000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	7139                	addi	sp,sp,-64
 692:	fc06                	sd	ra,56(sp)
 694:	f822                	sd	s0,48(sp)
 696:	f426                	sd	s1,40(sp)
 698:	f04a                	sd	s2,32(sp)
 69a:	ec4e                	sd	s3,24(sp)
 69c:	e852                	sd	s4,16(sp)
 69e:	e456                	sd	s5,8(sp)
 6a0:	e05a                	sd	s6,0(sp)
 6a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a4:	02051493          	slli	s1,a0,0x20
 6a8:	9081                	srli	s1,s1,0x20
 6aa:	04bd                	addi	s1,s1,15
 6ac:	8091                	srli	s1,s1,0x4
 6ae:	0014899b          	addiw	s3,s1,1
 6b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6b4:	00000517          	auipc	a0,0x0
 6b8:	0fc53503          	ld	a0,252(a0) # 7b0 <freep>
 6bc:	c515                	beqz	a0,6e8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6c0:	4798                	lw	a4,8(a5)
 6c2:	02977f63          	bgeu	a4,s1,700 <malloc+0x70>
 6c6:	8a4e                	mv	s4,s3
 6c8:	0009871b          	sext.w	a4,s3
 6cc:	6685                	lui	a3,0x1
 6ce:	00d77363          	bgeu	a4,a3,6d4 <malloc+0x44>
 6d2:	6a05                	lui	s4,0x1
 6d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6dc:	00000917          	auipc	s2,0x0
 6e0:	0d490913          	addi	s2,s2,212 # 7b0 <freep>
  if(p == (char*)-1)
 6e4:	5afd                	li	s5,-1
 6e6:	a88d                	j	758 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6e8:	00000797          	auipc	a5,0x0
 6ec:	0d078793          	addi	a5,a5,208 # 7b8 <base>
 6f0:	00000717          	auipc	a4,0x0
 6f4:	0cf73023          	sd	a5,192(a4) # 7b0 <freep>
 6f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 6fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 6fe:	b7e1                	j	6c6 <malloc+0x36>
      if(p->s.size == nunits)
 700:	02e48b63          	beq	s1,a4,736 <malloc+0xa6>
        p->s.size -= nunits;
 704:	4137073b          	subw	a4,a4,s3
 708:	c798                	sw	a4,8(a5)
        p += p->s.size;
 70a:	1702                	slli	a4,a4,0x20
 70c:	9301                	srli	a4,a4,0x20
 70e:	0712                	slli	a4,a4,0x4
 710:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 712:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 716:	00000717          	auipc	a4,0x0
 71a:	08a73d23          	sd	a0,154(a4) # 7b0 <freep>
      return (void*)(p + 1);
 71e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 722:	70e2                	ld	ra,56(sp)
 724:	7442                	ld	s0,48(sp)
 726:	74a2                	ld	s1,40(sp)
 728:	7902                	ld	s2,32(sp)
 72a:	69e2                	ld	s3,24(sp)
 72c:	6a42                	ld	s4,16(sp)
 72e:	6aa2                	ld	s5,8(sp)
 730:	6b02                	ld	s6,0(sp)
 732:	6121                	addi	sp,sp,64
 734:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 736:	6398                	ld	a4,0(a5)
 738:	e118                	sd	a4,0(a0)
 73a:	bff1                	j	716 <malloc+0x86>
  hp->s.size = nu;
 73c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 740:	0541                	addi	a0,a0,16
 742:	00000097          	auipc	ra,0x0
 746:	ec6080e7          	jalr	-314(ra) # 608 <free>
  return freep;
 74a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 74e:	d971                	beqz	a0,722 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 750:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 752:	4798                	lw	a4,8(a5)
 754:	fa9776e3          	bgeu	a4,s1,700 <malloc+0x70>
    if(p == freep)
 758:	00093703          	ld	a4,0(s2)
 75c:	853e                	mv	a0,a5
 75e:	fef719e3          	bne	a4,a5,750 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 762:	8552                	mv	a0,s4
 764:	00000097          	auipc	ra,0x0
 768:	b7e080e7          	jalr	-1154(ra) # 2e2 <sbrk>
  if(p == (char*)-1)
 76c:	fd5518e3          	bne	a0,s5,73c <malloc+0xac>
        return 0;
 770:	4501                	li	a0,0
 772:	bf45                	j	722 <malloc+0x92>
