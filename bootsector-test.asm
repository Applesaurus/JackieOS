[BITS 16]
[ORG 0]

jmp 0x7C0:main   ; goto segment 07C0

main:
    xor ax, ax
    mov ds, ax
    mov ss, ax ; set stack segment to 0 and stack pointer to well past code to be executed
    mov sp, 0x9c00
    cld
    
    mov si, msg
    call print-bios
    
    
    
jmp $ ; jump to current address
    
print-bios:
    lodsb
    test al, al ; if al is 0, done
    jz done; 
    mov ah, 0x0e ; tty mode
    mov bh, 0;
    int 0x10; print al w/ tty mode
    jmp bios_print
    
printc:

prints:
    
done:
    ret

msg   db 'Hello World', 13, 10, 0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55 
