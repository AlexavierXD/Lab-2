.section .bss
.globl seq_one
.lcomm seq_one, 256
.globl seq_two
.lcomm seq_two, 256
.globl num_buffer
.lcomm num_buffer, 16

.section .data
msg_in1:  .ascii "Enter string 1: "
msg_in2:  .ascii "Enter string 2: "
msg_dist: .ascii "Hamming distance: "

.section .text
.globl _start

_start:
    mov $1, %rax
    mov $1, %rdi
    mov $msg_in1, %rsi
    mov $16, %rdx
    syscall

    mov $0, %rax
    mov $0, %rdi
    mov $seq_one, %rsi
    mov $256, %rdx
    syscall
    dec %rax
    mov %rax, %r8

    mov $1, %rax
    mov $1, %rdi
    mov $msg_in2, %rsi
    mov $16, %rdx
    syscall

    mov $0, %rax
    mov $0, %rdi
    mov $seq_two, %rsi
    mov $256, %rdx
    syscall
    dec %rax
    mov %rax, %r9

    cmp %r9, %r8
    jbe calc_hamming
    mov %r9, %r8

calc_hamming:
    mov $0, %rsi
    mov $0, %r10

scan_chars:
    cmp %r8, %rsi
    je output_final

    movb seq_one(%rsi), %al
    movb seq_two(%rsi), %bl
    xor %bl, %al

    mov $8, %cl

count_differences:
    shr $1, %al
    jc increment_dist
    jmp shift_next

increment_dist:
    inc %r10

shift_next:
    dec %cl
    jnz count_differences

    inc %rsi
    jmp scan_chars

output_final:
    mov $1, %rax
    mov $1, %rdi
    mov $msg_dist, %rsi
    mov $18, %rdx
    syscall

    mov %r10, %rax
    mov $10, %rbx
    mov $num_buffer, %rsi
    add $14, %rsi
    
    movb $10, (%rsi)
    dec %rsi

convert_ascii:
    mov $0, %rdx
    div %rbx
    add $48, %dl
    movb %dl, (%rsi)
    dec %rsi
    cmp $0, %rax
    jnz convert_ascii

    inc %rsi
    
    mov $num_buffer, %rdx
    add $15, %rdx
    sub %rsi, %rdx

    mov $1, %rax
    mov $1, %rdi
    syscall

    mov $60, %rax
    mov $0, %rdi
    syscall

.section .note.GNU-stack,"",@progbits
