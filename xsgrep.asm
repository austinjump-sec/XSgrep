section .data 
 colon db ":"
 msg db "No results found", 10
 length equ $ - msg

 usage db "Usage: ./xsgrep keyword filename", 10
 usage_len equ $ - usage
 error db "Could not open file", 10
 error_len equ $ - error
 
section .bss
 chunk resb 4096; Bytes of file chunk to read 
 linebuffer resb 4096; Bytes of lines returned
 numberbuffer resb 32
 
section .text
 global _start

_start:
 mov rax, [rsp]; catch system arguments called with script
 cmp rax, 3
 jl _usage
 mov r13, [rsp + 16] ; argument one(r13): keyword
 mov r14, [rsp + 24] ; argument two(r14): filename
 xor r12, r12

_keyword_length:
 cmp byte [r13 + r12], 0
 je _keyword_length_done
 inc r12
 jmp _keyword_length

_keyword_length_done:
 test r12, r12; test if keyword is empty
 jz _usage
 mov rax, 2 ; system call for opening files
 mov rdi, r14
 xor rsi, rsi;pass filename
 xor rdx, rdx ; read only
 syscall
 test rax, rax 
 js _open_error ; error if no file
 mov r15, rax  
 mov rbx, 1
 xor r8, r8 
 xor r9, r9 

_read_file:
 xor rax, rax
 mov rdi, r15 ;enter filename stored as r15
 mov rsi, chunk; move by amount of bytes as chunk
 mov rdx, 4096
 syscall
 test rax, rax
 jz _eof
 js _read_error
 mov r10, rax
 xor r11, r11

_process_byte:
 cmp r11, r10 
 jae _read_file
 mov al, [chunk + r11]
 cmp al, 10 
 je _end_of_line
 cmp r8, 4095
 jae _skip_line_byte
 mov [linebuffer + r8], al
 inc r8
 inc r11 
 jmp _process_byte

_skip_line_byte:
 inc r11
 jmp _process_byte

_end_of_line:
 push r10
 push r11
 call _search_line
 pop r11
 pop r10 
 xor r8, r8
 inc rbx
 inc r11
 jmp _process_byte

_eof:
 test r8, r8
 jz _check_results
 call _search_line

_check_results:
 test r9, r9
 jnz _done
 mov rax, 1
 mov rdi, 1
 mov rsi, msg
 mov rdx, length
 syscall
 jmp _done

_search_line: 
 cmp r8, r12
 jb _search_line_done
 xor rdi, rdi

_search_position:
 mov rax, r8
 sub rax, rdi 
 cmp rax, r12 
 jb _search_line_done
 xor rcx, rcx

_compare: 
 cmp rcx, r12 ;comparison of r12 after algo with counter to know when strings finished
 jae _match ;match
 mov al, [linebuffer + rdi + rcx]; add text with saved value and counter
 mov dl, [r13 + rcx]; text buffer with counter
 cmp al, dl ; comparing the two
 jne _next_position; if not equal go to next spot in string
 inc rcx
 jmp _compare; repeat loop until rcx and r12 are equal

_next_position:
 inc rdi; increment position and go back to _search
 jmp _search_position
 
_match:
 mov r9, 1
 mov rax, rbx
 call _print_number
 mov rax, 1
 mov rdi, 1
 mov rsi, colon
 mov rdx, 1
 syscall; show was matched 
 test r8, r8
 jz _print_newline
 mov rax, 1 
 mov rdi, 1 
 mov rsi, linebuffer
 mov rdx, r8
 syscall

_print_newline:
 mov byte [numberbuffer], 10
 mov rax, 1
 mov rdi, 1
 mov rsi, numberbuffer
 mov rdx, 1
 syscall

_search_line_done:
 ret

_print_number:
 lea rsi, [numberbuffer + 31]
 xor rcx, rcx   
 mov r10, 10

_convert: 
 xor rdx, rdx
 div r10
 add dl, 0
 dec rsi
 mov [rsi], dl
 inc rcx
 test rax, rax
 jnz _convert
 mov rax, 1
 mov rdi, 1
 mov rdx, rcx
 syscall 
 ret

_read_error:
 jmp _done

_open_error:
 mov rax, 1 
 mov rdi, 1 
 mov rsi, error
 mov rdx, error_len
 syscall ; show error text
 jmp _done

_usage:
 mov rax, 1 
 mov rdi, 1 
 mov rsi, usage
 mov rdx, usage_len
 syscall ; show usage text
 jmp _done

_done: 
 mov rax, 60
 mov rdi, 0
 syscall; Linux exit
