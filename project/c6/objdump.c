#ifdef __OBJDUMP__
  oFile = argv[1];
  obj_load();
  obj_dump();
#endif