#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2024 Jean-François DEL NERO
#
# Clearfog Pro target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=armv7a-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export SAMBA_ARCH=arm
export GCC_ADD_CONF=""

export TARGET_BUILD_SUPPORT="1"

export KERNEL_IMAGE_TYPE="zImage"
export KERNEL_DTBS="YES"
export KERNEL_FIRMWARES="YES"

export NETWORK_ROUTER_MODE="YES"

export DEBUG_SUPPORT="1"

export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"

export HDD_SUPPORT="1"

###################################################
# Cross compiler for the cross compiled machine

export CROSS_TGT_MACH=arm-none-eabi
export CROSS_TGT_CPU=cortex-m3
export CROSS_TGT_CPUMODE=thumb

SRC_PACKAGE_TARGET_CROSS_BINUTILS="http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"

SRC_PACKAGE_TARGET_CROSS_GCC="https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
SRC_PACKAGE_TARGET_CROSS_GCC_MPFR="https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz"
SRC_PACKAGE_TARGET_CROSS_GCC_GMP="https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
SRC_PACKAGE_TARGET_CROSS_GCC_MPC="https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"
SRC_PACKAGE_TARGET_CROSS_GCC_ISL="ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2"
SRC_PACKAGE_TARGET_CROSS_GCC_CLOOG="ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz"

SRC_PACKAGE_CVS="https://ftp.gnu.org/non-gnu/cvs/source/stable/1.11.23/cvs-1.11.23.tar.gz"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.163.tar.xz"
