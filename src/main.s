.code16

.global _start
.extern clear_screen

.text
_start:
    cli                     # Clear interrupts

    call clear_screen

    jmp .                   # Infinite loop

