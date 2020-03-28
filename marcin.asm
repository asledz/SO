%macro end_program 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

global _start

section .rodata
        HELLO:  db "Hello World", 0xa
        HELLO_LEN: equ $-HELLO

section .text

;poczatek programu
_start:
    pop rbx
    cmp rbx, 2
    jne bad

    pop rbx
    pop rcx
loop:
    cmp byte [rcx], 0x0
    je exit 
    mov eax, 4
    mov ebx, 1
    mov edx, HELLO_LEN
    mov     ecx, HELLO
    int 0x80
    inc rcx
    jmp loop


exit:
    end_program 0


bad:
    end_program 1  