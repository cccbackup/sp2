#include <mgl2/mgl.h>
int main(int ,char **)
{
  mglGraph gr;
  mglData dat(100);
  char str[32];
  gr.StartGIF("sample.gif");
  for(int i=0;i<40;i++)
  {
    gr.NewFrame();     // start frame
    gr.Box();          // some plotting
    for(int j=0;j<dat.nx;j++)
      dat.a[j]=sin(M_PI*j/dat.nx+M_PI*0.05*i);
    gr.Plot(dat,"b");
    gr.EndFrame();     // end frame
  }
  gr.CloseGIF();
  return 0;
}
