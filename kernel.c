/** @file:        KixKernel.c
*** @author:      Joshua J Justice      Github Username: jjj7632
*** @description: This kernel project is an educational operating system kernel designed
***              to run on x86 architecture in 32-bit protected mode. The primary goal of this kernel 
***              is to provide a foundational understanding of low-level programming and the inner workings 
***              of operating systems, including memory management, process scheduling, and hardware interaction.
**/

#include <stdio.h>
#include <stdlib.h>

// @function:       kernel_main
// @description:    The main kernel function invoked as called in kernel_entry.asm
// @param:          None
void kernel_main() {
    // Pointer to the start of video memory.
    // 0xb8000 is the starting address of the VGA text buffer in video memory.
    char *video_memory = (char*)0xb8000;

    // Write the character 'X' to the first position in the VGA text buffer.
    // The VGA text buffer consists of pairs of bytes: the character and its attribute.
    // Here, video_memory[0] is the character byte.
    video_memory[0] = 'X';

    // Write the attribute byte for the character.
    // 0x07 sets the character attribute to light grey text on black background.
    video_memory[1] = 0x07;
}
