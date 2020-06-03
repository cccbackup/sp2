#include <stdio.h>

int main() {
  char buf[] = "aaa bbb ccc ddd eee fff ggg";
  FILE *fp = popen("wc -w", "w");
  fwrite(buf, sizeof(buf), 1, fp);
  pclose(fp);
}
