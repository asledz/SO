extern pixtime

global pix


; calculates S1
%macro calculate_pi 1
%endmacro

;
%macro calculate_s 2
%endmacro

%macro end_with_code 1
    mov         eax, 60
    mov         rdi, %1
    syscall
%endmacro


section .bss

section .data

section .text


; All of the arguments are stored in: RDI(array), RSI(start point), RDX(end point)

pix:

    ; MOVE ALL OF THE ARGUMENTS TO:
    ; array - R8
    ; start point - R9
    ; end point - R10
    mov                     r8, rdi
    mov                     r9, rsi
    mov                     r10, rdx
    
    main_loop:
        mov                qword [r8 + r9], 1 ; set all values as 1.
        inc                r9
        cmp                [r9], r10
        jne                main_loop
        jmp                end_loop
    
    end_loop:
    
    normal_exit:
   
