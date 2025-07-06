#include <frame_allocator.h>

// file: frame_allocator.c
// description: used for physical memory mapping working with the page tables (virtual memory)

// Constants for maximum memory and frames (adjust as needed)
#define MAX_FRAMES 1024  // Number of frames you want to manage (e.g., 4MB of RAM)
#define FRAME_SIZE PAGE_SIZE

// Bitmap to keep track of used/free frames
static uint32_t frame_bitmap[(MAX_FRAMES / 32) + 1];

// Set a bit in the frame bitmap
static void set_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / FRAME_SIZE;
    frame_bitmap[frame / 32] |= (1 << (frame % 32));
}

// Clear a bit in the frame bitmap
static void clear_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / FRAME_SIZE;
    frame_bitmap[frame / 32] &= ~(1 << (frame % 32));
}

// Test if a bit is set in the frame bitmap
static int test_frame(uint32_t frame_addr) {
    uint32_t frame = frame_addr / FRAME_SIZE;
    return frame_bitmap[frame / 32] & (1 << (frame % 32));
}

// Find the first free frame and return its address
uint32_t* allocate_frame(void) {
    for (uint32_t i = 0; i < MAX_FRAMES; i++) {
        if (!(frame_bitmap[i / 32] & (1 << (i % 32)))) {
            // Mark frame as used
            frame_bitmap[i / 32] |= (1 << (i % 32));
            // Return physical address of frame
            return (uint32_t*)(i * FRAME_SIZE);
        }
    }
    return NULL; // No free frames
}
