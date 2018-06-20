#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Banana pi R2 target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cat arch/${KERNEL_ARCH}/boot/zImage arch/${KERNEL_ARCH}/boot/dts/mt7623n-bananapi-bpi-r2.dtb > arch/${KERNEL_ARCH}/boot/zImage-dtb
mkimage -A ${KERNEL_ARCH} -O linux -T kernel -C none -a 80008000 -e 80008000 -n "Linux Kernel BPI-R2" -d arch/arm/boot/zImage-dtb ${TARGET_ROOTFS}/boot/uImage

