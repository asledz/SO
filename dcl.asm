;;;;;;;; CONSTANTS ;;;;;;;;

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
    %%iterate_length:
        cmp                 byte [rdx + rcx], 0
        je                  %%end_length
        correct_character   byte [rdx + rcx] ;; check wheter caracter is correct
        inc                 rcx
        jmp                 %%iterate_length
    %%end_length:
    
    cmp                 rcx, 42
    jne                 .bad_inital_check
%endmacro

%macro create_reverse_permutation 2
    mov             rdx, 0
    %%iterate_rev:
        cmp         rdx, 42             ; End of the loop.
        je          %%end_rev
        
        movzx       rcx, byte [%1 + rdx]
        sub         rcx, DOWN_LIMIT
        cmp         byte [%2 + rcx], 0
        jne         .bad_input_4
        
        movzx       rax, byte [%1 + rdx]
        mov         byte [%2 + rcx], al
        
        inc         rdx
        jmp         %%iterate_rev
    %%end_rev:
%endmacro

%macro check_key 1
    mov             rdx, 0
    mov             rcx, %1
    %%iterate_key:
        cmp         byte [rdx + rcx], 0
        je          %%iterate_end
        
        correct_character   byte [rcx + rdx]
        
        inc         rdx
        jmp         %%iterate_key
    %%wrong_len:
        jmp        .bad_input
    %%iterate_end:
    cmp     rdx, 2
    jne     %%wrong_len
%endmacro

%macro change_rotors 1
    add         r13b, 1 ; tutaj trzymam R key
    cmp         r13b, TOP_LIMIT+1   ; jeśli wychodzi poza limit
    je          %%fix_rotor_r       ;napraw
    
    %%check_rotor_l:
    cmp         r13b, 'L'
    je          %%move_rotor_l      ;ruszam jesli l
    cmp         r13b, 'R'
    je          %%move_rotor_l      ;ruszam jesli r
    cmp         r13b, 'T'
    je          %%move_rotor_l      ;ruszam jesli t
    jmp         %%end_rotors        ;koncze wszystko
    
    %%fix_rotor_r:
    mov         r13b, DOWN_LIMIT    ;musze ustawić go na dolny limit
    jmp         %%check_rotor_l      ; sprawdzam lke
    
    %%move_rotor_l:
    mov         r12b, DOWN_LIMIT
    jmp         %%end_rotors
    
    %%fix_rotor_l:
    mov         r12b, DOWN_LIMIT
    jmp         %%end_rotors
    
    %%end_rotors:
%endmacro

%macro code_letter_with_Q 1
    mov     dl, r14b
    add     dl, %1 ;increase o key
    sub     dl, DOWN_LIMIT
    sub     dl, DOWN_LIMIT

    %%needs_modulo:
    cmp     dl, 42
    jbe     %%dont_need_modulo
    sub     dl, 42
    jmp     %%needs_modulo

    %%dont_need_modulo:
    add     dl, DOWN_LIMIT
    mov     r14b, dl
%endmacro

%macro code_letter_with_Q_reverse 1
nop
%endmacro

%macro code_letter_with_rotor 1
   nop
%endmacro


%macro code_letter 1 ;; codes the letter stored in r14b
    correct_character           r14b

    code_letter_with_Q          r13b
    code_letter_with_rotor      r9
    code_letter_with_Q_reverse  r13b
    
    code_letter_with_Q          r12b
    code_letter_with_rotor      r8
    code_letter_with_Q_reverse  r12b
    
    code_letter_with_rotor      r10
    
    code_letter_with_Q          r12b
    code_letter_with_rotor      l1
    code_letter_with_Q_reverse  r12b
    
    code_letter_with_Q          r13b
    code_letter_with_rotor      r1
    code_letter_with_Q_reverse  r13b
    
    change_rotors  0
%endmacro

;;;;;;;; END OF MACROS ;;;;;;;;

;;;;;;;; SECTIONS ;;;;;;;;
global _start

section .data
    str:    times BUFFER_SIZE db 0 ; alokuję miejsce na string.
    l1:     times 42 db 0
    r1:     times 42 db 0
    t1:     times 42 db 0

section .bss
    e1_len resd 1           ; Ile przeczytanych.
section .text

;;;;;;;; PROGRAM START ;;;;;;;;

_start:

    pop     rax             ; ilość argumentówśś
    cmp     rax, 5
    jne     .bad_input
    pop     rax             ; nazwa pliku
    
    pop                             r8              ; permutacja L
    correct_permutation             r8
    create_reverse_permutation      r8, l1
    
    pop                             r9              ; permutacja R
    correct_permutation             r9
    create_reverse_permutation      r9, r1
    
    pop                             r10             ; permutacja T
    correct_permutation             r10
    create_reverse_permutation      r10, t1
    
    pop                             r12             ; zmienna: Key
    check_key                       r12
    mov                             r13b, byte [r12 + 1]
    mov                             r12b, byte [r12]

.main_loop:
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, str
    mov     edx, BUFFER_SIZE
    int     0x80
    
    mov     r15, 0
    .small_loop:
        mov                 r14b, byte [str + r15]
        code_letter         0
        mov                 [str + r15], r14b
        inc                 r15
        cmp                 r15, [e1_len]
        je                  .end_small_loop
    .end_small_loop:
    end_with_code [r15]
    ;; tyle wczytano znaków

    ;; WYPISZ POPRAWIONY STRING
    mov             edx, eax
    mov             eax, 4
    mov             ebx, 1
    mov             ecx, str
    int             0x80

    ;; CZY TO KONIEC? wczytywania
    cmp     edx, BUFFER_SIZE
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
    
.bad_input_4:
    end_with_code   4
