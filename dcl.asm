;; STAŁE

BUFFER_SIZE     equ 10
DOWN_LIMIT      equ 49
TOP_LIMIT       equ 90

;; MACROS

; ends program with given code
%macro end_with_code 1
    mov     eax, 1
    mov     ebx, %1
    int     0x80
%endmacro


; checks if character is correct
%macro correct_character 1
    cmp     %1, DOWN_LIMIT
    jl      .bad_inital_check2
    cmp     %1, TOP_LIMIT
    jg      .bad_inital_check2
%endmacro

%macro correct_permutation 1
    ; CALCULATE LENGTH
    mov                 rdx, %1         ;argument
    mov                 rcx, 0          ;długość
    .iterate_length:
        cmp                 byte [rdx + rcx], 0
        je                  .end_length
        correct_character   byte [rdx + rcx] ;; check wheter caracter is correct
        inc                 rcx
        jmp                 .iterate_length
    .end_length:
    
    ; LENGTH INCORRECT
    cmp                 rcx, 42
    jne                 .bad_inital_check
    
%endmacro

;; START OF THE PROGRAM


global _start


section .data
    str:    times BUFFER_SIZE db 0 ; alokuję miejsce na string.

section .bss
    e1_len resd 1           ; Ile przeczytanych.
    N: resd 1

section .text

_start:

    pop     rax             ; ilość argumentówśś
    cmp     rax, 5
    jne     .bad_input
    pop     rax             ; nazwa pliku
    
    pop     r8              ; permutacja L
    correct_permutation   r8
    pop     r9              ; permutacja R
;    check_permutation   r9
    pop     r10             ; permutacja T
;    check_permutation   r10
    pop     r12             ; zmienna: Key
;    check_key       r12

.main_loop:
    ;; CZYTANIE
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, str            ; Destination
    mov     edx, BUFFER_SIZE    ; Length
    int     0x80

    mov [e1_len], eax           ; Ile było przeczytanych
    
    cmp     eax, edx
    je      .main_loop
    jmp     .end_program


.end_program:

.normal_exit:
    end_with_code   0

.bad_input:
    end_with_code   1
    
.bad_inital_check:
    end_with_code   2
 
.bad_inital_check2:
    end_with_code   3
