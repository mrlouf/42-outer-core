section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_list_size

ft_list_size:
	xor rax, rax		; initialise the return value to 0 in rax = 64 bits/size_t
	test rdi, rdi		; test for null-pointer
	jz .exit			; exit if null-pointer

.loop:
    inc rax             ; count the starting node
	mov rdi, [rdi + 8]	; and advance the memory address of the parameter by 8 bytes/64 bits
    test rdi, rdi       ; test for null ptr
	jnz .loop			; repeat iteration

.exit:
	ret