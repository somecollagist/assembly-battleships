.code16
#
.global print_boards

.extern player_ships
.extern computer_ships
.extern player_torpedoes
.extern computer_torpedoes

.equ PLAYER_TORPEDO_CHAR,   $'X
.equ ENEMY_TORPEDO_CHAR,    $'X
.equ TORPEDO_MISS_COL,      0x9F
.equ TORPEDO_HIT_COL,       0x9C
.equ OCEAN,                 0x97
.equ BACKGROUND,            0x07

.equ VRAM_ROWS,             25
.equ VRAM_COLS,             80
.macro VRAM_ROW_COL,        row, col
    (row*VRAM_COLS+col)
.endm

.data
player:
    .asciz "Player:"

enemy:
    .asciz "Enemy:"

.text
print_boards:
    movb    $0x02, %ah                                  # Move cursor to top of screen
    movw    $0x0000, %dx
    int     $0x10

    movw    $player, %si
    movb    $0x0E, %ah
    movb    BACKGROUND, %bl
    player_print:
        movb    (%si), %al
        cmpb    $0, %al
        je      player_print_end
        int     $0x10
        inc     %si
        jmp     player_print
    player_print_end:

    ret