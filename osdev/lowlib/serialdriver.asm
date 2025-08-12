;
;   For now, the serial driver is only handling the serial
;   port 1, which is used explicitly for debugging
;

; -- macros -- ;
%define PORT 0x3F8
;BAUD RATE: 9600 (115200/12)

;
;   outb <port> <value>
;
%macro outb 2
    mov dx, %1
    mov al, %2
    out dx, al
%endmacro

;
;   inb <dest> <port>
;
%macro inb 2
    mov ax, %1
    mov dx, %2
    in ax, dx
%endmacro

;-- stubs --;

;
; serialStart
;
serialStart:
    ;this is all fine because it can be evaluated at compile time
    outb (PORT + 1), 0x00 ; disable interrupts
    outb (PORT + 3), 0x80 ; enable DLAB 
    outb (PORT + 0), 0x0C ; set divisor (lo)
    outb (PORT + 1), 0x00 ; (hi)
    outb (PORT + 3), 0x03 ; 8 bits, no parity, one stop bit (standard)
    outb (PORT + 2), 0xc7 ; Enable FIFO, clear, with 14 byte thresh
    outb (PORT + 4), 0xbe ; RTS set and IRQ enabled
    outb (PORT + 4), 0x1E ; loopback mode (to test)
    outb (PORT + 0), 0xAE ; magic number to test port 

    ;test serial against magic number
    inb ax, (PORT + 0)
    cmp ax, 0xAE

    je .succ

.fail:
    cli
    hlt
    jmp .fail

.succ:
    outb (PORT + 4), 0x0F ;put in normal mode
    ret

;
;   serialPutC
;       al -> character
;       
serialPutC:
    outb (PORT), al
    ret
;
;   serialWrite
;       esi -> source (null terminated)
;
serialWrite:
.lp:
    lodsb
    cmp al, 0
    je .done

    outb (PORT), al
    jmp .lp
.done:
    ret



;-- Interrupt Entry --;

;   interrupt 0x20
;
;   ah -> command
;       0x00: serialStart
;       0x01: serialPutC
;           
;       0x02: serialWrite
;
serial_entry:
.start:
    pushad
    cmp ah, 0x00
    je .init
    
    cmp ah, 0x01
    je .putc

    cmp ah, 0x02
    je .write

    jmp .done
;--child functions --;
.init:
    call serialStart
    jmp .done
.putc:
    call serialPutC
    jmp .done
.write:
    call serialWrite
    jmp .done
;--
.done:
    popad
    iret