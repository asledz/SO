extern pixtime

global pix


%macro moduluj 1
    // liczymy 16 ^ rdx mod rsi do rax
    xor         rax, rax
    
    %%start_potega:
        cmp                 [rdx], 0
        je                  %%end_potega
        
        %%start_modulo:
        
        %%end_modulo:
        
        dec                 rdx
        jmp                 %%start_potega
    
    %%end_potega:
    
%endmacro

;; ARGUMENT to j.
;; n to rcx
;; k to r11
%macro calculate 1
    
    xor                 r11, r11
    xor                 rdi, rdi
    
    %%begin_loop_inside:
        cmp             r11, rcx
        je              %%end_this_loop
        
        ;; W rsi zapisuję 8*k + j --> czyli 8 * r11 + $1 - mianownik ułamka w RSI.
        mov             rsi, r11
        mov             rax, 8
        mul             rsi
        mov             rax, rsi
        add             rsi, $1
        
        ;; licznik będzie liczony tutaj: 16 ^ n-k
        xor             rdx, rdx
        mov             rdx, rcx
        sub             rdx, r11 ;; tutaj jest n - k w RDX.
        
        moduluj         rax
        
        inc             r11
        jmp             %%begin_loop_inside
    %%end_this_loop:

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
    mov                     r9, qword [rsi]
    mov                     r10, rdx
    
    ;; Setting indexes to iterate:
    ; Starting index
    xor                    rdx, rdx
    mov                    rax, 4
    mul                    r9
    mov                    r9, rax
    ; Ending index
    xor                    rdx, rdx
    mov                    rax, 4
    mul                    r10
    mov                    r10, rax

    ;; Main loop
    main_loop:
    
    
        cmp                r9, r10
        je                 end_loop
        
        
        ; setting values
        
        mov                rcx, r9
        shr                rcx, 1 ;; mnożę razy DWA dla tego indeksu będę sobie obliczać. Potem tam będę mieć wynik(index jest 4 razy i tylko).
        
        calculate          1 ;; S(rcx, 1)
        mov                dword [r8 + r9], 1 ; set all values as 1.
    
        add                r9, 4
        jmp                main_loop
    
    end_loop:
    
    normal_exit:
        ret
   
