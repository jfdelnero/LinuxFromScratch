#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Zynq / Red Pitaya target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp arch/${KERNEL_ARCH}/boot/uImage ${TARGET_ROOTFS}/boot/uImage || exit 1
dtc -O dtb -o arch/arm/boot/dts/devicetree.dtb arch/arm/boot/dts/zynq-red-pitaya.dts
cp arch/arm/boot/dts/devicetree.dtb ${TARGET_ROOTFS}/boot/
