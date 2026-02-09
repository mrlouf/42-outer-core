section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_strcmp

ft_strcmp:

;	rdi = char const *s1, rsi = char const *s2
;	strcmp does NOT check for NULL pointers, which can cause undefined behaviour
;	this implementation of ft_strcmp mimics this behaviour, as allowed by the subject.

.loop:
	mov al, [rdi]		; copy character from arg1 into 8-bit register AL
    mov dl, [rsi]       ; do the same for arg2
    cmp al, dl          ; compare *arg1 to *arg2
    jne .diff           ; jump to diff if not equal
    test al, al         ; check for null-byte in arg1
    je .exit            ; 
    inc rdi				; advance memory address in arg1
	inc rsi				; and in arg2
	jmp .loop			; continue if not null

.diff:
    movzx eax, al       ; cast as unsigned into eax
    movzx edx, dl       ; cast as unsigned into edx
    sub eax, edx        ; substract *s2 from *s1
    ret

.exit:
    xor eax, edx        ; 
	ret