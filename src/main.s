.code16

.global _start

.extern init_screen
.extern display
.extern print_string
.extern query

.extern player_ships
.extern computer_ships
.extern player_torpedoes
.extern computer_torpedoes
.extern torpedo_target_row
.extern torpedo_target_column

.section .text.entry, "a"
_start:
    # Clear interrupts
    cli
    
    game_loop:
        call    init_screen
        call    display
        call    get_target_coords
        
        movb    (game_status), %bl
        cmpb    $0, %bl

        je      game_loop
    game_loop_end:

    # Infinite loop
    jmp .

.data
game_status:
    .byte 0x00

win:
    .asciz "You win!"

lose:
    .asciz "You lose!"