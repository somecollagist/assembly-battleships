.code16

.global _start

.extern clear_screen
.extern display

.section .text.entry, "a"
_start:
    # Clear interrupts
    cli

    call clear_screen
    call display

    # Infinite loop
    jmp .