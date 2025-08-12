
;   Dependenciear
;           __macros__: for ABI compliance
;

; -- macros -- ;
%define MEM_VID_TEXT_START 0xb8000
%define MEM_VID_TEXT_SIZE 0x2000

; -- data -- ;
text_cursor_x dd 0x0
text_cursor_y dd 0x0

terminal_color db 0x02

terminal_width dd 0x50 ;80
; -- functions -- ;

;
;   putc x, y, c
;
%macro putc 3
    push %1
    push %2
    push %3 
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
    xor ecx, ecx
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
;   clear_screen
;
%macro clear_screen 0
    call __internal__clear_screen
%endmacro

__internal__clear_screen:
SFRAME
.start:
    mov edi, MEM_VID_TEXT_START
    xor ecx, ecx
    mov al, 0x0
    mov ah, BYTE [terminal_color]
.lp:
    mov [edi+ecx], ax
    inc ecx
    cmp ecx, MEM_VID_TEXT_SIZE
    jl .lp
    jmp .done
.done:
SFRAME_END 0

;
;   strlen string_source
;
%macro strlen 1
    push %1
    call __internal__strlen
%endmacro

__internal__strlen:
SFRAME
.start:
    xor ecx, ecx
    mov esi, [ebp + 8] ; string source

    jmp .lp
.lp:
    lodsb
    cmp al, 0
    je .done

    inc ecx
    jmp .lp
.done:
SFRAME_END 1

;
;   csr_write: string
;       mem use:
;           text_cursor_x
;           text_cursor_y
;
%macro csr_write 1
    push %1
    call __internal__csr_write
%endmacro

__internal__csr_write:
SFRAME
.start:
    mov esi, [ebp + 8]
    strlen esi ;get length of string

    mov ebx, ecx ;store to update cursor later
    puts DWORD [text_cursor_x], DWORD [text_cursor_y], esi, ecx

    add [text_cursor_x], ebx

    ; wrap if text_cursor_x is greater than terminal_width
    mov eax, [text_cursor_x]
    mov edx, [text_cursor_y]

    cmp eax, [terminal_width]
    jge .newline
    jmp .done
    
.newline:
    add edx, 1
    mov [text_cursor_y], edx

    xor eax, eax
    mov [text_cursor_x], eax       
.done:
SFRAME_END 1

;
;   csr_move x, y
;
%macro csr_move 2
    push %1
    push %2
    call __internal__csr_move
%endmacro

__internal__csr_move:
SFRAME
.start:
    mov eax, [ebp + 12] ; x
    mov edx, [ebp + 8] ; y
    
    cmp eax, [terminal_width]
    jl .done
.newline:
    xor eax, eax
    add edx, 1
.done:
    mov [text_cursor_x], eax
    mov [text_cursor_y], edx
SFRAME_END 2

;
;   csr_inc
;
%macro csr_inc 0
    call __internal__csr_inc
%endmacro

__internal__csr_inc:
SFRAME
.start:
    mov eax, [text_cursor_x]
    inc eax

    cmp eax, [terminal_width]
    jl .done
.newline:
    mov edx, [text_cursor_y]
    inc edx
    xor eax, eax
.done:
    mov [text_cursor_x], eax
    mov [text_cursor_y], edx
SFRAME_END 0

;
;   csr_dec
;
