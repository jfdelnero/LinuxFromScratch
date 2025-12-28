#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# OCEDO G50w target setup
#

export KERNEL_ARCH=powerpc
export TGT_MACH=powerpc-e500v2-linux-gnueabi
export SSL_ARCH=linux-ppc
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="uImage"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.17.tar.xz"

