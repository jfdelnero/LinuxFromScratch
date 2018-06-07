#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi 3 target setup
#

export KERNEL_ARCH=arm64
export TGT_MACH=aarch64-linux
export SSL_ARCH=linux-aarch64
export GCC_ADD_CONF="--enable-fix-cortex-a53-843419"

export KERNEL_IMAGE_TYPE="Image"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
export GFX_SUPPORT="1"
export WAYLAND_SUPPORT="1"

source ${BASE_DIR}/configs/common/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_1.20180417-1.tar.gz"

SRC_PACKAGE_DIRECTFB=

