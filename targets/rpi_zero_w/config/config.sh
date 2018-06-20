#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi Zero (W)  target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=armv6j-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="Image"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"

source ${BASE_DIR}/configs/common/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_1.20180417-1.tar.gz"

