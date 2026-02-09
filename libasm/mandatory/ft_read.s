section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_read
    extern __errno_location

; rdi = fd, rsi = buf, rdx = count

ft_read:
	mov rax, 0              ; syscall number for read
                            ; no need to mov rdi, rsi and rdx since they are set by the caller (main.c)
    syscall                 ; syscall will call the function saved in rax
    cmp rax, 0              ; check if call was successful or not
    jge .success            ; if rax >= 0, success

    ; error path: just like in C, we set errno to the error code and return -1
    neg rax                             ; rax = -error_code
    mov rdi, rax                        ; save error_code before it is overwritten by errno call
    call __errno_location wrt ..plt     ; call errno via Procedure Linkage Table (PLT) instead of via absolute address (against PIE)
    mov [rax], rdi                      ; 
    mov rax, -1                         ; return -1 to caller to indicate failure
    ret
    
.success:
    ret