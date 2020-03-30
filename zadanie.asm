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

%macro write_string 2
   mov   eax, 4
   mov   ebx, 1
   mov   ecx, %1
   mov   edx, %2
   int   0x80
%endmacro

global _start

section .rodata

_start: 

    ; Check, if number of arguments is correct(should be 4).
    pop     rax
    cmp     rax, 5      ; the number of arguments includes name.
    jne     .wrongInput

    ; Pop the name of the program to rcx
    pop     r8d
    
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, r8
    mov     edx, 10
    int     0x80
    
    ; Test the printing
    write_string [eax], 4
    ;test printing char.
;    print_char 'a'
    ; End of the program



  mov edx, napis
petla:
    mov ecl, byte [edx]
    zrób coś z cl
    inc edx ; beda niewyrownane dostepy do pamieic, nie wiem, czy cos sie nie wyjebie
    test cl, cl ; sprawdz czy 0, stringi w C koncza sie na zerowym bajcie, to ustawi flage Z, jesli jest 0
    jnz petla ; jesli flaga Z nieustawiona, skocz
koniec:


.exit:
    end_with_code 0
    
.wrongInput:
    end_with_code 1
