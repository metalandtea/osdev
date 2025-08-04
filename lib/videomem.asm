;
;   Dependencies:
;       __macros__.asm
;

SECTION .data:
    text_cursor dd 0x0
    terminal_color db 0x02

    terminal_width dd 0xA0


SECTION .code:
;
;   puts: puts a string to the monitor
;       in: esi -> string to point to with null terminator
;           text_cursor -> the starting location of the cursor
;           terminal_color -> background color bit | text color bit 
;       out:
;           text_cursor <- new starting location at end of string
;
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
    cmp ecx, MEM_VID_TEXT_SIZE
    jl .lp
    jmp .done

.done:
    xor ecx, ecx
    ret

;
;   putnl: puts a new line onto screen
;       in: 
;           text_cursor -> the current position of the cursor
;           terminal_width -> the width of the terminal
;       out:
;           next_cursor <- the new position
;
putnl:
.start:
    ;get the difference between the column number
    ;and the current number
    mov eax, [text_cursor]
    xor edx, edx ;zero edx

    mov ebx, [terminal_width]
    div ebx ;result in eax, remainder in edx (we only need remainder)

    ;change eax to text_cursor again and thena add edx to got to new line
    mov eax, [text_cursor]
    
    ;make ecx the remaining characters needed to jump (terminal width - remainder)
    mov ecx, [terminal_width]
    sub ecx, edx

    add eax, ecx 

    mov [text_cursor], eax ;set new text cursor
    jmp .done    
.done:
    ;clean up everything
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    ret