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
#export GFX_SUPPORT="1"
#export WAYLAND_SUPPORT="1"
export AUDIO_SUPPORT="1"
export TARGET_BUILD_SUPPORT="1"
#export GAMES_SUPPORT="1"

export NETWORK_STATION_MODE="1"
#export NETWORK_ROUTER_MODE="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

#export MESA_DRI_DRV="swrast"
#export MESA_GALLIUM_DRV="vc4,swrast"
#export DRM_SUPPORT="--enable-vc4"

###################################################
# Cross compiler for the cross compiled machine

#export CROSS_TGT_MACH=arm-none-eabi
#export CROSS_TGT_CPU=cortex-m3
#export CROSS_TGT_CPUMODE=thumb

#SRC_PACKAGE_TARGET_CROSS_BINUTILS="http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"

#SRC_PACKAGE_TARGET_CROSS_GCC="http://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.gz"
#SRC_PACKAGE_TARGET_CROSS_GCC_MPFR="http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.xz"
#SRC_PACKAGE_TARGET_CROSS_GCC_GMP="http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.xz"
#SRC_PACKAGE_TARGET_CROSS_GCC_MPC="http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz"
#SRC_PACKAGE_TARGET_CROSS_GCC_ISL="ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.15.tar.bz2"
#SRC_PACKAGE_TARGET_CROSS_GCC_CLOOG="ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"

###################################################
# Kernel

SRC_PACKAGE_KERNEL="https://github.com/raspberrypi/linux/archive/refs/tags/raspberrypi-kernel_1.20210430-1.tar.gz"

SRC_PACKAGE_DIRECTFB=

SRC_PACKAGE_STRACE=
