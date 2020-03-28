%macro end_with_code 1
  mov     eax, %1
  int     0x80
%endmacro

global _start

section .rodata

_start: 
  end_with_code 4