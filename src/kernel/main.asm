;MACROS
%define ENDL 0x0D, 0x0A

org 0x7c00
bits 16

;Jump to main at beginning
start:
    jmp main

;
; Prints a string to the screen
; Params:
;   ds:si points to string
;
puts:
    push si
    push ax

.lp: ;loop
    lodsb
    or al, al ;so we can get a flag if there's no value;
    jz .done

    ;BIOS interrupt
    mov ah, 0x0e
    mov bh, 0
    int 0x10 ; This is the most complex hello world program ever
    jmp .lp

.done:
    pop ax
    pop si
    ret

main:
    mov ax, 0 ;can't write to ds/es directly
    mov ds, ax ;address
    mov es, ax

    ;setup stack;
    mov ss, ax
    mov sp, 0x7c00 ; stack goes down from memeory

    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello, world!', ENDL, 0

;Zero out the rest of the memory and add the expected word to the end;
times 510-($-$$) db 0
dw 0AA55h