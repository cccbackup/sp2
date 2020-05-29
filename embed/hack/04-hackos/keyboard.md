# nand2tetris -- HackOs

## Keyboard

* https://github.com/havivha/Nand2Tetris/blob/master/12/Keyboard.jack

```jack
class Keyboard {
    static Array keyboard;
    
    /** Initializes the keyboard. */
    function void init() {
        let keyboard = 24576;
        return;
    }

    // ...
    function char keyPressed() {
        return keyboard[0];
    }
```
