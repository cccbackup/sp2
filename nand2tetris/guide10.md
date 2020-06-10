# nand2tetris -- 第 10 章指引

# 編譯器

* 詞彙掃描 (lexer)
* 語法剖析 (parser)
* 代碼產生 (codegen)

## 手動作法

參考: nand2tetris 

* [第 4 章 -- 從 C 到組合語言](./04)
* [第 6 章 -- 從組合語言到機器碼](./06)

## 授課內容

1. 先用簡單運算式編譯器講解 BNF, EBNF 語法
    * https://github.com/ccccourse/sp/tree/master/code/c/02-compiler/00-exp0
2. 詞彙掃描 Lexer (Scanner)
    * https://github.com/ccccourse/sp/tree/master/code/c/02-compiler/02-lexer
3. 用 EBNF 語法描述 IF, WHILE, ...
    * https://github.com/ccccourse/sp/tree/master/code/c/02-compiler/03-compiler
4. 觀看更完整的 Lua 程式與語法
    * Lua 範例 -- https://en.wikipedia.org/wiki/Lua_(programming_language)
    * Lua 語法 -- https://www.lua.org/manual/5.1/manual.html (看 8 – The Complete Syntax of Lua)
5. 看 Jack 的程式與語法
    * 範例 -- https://drive.google.com/file/d/1rbHGZV8AK4UalmdJyivgt0fpPiD1Q6Vk/view (一開始就有範例，68 頁開始描述詞彙)
    * 語法 -- https://drive.google.com/file/d/1ujgcS7GoI-zu56FxhfkTAvEgZ6JT7Dxl/view
    * 目的碼產生 -- https://drive.google.com/file/d/1DfGKr0fuJcCvlIPABNSg7fsLfFFqRLex/view
6. 試著閱讀我的 js 版編譯器 -- https://github.com/ccccourse/sp/tree/master/code/nand2tetris/11/js
    * 詞彙掃描 -- https://github.com/ccccourse/sp/blob/master/code/nand2tetris/11/js/lexer.js
    * 語法剖析 -- https://github.com/ccccourse/sp/blob/master/code/nand2tetris/11/js/parser.js
    * 程式碼產生 -- https://github.com/ccccourse/sp/blob/master/code/nand2tetris/11/js/code_generator.js
    * 編譯器 -- https://github.com/ccccourse/sp/blob/master/code/nand2tetris/11/js/compiler.js

## 參考專案

* https://github.com/embedded2015/rubi
* https://github.com/jserv/amacc (1500 行)
    * 基於 https://github.com/rswier/c4/blob/master/c4.c (500 行)
