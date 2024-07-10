#! /bin/bash

INITRD=/tmp/mukeshinitrd.img

# Check if the argument is --kexec
if [[ "$1" == "--kexec" ]]; then
	kexec --initrd=$INITRD ./vmlinux --command-line="$(cat /proc/cmdline)"
else
	make -j$(nproc)
	make -j$(nproc) modules_install
	dracut $INITRD --kver=$(make kernelrelease) --force
	ls $INITRD
fi
