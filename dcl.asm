BUFFER_SIZE     equ 1000
DOWN_LIMIT      equ 49
TOP_LIMIT       equ 90

; Ends program with given code.
%macro end_with_code 1
    mov         eax, 60
    mov         rdi, %1
    syscall
%endmacro

; Checks, if given character c meets '1' <= c <= 'Z'.
%macro correct_character 1
    cmp     %1, DOWN_LIMIT
    jl      bad_input
    cmp     %1, TOP_LIMIT
    jg      bad_input
%endmacro

;; Checks, if given permutation has length 42 and contains only allowed characers.
%macro correct_permutation 1
    mov                 rdx, %1         ; argument
    mov                 rcx, 0          ; length
    %%iterate_length:
        cmp                 byte [rdx + rcx], 0
        je                  %%end_length
        correct_character   byte [rdx + rcx]
        inc                 rcx
        jmp                 %%iterate_length
    %%end_length:

    cmp                 rcx, 42
    jne                 bad_input
%endmacro

;; Creates reversed permutation: for example 210 -> 012, for L and R argument.
%macro create_reverse_permutation 2
    mov             rdx, 0
    %%iterate_rev:
        cmp         rdx, 42
        je          %%end_rev

        movzx ecx, byte [%1 + rdx]
        sub ecx, DOWN_LIMIT
        cmp byte [%2 + rcx], 0xff
        jne bad_input
        mov rax, rdx
        add rax, DOWN_LIMIT
        mov [%2 + rcx], al

        inc         rdx
        jmp         %%iterate_rev
    %%end_rev:
%endmacro

;; Validate cycles int T argument.
%macro validate_cycles 1
    xor eax, eax
%%loop:

    movzx ecx, byte [%1 + rax]
    sub ecx, DOWN_LIMIT
    movzx edx, byte [%1 + rcx]
    sub edx, DOWN_LIMIT

    cmp eax, edx
    jne bad_input
    cmp eax, ecx
    je bad_input

    inc eax
    cmp eax, 42
    jne %%loop
%endmacro

;; Validates key argument.
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
        jmp        bad_input
    %%iterate_end:
    cmp     rdx, 2
    jne     %%wrong_len
%endmacro

;; Changes keys - Lkey and Rkey.
%macro change_rotors 1
    add         r13b, 1
    cmp         r13b, TOP_LIMIT+1
    je          %%fix_rotor_r

    %%check_rotor_l:
    cmp         r13b, 'L'
    je          %%move_rotor_l
    cmp         r13b, 'R'
    je          %%move_rotor_l
    cmp         r13b, 'T'
    je          %%move_rotor_l
    jmp         %%end_rotors

    %%fix_rotor_r:
    mov         r13b, DOWN_LIMIT
    jmp         %%check_rotor_l

    %%move_rotor_l:
    add         r12b, 1
    cmp         r12b, TOP_LIMIT+1
    je          %%fix_rotor_l
    jmp         %%end_rotors

    %%fix_rotor_l:
    mov         r12b, DOWN_LIMIT
    jmp         %%end_rotors

    %%end_rotors:
%endmacro

;; Codes letter stored in r14b with Q rotor.
%macro code_letter_with_Q 1
    mov     dl, r14b
    sub     dl, DOWN_LIMIT
    add     dl, %1
    sub     dl, DOWN_LIMIT

    %%needs_modulo:
    cmp     dl, 42
    jl      %%dont_need_modulo
    sub     dl, 42
    jmp     %%needs_modulo

    %%dont_need_modulo:
    add     dl, DOWN_LIMIT
    mov     r14b, dl
%endmacro

;; Codes letter stored in r14b with Q^-1 rotor.
%macro code_letter_with_Q_reverse 1
    mov     dl, r14b
    add     dl, 42
    sub     dl, %1

    %%needs_modulo:
    cmp     dl, 42
    jl      %%dont_need_modulo
    sub     dl, 42
    jmp     %%needs_modulo

    %%dont_need_modulo:
    add     dl, DOWN_LIMIT
    mov     r14b, dl
%endmacro

;; Codes letter stored in r14b with any given by array rotor.
%macro code_letter_with_rotor 1
   xor      rdx, rdx
   mov      dl, r14b
   sub      dl, DOWN_LIMIT
   mov      r14b, byte [%1 + rdx]
%endmacro

;; Runs all of the sequences needed for coding the letter.
%macro code_letter 1
    change_rotors  0
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
%endmacro


global _start

section .bss
str:   resb BUFFER_SIZE+1       ; buffer for stdin.

section .data
    l1:     times 42 db 0xff    ; reversed permutation for L rotor.
    r1:     times 42 db 0xff    ; reversed permutation for R rotor.

section .text


_start:

    pop     rax
    cmp     rax, 5
    jne     bad_input
    pop     rax
    
;    Check the arguments given.
    pop                             r8              ; permutacja L
    correct_permutation             r8
    create_reverse_permutation      r8, l1

    pop                             r9              ; permutacja R
    correct_permutation             r9
    create_reverse_permutation      r9, r1

    pop                             r10             ; permutacja T
    correct_permutation             r10
    validate_cycles                 r10

    pop                             r12             ; zmienne key
    check_key                       r12
    movzx                           r13, byte [r12 + 1]
    movzx                           r12, byte [r12]


main_loop:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, str
    mov     rdx, BUFFER_SIZE
    syscall

    mov     r15, 0
    mov     rcx, rax
    
    cmp rax, 0
    je end_program
    
;   Iterates through buffer and codes every letter.
    small_loop:
        cmp                 r15, rcx
        je                  end_small_loop
        mov                 r14b, byte [str + r15]
        code_letter         0
        mov                 byte [str + r15], r14b
        inc                 r15
        jmp                 small_loop
    end_small_loop:

    mov             rax, rcx
    mov             rdx, rax
    mov             rax, 1
    mov             rdi, 1
    mov             rsi, str
    syscall

    cmp     rdx, BUFFER_SIZE
    je      main_loop
    jmp     end_program

end_program:

normal_exit:
    end_with_code   0

bad_input:
    end_with_code   1

