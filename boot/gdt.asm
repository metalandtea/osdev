
GDT_start:
    null_descriptor:    ; offset 0
        dq 0x00000000   ; null sector size
    
    ;since we're using a FMM, base should be 0s
    GDT_code_descriptor:   ;offset 8 (CS points)
        dw 0xffff          ; first 16 bits of limit
        dw 0x0             ; base first 0-15 bits
        db 0x0             ; base 16-23 bits
        db 0b1001_1010     ; kernel code access byte and first 4 bits of flags
        
        ;Lower four bits are flags and upper
        ;four bits are the next 4 bits of the limit
        db 0b1100_1111  ; last 4 bits of flags and the last 4 bits of the limit
        db 0x0          ; base 24-31 bit  

    GDT_data_descriptor:
        dw 0xffff       ; first 16 bits of limit
        dw 0x0          ; base
        db 0x0          ; ----
        db 0b1001_0010  ; kernel data access byte
        db 0b1100_1111  ; same flags, I think it works (?)
        db 0x0          ; base again (bruh intel just make it consecutive)
GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1  ; size
    dd GDT_start                ; start

CSS equ GDT_code_descriptor - GDT_start
DSS equ GDT_data_descriptor - GDT_start