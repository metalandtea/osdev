;Macros
%include "lib/__macros__.asm"

;Boot loader stuff
%include "boot/sector2.asm"
%include "boot/gdt.asm"
%include "boot/kernel_entry.asm"

;OS library files
%include "lib/textdriver.asm"
%include "lib/idt.asm"

int_1_jmp:
    mov BYTE [0xb8000], 'A'
    iret

kernel:
    mov eax, int_1_jmp
    mov WORD [idt_entry_0 + interrupt_entry.offset_low], ax

    shr eax, 16
    mov WORD [idt_entry_0 + interrupt_entry.offset_high], ax
    lidt [IDT_descriptor]

    pushad
    int 0x0
    popad
exit:
    cli
    hlt
    jmp $