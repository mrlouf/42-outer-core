section .data

section .bss

;         ft_list_remove_if(&lst, (void *)s2, (int (*)(void *, void *))strcmp, free);
;                           rdi     rsi                             rdx         rcx

section .text
	global ft_list_remove_if
    extern free

ft_list_remove_if:
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi            ; reassigning registers to not push / pop everywhere
    mov r13, rsi
    mov r14, rdx
    mov r15, rcx

	; NULL checks
    test r12, r12
    jz .exit
    test r13, r13
    jz .exit
    test r14, r14
    jz .exit
    test r15, r15
    jz .exit

    mov rdx, [rdi]          ; rdx current node, ** dereferencing
    mov rcx, 0              ; previous node is null by default

.loop:
    test rdx, rdx           ; if current node is null, exit
    je .exit

    mov rdi, [rdx]          ; rdi = current->data
    mov rsi, r13            ; rsi = data_ref
    push rdx                ; not callee-safe registers push
    push rcx                ;
    call r14                ; compare
    pop rcx
    pop rdx

    cmp rax, 0              ; check if the data matches
    jne .loop_skip          ; if it is not, then skip

    cmp rdx, [r12]          ; data is same, is it head node?
    je .free_head           ; if head node, we need to update head ptr

.free_middle:
    ; Save current->next before freeing anything
    mov rax, [rdx + 8]      ; rax = current->next
    
    ; Update previous->next = current->next
    mov [rcx + 8], rax      ; prev->next = current->next
    
    ; Free current->data
    mov rdi, [rdx]          ; current->data
    push rax                ; save next node
    push rcx                ; save previous
    push rdx                ; save current node
    call r15                ; free(current->data)
    pop rdx                 ; restore current node
    pop rcx                 ; restore previous
    pop rax                 ; restore next node
    
    ; Free current node
    mov rdi, rdx            ; current node
    push rax                ; save next node
    push rcx                ; save previous
    call free wrt ..plt     ; free(current)
    pop rcx                 ; restore previous
    pop rax                 ; restore next node
    
    ; Continue with next node (previous unchanged)
    mov rdx, rax            ; current = next
    jmp .loop

.skip_free_data:
    pop rdx
    mov rdi, rdx            ; free current
    call free wrt ..plt
    pop rcx
    mov rdx, [rcx + 8]      ; not changing previous, only current
    jmp .loop

.loop_skip:
    mov rcx, rdx
    mov rdx, [rdx + 8]
    jmp .loop

.free_head:
    mov rdi, [rdx + 8]
    mov [r12], rdi
    mov rdi, [rdx]

    push rdx
    push rcx
    call r15                ; free(current->data)
    pop rcx
    pop rdx

    mov rdi, rdx
    push rcx
    push rdx
    call free wrt ..plt     ; free(current)
    pop rdx
    pop rcx

    mov rdx, [r12]
    jmp .loop

.exit:
    pop r15
    pop r14
    pop r13
    pop r12
    ret