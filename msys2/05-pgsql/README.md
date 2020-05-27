# PostgreSQL

* [新手教學- PostgreSQL 正體中文使用手冊](https://docs.postgresql.tw/tutorial)
    * [1.3. 建立一個資料庫](https://docs.postgresql.tw/tutorial/getting-started/creating-a-database)
    * [1.4. 存取一個資料庫](https://docs.postgresql.tw/tutorial/getting-started/accessing-a-database)
    * [2. SQL 查詢語言](https://docs.postgresql.tw/tutorial/the-sql-language)

## 基本操作


```
Tim@DESKTOP-QOC5V2F MINGW64 /d/ccc/sp/code/c/06-os1windows/04-pacman/05-pgsql

$ mkdir pgdata

$ createdb mydb

$ psql mydb
psql (12.2)
Type "help" for help.

// 然後照著文件操作，從 1.3 直到 2.9 為止。
// https://docs.postgresql.tw/tutorial/

$ cd c

$ ls
Makefile    pqhello.c      pqprepare.c  pqtransact.c  setting.h
pqcreate.c  pqlisttab.c    pqquery.c    README.md
pqheader.c  pqmultirows.c  pqserver.c   run.md

$ make

gcc pqhello.c -o pqhello `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqserver.c -o pqserver `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqcreate.c -o pqcreate `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqquery.c -o pqquery `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqmultirows.c -o pqmultirows `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqprepare.c -o pqprepare `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqheader.c -o pqheader `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqlisttab.c -o pqlisttab `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`
gcc pqtransact.c -o pqtransact `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

$ createdb testdb

$ ./pqcreate

$ ./pqmultirows
1 Audi 52642
2 Mercedes 57127
3 Skoda 9000
4 Volvo 29000
5 Bentley 350000

$ ./pqlisttab
cars

$ psql testdb
psql (12.2)
Type "help" for help.

testdb=# SELECT * from Cars
testdb-# ;
 id |    name    | price
----+------------+--------
  1 | Audi       |  52642
  2 | Mercedes   |  57127
  3 | Skoda      |   9000
  4 | Volvo      |  29000
  5 | Bentley    | 350000
  6 | Citroen    |  21000
  7 | Hummer     |  41400
  8 | Volkswagen |  21600
(8 rows)

testdb=# \q

// 然後就跳出 pgsql 回到 shell 了！
```

## 詳細操作

* [install](install)
* [sql](sql)
* [c](c)
