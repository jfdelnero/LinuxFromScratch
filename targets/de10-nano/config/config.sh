#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2020 Jean-François DEL NERO
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

export NETWORK_STATION_MODE="1"
#export NETWORK_ROUTER_MODE="1"

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

# Altera tools installation path

# Quartus II Folder (../intelFPGA_lite/XX.X/)
export ALTERA_TOOLS_ROOT=${ALTERA_BASEDIR}

# GHRD (Golden Hardware Reference Design) DE10-nano project folder (DE10_NANO_SoC_GHRD folder)
export FPGA_GHRD_FOLDER=${ALTERA_DE10_GHRD_BASEDIR}

# Kernel

SRC_PACKAGE_KERNEL="https://github.com/altera-opensource/linux-socfpga/archive/rel_socfpga-4.14.73-ltsi-rt_19.03.01_pr.tar.gz"

SRC_PACKAGE_PERL=
SRC_PACKAGE_PERLCROSS=

#uboot
export UBOOT_DEFCONF=socfpga_cyclone5_config
SRC_PACKAGE_UBOOT="https://github.com/altera-opensource/u-boot-socfpga/archive/rel_socfpga_v2013.01.01_19.03.02_pr.tar.gz"

SRC_PACKAGE_FTRACE="http://ftp.debian.org/debian/pool/main/t/trace-cmd/trace-cmd_2.4.0.orig.tar.gz"
SRC_PACKAGE_VALGRIND=

