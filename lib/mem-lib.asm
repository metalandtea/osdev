;
;   Dependencies:
;       __macros__: System V compliant macros

;
;   memcpy: copies a memory buffer
;       in: 
;           esi -> location of input buffer start
;           edi -> location of output buffer
;           ecx -> size of buffer to copy
;       out:
;           esi (preserved)
;           edi (preserved)
;
%macro memcpy 3
    PUSH_PRESERVED
    mov esi, %1
    mov edi, %2
    mov ecx, %3
    call __internal__memcpy
    POP_PRESERVED
%endmacro

__internal__memcpy:
.start:
    cld ;clear direction flag (DF = 0 is incrementing)
    rep movsb
.done:
    ret