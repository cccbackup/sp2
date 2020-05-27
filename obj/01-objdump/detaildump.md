# bintool

## hello.c

```
PS D:\ccc\course\sp\code\c\05-objfile\bintool> objdump hello.o -hd

hello.o:     file format pe-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000024  00000000  00000000  000000dc  2**2
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000000  00000000  00000000  00000000  2**2
                  ALLOC, LOAD, DATA
  2 .bss          00000000  00000000  00000000  00000000  2**2
                  ALLOC
  3 .rdata        00000008  00000000  00000000  00000100  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .rdata$zzz    00000014  00000000  00000000  00000108  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA

Disassembly of section .text:

00000000 <_main>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   83 e4 f0                and    $0xfffffff0,%esp
   6:   83 ec 10                sub    $0x10,%esp
   9:   e8 00 00 00 00          call   e <_main+0xe>
   e:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
  15:   e8 00 00 00 00          call   1a <_main+0x1a>
  1a:   b8 00 00 00 00          mov    $0x0,%eax
  1f:   c9                      leave
  20:   c3                      ret
  21:   90                      nop
  22:   90                      nop
  23:   90                      nop
```

## sum.c

```
PS D:\ccc\course\sp\code\c\05-objfile\bintool> objdump sum.o -hd

sum.o:     file format pei-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000ca4  00401000  00401000  00000400  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE, DATA
  1 .data         00000010  00402000  00402000  00001200  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .rdata        00000130  00403000  00403000  00001400  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .eh_frame     000003a0  00404000  00404000  00001600  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .bss          00000060  00405000  00405000  00000000  2**2
                  ALLOC
  5 .idata        0000037c  00406000  00406000  00001a00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  6 .CRT          00000018  00407000  00407000  00001e00  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  7 .tls          00000020  00408000  00408000  00002000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  8 .debug_aranges 00000018  00409000  00409000  00002200  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_info   00000dc5  0040a000  0040a000  00002400  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_abbrev 000000a9  0040b000  0040b000  00003200  2**0
                  CONTENTS, READONLY, DEBUGGING
 11 .debug_line   000000d1  0040c000  0040c000  00003400  2**0
                  CONTENTS, READONLY, DEBUGGING

Disassembly of section .text:

00401000 <___mingw_CRTStartup>:
  401000:	53                   	push   %ebx
  401001:	83 ec 38             	sub    $0x38,%esp
  401004:	a1 30 30 40 00       	mov    0x403030,%eax
  401009:	85 c0                	test   %eax,%eax
  40100b:	74 1c                	je     401029 <___mingw_CRTStartup+0x29>
  40100d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  401014:	00 
  401015:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  40101c:	00 
  40101d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  401024:	ff d0                	call   *%eax
  401026:	83 ec 0c             	sub    $0xc,%esp
  401029:	c7 04 24 10 11 40 00 	movl   $0x401110,(%esp)
  401030:	e8 e3 0b 00 00       	call   401c18 <_SetUnhandledExceptionFilter@4>
  401035:	83 ec 04             	sub    $0x4,%esp
  401038:	e8 73 04 00 00       	call   4014b0 <___cpu_features_init>
  40103d:	e8 4e 05 00 00       	call   401590 <__fpreset>
  401042:	8d 44 24 2c          	lea    0x2c(%esp),%eax
  401046:	89 44 24 10          	mov    %eax,0x10(%esp)
  40104a:	a1 00 20 40 00       	mov    0x402000,%eax
  40104f:	c7 44 24 04 00 50 40 	movl   $0x405000,0x4(%esp)
  401056:	00 
  401057:	c7 04 24 04 50 40 00 	movl   $0x405004,(%esp)
  40105e:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  401065:	00 
  401066:	89 44 24 0c          	mov    %eax,0xc(%esp)
  40106a:	8d 44 24 28          	lea    0x28(%esp),%eax
  40106e:	89 44 24 08          	mov    %eax,0x8(%esp)
  401072:	e8 39 0b 00 00       	call   401bb0 <___getmainargs>
  401077:	a1 18 50 40 00       	mov    0x405018,%eax
  40107c:	85 c0                	test   %eax,%eax
  40107e:	74 42                	je     4010c2 <___mingw_CRTStartup+0xc2>
  401080:	8b 1d 00 61 40 00    	mov    0x406100,%ebx
  401086:	a3 04 20 40 00       	mov    %eax,0x402004
  40108b:	89 44 24 04          	mov    %eax,0x4(%esp)
  40108f:	8b 43 10             	mov    0x10(%ebx),%eax
  401092:	89 04 24             	mov    %eax,(%esp)
  401095:	e8 1e 0b 00 00       	call   401bb8 <__setmode>
  40109a:	a1 18 50 40 00       	mov    0x405018,%eax
  40109f:	89 44 24 04          	mov    %eax,0x4(%esp)
  4010a3:	8b 43 30             	mov    0x30(%ebx),%eax
  4010a6:	89 04 24             	mov    %eax,(%esp)
  4010a9:	e8 0a 0b 00 00       	call   401bb8 <__setmode>
  4010ae:	a1 18 50 40 00       	mov    0x405018,%eax
  4010b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  4010b7:	8b 43 50             	mov    0x50(%ebx),%eax
  4010ba:	89 04 24             	mov    %eax,(%esp)
  4010bd:	e8 f6 0a 00 00       	call   401bb8 <__setmode>
  4010c2:	e8 f9 0a 00 00       	call   401bc0 <___p__fmode>
  4010c7:	8b 15 04 20 40 00    	mov    0x402004,%edx
  4010cd:	89 10                	mov    %edx,(%eax)
  4010cf:	e8 3c 06 00 00       	call   401710 <__pei386_runtime_relocator>
  4010d4:	83 e4 f0             	and    $0xfffffff0,%esp
  4010d7:	e8 94 08 00 00       	call   401970 <___main>
  4010dc:	e8 e7 0a 00 00       	call   401bc8 <___p__environ>
  4010e1:	8b 00                	mov    (%eax),%eax
  4010e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  4010e7:	a1 00 50 40 00       	mov    0x405000,%eax
  4010ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  4010f0:	a1 04 50 40 00       	mov    0x405004,%eax
  4010f5:	89 04 24             	mov    %eax,(%esp)
  4010f8:	e8 80 02 00 00       	call   40137d <_main>
  4010fd:	89 c3                	mov    %eax,%ebx
  4010ff:	e8 cc 0a 00 00       	call   401bd0 <__cexit>
  401104:	89 1c 24             	mov    %ebx,(%esp)
  401107:	e8 14 0b 00 00       	call   401c20 <_ExitProcess@4>
  40110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00401110 <__gnu_exception_handler@4>:
  401110:	53                   	push   %ebx
  401111:	83 ec 28             	sub    $0x28,%esp
  401114:	8b 44 24 30          	mov    0x30(%esp),%eax
  401118:	8b 00                	mov    (%eax),%eax
  40111a:	8b 00                	mov    (%eax),%eax
  40111c:	3d 91 00 00 c0       	cmp    $0xc0000091,%eax
  401121:	77 3d                	ja     401160 <__gnu_exception_handler@4+0x50>
  401123:	3d 8d 00 00 c0       	cmp    $0xc000008d,%eax
  401128:	72 4d                	jb     401177 <__gnu_exception_handler@4+0x67>
  40112a:	bb 01 00 00 00       	mov    $0x1,%ebx
  40112f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  401136:	00 
  401137:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  40113e:	e8 95 0a 00 00       	call   401bd8 <_signal>
  401143:	83 f8 01             	cmp    $0x1,%eax
  401146:	0f 84 f4 00 00 00    	je     401240 <__gnu_exception_handler@4+0x130>
  40114c:	85 c0                	test   %eax,%eax
  40114e:	0f 85 a0 00 00 00    	jne    4011f4 <__gnu_exception_handler@4+0xe4>
  401154:	31 c0                	xor    %eax,%eax
  401156:	83 c4 28             	add    $0x28,%esp
  401159:	5b                   	pop    %ebx
  40115a:	c2 04 00             	ret    $0x4
  40115d:	8d 76 00             	lea    0x0(%esi),%esi
  401160:	3d 94 00 00 c0       	cmp    $0xc0000094,%eax
  401165:	74 4b                	je     4011b2 <__gnu_exception_handler@4+0xa2>
  401167:	3d 96 00 00 c0       	cmp    $0xc0000096,%eax
  40116c:	74 17                	je     401185 <__gnu_exception_handler@4+0x75>
  40116e:	3d 93 00 00 c0       	cmp    $0xc0000093,%eax
  401173:	75 df                	jne    401154 <__gnu_exception_handler@4+0x44>
  401175:	eb b3                	jmp    40112a <__gnu_exception_handler@4+0x1a>
  401177:	3d 05 00 00 c0       	cmp    $0xc0000005,%eax
  40117c:	74 42                	je     4011c0 <__gnu_exception_handler@4+0xb0>
  40117e:	3d 1d 00 00 c0       	cmp    $0xc000001d,%eax
  401183:	75 cf                	jne    401154 <__gnu_exception_handler@4+0x44>
  401185:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  40118c:	00 
  40118d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  401194:	e8 3f 0a 00 00       	call   401bd8 <_signal>
  401199:	83 f8 01             	cmp    $0x1,%eax
  40119c:	74 69                	je     401207 <__gnu_exception_handler@4+0xf7>
  40119e:	85 c0                	test   %eax,%eax
  4011a0:	74 b2                	je     401154 <__gnu_exception_handler@4+0x44>
  4011a2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  4011a9:	ff d0                	call   *%eax
  4011ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4011b0:	eb a4                	jmp    401156 <__gnu_exception_handler@4+0x46>
  4011b2:	31 db                	xor    %ebx,%ebx
  4011b4:	e9 76 ff ff ff       	jmp    40112f <__gnu_exception_handler@4+0x1f>
  4011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4011c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  4011c7:	00 
  4011c8:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  4011cf:	e8 04 0a 00 00       	call   401bd8 <_signal>
  4011d4:	83 f8 01             	cmp    $0x1,%eax
  4011d7:	74 4a                	je     401223 <__gnu_exception_handler@4+0x113>
  4011d9:	85 c0                	test   %eax,%eax
  4011db:	0f 84 73 ff ff ff    	je     401154 <__gnu_exception_handler@4+0x44>
  4011e1:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  4011e8:	ff d0                	call   *%eax
  4011ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4011ef:	e9 62 ff ff ff       	jmp    401156 <__gnu_exception_handler@4+0x46>
  4011f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  4011fb:	ff d0                	call   *%eax
  4011fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  401202:	e9 4f ff ff ff       	jmp    401156 <__gnu_exception_handler@4+0x46>
  401207:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  40120e:	00 
  40120f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  401216:	e8 bd 09 00 00       	call   401bd8 <_signal>
  40121b:	83 c8 ff             	or     $0xffffffff,%eax
  40121e:	e9 33 ff ff ff       	jmp    401156 <__gnu_exception_handler@4+0x46>
  401223:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  40122a:	00 
  40122b:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  401232:	e8 a1 09 00 00       	call   401bd8 <_signal>
  401237:	83 c8 ff             	or     $0xffffffff,%eax
  40123a:	e9 17 ff ff ff       	jmp    401156 <__gnu_exception_handler@4+0x46>
  40123f:	90                   	nop
  401240:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  401247:	00 
  401248:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  40124f:	e8 84 09 00 00       	call   401bd8 <_signal>
  401254:	85 db                	test   %ebx,%ebx
  401256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  40125b:	0f 84 f5 fe ff ff    	je     401156 <__gnu_exception_handler@4+0x46>
  401261:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  401265:	e8 26 03 00 00       	call   401590 <__fpreset>
  40126a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  40126e:	e9 e3 fe ff ff       	jmp    401156 <__gnu_exception_handler@4+0x46>
  401273:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  401279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00401280 <_mainCRTStartup>:
  401280:	83 ec 1c             	sub    $0x1c,%esp
  401283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  40128a:	ff 15 f8 60 40 00    	call   *0x4060f8
  401290:	e8 6b fd ff ff       	call   401000 <___mingw_CRTStartup>
  401295:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

004012a0 <_WinMainCRTStartup>:
  4012a0:	83 ec 1c             	sub    $0x1c,%esp
  4012a3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4012aa:	ff 15 f8 60 40 00    	call   *0x4060f8
  4012b0:	e8 4b fd ff ff       	call   401000 <___mingw_CRTStartup>
  4012b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  4012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

004012c0 <_atexit>:
  4012c0:	a1 10 61 40 00       	mov    0x406110,%eax
  4012c5:	ff e0                	jmp    *%eax
  4012c7:	89 f6                	mov    %esi,%esi
  4012c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

004012d0 <__onexit>:
  4012d0:	a1 04 61 40 00       	mov    0x406104,%eax
  4012d5:	ff e0                	jmp    *%eax
  4012d7:	90                   	nop
  4012d8:	90                   	nop
  4012d9:	90                   	nop
  4012da:	90                   	nop
  4012db:	90                   	nop
  4012dc:	90                   	nop
  4012dd:	90                   	nop
  4012de:	90                   	nop
  4012df:	90                   	nop

004012e0 <___gcc_register_frame>:
  4012e0:	55                   	push   %ebp
  4012e1:	89 e5                	mov    %esp,%ebp
  4012e3:	83 ec 18             	sub    $0x18,%esp
  4012e6:	a1 0c 20 40 00       	mov    0x40200c,%eax
  4012eb:	85 c0                	test   %eax,%eax
  4012ed:	74 3a                	je     401329 <___gcc_register_frame+0x49>
  4012ef:	c7 04 24 00 30 40 00 	movl   $0x403000,(%esp)
  4012f6:	e8 2d 09 00 00       	call   401c28 <_GetModuleHandleA@4>
  4012fb:	83 ec 04             	sub    $0x4,%esp
  4012fe:	85 c0                	test   %eax,%eax
  401300:	ba 00 00 00 00       	mov    $0x0,%edx
  401305:	74 15                	je     40131c <___gcc_register_frame+0x3c>
  401307:	c7 44 24 04 0e 30 40 	movl   $0x40300e,0x4(%esp)
  40130e:	00 
  40130f:	89 04 24             	mov    %eax,(%esp)
  401312:	e8 19 09 00 00       	call   401c30 <_GetProcAddress@8>
  401317:	83 ec 08             	sub    $0x8,%esp
  40131a:	89 c2                	mov    %eax,%edx
  40131c:	85 d2                	test   %edx,%edx
  40131e:	74 09                	je     401329 <___gcc_register_frame+0x49>
  401320:	c7 04 24 0c 20 40 00 	movl   $0x40200c,(%esp)
  401327:	ff d2                	call   *%edx
  401329:	c7 04 24 40 13 40 00 	movl   $0x401340,(%esp)
  401330:	e8 8b ff ff ff       	call   4012c0 <_atexit>
  401335:	c9                   	leave  
  401336:	c3                   	ret    
  401337:	89 f6                	mov    %esi,%esi
  401339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00401340 <___gcc_deregister_frame>:
  401340:	55                   	push   %ebp
  401341:	89 e5                	mov    %esp,%ebp
  401343:	5d                   	pop    %ebp
  401344:	c3                   	ret    
  401345:	90                   	nop
  401346:	90                   	nop
  401347:	90                   	nop
  401348:	90                   	nop
  401349:	90                   	nop
  40134a:	90                   	nop
  40134b:	90                   	nop
  40134c:	90                   	nop
  40134d:	90                   	nop
  40134e:	90                   	nop
  40134f:	90                   	nop

00401350 <_sum>:
  401350:	55                   	push   %ebp
  401351:	89 e5                	mov    %esp,%ebp
  401353:	83 ec 10             	sub    $0x10,%esp
  401356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  40135d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  401364:	eb 0a                	jmp    401370 <_sum+0x20>
  401366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  401369:	01 45 fc             	add    %eax,-0x4(%ebp)
  40136c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  401370:	8b 45 f8             	mov    -0x8(%ebp),%eax
  401373:	3b 45 08             	cmp    0x8(%ebp),%eax
  401376:	7e ee                	jle    401366 <_sum+0x16>
  401378:	8b 45 fc             	mov    -0x4(%ebp),%eax
  40137b:	c9                   	leave  
  40137c:	c3                   	ret    

0040137d <_main>:
  40137d:	55                   	push   %ebp
  40137e:	89 e5                	mov    %esp,%ebp
  401380:	83 e4 f0             	and    $0xfffffff0,%esp
  401383:	83 ec 20             	sub    $0x20,%esp
  401386:	e8 e5 05 00 00       	call   401970 <___main>
  40138b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  401392:	e8 b9 ff ff ff       	call   401350 <_sum>
  401397:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  40139b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  40139f:	89 44 24 04          	mov    %eax,0x4(%esp)
  4013a3:	c7 04 24 24 30 40 00 	movl   $0x403024,(%esp)
  4013aa:	e8 31 08 00 00       	call   401be0 <_printf>
  4013af:	b8 00 00 00 00       	mov    $0x0,%eax
  4013b4:	c9                   	leave  
  4013b5:	c3                   	ret    
  4013b6:	90                   	nop
  4013b7:	90                   	nop
  4013b8:	66 90                	xchg   %ax,%ax
  4013ba:	66 90                	xchg   %ax,%ax
  4013bc:	66 90                	xchg   %ax,%ax
  4013be:	66 90                	xchg   %ax,%ax

004013c0 <___dyn_tls_dtor@12>:
  4013c0:	83 ec 1c             	sub    $0x1c,%esp
  4013c3:	8b 44 24 24          	mov    0x24(%esp),%eax
  4013c7:	85 c0                	test   %eax,%eax
  4013c9:	74 15                	je     4013e0 <___dyn_tls_dtor@12+0x20>
  4013cb:	83 f8 03             	cmp    $0x3,%eax
  4013ce:	74 10                	je     4013e0 <___dyn_tls_dtor@12+0x20>
  4013d0:	b8 01 00 00 00       	mov    $0x1,%eax
  4013d5:	83 c4 1c             	add    $0x1c,%esp
  4013d8:	c2 0c 00             	ret    $0xc
  4013db:	90                   	nop
  4013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  4013e0:	8b 54 24 28          	mov    0x28(%esp),%edx
  4013e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  4013e8:	8b 44 24 20          	mov    0x20(%esp),%eax
  4013ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  4013f0:	89 04 24             	mov    %eax,(%esp)
  4013f3:	e8 18 07 00 00       	call   401b10 <___mingw_TLScallback>
  4013f8:	b8 01 00 00 00       	mov    $0x1,%eax
  4013fd:	83 c4 1c             	add    $0x1c,%esp
  401400:	c2 0c 00             	ret    $0xc
  401403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  401409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00401410 <___dyn_tls_init@12>:
  401410:	56                   	push   %esi
  401411:	53                   	push   %ebx
  401412:	83 ec 14             	sub    $0x14,%esp
  401415:	83 3d 28 50 40 00 02 	cmpl   $0x2,0x405028
  40141c:	8b 44 24 24          	mov    0x24(%esp),%eax
  401420:	74 0a                	je     40142c <___dyn_tls_init@12+0x1c>
  401422:	c7 05 28 50 40 00 02 	movl   $0x2,0x405028
  401429:	00 00 00 
  40142c:	83 f8 02             	cmp    $0x2,%eax
  40142f:	74 12                	je     401443 <___dyn_tls_init@12+0x33>
  401431:	83 f8 01             	cmp    $0x1,%eax
  401434:	74 42                	je     401478 <___dyn_tls_init@12+0x68>
  401436:	83 c4 14             	add    $0x14,%esp
  401439:	b8 01 00 00 00       	mov    $0x1,%eax
  40143e:	5b                   	pop    %ebx
  40143f:	5e                   	pop    %esi
  401440:	c2 0c 00             	ret    $0xc
  401443:	be 14 70 40 00       	mov    $0x407014,%esi
  401448:	81 ee 14 70 40 00    	sub    $0x407014,%esi
  40144e:	c1 fe 02             	sar    $0x2,%esi
  401451:	85 f6                	test   %esi,%esi
  401453:	7e e1                	jle    401436 <___dyn_tls_init@12+0x26>
  401455:	31 db                	xor    %ebx,%ebx
  401457:	8b 04 9d 14 70 40 00 	mov    0x407014(,%ebx,4),%eax
  40145e:	85 c0                	test   %eax,%eax
  401460:	74 02                	je     401464 <___dyn_tls_init@12+0x54>
  401462:	ff d0                	call   *%eax
  401464:	83 c3 01             	add    $0x1,%ebx
  401467:	39 f3                	cmp    %esi,%ebx
  401469:	75 ec                	jne    401457 <___dyn_tls_init@12+0x47>
  40146b:	83 c4 14             	add    $0x14,%esp
  40146e:	b8 01 00 00 00       	mov    $0x1,%eax
  401473:	5b                   	pop    %ebx
  401474:	5e                   	pop    %esi
  401475:	c2 0c 00             	ret    $0xc
  401478:	8b 44 24 28          	mov    0x28(%esp),%eax
  40147c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  401483:	00 
  401484:	89 44 24 08          	mov    %eax,0x8(%esp)
  401488:	8b 44 24 20          	mov    0x20(%esp),%eax
  40148c:	89 04 24             	mov    %eax,(%esp)
  40148f:	e8 7c 06 00 00       	call   401b10 <___mingw_TLScallback>
  401494:	eb a0                	jmp    401436 <___dyn_tls_init@12+0x26>
  401496:	8d 76 00             	lea    0x0(%esi),%esi
  401499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

004014a0 <___tlregdtor>:
  4014a0:	31 c0                	xor    %eax,%eax
  4014a2:	c3                   	ret    
  4014a3:	90                   	nop
  4014a4:	90                   	nop
  4014a5:	90                   	nop
  4014a6:	90                   	nop
  4014a7:	90                   	nop
  4014a8:	90                   	nop
  4014a9:	90                   	nop
  4014aa:	90                   	nop
  4014ab:	90                   	nop
  4014ac:	90                   	nop
  4014ad:	90                   	nop
  4014ae:	90                   	nop
  4014af:	90                   	nop

004014b0 <___cpu_features_init>:
  4014b0:	9c                   	pushf  
  4014b1:	9c                   	pushf  
  4014b2:	58                   	pop    %eax
  4014b3:	89 c2                	mov    %eax,%edx
  4014b5:	35 00 00 20 00       	xor    $0x200000,%eax
  4014ba:	50                   	push   %eax
  4014bb:	9d                   	popf   
  4014bc:	9c                   	pushf  
  4014bd:	58                   	pop    %eax
  4014be:	9d                   	popf   
  4014bf:	31 d0                	xor    %edx,%eax
  4014c1:	a9 00 00 20 00       	test   $0x200000,%eax
  4014c6:	0f 84 a5 00 00 00    	je     401571 <___cpu_features_init+0xc1>
  4014cc:	53                   	push   %ebx
  4014cd:	31 c0                	xor    %eax,%eax
  4014cf:	0f a2                	cpuid  
  4014d1:	85 c0                	test   %eax,%eax
  4014d3:	0f 84 97 00 00 00    	je     401570 <___cpu_features_init+0xc0>
  4014d9:	b8 01 00 00 00       	mov    $0x1,%eax
  4014de:	0f a2                	cpuid  
  4014e0:	f6 c6 01             	test   $0x1,%dh
  4014e3:	74 07                	je     4014ec <___cpu_features_init+0x3c>
  4014e5:	83 0d 1c 50 40 00 01 	orl    $0x1,0x40501c
  4014ec:	f6 c6 80             	test   $0x80,%dh
  4014ef:	74 07                	je     4014f8 <___cpu_features_init+0x48>
  4014f1:	83 0d 1c 50 40 00 02 	orl    $0x2,0x40501c
  4014f8:	f7 c2 00 00 80 00    	test   $0x800000,%edx
  4014fe:	74 07                	je     401507 <___cpu_features_init+0x57>
  401500:	83 0d 1c 50 40 00 04 	orl    $0x4,0x40501c
  401507:	f7 c2 00 00 00 01    	test   $0x1000000,%edx
  40150d:	74 07                	je     401516 <___cpu_features_init+0x66>
  40150f:	83 0d 1c 50 40 00 08 	orl    $0x8,0x40501c
  401516:	f7 c2 00 00 00 02    	test   $0x2000000,%edx
  40151c:	74 07                	je     401525 <___cpu_features_init+0x75>
  40151e:	83 0d 1c 50 40 00 10 	orl    $0x10,0x40501c
  401525:	81 e2 00 00 00 04    	and    $0x4000000,%edx
  40152b:	74 07                	je     401534 <___cpu_features_init+0x84>
  40152d:	83 0d 1c 50 40 00 20 	orl    $0x20,0x40501c
  401534:	f6 c1 01             	test   $0x1,%cl
  401537:	74 07                	je     401540 <___cpu_features_init+0x90>
  401539:	83 0d 1c 50 40 00 40 	orl    $0x40,0x40501c
  401540:	80 e5 20             	and    $0x20,%ch
  401543:	75 2e                	jne    401573 <___cpu_features_init+0xc3>
  401545:	b8 00 00 00 80       	mov    $0x80000000,%eax
  40154a:	0f a2                	cpuid  
  40154c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  401551:	76 1d                	jbe    401570 <___cpu_features_init+0xc0>
  401553:	b8 01 00 00 80       	mov    $0x80000001,%eax
  401558:	0f a2                	cpuid  
  40155a:	85 d2                	test   %edx,%edx
  40155c:	78 22                	js     401580 <___cpu_features_init+0xd0>
  40155e:	81 e2 00 00 00 40    	and    $0x40000000,%edx
  401564:	74 0a                	je     401570 <___cpu_features_init+0xc0>
  401566:	81 0d 1c 50 40 00 00 	orl    $0x200,0x40501c
  40156d:	02 00 00 
  401570:	5b                   	pop    %ebx
  401571:	f3 c3                	repz ret 
  401573:	81 0d 1c 50 40 00 80 	orl    $0x80,0x40501c
  40157a:	00 00 00 
  40157d:	eb c6                	jmp    401545 <___cpu_features_init+0x95>
  40157f:	90                   	nop
  401580:	81 0d 1c 50 40 00 00 	orl    $0x100,0x40501c
  401587:	01 00 00 
  40158a:	eb d2                	jmp    40155e <___cpu_features_init+0xae>
  40158c:	90                   	nop
  40158d:	90                   	nop
  40158e:	90                   	nop
  40158f:	90                   	nop

00401590 <__fpreset>:
  401590:	db e3                	fninit 
  401592:	c3                   	ret    
  401593:	90                   	nop
  401594:	90                   	nop
  401595:	90                   	nop
  401596:	90                   	nop
  401597:	90                   	nop
  401598:	90                   	nop
  401599:	90                   	nop
  40159a:	90                   	nop
  40159b:	90                   	nop
  40159c:	90                   	nop
  40159d:	90                   	nop
  40159e:	90                   	nop
  40159f:	90                   	nop

004015a0 <___report_error>:
  4015a0:	53                   	push   %ebx
  4015a1:	83 ec 28             	sub    $0x28,%esp
  4015a4:	8b 1d 00 61 40 00    	mov    0x406100,%ebx
  4015aa:	8d 44 24 34          	lea    0x34(%esp),%eax
  4015ae:	c7 44 24 08 17 00 00 	movl   $0x17,0x8(%esp)
  4015b5:	00 
  4015b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  4015bd:	00 
  4015be:	83 c3 40             	add    $0x40,%ebx
  4015c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  4015c5:	c7 04 24 34 30 40 00 	movl   $0x403034,(%esp)
  4015cc:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  4015d0:	e8 13 06 00 00       	call   401be8 <_fwrite>
  4015d5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4015d9:	89 1c 24             	mov    %ebx,(%esp)
  4015dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  4015e0:	8b 44 24 30          	mov    0x30(%esp),%eax
  4015e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  4015e8:	e8 03 06 00 00       	call   401bf0 <_vfprintf>
  4015ed:	e8 06 06 00 00       	call   401bf8 <_abort>
  4015f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00401600 <___write_memory.part.0>:
  401600:	83 ec 5c             	sub    $0x5c,%esp
  401603:	89 5c 24 4c          	mov    %ebx,0x4c(%esp)
  401607:	89 c3                	mov    %eax,%ebx
  401609:	8d 44 24 24          	lea    0x24(%esp),%eax
  40160d:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
  401614:	00 
  401615:	89 44 24 04          	mov    %eax,0x4(%esp)
  401619:	89 1c 24             	mov    %ebx,(%esp)
  40161c:	89 74 24 50          	mov    %esi,0x50(%esp)
  401620:	89 d6                	mov    %edx,%esi
  401622:	89 7c 24 54          	mov    %edi,0x54(%esp)
  401626:	89 cf                	mov    %ecx,%edi
  401628:	89 6c 24 58          	mov    %ebp,0x58(%esp)
  40162c:	e8 07 06 00 00       	call   401c38 <_VirtualQuery@12>
  401631:	83 ec 0c             	sub    $0xc,%esp
  401634:	85 c0                	test   %eax,%eax
  401636:	0f 84 ba 00 00 00    	je     4016f6 <___write_memory.part.0+0xf6>
  40163c:	8b 44 24 38          	mov    0x38(%esp),%eax
  401640:	83 f8 04             	cmp    $0x4,%eax
  401643:	75 2b                	jne    401670 <___write_memory.part.0+0x70>
  401645:	89 7c 24 08          	mov    %edi,0x8(%esp)
  401649:	89 74 24 04          	mov    %esi,0x4(%esp)
  40164d:	89 1c 24             	mov    %ebx,(%esp)
  401650:	e8 ab 05 00 00       	call   401c00 <_memcpy>
  401655:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
  401659:	8b 74 24 50          	mov    0x50(%esp),%esi
  40165d:	8b 7c 24 54          	mov    0x54(%esp),%edi
  401661:	8b 6c 24 58          	mov    0x58(%esp),%ebp
  401665:	83 c4 5c             	add    $0x5c,%esp
  401668:	c3                   	ret    
  401669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  401670:	83 f8 40             	cmp    $0x40,%eax
  401673:	74 d0                	je     401645 <___write_memory.part.0+0x45>
  401675:	8b 44 24 30          	mov    0x30(%esp),%eax
  401679:	8d 6c 24 20          	lea    0x20(%esp),%ebp
  40167d:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  401681:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  401688:	00 
  401689:	89 44 24 04          	mov    %eax,0x4(%esp)
  40168d:	8b 44 24 24          	mov    0x24(%esp),%eax
  401691:	89 04 24             	mov    %eax,(%esp)
  401694:	e8 a7 05 00 00       	call   401c40 <_VirtualProtect@16>
  401699:	83 ec 10             	sub    $0x10,%esp
  40169c:	8b 44 24 38          	mov    0x38(%esp),%eax
  4016a0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  4016a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  4016a8:	89 1c 24             	mov    %ebx,(%esp)
  4016ab:	83 f8 40             	cmp    $0x40,%eax
  4016ae:	0f 95 44 24 1e       	setne  0x1e(%esp)
  4016b3:	83 f8 04             	cmp    $0x4,%eax
  4016b6:	0f 95 44 24 1f       	setne  0x1f(%esp)
  4016bb:	e8 40 05 00 00       	call   401c00 <_memcpy>
  4016c0:	80 7c 24 1f 00       	cmpb   $0x0,0x1f(%esp)
  4016c5:	74 8e                	je     401655 <___write_memory.part.0+0x55>
  4016c7:	80 7c 24 1e 00       	cmpb   $0x0,0x1e(%esp)
  4016cc:	74 87                	je     401655 <___write_memory.part.0+0x55>
  4016ce:	8b 44 24 20          	mov    0x20(%esp),%eax
  4016d2:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  4016d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  4016da:	8b 44 24 30          	mov    0x30(%esp),%eax
  4016de:	89 44 24 04          	mov    %eax,0x4(%esp)
  4016e2:	8b 44 24 24          	mov    0x24(%esp),%eax
  4016e6:	89 04 24             	mov    %eax,(%esp)
  4016e9:	e8 52 05 00 00       	call   401c40 <_VirtualProtect@16>
  4016ee:	83 ec 10             	sub    $0x10,%esp
  4016f1:	e9 5f ff ff ff       	jmp    401655 <___write_memory.part.0+0x55>
  4016f6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  4016fa:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  401701:	00 
  401702:	c7 04 24 4c 30 40 00 	movl   $0x40304c,(%esp)
  401709:	e8 92 fe ff ff       	call   4015a0 <___report_error>
  40170e:	66 90                	xchg   %ax,%ax

00401710 <__pei386_runtime_relocator>:
  401710:	a1 20 50 40 00       	mov    0x405020,%eax
  401715:	85 c0                	test   %eax,%eax
  401717:	74 07                	je     401720 <__pei386_runtime_relocator+0x10>
  401719:	c3                   	ret    
  40171a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  401720:	b8 30 31 40 00       	mov    $0x403130,%eax
  401725:	2d 30 31 40 00       	sub    $0x403130,%eax
  40172a:	83 f8 07             	cmp    $0x7,%eax
  40172d:	c7 05 20 50 40 00 01 	movl   $0x1,0x405020
  401734:	00 00 00 
  401737:	7e e0                	jle    401719 <__pei386_runtime_relocator+0x9>
  401739:	83 ec 2c             	sub    $0x2c,%esp
  40173c:	83 f8 0b             	cmp    $0xb,%eax
  40173f:	89 5c 24 20          	mov    %ebx,0x20(%esp)
  401743:	89 74 24 24          	mov    %esi,0x24(%esp)
  401747:	89 7c 24 28          	mov    %edi,0x28(%esp)
  40174b:	0f 8e df 00 00 00    	jle    401830 <__pei386_runtime_relocator+0x120>
  401751:	8b 35 30 31 40 00    	mov    0x403130,%esi
  401757:	85 f6                	test   %esi,%esi
  401759:	0f 85 85 00 00 00    	jne    4017e4 <__pei386_runtime_relocator+0xd4>
  40175f:	8b 1d 34 31 40 00    	mov    0x403134,%ebx
  401765:	85 db                	test   %ebx,%ebx
  401767:	75 7b                	jne    4017e4 <__pei386_runtime_relocator+0xd4>
  401769:	8b 0d 38 31 40 00    	mov    0x403138,%ecx
  40176f:	bb 3c 31 40 00       	mov    $0x40313c,%ebx
  401774:	85 c9                	test   %ecx,%ecx
  401776:	0f 84 b9 00 00 00    	je     401835 <__pei386_runtime_relocator+0x125>
  40177c:	bb 30 31 40 00       	mov    $0x403130,%ebx
  401781:	8b 43 08             	mov    0x8(%ebx),%eax
  401784:	83 f8 01             	cmp    $0x1,%eax
  401787:	0f 85 47 01 00 00    	jne    4018d4 <__pei386_runtime_relocator+0x1c4>
  40178d:	83 c3 0c             	add    $0xc,%ebx
  401790:	81 fb 30 31 40 00    	cmp    $0x403130,%ebx
  401796:	0f 83 83 00 00 00    	jae    40181f <__pei386_runtime_relocator+0x10f>
  40179c:	0f b6 53 08          	movzbl 0x8(%ebx),%edx
  4017a0:	8b 73 04             	mov    0x4(%ebx),%esi
  4017a3:	8b 0b                	mov    (%ebx),%ecx
  4017a5:	83 fa 10             	cmp    $0x10,%edx
  4017a8:	8d 86 00 00 40 00    	lea    0x400000(%esi),%eax
  4017ae:	8b b9 00 00 40 00    	mov    0x400000(%ecx),%edi
  4017b4:	0f 84 8e 00 00 00    	je     401848 <__pei386_runtime_relocator+0x138>
  4017ba:	83 fa 20             	cmp    $0x20,%edx
  4017bd:	0f 84 f0 00 00 00    	je     4018b3 <__pei386_runtime_relocator+0x1a3>
  4017c3:	83 fa 08             	cmp    $0x8,%edx
  4017c6:	0f 84 b4 00 00 00    	je     401880 <__pei386_runtime_relocator+0x170>
  4017cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  4017d0:	c7 04 24 b4 30 40 00 	movl   $0x4030b4,(%esp)
  4017d7:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  4017de:	00 
  4017df:	e8 bc fd ff ff       	call   4015a0 <___report_error>
  4017e4:	bb 30 31 40 00       	mov    $0x403130,%ebx
  4017e9:	81 fb 30 31 40 00    	cmp    $0x403130,%ebx
  4017ef:	73 2e                	jae    40181f <__pei386_runtime_relocator+0x10f>
  4017f1:	8b 53 04             	mov    0x4(%ebx),%edx
  4017f4:	b9 04 00 00 00       	mov    $0x4,%ecx
  4017f9:	8d 82 00 00 40 00    	lea    0x400000(%edx),%eax
  4017ff:	8b 92 00 00 40 00    	mov    0x400000(%edx),%edx
  401805:	03 13                	add    (%ebx),%edx
  401807:	83 c3 08             	add    $0x8,%ebx
  40180a:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  40180e:	8d 54 24 1c          	lea    0x1c(%esp),%edx
  401812:	e8 e9 fd ff ff       	call   401600 <___write_memory.part.0>
  401817:	81 fb 30 31 40 00    	cmp    $0x403130,%ebx
  40181d:	72 d2                	jb     4017f1 <__pei386_runtime_relocator+0xe1>
  40181f:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  401823:	8b 74 24 24          	mov    0x24(%esp),%esi
  401827:	8b 7c 24 28          	mov    0x28(%esp),%edi
  40182b:	83 c4 2c             	add    $0x2c,%esp
  40182e:	c3                   	ret    
  40182f:	90                   	nop
  401830:	bb 30 31 40 00       	mov    $0x403130,%ebx
  401835:	8b 13                	mov    (%ebx),%edx
  401837:	85 d2                	test   %edx,%edx
  401839:	75 ae                	jne    4017e9 <__pei386_runtime_relocator+0xd9>
  40183b:	8b 43 04             	mov    0x4(%ebx),%eax
  40183e:	85 c0                	test   %eax,%eax
  401840:	0f 84 3b ff ff ff    	je     401781 <__pei386_runtime_relocator+0x71>
  401846:	eb a1                	jmp    4017e9 <__pei386_runtime_relocator+0xd9>
  401848:	0f b7 b6 00 00 40 00 	movzwl 0x400000(%esi),%esi
  40184f:	66 85 f6             	test   %si,%si
  401852:	0f b7 d6             	movzwl %si,%edx
  401855:	79 06                	jns    40185d <__pei386_runtime_relocator+0x14d>
  401857:	81 ca 00 00 ff ff    	or     $0xffff0000,%edx
  40185d:	29 ca                	sub    %ecx,%edx
  40185f:	b9 02 00 00 00       	mov    $0x2,%ecx
  401864:	81 ea 00 00 40 00    	sub    $0x400000,%edx
  40186a:	01 fa                	add    %edi,%edx
  40186c:	89 54 24 18          	mov    %edx,0x18(%esp)
  401870:	8d 54 24 18          	lea    0x18(%esp),%edx
  401874:	e8 87 fd ff ff       	call   401600 <___write_memory.part.0>
  401879:	e9 0f ff ff ff       	jmp    40178d <__pei386_runtime_relocator+0x7d>
  40187e:	66 90                	xchg   %ax,%ax
  401880:	0f b6 10             	movzbl (%eax),%edx
  401883:	84 d2                	test   %dl,%dl
  401885:	0f b6 f2             	movzbl %dl,%esi
  401888:	79 06                	jns    401890 <__pei386_runtime_relocator+0x180>
  40188a:	81 ce 00 ff ff ff    	or     $0xffffff00,%esi
  401890:	89 f2                	mov    %esi,%edx
  401892:	81 ea 00 00 40 00    	sub    $0x400000,%edx
  401898:	29 ca                	sub    %ecx,%edx
  40189a:	b9 01 00 00 00       	mov    $0x1,%ecx
  40189f:	01 fa                	add    %edi,%edx
  4018a1:	89 54 24 18          	mov    %edx,0x18(%esp)
  4018a5:	8d 54 24 18          	lea    0x18(%esp),%edx
  4018a9:	e8 52 fd ff ff       	call   401600 <___write_memory.part.0>
  4018ae:	e9 da fe ff ff       	jmp    40178d <__pei386_runtime_relocator+0x7d>
  4018b3:	81 c1 00 00 40 00    	add    $0x400000,%ecx
  4018b9:	29 cf                	sub    %ecx,%edi
  4018bb:	b9 04 00 00 00       	mov    $0x4,%ecx
  4018c0:	03 38                	add    (%eax),%edi
  4018c2:	8d 54 24 18          	lea    0x18(%esp),%edx
  4018c6:	89 7c 24 18          	mov    %edi,0x18(%esp)
  4018ca:	e8 31 fd ff ff       	call   401600 <___write_memory.part.0>
  4018cf:	e9 b9 fe ff ff       	jmp    40178d <__pei386_runtime_relocator+0x7d>
  4018d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  4018d8:	c7 04 24 80 30 40 00 	movl   $0x403080,(%esp)
  4018df:	e8 bc fc ff ff       	call   4015a0 <___report_error>
  4018e4:	90                   	nop
  4018e5:	90                   	nop
  4018e6:	90                   	nop
  4018e7:	90                   	nop
  4018e8:	90                   	nop
  4018e9:	90                   	nop
  4018ea:	90                   	nop
  4018eb:	90                   	nop
  4018ec:	90                   	nop
  4018ed:	90                   	nop
  4018ee:	90                   	nop
  4018ef:	90                   	nop

004018f0 <___do_global_dtors>:
  4018f0:	a1 08 20 40 00       	mov    0x402008,%eax
  4018f5:	8b 00                	mov    (%eax),%eax
  4018f7:	85 c0                	test   %eax,%eax
  4018f9:	74 1f                	je     40191a <___do_global_dtors+0x2a>
  4018fb:	83 ec 0c             	sub    $0xc,%esp
  4018fe:	66 90                	xchg   %ax,%ax
  401900:	ff d0                	call   *%eax
  401902:	a1 08 20 40 00       	mov    0x402008,%eax
  401907:	8d 50 04             	lea    0x4(%eax),%edx
  40190a:	8b 40 04             	mov    0x4(%eax),%eax
  40190d:	89 15 08 20 40 00    	mov    %edx,0x402008
  401913:	85 c0                	test   %eax,%eax
  401915:	75 e9                	jne    401900 <___do_global_dtors+0x10>
  401917:	83 c4 0c             	add    $0xc,%esp
  40191a:	f3 c3                	repz ret 
  40191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00401920 <___do_global_ctors>:
  401920:	53                   	push   %ebx
  401921:	83 ec 18             	sub    $0x18,%esp
  401924:	8b 1d 90 1c 40 00    	mov    0x401c90,%ebx
  40192a:	83 fb ff             	cmp    $0xffffffff,%ebx
  40192d:	74 24                	je     401953 <___do_global_ctors+0x33>
  40192f:	85 db                	test   %ebx,%ebx
  401931:	74 0f                	je     401942 <___do_global_ctors+0x22>
  401933:	ff 14 9d 90 1c 40 00 	call   *0x401c90(,%ebx,4)
  40193a:	83 eb 01             	sub    $0x1,%ebx
  40193d:	8d 76 00             	lea    0x0(%esi),%esi
  401940:	75 f1                	jne    401933 <___do_global_ctors+0x13>
  401942:	c7 04 24 f0 18 40 00 	movl   $0x4018f0,(%esp)
  401949:	e8 72 f9 ff ff       	call   4012c0 <_atexit>
  40194e:	83 c4 18             	add    $0x18,%esp
  401951:	5b                   	pop    %ebx
  401952:	c3                   	ret    
  401953:	31 db                	xor    %ebx,%ebx
  401955:	eb 02                	jmp    401959 <___do_global_ctors+0x39>
  401957:	89 c3                	mov    %eax,%ebx
  401959:	8d 43 01             	lea    0x1(%ebx),%eax
  40195c:	8b 14 85 90 1c 40 00 	mov    0x401c90(,%eax,4),%edx
  401963:	85 d2                	test   %edx,%edx
  401965:	75 f0                	jne    401957 <___do_global_ctors+0x37>
  401967:	eb c6                	jmp    40192f <___do_global_ctors+0xf>
  401969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00401970 <___main>:
  401970:	8b 0d 24 50 40 00    	mov    0x405024,%ecx
  401976:	85 c9                	test   %ecx,%ecx
  401978:	74 06                	je     401980 <___main+0x10>
  40197a:	f3 c3                	repz ret 
  40197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401980:	c7 05 24 50 40 00 01 	movl   $0x1,0x405024
  401987:	00 00 00 
  40198a:	eb 94                	jmp    401920 <___do_global_ctors>
  40198c:	90                   	nop
  40198d:	90                   	nop
  40198e:	90                   	nop
  40198f:	90                   	nop

00401990 <___mingwthr_run_key_dtors.part.0>:
  401990:	56                   	push   %esi
  401991:	53                   	push   %ebx
  401992:	83 ec 14             	sub    $0x14,%esp
  401995:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  40199c:	e8 a7 02 00 00       	call   401c48 <_EnterCriticalSection@4>
  4019a1:	8b 1d 48 50 40 00    	mov    0x405048,%ebx
  4019a7:	83 ec 04             	sub    $0x4,%esp
  4019aa:	85 db                	test   %ebx,%ebx
  4019ac:	74 2d                	je     4019db <___mingwthr_run_key_dtors.part.0+0x4b>
  4019ae:	66 90                	xchg   %ax,%ax
  4019b0:	8b 03                	mov    (%ebx),%eax
  4019b2:	89 04 24             	mov    %eax,(%esp)
  4019b5:	e8 96 02 00 00       	call   401c50 <_TlsGetValue@4>
  4019ba:	83 ec 04             	sub    $0x4,%esp
  4019bd:	89 c6                	mov    %eax,%esi
  4019bf:	e8 94 02 00 00       	call   401c58 <_GetLastError@0>
  4019c4:	85 c0                	test   %eax,%eax
  4019c6:	75 0c                	jne    4019d4 <___mingwthr_run_key_dtors.part.0+0x44>
  4019c8:	85 f6                	test   %esi,%esi
  4019ca:	74 08                	je     4019d4 <___mingwthr_run_key_dtors.part.0+0x44>
  4019cc:	8b 43 04             	mov    0x4(%ebx),%eax
  4019cf:	89 34 24             	mov    %esi,(%esp)
  4019d2:	ff d0                	call   *%eax
  4019d4:	8b 5b 08             	mov    0x8(%ebx),%ebx
  4019d7:	85 db                	test   %ebx,%ebx
  4019d9:	75 d5                	jne    4019b0 <___mingwthr_run_key_dtors.part.0+0x20>
  4019db:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  4019e2:	e8 79 02 00 00       	call   401c60 <_LeaveCriticalSection@4>
  4019e7:	83 ec 04             	sub    $0x4,%esp
  4019ea:	83 c4 14             	add    $0x14,%esp
  4019ed:	5b                   	pop    %ebx
  4019ee:	5e                   	pop    %esi
  4019ef:	c3                   	ret    

004019f0 <____w64_mingwthr_add_key_dtor>:
  4019f0:	83 ec 1c             	sub    $0x1c,%esp
  4019f3:	a1 2c 50 40 00       	mov    0x40502c,%eax
  4019f8:	89 74 24 18          	mov    %esi,0x18(%esp)
  4019fc:	31 f6                	xor    %esi,%esi
  4019fe:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  401a02:	85 c0                	test   %eax,%eax
  401a04:	75 0e                	jne    401a14 <____w64_mingwthr_add_key_dtor+0x24>
  401a06:	89 f0                	mov    %esi,%eax
  401a08:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  401a0c:	8b 74 24 18          	mov    0x18(%esp),%esi
  401a10:	83 c4 1c             	add    $0x1c,%esp
  401a13:	c3                   	ret    
  401a14:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  401a1b:	00 
  401a1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  401a23:	e8 e0 01 00 00       	call   401c08 <_calloc>
  401a28:	85 c0                	test   %eax,%eax
  401a2a:	89 c3                	mov    %eax,%ebx
  401a2c:	74 47                	je     401a75 <____w64_mingwthr_add_key_dtor+0x85>
  401a2e:	8b 44 24 20          	mov    0x20(%esp),%eax
  401a32:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401a39:	89 03                	mov    %eax,(%ebx)
  401a3b:	8b 44 24 24          	mov    0x24(%esp),%eax
  401a3f:	89 43 04             	mov    %eax,0x4(%ebx)
  401a42:	e8 01 02 00 00       	call   401c48 <_EnterCriticalSection@4>
  401a47:	a1 48 50 40 00       	mov    0x405048,%eax
  401a4c:	89 1d 48 50 40 00    	mov    %ebx,0x405048
  401a52:	89 43 08             	mov    %eax,0x8(%ebx)
  401a55:	83 ec 04             	sub    $0x4,%esp
  401a58:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401a5f:	e8 fc 01 00 00       	call   401c60 <_LeaveCriticalSection@4>
  401a64:	89 f0                	mov    %esi,%eax
  401a66:	83 ec 04             	sub    $0x4,%esp
  401a69:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  401a6d:	8b 74 24 18          	mov    0x18(%esp),%esi
  401a71:	83 c4 1c             	add    $0x1c,%esp
  401a74:	c3                   	ret    
  401a75:	be ff ff ff ff       	mov    $0xffffffff,%esi
  401a7a:	eb 8a                	jmp    401a06 <____w64_mingwthr_add_key_dtor+0x16>
  401a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00401a80 <____w64_mingwthr_remove_key_dtor>:
  401a80:	53                   	push   %ebx
  401a81:	83 ec 18             	sub    $0x18,%esp
  401a84:	a1 2c 50 40 00       	mov    0x40502c,%eax
  401a89:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  401a8d:	85 c0                	test   %eax,%eax
  401a8f:	75 07                	jne    401a98 <____w64_mingwthr_remove_key_dtor+0x18>
  401a91:	83 c4 18             	add    $0x18,%esp
  401a94:	31 c0                	xor    %eax,%eax
  401a96:	5b                   	pop    %ebx
  401a97:	c3                   	ret    
  401a98:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401a9f:	e8 a4 01 00 00       	call   401c48 <_EnterCriticalSection@4>
  401aa4:	8b 15 48 50 40 00    	mov    0x405048,%edx
  401aaa:	83 ec 04             	sub    $0x4,%esp
  401aad:	85 d2                	test   %edx,%edx
  401aaf:	74 1e                	je     401acf <____w64_mingwthr_remove_key_dtor+0x4f>
  401ab1:	8b 02                	mov    (%edx),%eax
  401ab3:	39 d8                	cmp    %ebx,%eax
  401ab5:	75 11                	jne    401ac8 <____w64_mingwthr_remove_key_dtor+0x48>
  401ab7:	eb 4b                	jmp    401b04 <____w64_mingwthr_remove_key_dtor+0x84>
  401ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  401ac0:	8b 08                	mov    (%eax),%ecx
  401ac2:	39 d9                	cmp    %ebx,%ecx
  401ac4:	74 1f                	je     401ae5 <____w64_mingwthr_remove_key_dtor+0x65>
  401ac6:	89 c2                	mov    %eax,%edx
  401ac8:	8b 42 08             	mov    0x8(%edx),%eax
  401acb:	85 c0                	test   %eax,%eax
  401acd:	75 f1                	jne    401ac0 <____w64_mingwthr_remove_key_dtor+0x40>
  401acf:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401ad6:	e8 85 01 00 00       	call   401c60 <_LeaveCriticalSection@4>
  401adb:	83 ec 04             	sub    $0x4,%esp
  401ade:	83 c4 18             	add    $0x18,%esp
  401ae1:	31 c0                	xor    %eax,%eax
  401ae3:	5b                   	pop    %ebx
  401ae4:	c3                   	ret    
  401ae5:	8b 48 08             	mov    0x8(%eax),%ecx
  401ae8:	89 4a 08             	mov    %ecx,0x8(%edx)
  401aeb:	89 04 24             	mov    %eax,(%esp)
  401aee:	e8 1d 01 00 00       	call   401c10 <_free>
  401af3:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401afa:	e8 61 01 00 00       	call   401c60 <_LeaveCriticalSection@4>
  401aff:	83 ec 04             	sub    $0x4,%esp
  401b02:	eb da                	jmp    401ade <____w64_mingwthr_remove_key_dtor+0x5e>
  401b04:	8b 42 08             	mov    0x8(%edx),%eax
  401b07:	a3 48 50 40 00       	mov    %eax,0x405048
  401b0c:	89 d0                	mov    %edx,%eax
  401b0e:	eb db                	jmp    401aeb <____w64_mingwthr_remove_key_dtor+0x6b>

00401b10 <___mingw_TLScallback>:
  401b10:	83 ec 1c             	sub    $0x1c,%esp
  401b13:	8b 44 24 24          	mov    0x24(%esp),%eax
  401b17:	83 f8 01             	cmp    $0x1,%eax
  401b1a:	74 44                	je     401b60 <___mingw_TLScallback+0x50>
  401b1c:	72 12                	jb     401b30 <___mingw_TLScallback+0x20>
  401b1e:	83 f8 03             	cmp    $0x3,%eax
  401b21:	74 5d                	je     401b80 <___mingw_TLScallback+0x70>
  401b23:	b8 01 00 00 00       	mov    $0x1,%eax
  401b28:	83 c4 1c             	add    $0x1c,%esp
  401b2b:	c3                   	ret    
  401b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401b30:	a1 2c 50 40 00       	mov    0x40502c,%eax
  401b35:	85 c0                	test   %eax,%eax
  401b37:	75 68                	jne    401ba1 <___mingw_TLScallback+0x91>
  401b39:	a1 2c 50 40 00       	mov    0x40502c,%eax
  401b3e:	83 f8 01             	cmp    $0x1,%eax
  401b41:	75 e0                	jne    401b23 <___mingw_TLScallback+0x13>
  401b43:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401b4a:	c7 05 2c 50 40 00 00 	movl   $0x0,0x40502c
  401b51:	00 00 00 
  401b54:	e8 0f 01 00 00       	call   401c68 <_DeleteCriticalSection@4>
  401b59:	83 ec 04             	sub    $0x4,%esp
  401b5c:	eb c5                	jmp    401b23 <___mingw_TLScallback+0x13>
  401b5e:	66 90                	xchg   %ax,%ax
  401b60:	a1 2c 50 40 00       	mov    0x40502c,%eax
  401b65:	85 c0                	test   %eax,%eax
  401b67:	74 27                	je     401b90 <___mingw_TLScallback+0x80>
  401b69:	c7 05 2c 50 40 00 01 	movl   $0x1,0x40502c
  401b70:	00 00 00 
  401b73:	b8 01 00 00 00       	mov    $0x1,%eax
  401b78:	83 c4 1c             	add    $0x1c,%esp
  401b7b:	c3                   	ret    
  401b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  401b80:	a1 2c 50 40 00       	mov    0x40502c,%eax
  401b85:	85 c0                	test   %eax,%eax
  401b87:	74 9a                	je     401b23 <___mingw_TLScallback+0x13>
  401b89:	e8 02 fe ff ff       	call   401990 <___mingwthr_run_key_dtors.part.0>
  401b8e:	eb 93                	jmp    401b23 <___mingw_TLScallback+0x13>
  401b90:	c7 04 24 30 50 40 00 	movl   $0x405030,(%esp)
  401b97:	e8 d4 00 00 00       	call   401c70 <_InitializeCriticalSection@4>
  401b9c:	83 ec 04             	sub    $0x4,%esp
  401b9f:	eb c8                	jmp    401b69 <___mingw_TLScallback+0x59>
  401ba1:	e8 ea fd ff ff       	call   401990 <___mingwthr_run_key_dtors.part.0>
  401ba6:	eb 91                	jmp    401b39 <___mingw_TLScallback+0x29>
  401ba8:	90                   	nop
  401ba9:	90                   	nop
  401baa:	90                   	nop
  401bab:	90                   	nop
  401bac:	90                   	nop
  401bad:	90                   	nop
  401bae:	90                   	nop
  401baf:	90                   	nop

00401bb0 <___getmainargs>:
  401bb0:	ff 25 ec 60 40 00    	jmp    *0x4060ec
  401bb6:	90                   	nop
  401bb7:	90                   	nop

00401bb8 <__setmode>:
  401bb8:	ff 25 08 61 40 00    	jmp    *0x406108
  401bbe:	90                   	nop
  401bbf:	90                   	nop

00401bc0 <___p__fmode>:
  401bc0:	ff 25 f4 60 40 00    	jmp    *0x4060f4
  401bc6:	90                   	nop
  401bc7:	90                   	nop

00401bc8 <___p__environ>:
  401bc8:	ff 25 f0 60 40 00    	jmp    *0x4060f0
  401bce:	90                   	nop
  401bcf:	90                   	nop

00401bd0 <__cexit>:
  401bd0:	ff 25 fc 60 40 00    	jmp    *0x4060fc
  401bd6:	90                   	nop
  401bd7:	90                   	nop

00401bd8 <_signal>:
  401bd8:	ff 25 28 61 40 00    	jmp    *0x406128
  401bde:	90                   	nop
  401bdf:	90                   	nop

00401be0 <_printf>:
  401be0:	ff 25 24 61 40 00    	jmp    *0x406124
  401be6:	90                   	nop
  401be7:	90                   	nop

00401be8 <_fwrite>:
  401be8:	ff 25 1c 61 40 00    	jmp    *0x40611c
  401bee:	90                   	nop
  401bef:	90                   	nop

00401bf0 <_vfprintf>:
  401bf0:	ff 25 2c 61 40 00    	jmp    *0x40612c
  401bf6:	90                   	nop
  401bf7:	90                   	nop

00401bf8 <_abort>:
  401bf8:	ff 25 0c 61 40 00    	jmp    *0x40610c
  401bfe:	90                   	nop
  401bff:	90                   	nop

00401c00 <_memcpy>:
  401c00:	ff 25 20 61 40 00    	jmp    *0x406120
  401c06:	90                   	nop
  401c07:	90                   	nop

00401c08 <_calloc>:
  401c08:	ff 25 14 61 40 00    	jmp    *0x406114
  401c0e:	90                   	nop
  401c0f:	90                   	nop

00401c10 <_free>:
  401c10:	ff 25 18 61 40 00    	jmp    *0x406118
  401c16:	90                   	nop
  401c17:	90                   	nop

00401c18 <_SetUnhandledExceptionFilter@4>:
  401c18:	ff 25 d8 60 40 00    	jmp    *0x4060d8
  401c1e:	90                   	nop
  401c1f:	90                   	nop

00401c20 <_ExitProcess@4>:
  401c20:	ff 25 c0 60 40 00    	jmp    *0x4060c0
  401c26:	90                   	nop
  401c27:	90                   	nop

00401c28 <_GetModuleHandleA@4>:
  401c28:	ff 25 c8 60 40 00    	jmp    *0x4060c8
  401c2e:	90                   	nop
  401c2f:	90                   	nop

00401c30 <_GetProcAddress@8>:
  401c30:	ff 25 cc 60 40 00    	jmp    *0x4060cc
  401c36:	90                   	nop
  401c37:	90                   	nop

00401c38 <_VirtualQuery@12>:
  401c38:	ff 25 e4 60 40 00    	jmp    *0x4060e4
  401c3e:	90                   	nop
  401c3f:	90                   	nop

00401c40 <_VirtualProtect@16>:
  401c40:	ff 25 e0 60 40 00    	jmp    *0x4060e0
  401c46:	90                   	nop
  401c47:	90                   	nop

00401c48 <_EnterCriticalSection@4>:
  401c48:	ff 25 bc 60 40 00    	jmp    *0x4060bc
  401c4e:	90                   	nop
  401c4f:	90                   	nop

00401c50 <_TlsGetValue@4>:
  401c50:	ff 25 dc 60 40 00    	jmp    *0x4060dc
  401c56:	90                   	nop
  401c57:	90                   	nop

00401c58 <_GetLastError@0>:
  401c58:	ff 25 c4 60 40 00    	jmp    *0x4060c4
  401c5e:	90                   	nop
  401c5f:	90                   	nop

00401c60 <_LeaveCriticalSection@4>:
  401c60:	ff 25 d4 60 40 00    	jmp    *0x4060d4
  401c66:	90                   	nop
  401c67:	90                   	nop

00401c68 <_DeleteCriticalSection@4>:
  401c68:	ff 25 b8 60 40 00    	jmp    *0x4060b8
  401c6e:	90                   	nop
  401c6f:	90                   	nop

00401c70 <_InitializeCriticalSection@4>:
  401c70:	ff 25 d0 60 40 00    	jmp    *0x4060d0
  401c76:	90                   	nop
  401c77:	90                   	nop

00401c78 <.text>:
  401c78:	66 90                	xchg   %ax,%ax
  401c7a:	66 90                	xchg   %ax,%ax
  401c7c:	66 90                	xchg   %ax,%ax
  401c7e:	66 90                	xchg   %ax,%ax

00401c80 <_register_frame_ctor>:
  401c80:	55                   	push   %ebp
  401c81:	89 e5                	mov    %esp,%ebp
  401c83:	5d                   	pop    %ebp
  401c84:	e9 57 f6 ff ff       	jmp    4012e0 <___gcc_register_frame>
  401c89:	90                   	nop
  401c8a:	90                   	nop
  401c8b:	90                   	nop
  401c8c:	90                   	nop
  401c8d:	90                   	nop
  401c8e:	90                   	nop
  401c8f:	90                   	nop

00401c90 <__CTOR_LIST__>:
  401c90:	ff                   	(bad)  
  401c91:	ff                   	(bad)  
  401c92:	ff                   	(bad)  
  401c93:	ff 80 1c 40 00 00    	incl   0x401c(%eax)

00401c94 <.ctors.65535>:
  401c94:	80 1c 40 00          	sbbb   $0x0,(%eax,%eax,2)
  401c98:	00 00                	add    %al,(%eax)
	...

00401c9c <__DTOR_LIST__>:
  401c9c:	ff                   	(bad)  
  401c9d:	ff                   	(bad)  
  401c9e:	ff                   	(bad)  
  401c9f:	ff 00                	incl   (%eax)
  401ca1:	00 00                	add    %al,(%eax)
	...

```