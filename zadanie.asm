%macro end_with_code 1
    mov     eax, 1
    mov     ebx, %1
    int     0x80
%endmacro

%macro print_char 1
    mov     eax, 4      ; printing argument
    mov     ebx, 1
    mov     ecx, %1
    mov     edx, 1
    int     0x80
%endmacro

global _start

section .rodata

_start: 

    ; Check, if number of arguments is correct(should be 4).
    pop     rax
    cmp     rax, 5      ; the number of arguments includes name.
    jne     .wrongInput

    ; Pop the name of the program to rcx
    pop     rcx
    call    .loop
    ; Test the printing
    
    ;test printing char.
;    print_char 'a'
    
    ; End of the program
    call    .exit

.loop:
    cmp byte [rcx], 0x0
    je exit
    mov eax, 4
    mov ebx, 1
    mov ecx, [rcx]
    mov edx, 1
    int 0x80
    inc rcx
    jmp loop

.exit:
    end_with_code 0
    
.wrongInput:
    end_with_code 1
    ret
