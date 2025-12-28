#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# OCEDO G50w target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

dtc -O dtb -o ${TARGET_ROOTFS}/boot/dtb_file ${TARGET_SOURCES}/linux-kernel/arch/powerpc/boot/dts/fsl/p1020rdb-pc_32b.dts

cp  ${TARGET_SOURCES}/linux-kernel/arch/powerpc/boot/uImage ${TARGET_ROOTFS}/boot/

