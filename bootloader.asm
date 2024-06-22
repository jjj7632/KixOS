; bootloader.asm
BITS 16         ; Set the assembler to 16-bit mode
org 0x7c00      ; Origin: Set the code to start at memory address 0x7C00
 
start:          ; Label 'start': this is the entry point for the code
    ; Print 'Hello, World!' to the screen   
    mov si, hello_msg   ; Load the address of the string 'hello_msg' into the SI register
    call print_string   ; Call the 'print_string' subroutine

print_string:           ;Label 'print_string': this is a subroutine to print a string
    mov ah, 0x0E        ; Set AH to 0x0E, the BIOS teletype (TTY) function for displaying characters  
.loop:                  ; Label '.loop': start of a typical 'for loop'
    lodsb               ; Load the byte at [SI] into Al and increment SI
    cmp al, 0           ; Compare AL with 0 (end of the string)
    je .done            ; If AL is 0, jump to '.done' label
    int 0x10            ; Call the BIOS interrupt 0x10 to print the character in AL
    jmp .loop           ; Jump back to the start of the loop
.done:                  ; Label '.done': end of the subroutine
    ret                 ; Return from the subroutine

hello_msg db 'Hello, World!', 0  ; Define the string followed by a null terminator (0)

times 510-($-$$) db 0       ; Fill the rest of the 512-byte sector with zeros
                            ; ($-$$) is the current size of the code, so 510 - (code size) bytes are filled with zero.
                            ; 2 bytes are reserved for the boot signature
dw 0xAA55                   ; Boot signature, 0xAA55, to mark the disk as bootable