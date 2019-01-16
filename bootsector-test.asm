[BITS 16]
[ORG 0]

jmp 0x7C0:main   ; Goto segment 07C0

main:
    mov si, msg
    call print
    
jmp $ ; jump to current address
    
print:
    lodsb
    or al, 0 ; if al is 0, done
    jz done
    mov ah, 0x0e ; tty mode
    mov bh, 0;
    int 0x10; print al w/ tty mode
    jmp bios_print
    
done:
    ret

msg   db 'Hello World', 13, 10, 0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55 
