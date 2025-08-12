
;NOTE: if macros do not explicitly mention in
; name what mode they support, assume protected

;Stack Macros (for kernel runtime)
%define STACK_SIZE 0x4000
%define STACK_TOP 0x90000 ;MAKE SURE THIS IS 16 BYTE ALIGNED
%define ARG_SIZE 4

;general macros
%macro SFRAME 0
    push ebp
    mov ebp, esp

    ;store reserved stuff
    push ebx
    push edi
    push esi
%endmacro

%macro SFRAME_END 1
    pop esi
    pop edi
    pop ebx
    pop ebp

    %assign __ret__bytes %1 * ARG_SIZE 
    ret __ret__bytes
%endmacro