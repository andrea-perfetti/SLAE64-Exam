; Filename: Decoder-Exit.nasm
; Author  : Andrea Perfetti
; SLAE ID : PA-29059

global _start			

section .text
_start:
	jmp ShellcodeToStack 

Decode:
	pop rsi 				; RSI --> Pointer to start of the encoded shellcode

	xor rdx, rdx			; RDX --> Offset to shellcode byte being scanned
	xor rcx, rcx			; RCX --> Offset to actual shellcode being decoded

Loop:
	xor rbx, rbx			; Zeroing RBX
	mov bl, byte [rsi+rcx]	; Shellcode byte into BL

	xor bl, 0x3e	
	
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
	Shellcode: db 0x76,0xFE,0xf,0xFE,0xfe,0xFE,0x8e,0xFE,0x2,0xFE,0x76,0xFE,0xf,0xFE,0xc1,0xFE,0x76,0xFE,0xbd,0xFE,0xf9,0xFE,0x33,0xFE,0x31,0xFE,0x3b,0xFF