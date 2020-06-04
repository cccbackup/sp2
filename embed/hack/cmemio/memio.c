#define KEYBD ((volatile short *)24576)
#define SCREEN ((short *)16384)
short *p;

int main() {
    while (1) {
        short keyPressed = (*KEYBD == 0);
        short fill = (keyPressed) ? 0xFFFF : 0;
        for (p=SCREEN; p<KEYBD; p++) {
          if (keyPressed) continue;
            *p = fill;
        }
    }
}
