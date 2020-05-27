# libpq for PostgreSQL

* 程式修改自 -- [PostgreSQL C tutorial](http://zetcode.com/db/postgresqlc/)

```
$ make
gcc pqhello.c -o pqhello `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqhello
Version of libpq: 100004
```


## 先做 createdb

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ createdb testdb

```

## pqcreate

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqcreate.c -o pqcreate `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqcreate
NOTICE:  table "cars" does not exist, skipping

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqcreate

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ psql testdb
psql (10.4)
Type "help" for help.

testdb=# SELECT * from Cars
testdb-#
testdb-#
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


```

## pqquery

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqcreate.c -o pqcreate `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqcreate
NOTICE:  table "cars" does not exist, skipping

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqcreate

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ psql testdb
psql (10.4)
Type "help" for help.

testdb=# SELECT * from Cars
testdb-#
testdb-#
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

```

## pqmultirows.c

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqmultirows.c -o pqmultirows `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqmultirows
1 Audi 52642
2 Mercedes 57127
3 Skoda 9000
4 Volvo 29000
5 Bentley 350000

```

## pqprepqre.c

Prepared statements guard against SQL injections and increase performance. When using prepared statements, we use placeholders instead of directly writing the values into the statements.

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqprepare.c -o pqprepare `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqprepare 4
4 Volvo 29000

```

## pqheader.c

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqheader.c -o pqheader `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqheader
There are 3 columns
The column names are:
id
name
price

```

## palisttab.c

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqlisttab.c -o pqlisttab `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqlisttab
cars

```

## pqtransact.c

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ make
gcc pqtransact.c -o pqtransact `pkg-config --cflags libpq` -g -Wall -std=gnu11 -O3 `pkg-config --libs libpq`

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/03-msys2/10-pgsql/c
$ ./pqtransact
pqtransact (UPDATE/INSERT/COMMIT) success!

```

