#include <elf.h>
#include <stdio.h>
#include <string.h>

void print_ehdr(Elf64_Ehdr *h) {
  printf("============== ehdr ==================\n");
  printf("e_type=%d\n", h->e_type);
  printf("e_machine=%d\n", h->e_machine);
  printf("e_version=0x%x\n", h->e_version);
  printf("e_entry=0x%lx\n", h->e_entry);
  printf("e_phoff=%ld\n", h->e_phoff);
  printf("e_shoff=%ld\n", h->e_shoff);
  printf("e_flags=0x%x\n", h->e_flags);
  printf("e_ehsize=%d\n", h->e_ehsize);
  printf("e_phentsize=%d\n", h->e_phentsize);
  printf("e_phnum=%d\n", h->e_phnum);
  printf("e_shentsize=%d\n", h->e_shentsize);
  printf("e_shnum=%d\n", h->e_shnum);
  printf("e_shstrndx=%d\n", h->e_shstrndx);
}

void print_shdr(FILE *file, Elf64_Ehdr *h) {
  // Section Headers:
  //   [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  //   [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  //   [ 1] .interp           PROGBITS        0000000000000238 000238 00001c 00   A  0   0  1
  printf("Section Headers:\n");
  printf("  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al\n");
  fseek(file, h->e_shoff, SEEK_SET);

  for (int i=0; i < h->e_shnum; i++) {
    Elf64_Shdr shdr;
    fread(&shdr, 1, sizeof(shdr), file);
    printf("       %-17x %-15x %016lx %06lx %06lx %02lx %3lx %2d %3d %2ld\n", shdr.sh_name, shdr.sh_type, shdr.sh_addr, shdr.sh_offset, shdr.sh_size, shdr.sh_entsize, shdr.sh_flags, shdr.sh_link, shdr.sh_info, shdr.sh_addralign);
  }
}

void print_phdr(FILE *file, Elf64_Ehdr *h) {
// Program Headers:
//   Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
//   PHDR           0x000040 0x0000000000000040 0x0000000000000040 0x0001f8 0x0001f8 R   0x8
//   INTERP         0x000238 0x0000000000000238 0x0000000000000238 0x00001c 0x00001c R   0x1
  printf("Program Headers:\n");
  printf("  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align\n");
  fseek(file, h->e_phoff, SEEK_SET);

  for (int i=0; i < h->e_shnum; i++) {
    Elf64_Phdr phdr;
    fread(&phdr, 1, sizeof(phdr), file);
    printf("  %-14x 0x%06lx 0x%016lx 0x%016lx 0x%06lx 0x%06lx %3x 0x%lx\n", phdr.p_type, phdr.p_offset, phdr.p_vaddr, phdr.p_paddr, phdr.p_filesz, phdr.p_memsz, phdr.p_flags, phdr.p_align);
  }
}

void read_elf(const char* elfFile) {
  // switch to Elf32_Ehdr for x86 architecture.
  Elf64_Ehdr ehdr;
  Elf64_Sym  sym;
  Elf64_Rela rela;

  FILE* file = fopen(elfFile, "rb");
  if(file) {
    // read the ehdr
    fread(&ehdr, 1, sizeof(ehdr), file);

    // check so its really an elf file
    if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) == 0) {
       // this is a valid elf file
       print_ehdr(&ehdr);
       print_shdr(file, &ehdr);
       print_phdr(file, &ehdr);
    }

    // finally close the file
    fclose(file);
  }
}



int main() {
  read_elf("elf4");
}