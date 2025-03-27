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

QEMU	:= qemu-system-x86_64 -hda $(TARGET) -vga virtio

all: clean build run

build: $(ASMTAR)
	@$(AS) $(ASFLAGS) $(ASMSRC) -o $(BIN)/battleships.o
	@$(OD) $(ODFLAGS) -x $(BIN)/battleships.o > $(BIN)/battleships.dis
	@$(LD) $(LDFLAGS) --oformat=binary $^ -o $(TARGET)
	@$(OD) -DhsZz -mi8086 -b binary $(TARGET) > $(TARGET).dis
	@qrencode -r $(TARGET) -o $(BIN)/qr.png -8

run:
	@clear
	@$(QEMU)

debug: clean build
	@clear
	@$(QEMU) -monitor stdio

clean:
	@clear
	@rm -rf $(BIN)

$(BIN)/%.o: $(SRC)/%.s
	@mkdir -p $(shell dirname $@)
	@$(AS) $(ASFLAGS) $^ -o $@
	@objcopy -R .note.* $@ $@
	@$(OD) $(ODFLAGS) $@ > $@.dis