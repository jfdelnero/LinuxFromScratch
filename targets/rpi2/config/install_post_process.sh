#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Raspberry pi 3 post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

mv -f ${TARGET_ROOTFS}/boot/Image                          ${TARGET_CONFIG}/boot_part/kernel8.img
mv -f ${TARGET_ROOTFS}/boot/dts/broadcom/bcm*-rpi-3-b.dtb  ${TARGET_CONFIG}/boot_part
mv -f ${TARGET_ROOTFS}/boot/dts/overlays/*                 ${TARGET_CONFIG}/boot_part/overlays

