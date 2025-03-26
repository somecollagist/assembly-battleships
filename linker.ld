ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS
{
    .                   = 0x7C00;                       # Organise past BIOS code
    START               = .;                            # Track start of sector
    .text ALIGN(0x10)   : { *(.text.entry) *(.text) }   # Game Code
    .data ALIGN(0x10)   : { *(.data) }                  # Game Data (rw)
    
    .                   = START + 0x1FE;                # Organise to final 2 bytes
    .boot ALIGN(0x1)    : { KEEP(*(.boot)) }            # Insert boot marker (0xAA55)

    /DISCARD/           : { *(*) }                      # Discard extraneous sections
}