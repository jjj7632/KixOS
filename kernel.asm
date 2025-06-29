[BITS 16]
[ORG 0x1000]      ; Must match the address where the bootloader loads it

start:
    mov ah, 0x0E  ; BIOS teletype output
    mov al, 'K'   ; Character to print
    int 0x10      ; Print 'K'
    mov al, '!'
    int 0x10      ; Print '!'

hang:
    cli
    hlt           ; Halt CPU
    jmp hang      ; Infinite loop
