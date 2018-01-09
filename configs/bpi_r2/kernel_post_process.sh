#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Banana pi R2 target kernel compilation
# post process
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

cp arch/${KERNEL_ARCH}/boot/uImage ${TARGET_ROOTFS}/boot || exit 1

