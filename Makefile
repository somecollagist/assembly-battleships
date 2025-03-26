RT		:= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SRC		:= $(RT)/src
BIN		:= $(RT)/bin

TARGET	:= $(BIN)/battleships.bin

AS		:= as
ASFLAGS := -Wno-eof-newline

LD		:= ld
LDFLAGS := --script=linker.ld

OD		:= objdump
ODFLAGS	:= -dhsZ -mi8086

ASMSRC	:= $(shell find $(SRC) -name "*.s")
ASMTAR	:= $(patsubst $(SRC)/%.s,$(BIN)/%.o,$(ASMSRC))

all: clean build run

build: $(ASMTAR)
	@$(LD) $(LDFLAGS) --oformat=binary $^ -o $(TARGET)
	@$(OD) $(ODFLAGS) -b binary -D $(TARGET) > $(TARGET).dis

run:
	@clear
	@qemu-system-x86_64 -hda $(TARGET) -vga std

clean:
	@clear
	@rm -rf $(BIN)

$(BIN)/%.o: $(SRC)/%.s
	@mkdir -p $(shell dirname $@)
	@$(AS) $(ASFLAGS) $^ -o $@
	@objcopy -R .note.* $@ $@
	@$(OD) $(ODFLAGS) $@ > $@.dis