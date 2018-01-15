#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi 3 post install process
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

mv -f ${TARGET_ROOTFS}/boot/Image                          ${BASE_DIR}/configs/${TARGET_NAME}/boot_part/kernel8.img
mv -f ${TARGET_ROOTFS}/boot/dts/broadcom/bcm*-rpi-3-b.dtb  ${BASE_DIR}/configs/${TARGET_NAME}/boot_part
mv -f ${TARGET_ROOTFS}/boot/dts/overlays/*                 ${BASE_DIR}/configs/${TARGET_NAME}/boot_part/overlays

