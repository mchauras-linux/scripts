#! /bin/bash

export ARCH=powerpc
export CROSS_COMPILE=powerpc-linux-gnu-

make pseries_defconfig

make -j$(nproc) all
