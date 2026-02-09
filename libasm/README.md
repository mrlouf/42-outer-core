# LIBASM
Recreation of a few functions from the 42 libft in x86_64 System V ABI (Linux)

## _DESCRIPTION_
This project is a recreation of some functions from the 42 libft, implemented in x86_64 assembly language instead of C.

## _FUNCTIONS_
- `ft_strlen`: Computes the length of a string. Key points:
    - Uses a loop to iterate through the string until it finds the null terminator.
    - Returns the length of the string in the `rax` register.
- `ft_strcpy`: Copies a string from source to destination. Key points:
    - Uses a loop to copy each character from the source string to the destination string, using the 8-bit register `dl` as a temporary storage, as memory-to-memory operations are not possible in x86_64 assembly.
    - Returns the destination string in the `rax` register.
- `ft_strcmp`: Compares two strings. Key points:
    - Uses the movzx instruction to cast the characters to unsigned integers before performing the subtraction.
    - Returns the difference between the first non-matching characters in the `eax` register since the return value of strcmp is a 32-bit integer.
- `ft_write`: Writes a string to the standard output. Key points:
    - Uses the `syscall` instruction to invoke the write system call.
    - Handles errors by checking the return value and setting `errno` if necessary.
- `ft_read`: Reads a string from the standard input. Key points:
    - Uses the `syscall` instruction to invoke the read system call, similarly to ft_write.
    - Handles errors by checking the return value and setting `errno` if necessary.
- `ft_strdup`: Duplicates a string by allocating memory for it and copying the content. Key points:
    - Uses a direct call to malloc to allocate space needed for the new string. The length is calculated the same way strlen does, and the null-terminating byte is added.
    - Just like in C, it is essential to check whether malloc succeeded or not by checking the return value in `rax` register after the call and setting `errno` if necessary.

### _BONUS FUNCTIONS_
- `ft_atoi_base`: Convert a string representing a number in a given base to an integer. Key points:
    - Validate the base string to ensure it contains at least two unique characters and does not include '+' or '-'.
    - Handle leading whitespace and optional '+' or '-' signs in the input string.
    - Convert the string to an integer by iterating through each character, finding its index in the base string, and accumulating the result while considering the sign.
- `ft_list_push_front`: Create a new node using `malloc` and push it as the first element of a list. Key points:
    - Handling double pointers in assembly: dereference a double pointer into a tmp register (`rax`) to access single pointer.
    - Understand how structures are saved in the RAM and how to access each of their elements by calculating manually their offset.
- `ft_list_size`: Calculate the size of a list, ie. how many nodes it contains. Key points:
    - Navigating from the beginning of a list to its last node by dereferencing and accessing 'node->next', incrementing a counter for each iteration.
- `ft_list_sort`: Sort all nodes from a list. Key points:
    - Call a function passed as argument in `rsi` to the current node's data and the next one's. If not sorted, swap data and start the iteration from the beginning until the entire list is sorted.
- `ft_remove_if`: Remove all nodes from a list that match a given value. Key points:
    - Iterate through the list, comparing each node's data with the value to remove.
    - If a match is found, remove the node and free its memory.
    - Update the list head if necessary.

## _CHEATSHEET_
- **Registers**:
Summary table of the main 64-bit registers and their typical uses in NASM for Linux (System V AMD64 ABI):

| Register | Name      | Typical Use (Linux x86-64)                | Notes                                 |
|----------|-----------|-------------------------------------------|---------------------------------------|
| rax      | Accumulator | Return value from functions, math ops   | Also used for syscall numbers         |
| rbx      | Base      | Callee-saved (must be preserved)         | General purpose                       |
| rcx      | Counter   | 4th function argument, loop counter      | Volatile, used in string/loop ops     |
| rdx      | Data      | 3rd function argument                    | Volatile, also used for return value (with rax) in 128-bit returns |
| rsi      | Source    | 2nd function argument, source pointer    | Volatile, used in string ops          |
| rdi      | Destination | 1st function argument, dest pointer    | Volatile, used in string ops          |
| rsp      | Stack Pointer | Stack pointer                        | Must always point to top of stack     |
| rbp      | Base Pointer  | Frame pointer (optional)             | Callee-saved, used for stack frames   |
| r8       |           | 5th function argument                    | Volatile                              |
| r9       |           | 6th function argument                    | Volatile                              |
| r10–r11  |           | Temporary, volatile                      | Not preserved across calls            |
| r12–r15  |           | Callee-saved (must be preserved)         | General purpose                       |

- **Function arguments (in order):**
1. `rdi`
2. `rsi`
3. `rdx`
4. `rcx`
5. `r8`
6. `r9`

- **Return value:**  
- `rax` (and `rdx:rax` for 128-bit values)

- **Callee-saved:**  
- `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15` (must be preserved by your function if you use them)

- **Caller-saved (volatile):**  
- `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`, `r11`

- **Calling Convention**:
    - Arguments are passed in registers: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`. Additional arguments are passed on the stack.
	- Watch out for stack alignment: the stack pointer (`rsp`) must be 16-byte aligned before calling another function.
	- Preserve callee-saved registers (`rbx`, `rbp`, `r12`-`r15`) if you use them in your function.
	- Use `push` and `pop` to save and restore registers on the stack.
	- The return address is automatically pushed onto the stack when a function is called using `call`.
	- Use `ret` to return from a function, which pops the return address from the stack and jumps to it.
	- Functions that call other functions must ensure the stack is aligned to a 16-byte boundary before making the call.
    - Return values are returned in `rax` for 64-bits, `eax` for 32-bits, and `al` for 8-bits.
- **Memory Operations**:
    - Use `mov` to copy data between registers and memory.
    - Use `movzx` to zero-extend a smaller register to a larger one (i.e. fill the upper bits with 0s).
    - Use `movsx` to sign-extend a smaller register to a larger one (i.e. fill the upper bits with 1s if the value is negative).
- **Arithmetic Operations**:
    - Use `add`, `sub`, `mul`, and `div` for arithmetic operations.
    - Use `xor` to set a register to zero (e.g., `xor rax, rax` sets `rax` to 0).
- **Control Flow**:
    - Use `jmp` for unconditional jumps.
    - Use `je`, `jne`, `jg`, `jl`, etc. for conditional jumps based on the flags set by previous operations.

### _REFERENCES_
- https://diveintosystems.org/singlepage/#_x64_assembly_chapter
- Essential read to understand structures in assembly: https://diveintosystems.org/book/C7-x86_64/structs.html
- https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
- https://www.tutorialspoint.com/assembly_programming/index.htm
- https://gpfault.net/posts/asm-tut-0.txt.html
- https://scadahacker.com/library/Documents/Cheat_Sheets/Programming%20-%20x86%20Instructions%201.pdf
- https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html