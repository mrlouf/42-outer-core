section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

; extern int		ft_atoi_base(char const *str, char const *base);
;                                         rdi              rsi

section .text
	global ft_atoi_base

ft_atoi_base:
    xor eax, eax        ; initialise return value of = 0 in eax since we return an int
    xor ecx, ecx        ; initialise ecx to act as a sign register to multiply the end result without
    test rdi, rdi       ; test for null source
    jz .exit            ;
    test rsi, rsi       ; test for null base
    jz .exit            ;
    push rdi            ; save str pointer
    mov rdi, rsi        ; rdi = base string for length counting
    xor r8, r8          ; r8 will hold base length

.base_len_loop:
    mov al, [rdi + r8]  ; load character from base
    cmp al, 0           ; check for null terminator
    je .base_len_done   ; if null, we're done counting

    cmp al, '+'
    je .exit_invalid    ;
    cmp al, '-'
    je .exit_invalid    ;
    cmp al, ' '
    je .exit_invalid    ;
    cmp al, 9           ; check for '\t'
    je .exit_invalid    ;
    
    inc r8              ; increment base length
    jmp .base_len_loop

.base_len_done:
    cmp r8, 2           ; base must be at least 2
    jb .exit_invalid    ; if less than 2, invalid
    
    pop rdi             ; restore str pointer (equivalent to index i)
                        ; r8 = strlen(base)
                        ; rsi = base

.spaces:                ;
    mov dl, [rdi]       ; str[i]
    cmp dl, ' '         ; check for normal space (ASCII 32)
    je .skip_space      ;
    sub dl, 9           ; substract 9 to the character
    cmp dl, 4           ; if less or equal to zero, then it is a whitespace (0-9 ASCII table)
    ja .sign_loop       ;

.skip_space:            ;
    inc rdi             ; i++
    jmp .spaces         ;

.sign_loop:             ;
    mov dl, [rdi]       ;
    cmp dl, '-'         ; check for negative sign
    je .sign_neg        ;
    cmp dl, '+'         ;
    je .sign_pos        ;
    cmp ecx, 0          ; if ecx 0 = by then, then we set it to 1
    je .set_sign        ;
    jmp .digit_loop

.set_sign:
    mov ecx, 1          ;
    jmp .digit_loop     ;

.sign_neg:
    cmp ecx, 1          ; if ecx = 1, then we have a '+-' combination in str, which is incorrect
    je .exit_sign       ;
    mov ecx, -1         ;
    inc rdi             ;
    jmp .sign_loop      ;

.sign_pos:
    cmp ecx, -1         ; if ecx = -1, then we have a '-+' combination in str, which is incorrect
    je .exit_sign       ;
    mov ecx, 1          ;
    inc rdi             ;
    jmp .sign_loop

.digit_loop:
    mov dl, [rdi]       ; load current character from input string
    cmp dl, 0
    je .exit            ; end of string

    xor r9, r9          ; r9 = digit index (start at 0)
    
.find_digit:
    cmp r9, r8          ; r8 = base length
    jge .exit           ; not found in base, stop parsing

    mov bl, [rsi + r9]  ; load base[r9]
    cmp dl, bl
    je .digit_found

    inc r9
    jmp .find_digit

.digit_found:
    imul eax, r8d       ; result *= base_length
    add eax, r9d        ; result += digit value
    inc rdi             ; move to next char in input
    jmp .digit_loop

.exit:
    imul eax, ecx       ;
    ret

.exit_invalid:
    pop rdi             ; clean up stack in case something was pushed
    xor eax, eax        ; return 0 for invalid base
    ret

.exit_sign:
    ret