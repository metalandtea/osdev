;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files
%include "lib/textdriver.asm"
%include "lib/mem-lib.asm"

mystring: db "Hello, World! ", 0
myotherstring: db "Beans", 0

kernel:
    clearScreen
    csr_write mystring
    csr_move 2, 1
    csr_write myotherstring
exit:
    cli
    hlt
    jmp exit