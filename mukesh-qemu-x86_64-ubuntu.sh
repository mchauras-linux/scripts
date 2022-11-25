#! /bin/bash

UBUNTU_URL=https://old-releases.ubuntu.com/releases/focal/ubuntu-20.04.2.0-desktop-amd64.iso
UBUNTU_IMG_NAME=ubuntu-20.04.2.0-desktop-amd64
mkdir -p ~/.vm


if [ ! -e ~/.vm/$UBUNTU_IMG_NAME.iso ]
then
	echo "Ubuntu image not found"
	echo "Fetching Ubuntu image from $UBUTNU_URL"
	wget -P ~/.vm/ $UBUNTU_URL
fi

if [ ! -e ~/.vm/$UBUNTU_IMG_NAME.qcow2 ]
then
	echo "QCOW image not available"
	echo "Creating qcow image"
	qemu-img create -f qcow2 ~/.vm/$UBUNTU_IMG_NAME.qcow2 10G
fi

N_PROC=`expr $(nproc) - 1`

qemu-system-x86_64 \
  -m 8G \
  -vga std \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -smp $N_PROC \
  -cdrom ~/.vm/$UBUNTU_IMG_NAME.iso \
  -drive file=~/.vm/$UBUNTU_IMG_NAME.qcow2,if=virtio
