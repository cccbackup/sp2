# nand2tetris -- HackOs

## Sys

```jack
class Sys {

    /** Performs all the initializations required by the OS. */
    function void init() {
        do Math.init();
        do Output.init();
        do Screen.init();
        do Keyboard.init();
        do Memory.init();
        do Main.main();
        do Sys.halt();
        return;
    }
    // ...
```
