
; ENDING WITH CODE MACRO
%macro end_with_code 1
  mov     eax, 1
  mov     ebx, %1
  int     0x80
%endmacro



global _start

section .rodata

_start: 
  ; pop number of arguments
  pop rax
  cmp rax, 5
  jne .wrongInput


  end_with_code 0

  .wrongInput:
    end_with_code 1
    ret