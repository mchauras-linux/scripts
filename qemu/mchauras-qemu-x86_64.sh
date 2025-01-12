#! /bin/bash

qemu-system-x86_64 -s -S -nographic					\
-smp cores=2								\
-kernel ./vmlinux							\
-initrd ../busybox/ramdisk.img						\
-nic user,model=rtl8139,hostfwd=tcp::5555-:23,hostfwd=tcp::5556-:8080
