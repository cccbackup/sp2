#include <elf.h>
#include <stdio.h>
#include <string.h>

void read_elf_header(const char* elfFile) {
  // switch to Elf32_Ehdr for x86 architecture.
  Elf64_Ehdr header;

  FILE* file = fopen(elfFile, "rb");
  if(file) {
    // read the header
    fread(&header, 1, sizeof(header), file);

    // check so its really an elf file
    if (memcmp(header.e_ident, ELFMAG, SELFMAG) == 0) {
       // this is a valid elf file
       printf("e_type=%d\n", header.e_type);
       printf("e_machine=%d\n", header.e_machine);
       printf("e_version=%d\n", header.e_version);
       printf("e_entry=%ld\n", header.e_entry);
       printf("e_phoff=%ld\n", header.e_phoff);
       printf("e_shoff=%ld\n", header.e_shoff);
       printf("e_flags=%d\n", header.e_flags);
       printf("e_ehsize=%d\n", header.e_ehsize);
       printf("e_phentsize=%d\n", header.e_phentsize);
       printf("e_phnum=%d\n", header.e_phnum);
       printf("e_shentsize=%d\n", header.e_shentsize);
       printf("e_shnum=%d\n", header.e_shnum);
       printf("e_shstrndx=%d\n", header.e_shstrndx);
    }

    // finally close the file
    fclose(file);
  }
}

int main() {
  read_elf_header("elf2");
}