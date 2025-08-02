
; text video memory starts at 0xb8000
; first byte: character
; second byte: color

%include "src/__macros__.asm"

[bits 32]
start_protected_mode:
    mov al, 'A'
    mov ah, 0x08
    mov [0xb8000], ax 
