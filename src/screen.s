.code16

.global clear_screen
.global display
.global print_string

.extern player_ships
.extern computer_ships
.extern player_torpedoes
.extern computer_torpedoes

.equ COL_TEXT,              0x07
.equ COL_SHIP_OK,           0x1F # Light blue background, light grey foreground
.equ COL_SHIP_HIT,          0x1C # Light blue background, red foreground
.equ COL_TORPEDO_OK,        0x1F # Light blue background, white foreground
.equ COL_TORPEDO_HIT,       0x1C # Light blue background, light red foreground
.equ CHAR_SHIP,             '#
.equ CHAR_TORPEDO,          'X
.equ CHAR_EMPTY,            ' 

.equ VRAM_ROWS,             25
.equ VRAM_COLS,             40
.macro VRAM_ROW_COL,        row, col
    (row*VRAM_COLS+col)
.endm

.data
player_legend:
    .asciz "My Ships:\r\n"

enemy_legend:
    .asciz "Radar:\r\n"

board_col_legend:
    .asciz " ABCDEFGH\r\n"

.text
clear_screen:
    # Set video mode to 40x25, VGA colours, 8x8 characters
    movw    $0x000D, %ax
    int     $0x10

    # Clear blinking cursor
    movw    $0x1003, %ax
    movw    $0x0000, %bx
    int     $0x10

    ret

display:
    pusha
    # Move cursor to the top of the screen
    movb    $0x02, %ah
    movw    $0x0000, %dx
    int     $0x10
    movb    $0x0E, %ah                      # Print only characters from here

    # Print player's ships
    movw    $player_legend, %si
    call    print_string
    movw    $player_ships, %si
    movw    $computer_torpedoes, %di
    call    print_board

    # Print enemy's ships
    movw    $enemy_legend, %si
    call    print_string
    movw    $player_torpedoes, %si
    movw    $computer_ships, %di
    call    print_board

    popa
    ret

print_board:
    pusha
    
    # Print legend
    push    %si
    movw    $board_col_legend, %si
    call    print_string
    pop     %si

    movb    $0x00, %ch                      # Row index
    .print_player_rows:
        # Print row number
        movb    $COL_TEXT, %bl
        movb    $'1, %al
        addb    %ch, %al
        int     $0x10

        movb    $0x80, %cl                  # Column index mask
        .print_cell:
            movb    (%si), %dh              # Store current ship row in %dh
            movb    $CHAR_EMPTY, %al        # Assume the cell doesn't contain a ship
            movb    $COL_SHIP_OK, %bl       # Assume the cell hasn't been hit

            testb   %cl, %dh
            jz     .print_cell_execute      # If there's no ship, print
            movb    $CHAR_SHIP, %al         # Cell contains a ship
            movb    (%di), %dh              # Store current torpedo row in %sh
            testb   %cl, %dh
            jz      .print_cell_execute     # If the ship isn't hit, print (i.e. it's ok)
            movb    $COL_SHIP_HIT, %bl      # Cell has been hit
            .print_cell_execute:            # Print the cell
            int     $0x10

            shrb    %cl                     # Shift mask
            testb   %cl, %cl
            jnz     .print_cell             # If the mask still tracks a bit, repeat
        .print_cell_end:

        incw    %si                         # Move to next ship row
        incw    %di                         # Move to next torpedo row

        # Go the the next line if necessary, or exit
        call    cursor_newline
        incb    %ch
        cmpb    $8, %ch
        jl      .print_player_rows
    .print_player_rows_end:
    call    cursor_newline
    popa
    ret

print_string:
    pusha
    movb    $0x0E, %ah
    movb    $COL_TEXT, %bl
    .printstr:
        movb    (%si), %al
        cmpb    $0, %al
        je      .printstr_end
        int     $0x10
        inc     %si
        jmp     .printstr
    .printstr_end:
    popa
    ret

cursor_newline:
    pusha

    movw    $0x0E0D, %ax
    int     $0x10
    movb    $0x0A, %al
    int     $0x10

    popa
    ret