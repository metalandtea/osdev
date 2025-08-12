;
;   setEntryOffset <entry_num> <offset> 
;      note: make sure that <entry_num> is valid in the IDT
;       (if it's not it'll triple fault
%macro setEntryOffset 2
    pushad
    ;get position from entry_num
    mov ebx, IDT_start

    mov ecx, %1
    lea ebx, [ebx + ecx*8]

    mov eax, %2
    mov WORD [ebx + interrupt_entry.offset_low], ax

    shr eax, 16
    mov WORD [ebx + interrupt_entry.offset_high], ax
    popad
%endmacro

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
    %rep 256
        initEntry
    %endrep
IDT_end:

IDT_descriptor:
    dw IDT_end - IDT_start - 1 ;size
    dd IDT_start