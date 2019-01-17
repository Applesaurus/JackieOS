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
    
    call prints
    mov gs, 0xb800 ; video memory
    mov bx, 0x0000 ; video memory offset
    mov ax, [gs:bx]
    
    mov word [reg16], ax
    call print16
    
    
    
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
    mov ah, 0x0F ; white on black
    mov cx, ax ; save char & attrib 
    movzx ax, byte [ypos]
    mov dx, 160
    mul dx
    movzx bx, byte [xpos]
    sh1 bx, 1
    
    mov di, 0
    add di, ax ; y offset
    add di, bx ; x offset
    
    mov ax, cx ; restore char & attrib
    stosw ; write character in al to first byte of video memory, attribute in ah to second
    add byte [xpos], 1 ; advance x position to the right
    ret

prints:
    lodsb
    test al, al
    jnz cprint
    add byte [ypos], 1 ; go down 
    mov byte [xpos], 0 ; go all the way to left
    ret
    

print16:

    
done:
    ret

msg   db 'Hello World', 13, 10, 0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55 
