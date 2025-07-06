BUILD_DIR=../build/os

OS_SRCS := $(wildcard *.asm)
OS_OBJS := $(patsubst %.asm, $(BUILD_DIR)/%.o, $(OS_SRCS))

all: $(OS_OBJS)

$(BUILD_DIR)/%.o: %.asm
	nasm -f bin $< -o $@

$(OS): $(OS_OBJS)
	ld -m elf_i386 -nmagic -Tos.lds $(OS_OBJS) -o $@

clean:
	rm $(BUILD_DIR)/*
