// Memory layout // 記憶體配置

#define EXTMEM  0x100000            // Start of extended memory                // 擴充記憶體的起點
#define PHYSTOP 0xE000000           // Top physical memory                     // 實體記憶體的頂端
#define DEVSPACE 0xFE000000         // Other devices are at high addresses     // 其他裝置映射到高位址區

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0x80000000         // First kernel virtual address            // kernel 第一段的虛擬位址
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked          // 連結進來的 kernel 的位址?

#define V2P(a) (((uint) (a)) - KERNBASE)                                       // 虛擬位址 => 實體位址
#define P2V(a) ((void *)(((char *) (a)) + KERNBASE))                           // 實體位址 => 虛擬位址

#define V2P_WO(x) ((x) - KERNBASE)    // same as V2P, but without casts        // V2P 不做型態轉換的版本
#define P2V_WO(x) ((x) + KERNBASE)    // same as P2V, but without casts        // P2V 不做型態轉換的版本
