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
    mov                     r9, [rsi]
    mov                     r10, rdx
    
    ;; mnoże razy 10
    imul                    r9, 8
    imul                    r10, 8

    main_loop:
    
        cmp                r9, r10
        je                 end_loop

        mov                dword [r8 + r9], 1 ; set all values as 1.
        add                r9, 8
        jmp                main_loop
    
    end_loop:
    
    normal_exit:
        ret
   
