.code16

.global _start

.extern print_boards

.section .text.entry, "a"
_start:
    cli                     # Clear interrupts

    call print_boards

    jmp .                   # Infinite loop