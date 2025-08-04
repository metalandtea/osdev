
; text video memory starts at 0xb8000
; first byte: character
; second byte: color

section .code

[bits 32]
start_protected_mode:
    ;reset all the pointer stuff
    mov ax, 0x10
    mov ds, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ;setup stack
    mov esp, STACK_TOP
    mov ebp, esp

    ;jump to kernel
    jmp CSS:kernel