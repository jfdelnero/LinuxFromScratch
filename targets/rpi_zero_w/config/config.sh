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
export KERNEL_DTBS="YES"
export KERNEL_FIRMWARES="YES"

export NETWORK_ROUTER_MODE="YES"

export DEBUG_SUPPORT="1"
export TARGET_BUILD_SUPPORT="1"

export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
#export GFX_SUPPORT="1"
#export WAYLAND_SUPPORT="1"
#export AUDIO_SUPPORT="1"
#export GAMES_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

#export MESA_DRI_DRV="swrast"
#export MESA_GALLIUM_DRV="vc4,swrast"
#export DRM_SUPPORT="--enable-vc4"

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/raspberrypi/linux/archive/raspberrypi-kernel_1.20190709-1.tar.gz"

SRC_PACKAGE_PERL=
SRC_PACKAGE_PERLCROSS=

