#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Clearfog Pro target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp arch/${KERNEL_ARCH}/boot/zImage ${TARGET_ROOTFS}/boot/zImage || exit 1

mkdir ${TARGET_ROOTFS}/boot/dtb

cp arch/${KERNEL_ARCH}/boot/dts/*.dtb ${TARGET_ROOTFS}/boot/dtb/
