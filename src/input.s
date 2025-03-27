.code16

.global get_target_coords

.extern cursor_newline
.extern print_string
.extern torpedo_target_row
.extern torpedo_target_column

.equ COL_INPUT,             0x0E

.data
row_question:
    .asciz "Row:    "

column_question:
    .asciz "Column: "

.text
get_target_coords:
    pusha
    movb    $COL_INPUT, %bl

    mov     $row_question, %si
    call    query
    movw    %si, %ax
    int     $0x10
    subw    $'1, %ax
    mov     %al, (torpedo_target_row)

    call    cursor_newline

    mov     $column_question, %si
    call    query
    movw    %si, %ax
    cmpb    $'a, %al
    jl      column_is_uppercase
    subb    $0x20, %al
    column_is_uppercase:
    int     $0x10
    subw    $'A, %ax
    mov     %al, (torpedo_target_column)

    movb    $0x00, %ah
    int     $0x16
    
    popa
    ret

query:
    push    %ax

    # Print the query string, passed in via %si
    call    print_string

    # Obtain a character
    movb    $0x00, %ah
    int     $0x16

    # Returned character is in %al.
    # Set %ah to TTY output and mov %ax to %si (returned)
    # To print input, just mov %si, %ax and int $0x10
    movb    $0x0E, %ah
    xor     %si, %si
    movw    %ax, %si

    pop     %ax

    ret