section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_strcpy

; rdi = dest, rsi = src
; returns: rax = dest

ft_strcpy:
	mov rax, rdi		; initialise the return value to dest

.loop:
	mov dl, [rsi]		; copy character from src into 8-bit register DL
	mov [rdi], dl		; copy from DL into dest
	inc rsi				; advance memory address in src
	inc rdi				; and in dest
	test dl, dl			; now compare dest to 0
	jnz .loop			; loop if not null

	ret