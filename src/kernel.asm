;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files
%include "lib/textdriver.asm"
%include "lib/mem-lib.asm"

mystring: db "Hello, World!"
myotherstring: db "Beans"
my_mem_test: db "H", 0x07, "i"

kernel:
    clearScreen
    putc 0, 0, 'A'
    puts 0, 1, mystring, 13
exit:
    cli
    hlt
    jmp exit