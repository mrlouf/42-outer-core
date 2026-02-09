; how to use the rdi (reg for 2nd parameter) to call a function from a pointer:
; mov rdi, [rsi]  ; Load the first argument for cmp into rdi
; mov rsi, [rdx]  ; Load the second argument for cmp into rsi
; call rsi        ; Call the cmp function

; how to call the cmp function and use the return value:
; call rsi        ; Call the cmp function
; cmp rax, 0      ; Compare the return value to 0
; jl .swap        ; If rax < 0, jump to swap logic

;    	ft_list_sort(t_list **begin_list, int (*cmp)());
;                       rdi                     rsi

section .text
    global ft_list_sort

ft_list_sort:
    test rdi, rdi
    jz .exit
    mov r8, [rdi]           ; r8 = *lst (head)
    test r8, r8
    jz .exit                ; if list is empty, exit
	mov r15, r8				; r15 = *lst
	mov r12, rsi			; r12 = cmp

.start:
    mov rbx, r8             ; rbx = first node
    mov r13, [rbx + 8]      ; r13 = second node (first->next)
    cmp qword r13, 0
    jz .exit                ; if only one node, exit

.compare:
	mov rdi, [rbx]			;
	mov rsi, [r13]			;
	call r12				;
	cmp rax, 0				;
	jle .next				;

.swap:
    mov rax, [rbx]          ; rax = first->data
    mov rcx, [r13]          ; rcx = second->data
    mov [rbx], rcx          ; first->data = second->data
    mov [r13], rax          ; second->data = first->data

	mov r8, r15				; go back to the head of list
	jmp .start

.next:
	mov r8, r13				;
	jmp .start

.exit:
    ret