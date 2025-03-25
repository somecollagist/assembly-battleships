ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 0x0;
    .text ALIGN(0x10) : { *(.text) }
    .data ALIGN(0x10) : { *(.data) }
    . = 0x1FE;
    .bootmark ALIGN(0x1) : { KEEP(*(.bootmark)) }
    /DISCARD/ : { *(*) }
}