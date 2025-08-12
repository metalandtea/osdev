;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files (these are ignored since we jump straight to kernel)
%include "lib/textdriver.asm"
%include "lib/idt.asm"
%include "lowlib/serialdriver.asm"

mystring: db "Hello, world!", 0

kernel:
    ;setup
    call addIDTGates

    mov ah, 0x00 ; serialStart
    int 0x20

    mov ah, 0x02 ; serialWrite
    mov esi, mystring ; string to write
    int 0x20
exit:
    cli
    hlt
    jmp $