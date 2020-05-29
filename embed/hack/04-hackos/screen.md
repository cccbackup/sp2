# nand2tetris -- HackOs

## Screen

* https://github.com/havivha/Nand2Tetris/blob/master/12/Screen.jack

```jack
class Screen {
    static Array screen;

    // ...
    /** Initializes the Screen. */
    function void init() {
        let screen = 16384;
        let white = false;
        let black = true;
        let white_pixel = 0;
        let black_pixel = 1;
        let cur_colour = black;
        return;
    }

    /** Erases the whole screen. */
    function void clearScreen() {
        var int i;
        let i = 0;
        while( i < 8192 ) {
            let screen[i] = white;
        }
        return;
    }
```