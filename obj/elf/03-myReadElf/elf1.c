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
    }

    // finally close the file
    fclose(file);
  }
}

int main() {
  read_elf_header("elf1");
}