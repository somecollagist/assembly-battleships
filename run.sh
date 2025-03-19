#!/bin/bash

clear
as main.s -o main.o
ld --oformat binary --script=linker.ld main.o -o main.bin

qemu-system-x86_64 -hda main.bin -vga std