[org 0x201] ;location of kernel
[bits 16]

print:
    mov si, msg

    .lp:
        mov ah, 0xE ; ah -> instruction
        lodsb ; ah -> *si, si += 4 (1 byte)

        cmp al, 0 
        je .done ; if prev inst 0 jump .done
        int 0x10 ; teletype print char

        jmp .lp ;jmp into lp again

    .done:
        jmp kernel_stop

kernel_stop:
    hlt
    jmp $

msg: db "Success! We're in the Kernel!", 0
times 512-($-$$) db 0