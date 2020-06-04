#include <mgl2/mgl_cf.h>
int main()
{
  HMGL gr = mgl_create_graph(600,400);
  mgl_fplot(gr,"sin(pi*x)","","");
  mgl_write_frame(gr,"test.png","");
  mgl_delete_graph(gr);
}
