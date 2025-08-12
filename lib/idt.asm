;
;   %1 -> offset (entry) [16 bits]
;   %2 -> segment selector (GDT) [16 bits]
;       ring 0
;       gate size 32
;   
%macro IDT_int_0_32 2 
    dw %1 & 0xFFFF ;first 16 bits of entry
    db 0x8E ; magic number (see intel)
    db 0x0 ;0s and res
    dw %2 ;segment selector
    dw (%1 >> 32) & 0xFFFF ;last 16 bits of entry
%endmacro

;
;   %1 -> offset
;   %2 -> segment selector
;       ring 0
;       gate size 32
;
struc interrupt_entry
    .offset_low: resw 1
    .selector: resw 1
    .zero: resb 1
    .attributes: resb 1
    .offset_high: resw 1
endstruc

%macro initEntry 0
    istruc interrupt_entry
        at interrupt_entry.offset_low, dw 0
        at interrupt_entry.selector, dw 0x08
        at interrupt_entry.zero, db 0
        at interrupt_entry.attributes, db 0x8E
        at interrupt_entry.offset_high, dw 0
    iend
%endmacro

align 4
IDT_start:
    idt_entry_0: initEntry 
IDT_end:

IDT_descriptor:
    dw IDT_end - IDT_start - 1 ;size
    dd IDT_start