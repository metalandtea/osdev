;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files
%include "lib/videomem.asm"

mystring1: db "Hello, World!", 0
mystring2: db "This is my new and awesome OS!", 0
mystring3: db "It's pretty cool!", 0

kernel:
    call flush

    mov esi, mystring1
    call puts
    call putnl

    mov esi, mystring2
    call puts
    call putnl

    mov esi, mystring3
    call puts

    jmp exit

exit:
    cli
    hlt
    jmp exit