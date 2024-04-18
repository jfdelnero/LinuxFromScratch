#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2024 Jean-François DEL NERO
#
# Redpitaya / Zynq 7020 target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=arm-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="uImage"
export KERNEL_ADD_OPTIONS="LOADADDR=0x2001000"

export DEBUG_SUPPORT="1"
export NETWORK_SUPPORT="1"
#export WIRELESS_SUPPORT="1"
export TARGET_BUILD_SUPPORT="1"

export NETWORK_STATION_MODE="1"
#export NETWORK_ROUTER_MODE="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/RedPitaya/linux-xlnx/archive/refs/tags/redpitaya-v2016.2-RP4.tar.gz"

SRC_PACKAGE_PERL=
SRC_PACKAGE_PERLCROSS=

#uboot
export UBOOT_DEFCONF=xilinx_zynq_config
SRC_PACKAGE_UBOOT="https://github.com/RedPitaya/u-boot-xlnx/archive/refs/tags/redpitaya-v2022.2.tar.gz"

SRC_PACKAGE_FTRACE="http://ftp.debian.org/debian/pool/main/t/trace-cmd/trace-cmd_2.4.0.orig.tar.gz"
SRC_PACKAGE_VALGRIND=

