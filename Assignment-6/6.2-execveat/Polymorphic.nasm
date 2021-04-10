global _start

section .text

_start:
	push   0x142
	pop    rax
	cqo
	push   rdx
	mov    rdi, 0x68732f2f6e69622f
	push   rdi
	push   rsp
	pop    rsi
	xor    r10, r10
	mov    r8, r10
	syscall