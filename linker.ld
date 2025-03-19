ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS
{
    . = 0x0;
    .text ALIGN(0x1) : { *(.text) }
    /DISCARD/ : { *(.note.gnu.property) }
}