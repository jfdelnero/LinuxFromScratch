#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Zynq / Red Pitaya target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=armv7a-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export TARGET_BUILD_SUPPORT="1"

export KERNEL_IMAGE_TYPE="uImage"
export KERNEL_ADD_OPTIONS="LOADADDR=0x2001000"

export KERNEL_DTBS="YES"
export KERNEL_FIRMWARES="YES"

export DEBUG_SUPPORT="1"

export NETWORK_SUPPORT="1"
#export WIRELESS_SUPPORT="1"
#export GFX_SUPPORT="1"
#export LIBGFX_SUPPORT="1"
#export WAYLAND_SUPPORT="1"
#export AUDIO_SUPPORT="1"
export TARGET_BUILD_SUPPORT="1"
#export GAMES_SUPPORT="1"

#export HDD_SUPPORT="1"
#export NETWORK_STATION_MODE="1"
export NETWORK_ROUTER_MODE="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

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

#https://github.com/RedPitaya/linux-xlnx/tree/branch-redpitaya-v2022.3
SRC_PACKAGE_KERNEL="redpitaya-kernel-v2022.3.tar.gz"

SRC_PACKAGE_DIRECTFB=

