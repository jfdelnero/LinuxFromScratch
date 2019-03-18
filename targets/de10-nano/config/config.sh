#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2019 Jean-François DEL NERO
#
# DE10-Nano target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=arm-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="zImage"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
export WIRELESS_SUPPORT="1"
export TARGET_BUILD_SUPPORT="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/altera-opensource/linux-socfpga/archive/rel_socfpga-4.14.73-ltsi-rt_19.03.01_pr.tar.gz"
SRC_PACKAGE_UBOOT="https://github.com/u-boot/u-boot/archive/v2017.03.tar.gz"
SRC_PACKAGE_FTRACE="http://ftp.debian.org/debian/pool/main/t/trace-cmd/trace-cmd_2.4.0.orig.tar.gz"
SRC_PACKAGE_VALGRIND=

