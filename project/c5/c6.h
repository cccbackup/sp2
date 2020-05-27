#define open(fname, flag, mode) (int)fopen(fname, (flag==0)?"rb":"wb")
#define read(fd, buf, size)  (int)fread(buf, 1, size, (FILE*)fd)
#define write(fd, buf, size) (int)fwrite(buf, 1, size, (FILE*)fd)
#define close(fd) fclose((FILE*)fd)
