BITS 16                ; Start in 16-bit real mode
ORG 0x7C00             ; BIOS loads the bootloader at memory address 0x7C00

start:
    cli               ; Disable interrupts for safety during setup
    xor ax, ax        ; Clear AX register (set it to 0)
    mov ds, ax        ; Set Data Segment (DS) to 0
    mov es, ax        ; Set Extra Segment (ES) to 0
    mov ss, ax        ; Set Stack Segment (SS) to 0
    mov sp, 0x7C00    ; Set Stack Pointer (SP) to 0x7C00 (just below our code)

    ; Load the Global Descriptor Table (GDT)
    lgdt [gdt_descriptor]  ; Load the address and size of our GDT

    ; Enable protected mode
    mov eax, cr0      ; Move Control Register 0 into EAX
    or eax, 1         ; Set the lowest bit (Protection Enable bit)
    mov cr0, eax      ; Write it back to CR0 to enable protected mode

    ; Jump to protected mode (must be a far jump to flush pipeline)
    jmp CODE_SEG:init_pm   ; Jump to init_pm in 32-bit mode using GDT code segment

; --------- Begin 32-bit Protected Mode Code ---------
[BITS 32]
init_pm:
    ; Set up segment registers with data segment selector
    mov ax, DATA_SEG  ; Load data segment selector into AX
    mov ds, ax        ; Set DS
    mov es, ax        ; Set ES
    mov fs, ax        ; Set FS
    mov gs, ax        ; Set GS
    mov ss, ax        ; Set SS (stack segment)

    ; For demonstration: Put a recognizable value into EAX
    mov eax, 0xCAFEBABE

.loop:
    hlt              ; Halt CPU (wait for interrupt)
    jmp .loop        ; Infinite loop

; --------- Global Descriptor Table (GDT) ----------
gdt_start:

gdt_null:            ; Null descriptor (first entry is always null)
    dd 0x0           ; 4 bytes = 0
    dd 0x0           ; 4 bytes = 0

gdt_code:            ; Code segment descriptor
    dw 0xFFFF        ; Limit (lower 16 bits) = 0xFFFF
    dw 0x0000        ; Base (lower 16 bits) = 0x0000
    db 0x00          ; Base (next 8 bits) = 0x00
    db 10011010b     ; Access byte: present, ring 0, code segment, executable, readable
    db 11001111b     ; Flags: granularity=4KB, 32-bit segment, limit high bits=0xF
    db 0x00          ; Base (highest 8 bits) = 0x00

gdt_data:            ; Data segment descriptor (similar to code, but non-executable)
    dw 0xFFFF        ; Limit
    dw 0x0000        ; Base
    db 0x00          ; Base
    db 10010010b     ; Access byte: present, ring 0, data segment, writable
    db 11001111b     ; Flags: 4KB granularity, 32-bit
    db 0x00          ; Base

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Limit: size of GDT minus 1
    dd gdt_start                 ; Base: address of GDT

; --------- Segment Selector Constants ----------
CODE_SEG equ gdt_code - gdt_start   ; Offset of code segment in GDT
DATA_SEG equ gdt_data - gdt_start   ; Offset of data segment in GDT

; --------- Boot Sector Padding + Signature ----------
times 510 - ($ - $$) db 0    ; Fill up to 510 bytes with zeros
dw 0xAA55                    ; Boot signature (required to boot)

