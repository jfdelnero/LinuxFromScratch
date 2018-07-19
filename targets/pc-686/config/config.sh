#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# i686-pc setup
#

export KERNEL_ARCH=x86
export TGT_MACH=i686-linux
export SSL_ARCH=linux-i686
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE=""

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
export GFX_SUPPORT="1"
export WAYLAND_SUPPORT="1"
export AUDIO_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.15.9.tar.xz"

SRC_PACKAGE_DIRECTFB=
SRC_PACKAGE_PYTHON=
