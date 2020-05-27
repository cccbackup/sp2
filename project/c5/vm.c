#ifdef __VM__
  oFile = argv[1];
  obj_load();
  vm_main(pc, argc, argv);
#endif