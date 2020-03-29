%macro end_with_code 1
    mov     eax, 1
    mov     ebx, %1
    int     0x80
%endmacro

BUFFER_SIZE     equ 10


global _start


section .data
    str:    times BUFFER_SIZE db 0 ; alokuję miejsce na string.

section .bss
    e1_len resd 1           ; Ile przeczytanych.

section .text

_start:

    pop     rax             ; ilość argumentówśś
    cmp     rax, 5
    jne     .badInput
    pop     rax             ; nazwa pliku
    
    pop     r8              ; permutacja L
    pop     r9              ; permutacja R
    pop     r10             ; permutacja T
    pop     r12             ; zmienna: Key
    

.loop:
    ;; CZYTANIE
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, str            ; Destination
    mov     edx, BUFFER_SIZE    ; Length
    

    mov [e1_len], eax           ; Ile było przeczytanych
    cmp     eax, edx
    je      .loop
    jmp     .end_program

.end_program:
    
.exit:
    end_with_code   0
.badInput:
    end_with_code   1
