#ifndef FRAME_ALLOCATOR_H
#define FRAME_ALLOCATOR_H

#include <stdint.h>

// Size of a page/frame (should match your paging setup)
#define PAGE_SIZE 0x1000 // 4KB

// Allocate a free frame and return its physical address
uint32_t allocate_frame(void);

// Mark a frame as used
void set_frame(uint32_t frame_addr);

// Mark a frame as free
void clear_frame(uint32_t frame_addr);

// Check if a frame is used (returns 1 if used, 0 if free)
int test_frame(uint32_t frame_addr);

#endif // FRAME_ALLOCATOR_H
