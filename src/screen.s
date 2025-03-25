.code16

.global clear_screen
.extern player_ships
.extern computer_ships
.extern player_torpedoes
.extern computer_torpedoes

.equ PLAYER_TORPEDO_CHAR,   $'X
.equ ENEMY_TORPEDO_CHAR,    $'X
.equ TORPEDO_MISS_COL,      $0x9F
.equ TORPEDO_HIT_COL,       $0x9C
.equ OCEAN,                 $0x99
.equ BACKGROUND,            $0x07

.set VRAM_ROWS,             25
.set VRAM_COLS,             80
.macro VRAM_ROW_COL,        row, col
    (row*VRAM_COLS+col)
.endm

.data
player:
    .ascii "Player:"
    .byte 0

enemy:
    .ascii "Enemy:"
    .byte 0
    .byte 0                 # 16-byte alignment

.text
clear_screen:
    mov $0x0003, %ax        # Set video mode to 80x25
    int $0x10

    mov $0x0700, %ax        # Clear screen
    mov $0x07, %bh
    mov $0000, %cx
    mov ((VRAM_ROWS-1)<<8)|(VRAM_COLS-1), %dx
    int $0x10

    mov $0x01, %ah          # Hide cursor
    mov $0x2607, %cx
    int $0x10

    mov $0x02, %ah          # Move cursor to top of screen
    mov $0x0000, %dx
    int $0x10
    ret
