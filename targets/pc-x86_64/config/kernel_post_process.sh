#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# i686-pc target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp arch/${KERNEL_ARCH}/boot/*Image ${TARGET_ROOTFS}/boot/ || exit 1
