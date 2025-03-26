.code16

.global query

.extern print_string

.equ COL_INPUT,             0x0E

.text
query:
    push    %ax

    # Print the query string, passed in via %si
    call    print_string

    # Loop until a key is pressed
    movb    $0x01, %ah
    await_key_press:
        int     $0x16
        jz      await_key_press

    # Returned character is in %al.
    # Set %ah to TTY output and mov %ax to %si (returned)
    # To print input, just mov %si, %ax and int $0x10
    movb    $0x0E, %ah
    movw    %ax, %si

    pop     %ax

    ret