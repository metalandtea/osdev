
; text video memory starts at 0xb8000
; first byte: character
; second byte: color
%include "src/__macros__.asm"

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

    call flush

    mov esi, mystring1
    call puts

    mov esi, mystring2
    call puts

    jmp exit
    
;
;   puts: writes a string to text memory
;   in: esi -> pointer to string
;       terminal_color -> color of backgorund | color of text (VGA)
;       text_cursor -> start of write to memory
;   
text_cursor dd 0x0
terminal_color db 0x02

puts:
.start:
    mov ah, [terminal_color]
    mov ebx, [text_cursor] ; resgister for text cursor flow

    ;load MEM_VID_TEXT_START into edi
    mov edi, MEM_VID_TEXT_START
.lp:
    lodsb
    cmp al, 0
    je .done

    ;put to screen
    mov [edi+ebx], ax; write to memory
    add ebx, 2 ; add two to the address
    jmp .lp
.done:
    mov [text_cursor], ebx ; set the new offset
    
    ;reset and clear everything
    xor ax, ax
    xor ebx, ebx
    ret

;
;   flush: flushes the text memory
;
flush:
.start:
    mov edi, MEM_VID_TEXT_START
    xor ecx, ecx ;to increment stuff (we're going to write 4000 bytes)
.lp:
    mov BYTE [edi+ecx], 0x0
    inc ecx
    cmp ecx, 4000
    jl .lp
    jmp .done

.done:
    xor ecx, ecx
    ret

section .data

exit:
    cli
    hlt
    jmp exit

mystring1 db "Hello, World! ", 0
mystring2 db "This is my epic OS", 0