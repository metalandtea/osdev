;
;   Dependencies:
;           __macros__: for general ABI compliance
;

; -- macros -- ;
%define MEM_VID_TEXT_START 0xb8000
%define MEM_VID_TEXT_SIZE 0x2000

; -- data -- ;
text_cursor dd 0x0
terminal_color db 0x72

terminal_width dd 0xA0 ;80
; -- functions -- ;

;
;   putc:
;       in:
;
;
%macro putc 3
    
    call __internal__putc
%endmacro
 
__internal__putc:
SFRAME
.start:
    ;calculating x
    mov ecx, [ebp+16] ; x
    
    ;mult by 2 to get only the 0 + 2n bytes
    mov eax, ecx
    add ecx, eax

    ;calculating y
    mov eax, [ebp+12] ; y
    mov ebx, [terminal_width]
    
    mul ebx ; -> eax = y * terminal width
    add eax, ecx ; -> eax = x + (y * terminal width)
    add eax, MEM_VID_TEXT_START
    mov ecx, eax ; our final val

    ;testing
    mov al, BYTE [ebp+8] ;character
    mov ah, [terminal_color]

    mov [ecx], ax
.done:
SFRAME_END 3

;
;   puts x, y, string, size
;    
%macro puts 4
    push %1
    push %2
    push %3
    push %4
    call __internal__puts
%endmacro

__internal__puts:
SFRAME
.start:
    mov ecx, [ebp + 8] ; size
    mov esi, [ebp + 12] ; source string
    
    mov eax, [ebp + 20] ; x
    mov edx, [ebp + 16] ; y
    jmp .lp
.lp:
    cmp ecx, 0
    je .done

    movzx ebx, BYTE [esi]
    ;push scratch so they aren't overwritten
    push eax
    push edx
    push ecx

    putc eax, edx, ebx

    pop ecx
    pop edx
    pop eax

    dec ecx
    inc esi
    inc eax
    jmp .lp
.done:
SFRAME_END 4

;
;   clearScreen
;
%macro clearScreen 0
    call __internal__clearScreen
%endmacro

__internal__clearScreen:
SFRAME
.start:
    mov edi, MEM_VID_TEXT_START
    xor ecx, ecx
.lp:
    mov BYTE [edi+ecx], 0x0
    inc ecx
    mov dl, BYTE [terminal_color]
    mov BYTE [edi+ecx], dl
    inc ecx
    cmp ecx, MEM_VID_TEXT_SIZE
    jl .lp
    jmp .done
.done:
SFRAME_END 0