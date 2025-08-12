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
    ;set up everything
    setEntryOffset 0x20, serial_entry
    lidt [IDT_descriptor]

    mov ah, 0x00
    int 0x20

    mov ah, 0x02
    mov esi, mystring
    int 0x20
exit:
    cli
    hlt
    jmp $