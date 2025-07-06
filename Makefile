# === Build Settings ===
BUILD_DIR   := build
ISO_DIR     := iso
BOOT_SRC    := src/boot.s
KERNEL_SRC  := src/kernel.c
LINKER      := linker.ld

BOOT_OBJ    := $(BUILD_DIR)/boot.o
KERNEL_OBJ  := $(BUILD_DIR)/kernel.o
OUTPUT_BIN  := $(BUILD_DIR)/myos.bin
DISK_IMG    := $(BUILD_DIR)/disk.iso

CFLAGS      := -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS     := -T $(LINKER) -ffreestanding -O2 -nostdlib

GRUB_CFG    := $(ISO_DIR)/boot/grub/grub.cfg
ISO_BOOTBIN := $(ISO_DIR)/boot/myos.bin

.PHONY: all clean run qemu_run qemu_debug

# === Main Build Target ===
all: $(DISK_IMG)

# === Create ISO ===
$(DISK_IMG): $(OUTPUT_BIN) | $(GRUB_CFG)
	@echo "[ISO] Creating bootable disk image..."
	@cp $(OUTPUT_BIN) $(ISO_BOOTBIN)
	@grub-mkrescue -o $(DISK_IMG) $(ISO_DIR) >/dev/null
	@rm -rf $(ISO_DIR)

# === GRUB Config ===
$(GRUB_CFG): | $(ISO_DIR)/boot/grub
	@echo "[GRUB] Writing GRUB config..."
	@echo 'set timeout=0'              >  $(GRUB_CFG)
	@echo 'menuentry "My OS" {'       >> $(GRUB_CFG)
	@echo '  multiboot /boot/myos.bin' >> $(GRUB_CFG)
	@echo '}'                         >> $(GRUB_CFG)

# === Kernel Build and Link ===
$(OUTPUT_BIN): $(BOOT_OBJ) $(KERNEL_OBJ)
	@echo "[LD] Linking kernel..."
	i686-elf-gcc $(LDFLAGS) -o $@ $^ -lgcc

$(BOOT_OBJ): $(BOOT_SRC) | $(BUILD_DIR)
	@echo "[AS] Assembling boot..."
	i686-elf-as $< -o $@

$(KERNEL_OBJ): $(KERNEL_SRC) | $(BUILD_DIR)
	@echo "[CC] Compiling kernel..."
	i686-elf-gcc -c $< -o $@ $(CFLAGS)

# === Directory Rules ===
$(BUILD_DIR):
	@mkdir -p $@

$(ISO_DIR)/boot/grub:
	@mkdir -p $@

# === Clean Build ===
clean:
	@echo "[CLEAN] Removing build artifacts..."
	@rm -rf $(BUILD_DIR) $(ISO_DIR)

# === Run Targets ===
run: qemu_run

qemu_run: all
	@qemu-system-i386 -cdrom $(DISK_IMG)

qemu_debug: all
	@qemu-system-i386 -cdrom $(DISK_IMG) -gdb tcp::26000 -S
