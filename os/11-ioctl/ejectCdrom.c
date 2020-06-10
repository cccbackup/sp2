// http://discourse-production.oss-cn-shanghai.aliyuncs.com/original/3X/f/4/f4c905949ecd71ab2889b4fd10b1e11910b67460.pdf
// 144 頁
#include <fcntl.h>
#include <linux/cdrom.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
int main (int argc, char* argv[])
{
  /* Open a file descriptor to the device specified on the command line. */
  int fd = open (argv[1], O_RDONLY);
  /* Eject the CD-ROM. */
  ioctl (fd, CDROMEJECT);
  /* Close the file descriptor. */
  close (fd);
  return 0;
}