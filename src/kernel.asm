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
    puts 0, 0, mystring, 13

    mov [terminal_color], BYTE 0x02
exit:
    cli
    hlt
    jmp exit