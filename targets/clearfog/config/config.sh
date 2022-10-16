#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Clearfog Pro target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=armv7a-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="Image"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.9.tar.xz"
