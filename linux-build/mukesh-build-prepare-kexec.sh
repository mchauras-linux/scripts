#! /bin/bash

INITRD=/tmp/mukeshinitrd.img

prepare() {
	make -j$(nproc)
	sudo make -j$(nproc) modules_install
	sudo depmod
	sudo dracut $INITRD --kver=$(make kernelrelease) --force
	ls $INITRD
	echo "Rerun with --kexec option to perform kexec"
}

kexec() {
	if test -f $INITRD; then
		kexec --initrd=$INITRD ./vmlinux --command-line="$(cat /proc/cmdline)"
	else
		echo "Running prerequisites...!!!"
		prepare
	fi
}

# Check if the argument is --kexec
if [[ "$1" == "--kexec" ]]; then
	kexec
fi
	
prepare
