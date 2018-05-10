#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Banana pi R2 target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=armv7a-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="zImage"
export KERNEL_ADD_OPTIONS="UIMAGE_LOADADDR=0x80008000"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
export GFX_SUPPORT="1"
export WAYLAND_SUPPORT="1"

source ${BASE_DIR}/configs/common/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL=BPI-R2-4.14.tar.gz
#v1.2.1.tar.gz

