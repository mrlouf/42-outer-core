section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_strlen

; rdi = pointer to string
; returns: rax = length

ft_strlen:
	mov rax, 0			; initialise the return value to 0 in rax = 64 bits/size_t
	test rdi, rdi		; test for null-pointer
	jz .exit			; exit if null-pointer

.loop:
	cmp byte [rdi], 0	; compare arg1 to 0
	je .exit			; exit when arg1 is null ('\0')
	inc rax				; otherwise increment the value in rax
	inc rdi				; and advance the memory address of the parameter
	jmp .loop			; repeat iteration

.exit:
	ret