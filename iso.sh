#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/KixOS.kernel isodir/boot/KixOS.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "KixOS" {
	multiboot /boot/KixOS.kernel
}
EOF
grub-mkrescue -o KixOS.iso isodir
