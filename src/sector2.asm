
[org 0x201] ;location of second sector

[bits 16]
switch_to_32bit:
    cli ;stop interrupts
    lgdt [GDT_descriptor] ;load gdt descriptor
    mov eax, cr0 ;
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:start_protected_mode

%include "src/gdt.asm"
%include "src/kernel_entry.asm"

times 1024-($-$$) db 0