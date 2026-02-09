section .data
; where you declare constant values, file names, buffer size, etc.

section .bss
; where you declare variables used in the program/function.

section .text
	global ft_list_push_front
    extern __errno_location
    extern malloc


; extern void ft_list_push_front(t_list **begin_list, void *data);
;										rdi				rsi

ft_list_push_front:
    push rdi                ; rdi => stack
    push rsi                ; rsi => stack
    mov rdi, 16             ; 16 bit for (void *)data and (lst *)next

    call malloc wrt ..plt   ; allocate rax
    pop rsi                 ; rsi <= stack
    pop rdi                 ; rdi <= stack

    cmp rax, 0              ; if (malloc(sizeof(t_list)) == NULL)
    je .error               ; return (error)

    mov [rax], rsi          ; lst->data = data
    mov rcx, [rdi]
    mov [rax + 8], rcx      ; lst->next = *list
    mov [rdi], rax          ; *list = lst
	ret

.error:
    neg rax                             ; rax = -error_code
    mov rdi, rax                        ; save error_code before it is overwritten by errno call
    call __errno_location wrt ..plt     ; call errno via Procedure Linkage Table (PLT) instead of via absolute address (against PIE)
    ret