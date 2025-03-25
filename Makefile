RT		:= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SRC		:= $(RT)/src
BIN		:= $(RT)/bin

TARGET	:= $(BIN)/battleships.bin

AS		:= as
ASFLAGS := -Wno-eof-newline

LD		:= ld
LDFLAGS := --oformat binary --script=linker.ld

ASMSRC	:= $(shell find $(SRC) -name "*.s")
ASMTAR	:= $(patsubst $(SRC)/%.s,$(BIN)/%.o,$(ASMSRC))

all: build run

build: $(ASMTAR)
	@$(LD) $(LDFLAGS) $^ -o $(TARGET)

run:
	@clear
	@qemu-system-x86_64 -hda $(TARGET) -vga std

clean:
	@git clean -Xdf

$(BIN)/%.o: $(SRC)/%.s
	@mkdir -p $(shell dirname $@)
	@$(AS) $(ASFLAGS) $^ -o $@
	@objdump -dx $@ > $(patsubst %.o,%.dis,$@)