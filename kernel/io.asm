; io.asm - I/O routines
;
; This file contains routines for handling input/output operations
; such as moving the cursor on the screen.
section .text
    global MovCursor
    global PrintChar

; --------------------------
; MovCursor
; Purpose: Move the cursor to (BL=X, BH=Y) and remember the position
; Input:
;   BH = Y (row)
;   BL = X (column)
; Output:
;   None (modifies internal cursor position via BIOS)
; --------------------------

MovCursor:
    mov ah, 0x02      ; BIOS function: Video - Set cursor position
    mov dh, bh        ; DH = row (Y)
    mov dl, bl        ; DL = column (X)
    mov bh, 0x00      ; Page number (usually 0)
    int 0x10          ; Call BIOS interrupt
    ret

; -------------------------
; PrintChar
; Purpose: Print a character on screen, at the cursor position previously
; set by MovCursor
; Input:
;   al = Character to print
;   bl = text color
;   cx = number of times the chracter is repeated
; Output:
;   None (Prints the character to the screen at the previously set cursor position)

PrintChar:
    mov ah, 0x09    ; BIOS function: Video - write character and attribute at cursor position
    mov bh, 0x00    ; Page number
    int 0x10    ; Call BIOS interrupt
    ret