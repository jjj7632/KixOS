#include "paging.h"
#include "string.h"  // your own string functions like memset

#define PAGE_PRESENT  0x1
#define PAGE_WRITE    0x2
#define PAGE_USER     0x4
#define PAGE_NX       (1ULL << 63) // Only with PAE/64-bit
#define PAGE_SIZE     0x1000

extern uint8_t __text_start, __text_end;
extern uint8_t __rodata_start, __rodata_end;
extern uint8_t __data_start, __data_end;
extern uint8_t __bss_start, __bss_end;

// You must implement allocate_frame() yourself somewhere, which returns
// a pointer to a zeroed 4K page frame suitable for page tables
extern uint32_t* allocate_frame(void);

void map_page(uint32_t* page_directory, uint32_t virtual_addr, uint32_t physical_addr, uint32_t flags) {
    uint32_t pd_index = virtual_addr >> 22;
    uint32_t pt_index = (virtual_addr >> 12) & 0x03FF;

    uint32_t* page_table = (uint32_t*)(page_directory[pd_index] & 0xFFFFF000);
    if (!(page_directory[pd_index] & PAGE_PRESENT)) {
        page_table = allocate_frame();
        memset(page_table, 0, PAGE_SIZE);
        page_directory[pd_index] = ((uint32_t)page_table) | flags | PAGE_PRESENT;
    }

    page_table[pt_index] = (physical_addr & 0xFFFFF000) | flags | PAGE_PRESENT;
}

void map_region(uint32_t* page_directory,
                uint32_t virt_start,
                uint32_t virt_end,
                uint32_t phys_start,
                uint32_t flags) {
    for (uint32_t addr = virt_start, phys = phys_start; addr < virt_end; addr += PAGE_SIZE, phys += PAGE_SIZE) {
        map_page(page_directory, addr, phys, flags);
    }
}
