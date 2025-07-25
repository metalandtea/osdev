
;BIOS org
[org 0x7c00]
[bits 16]

;macros
KERNEL_OFFSET equ 0x201

;boot druver
mov [BOOT_DRIVE], dl ;get drive at beggining of execution

load_disk:
    mov ah, 0x2 ; ah -> instruction
    mov al, 1 ; al -> #of sectors to read
    mov ch, 0x0 ; cylinder 0
    mov cl, 0x2 ; sector 2
    mov dh, 0x0 ; dh -> head number
    mov dl, [BOOT_DRIVE] ; dl -> *BOOT_DRIVE (drive number)

    ;pointer (0x0000: 0x0300)
    mov bx, KERNEL_OFFSET

    int 0x13 ; Read Disk (CHS)

    jc .fail ;jump fail if carry
    jmp .success ;otherwise, success

    .fail:
        jmp sys_halt

    .success:
        call KERNEL_OFFSET

sys_halt:
    hlt
    jmp $

BOOT_DRIVE: db 0

;pad and give signature
times 510-($-$$) db 0
dw 0x0aa55