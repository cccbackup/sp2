#include <iostream>
#include <sqlite3.h>

int main() {
  sqlite3 *db;
  int rc = sqlite3_open("test.db", &db);
  if (SQLITE_OK == rc) {
    std::cout << "Opened database successfully \n";
    sqlite3_close(db);
  } else {
    std::cout << "Can't open database: " << sqlite3_errmsg(db) << "\n";
  }
  return 0;
}
