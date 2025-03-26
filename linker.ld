ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 0x7C00;
    START = .;
    .text ALIGN(0x10)   : { *(.text.entry) *(.text) }
    .data ALIGN(0x10)   : { *(.data) }
    . = START + 0x1FE;
    .boot ALIGN(0x1)    : { KEEP(*(.boot)) }
    /DISCARD/           : { *(*) }
}