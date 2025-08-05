;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files
%include "lib/textdriver.asm"
%include "lib/mem-lib.asm"

mystring: db "Hello, World!", 0
my_mem_test: db "H", 0x07, "i", 0x07

kernel:
    flush
    memcpy my_mem_test, 0xb8000, 4
    putnl
    puts mystring
    
    

exit:
    cli
    hlt
    jmp exit