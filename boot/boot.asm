; boot.asm
BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; ---- kernel loading (simple, 1 sector) ----
    mov ax, 0x1000    ; The kernel segment (0x1000:0x0000 = 0x10000)
    mov es, ax
    xor bx, bx        ; ES:BX = 0x10000

    mov ah, 0x02
    mov al, 10          ; 10 sector reading
    ;mov al, 1            ; 1 sector!
    mov ch, 0
    mov cl, 2
    mov dh, 0
    ;mov dl, 0x80
    mov dl, 0x00   ; floppy
    int 0x13
    jc disk_error

    ; ---- Switching to Protected Mode ----
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:init_pm

BITS 32
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    jmp 0x10000         ; Jump to kernel load address (0x1000:0x0000)

disk_error:
    jmp $

; ---- GDT ----
gdt_start:
    dq 0
gdt_code:
    dw 0xFFFF, 0
    db 0, 10011010b, 11001111b, 0
gdt_data:
    dw 0xFFFF, 0
    db 0, 10010010b, 11001111b, 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510 - ($ - $$) db 0
dw 0xAA55