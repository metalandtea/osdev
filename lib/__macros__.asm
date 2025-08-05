
;NOTE: if macros do not explicitly mention in
; name what mode they support, assume protected

;Stack Macros (for kernel runtime)
%define STACK_SIZE 0x4000
%define STACK_TOP 0x90000 ;MAKE SURE THIS IS 16 BYTE ALIGNED

;general macros
%macro PUSH_PRESERVED 0
    push ebx
    push esi
    push edi
    push ebp
    push esp
%endmacro

%macro POP_PRESERVED 0
    pop esp
    pop ebp
    pop edi
    pop esi
    pop ebx
%endmacro