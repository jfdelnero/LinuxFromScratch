#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Neufbox NB5-SER-r1 target setup
#

export KERNEL_ARCH=mips
export TGT_MACH=mips64-linux-gnueabi
export SSL_ARCH=linux-mips64
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="Image"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.17.9.tar.xz"
