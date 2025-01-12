#! /bin/bash

export ARCH=powerpc
export CROSS_COMPILE=powerpc64le-linux-gnu-

make pseries_defconfig

make -j$(nproc) all
