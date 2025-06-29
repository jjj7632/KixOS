; sample.asm — valid 16-bit second stage
org 0x500
bits 16

start:
    cli
    mov si, msg

print_loop:
    lodsb           ; load byte at DS:SI into AL, increment SI
    or al, al       ; check if it's null terminator
    jz hang
    mov ah, 0x0E    ; teletype output function
    int 0x10
    jmp print_loop

hang:
    hlt
    jmp hang

msg db "Hello World!", 0
