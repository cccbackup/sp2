#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>

int imTop = 0;
int16_t im[32768];
char *jTable[]    = {"","JGT","JEQ","JGE","JLT", "JNE", "JLE", "JMP"};
char *jX86[]      = {"","jg", "je", "jge","jl",  "jne", "jle", "jmp"};
char *jX86Neg[]   = {"","jle","jne","jl", "jge", "je",  "jg",  "jmp"};
char *dTable[]    = {"", "M", "D",  "MD", "A",   "AM",  "AD",  "AMD"};

int disasm(uint16_t *im, int16_t imTop, char *fileHead) {
  char sFileName[100], cFileName[100];
  sprintf(sFileName, "%s.s", fileHead);
  FILE *sFile = fopen(sFileName, "w");
  int16_t D = 0, A = 0, PC = 0;
  uint16_t I = 0;
  uint16_t a, c, d, j;
  char hCode[100], sCode[1000], cCode[1000];
	fprintf(sFile, "	.text\n	.globl	_hcode\n	.def	_hcode;	.scl	2;	.type	32;	.endef\n_hcode:\n	pushl	%%ebp\n	movl	%%esp, %%ebp\n	subl	$48, %%esp\n");
  for (int PC = 0; PC<imTop; PC++) {
    I = im[PC];
    if ((I & 0x8000) == 0) { // A 指令
      sprintf(hCode, "@%d", I);
      printf("%s\n", hCode);
      fprintf(sFile, "L%d: # %s\n	movw $%d, %%ax\n", PC, hCode, I);
    } else { // C 指令
      a = (I & 0x1000) >> 12;
      c = (I & 0x0FC0) >>  6;
      d = (I & 0x0038) >>  3;
      j = (I & 0x0007) >>  0;
      char op[10] = "", xop[100];
      char AM = (a == 0) ? 'A' : 'M';
      switch (c) { // 處理 c1..6, 計算 aluOut
        case 0x2A: sprintf(op, "0"); // "0",   "101010"
          sprintf(xop, "	movw $0, %%bx"); break;
        case 0x3F: sprintf(op, "1"); // "1",   "111111"
          sprintf(xop, "	movw $1, %%bx"); break;
        case 0x3A: sprintf(op, "-1"); // "-1",  "111010"
          sprintf(xop, "	movw $-1, %%bx"); break;
        case 0x0C: sprintf(op, "D"); // "D",   "001100"
          sprintf(xop, "	movw %%dx, %%bx"); break;
        case 0x30: sprintf(op, "%c", AM); // "AM",  "110000"
          if (a == 0)
            sprintf(xop, "	movw %%ax, %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx"); break;
        case 0x0D: sprintf(op, "!D"); // "!D",  "001101"
          sprintf(xop, "	testw	%%dx, %%dx\n	sete %%bl"); break;
        case 0x31: sprintf(op, "!%c", AM); // "!AM", "110001"
          if (a == 0)
            sprintf(xop, "	testw	%%ax, %%ax\n	sete %%bl");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	%%testw	%%bx, %%bx\n	sete %%bl");
          break;
        case 0x0F: sprintf(op, "-D");
            sprintf(xop, "	movw %%dx, %%bx\n	negw %%bx"); break; // "-D",  "001111"
        case 0x33: sprintf(op, "-%c", AM); // "-AM", "110011"
          if (a == 0)
            sprintf(xop, "	movw %%ax, %%bx\n	negw %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	negw %%bx");
          break;
        case 0x1F: sprintf(op, "D+1"); // "D+1", "011111"
          sprintf(xop, "	movw %%dx, %%bx\n	addw $1, %%bx");
          break;
        case 0x37: sprintf(op, "%c+1", AM); // "AM+1","110111"
          if (a == 0)
            sprintf(xop, "	movw %%ax, %%bx\n	addw $1, %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	addw $1, %%bx");
          break;
        case 0x0E: sprintf(op, "D-1"); // "D-1", "001110"
          sprintf(xop, "	movw %%dx, %%bx\n	subw $1, %%bx");
          break;
        case 0x32: sprintf(op, "%c-1", AM); // "AM-1","110010"
          if (a == 0)
            sprintf(xop, "	movw %%ax, %%bx\n	subw $1, %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	subw $1, %%bx");
          break;
        case 0x02: sprintf(op, "D+%c", AM); // "D+AM","000010"
          if (a == 0)
            sprintf(xop, "	movw %%dx, %%bx\n	addw %%ax, %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	addw %%dx, %%bx");
          break;
        case 0x13: sprintf(op, "D-%c", AM); // "D-AM","010011"
          if (a == 0)
            sprintf(xop, "	movw %%dx, %%bx\n	subw %%ax, %%bx");
          else
            sprintf(xop, "	movw %%dx, %%bx\n	movw _m(%%eax,%%eax), %%cx\n	subw %%cx, %%bx");
          break;
        case 0x07: sprintf(op, "%c-D", AM); // "AM-D","000111"
          if (a == 0)
            sprintf(xop, "	movw %%ax, %%bx\n	subw %%dx, %%bx");
          else
            sprintf(xop, "	movw _m(%%eax,%%eax), %%bx\n	subw %%dx, %%bx");
          break;
        case 0x00: sprintf(op, "D&%c", AM); // "D&AM","000000"
          if (a == 0)
            sprintf(xop, "	movw %%dx, %%bx\n	andw %%ax, %%bx");
          else
            sprintf(xop, "	movw %%dx, %%bx\n	movw _m(%%eax,%%eax), %%cx\n	andw %%cx, %%bx");
          break;
        case 0x15: sprintf(op, "D|%c", AM); // "D|AM","010101"
          if (a == 0)
            sprintf(xop, "	movw %%dx, %%bx\n	orw %%ax, %%bx");
          else
            sprintf(xop, "	movw %%dx, %%bx\n	movw _m(%%eax,%%eax), %%cx\n	orw %%cx, %%bx");
          break;
        default: assert(0);
      }
      char head[100]="";
      if (d != 0) sprintf(head, "%s=", dTable[d]);
      if (op[0] != '\0') strcat(head, op);
      if (j != 0) 
        sprintf(hCode, "%s;%s", head, jTable[j]);
      else
        sprintf(hCode, "%s", head);

      printf("%s\n", hCode);
      fprintf(sFile, "L%d: # %s\n", PC, hCode);

      char dAsmCode[100] = "";
      if ((d & 0x01)!=0) strcat(dAsmCode, "\n	movw %bx, _m(%eax,%eax)");
      if ((d & 0x02)!=0) strcat(dAsmCode, "\n	movw %bx, %dx");
      if ((d & 0x04)!=0) strcat(dAsmCode, "\n	movw %bx, %ax");

      char jAsmCode[200] = "";
      if (j != 0) {
        if (j == 7)
          sprintf(jAsmCode, "\n	jmp ToLA");
        else {
          sprintf(jAsmCode, "\n	cmpw $0, %%bx\n	%s ToLA", jX86[j]);
        }
      }
      fprintf(sFile, "%s%s%s\n", xop, dAsmCode, jAsmCode);
    }
  }
  fputs("	movw	%ax, _A\n	movw	%dx, _D\n	nop\n	leave\n	ret\n"
        "ToLA:\n# +printf\n	movl	%edx, 16(%esp)\n	movl	%ecx, 12(%esp)\n	movl	%ebx, 8(%esp)\n	movl	%eax, 4(%esp)\n	movl	$LC0, (%esp)\n	call	_printf\n	movl  4(%esp), %eax\n	movl  8(%esp), %ebx\n	movl  12(%esp), %ecx\n	movl  16(%esp), %edx\n# -printf\n	movl %eax, %ecx\n	sall $2, %ecx\n	addl $JumpTable, %ecx\n	movl (%ecx), %ecx\n	jmp *%ecx\n"
        ".section .rdata,\"dr\"\nLC0:\n	.ascii \"eax=%d ebx=%d ecx=%d edx=%d\\12\\0\"\n	.align 4\nJumpTable:\n", sFile);
  for (int PC = 0; PC<imTop; PC++) {
    fprintf(sFile, "	.long L%d\n", PC);
  }
  fprintf(sFile, "	.text\n");
  fclose(sFile);
}

// run: ./disasm <file.bin>
int main(int argc, char *argv[]) {
  char binFileName[100];
  sprintf(binFileName, "%s.bin", argv[1]);
  FILE *binFile = fopen(binFileName, "rb");
  imTop = fread(im, sizeof(uint16_t), 32768, binFile);
  fclose(binFile);
  disasm(im, imTop, argv[1]);
}
