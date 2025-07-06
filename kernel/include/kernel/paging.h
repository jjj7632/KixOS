#ifndef PAGING_H
#define PAGING_H

#include <stdint.h>

// Page flags
#define PAGE_PRESENT  0x1
#define PAGE_WRITE    0x2
#define PAGE_USER     0x4
#define PAGE_NX       (1ULL << 63) // Only with PAE/64-bit, ignore if 32-bit

#define PAGE_SIZE     0x1000  // 4 KB

// Symbols from linker script for kernel sections
extern uint8_t __text_start, __text_end;
extern uint8_t __rodata_start, __rodata_end;
extern uint8_t __data_start, __data_end;
extern uint8_t __bss_start, __bss_end;

// Allocates a free physical frame (4 KB aligned physical memory)
// You need to implement this yourself
uint32_t* allocate_frame(void);

// Maps a single virtual page to a physical frame with given flags
void map_page(uint32_t* page_directory, uint32_t virtual_addr, uint32_t physical_addr, uint32_t flags);

// Maps a region of virtual memory to physical memory with given flags
void map_region(uint32_t* page_directory,
                uint32_t virt_start,
                uint32_t virt_end,
                uint32_t phys_start,
                uint32_t flags);

#endif // PAGING_H
