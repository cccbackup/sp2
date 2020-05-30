# nand2tetris -- HackOs

## Output

* https://github.com/havivha/Nand2Tetris/blob/master/12/Output.jack

```jack
class Output {

    // Character map for printing on the left of a screen word
    static Array charMaps; 
    
    static int cursor_x, cursor_y;
    
    static Array screen;
    static Array charMasks;

    /** Initializes the screen and locates the cursor at the screen's top-left. */
    function void init() {
        let screen = 16384;
        let cursor_x = 0;
        let cursor_y = 0;
        let charMasks = Array.new(2);
        let charMasks[0] = 255;
        let charMasks[1] = -1 & 255;
        do Output.initMap();
        return;
    }
    // ...

    // Initalizes the character map array
    function void initMap() {
        var int i;
    
        let charMaps = Array.new(127);
        
        // black square (used for non printable characters)
        do Output.create(0,63,63,63,63,63,63,63,63,63,0,0);

        // Assigns the bitmap for each character in the charachter set.
        do Output.create(32,0,0,0,0,0,0,0,0,0,0,0);          //
        do Output.create(33,12,30,30,30,12,12,0,12,12,0,0);  // !
        do Output.create(34,54,54,20,0,0,0,0,0,0,0,0);       // "
        do Output.create(35,0,18,18,63,18,18,63,18,18,0,0);  // #
    // ...
    // Creates a character map array of the given char index with the given values.
    function void create(int index, int a, int b, int c, int d, int e,
		         int f, int g, int h, int i, int j, int k) {
        var Array map;

        let map = Array.new(11);
        let charMaps[index] = map;

        let map[0] = a;
        let map[1] = b;
        let map[2] = c;
        let map[3] = d;
        let map[4] = e;
        let map[5] = f;
        let map[6] = g;
        let map[7] = h;
        let map[8] = i;
        let map[9] = j;
        let map[10] = k;

        return;
    }

    // ...
    /** Prints c at the cursor location and advances the cursor one
     *  column forward. */
    function void printChar(char c) {
        var Array map;
        var int address;
        var int mask;
        var int bitmap;
        var int i;
        
        // Get the character bitmap
        let map = Output.getMap(c);
        let address = (cursor_y*32*11) + (cursor_x/2);
        let mask = cursor_x & 1;
        
        // Print the character
        let i = 0;
        while( i < 11 ) {
            let bitmap = map[i];
            if( mask = 1 ) {
                let bitmap = bitmap * 256;
            }
            let screen[address] = screen[address] & charMasks[mask] | bitmap;
            let address = address + 32;
            let i = i + 1;
        }
        
        // Advance the cursor
        if( cursor_x = 63 ) {
            do Output.println();
        }
        else {
            let cursor_x = cursor_x + 1;
        }
        
        return;
    }
    // ...
```