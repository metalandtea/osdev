;
; Dependencies
;   textdriver: for cursor functions and terminal behavior
;   __macros__: for ABI compliance
;

;-- macros --;

;Clock options

;0 -> bin/bsd (bin)
;01 -> clock access mode (hi)
;00 -> select channel (0)
;111 -> clock mode (square)
%define CLOCK_TERMINAL_SETTINGS 00100111b 

%define CLOCK_MODE_REGISTER 0x43
%define CLOCK_CHANNEL_0 0x40

;Note: to keep performance reasonable, clock cycles will not push much onto the stack

;
;   set_clock_settings <setting byte>
;
%macro set_clock_settings 1
    mov al, %1
    call __internal__set_clock_settings
%endmacro

__internal__set_clock_settings:
.start:
    out CLOCK_MODE_REGISTER, al
.done:
    ret