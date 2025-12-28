#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Raspberry pi 3 target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp arch/${KERNEL_ARCH}/boot/Image ${TARGET_ROOTFS}/boot/Image || exit 1

mkdir ${TARGET_ROOTFS}/boot/dts
mkdir ${TARGET_ROOTFS}/boot/dts/broadcom
mkdir ${TARGET_ROOTFS}/boot/dts/overlays

cp arch/${KERNEL_ARCH}/boot/dts/broadcom/bcm*-rpi-3-b.dtb ${TARGET_ROOTFS}/boot/dts/broadcom
cp arch/arm/boot/dts/overlays/*.dtb* ${TARGET_ROOTFS}/boot/dts/overlays/
cp arch/arm/boot/dts/overlays/README ${TARGET_ROOTFS}/boot/dts/overlays/
