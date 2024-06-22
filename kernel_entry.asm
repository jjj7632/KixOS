; kernel_entry.asm
; This file contains the entry point for the 32-bit protected mode kernel.


BITS 32     ; tells the assembler that the code that follows is for a 32-bit environment
extern kernel_main     ; kernel_main definition defined elsewhere in project

start:
    cli     ; CLI (Clear Interrupt Flag): Disables interrupts to prevent them from interfering with kernel initialization 

    cld
    ; CLD (Clear Direction Flag): Sets the direction flag to 0, causing string operations to auto-increment.
    ; This ensures that string operations go forward (low to high memory addresses).

    call kernel_main
    ; CALL 'kernel_main': Calls the main kernel function, which is defined elsewhere in the project.
    ; This transfers control to the C/C++ kernel code.
    
.loop:
    hlt
    ; HLT (Halt): Halts the CPU until the next external interrupt is received.
    jmp .loop
    ; JMP '.loop': Jumps back to the '.loop' label, creating an infinite loop that repeatedly halts the CPU.