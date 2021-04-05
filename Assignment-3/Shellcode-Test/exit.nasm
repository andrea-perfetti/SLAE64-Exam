global _start

_start:
	nop
	nop
	nop
	nop

	xor rax, rax
	mov al, 0x3c		; rax = 0x3c (syscall exit)

	xor rdi, rdi
	add rdi, 0xD 		; rdi = 0x13

	syscall
