extern pixtime

global _pixme


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


; All of the arguments are stored in: RDI, RSI, RDX

_pixme:

    main_loop:
        calculate_pi       rsi
        inc                rsi
        cmp                rsi, rdx
        jne                main_loop
        jmp                end_loop
        
    end_loop:
    
    normal_exit:
        end_with_code      0
