
;NOTE: if macros do not explicitly mention in
; name what mode they support, assume protected

;GDT Macros
%define CSS 0x08 ;code segment selector
%define DSS 0x10 ;data segment selector

;Video Macros
%define MEM_VID_TEXT_START 0xb8000
%define MEM_VID_TEXT_SIZE 0x4000

;Stack Macros (for kernel runtime)
%define STACK_SIZE 0x4000
%define STACK_TOP 0x90000