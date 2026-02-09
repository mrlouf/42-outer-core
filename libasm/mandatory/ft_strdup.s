section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_strdup
    extern __errno_location
    extern malloc

ft_strdup:
    push rbx
    test rdi, rdi           ; if null-pointer, exit
    jz .exit                ;
    mov rbx, rdi            ; get the pointer address from arg1 into rdi
    xor rcx, rcx            ; initialise rcx (counter register) to 0

.len:
	cmp byte [rbx + rcx], 0	; str[0 + i] == '\0'?
	je .alloc			    ; exit when arg1 is null ('\0')
	inc rcx				    ; otherwise increment counter
	jmp .len			    ; repeat iteration

.alloc:
    add rcx, 1              ; add plus one to account for null byte
    mov rdi, rcx            ; save length into rdi
    call malloc wrt ..plt   ; malloc as many bytes as the value of rdi
    test rax, rax           ; check if malloc failed
    jz .failure             ;
    mov rdi, rax            ; set the rdi register as dest pointer
    mov rsi, rbx            ; restore source register
    xor rcx, rcx            ; reinitialise counter to 0

.copy:
    mov dl, [rsi + rcx]     ; move one byte from src to 8-bit register
    mov [rdi + rcx], dl     ; copy byte into dest
    test dl, dl             ; check if null-byte
    jz .exit                ; exit if null-byte
    inc rcx                 ; otherwise increment and continue
    jmp .copy               ; 

.failure:
    neg rax                             ; rax = -error_code
    mov rdi, rax                        ; save error_code before it is overwritten by errno call
    call __errno_location wrt ..plt     ; call errno via Procedure Linkage Table (PLT) instead of via absolute address (against PIE)
    mov [rax], rdi                      ; 
    mov rax, 0                         	; return 0 to caller to indicate failure
    pop rbx
    ret

.exit:
    pop rbx
    ret
