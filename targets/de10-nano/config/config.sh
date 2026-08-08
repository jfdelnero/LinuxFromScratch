#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# DE10-Nano target setup
#

export KERNEL_ARCH=arm
export TGT_MACH=arm-hardfloat-linux-gnueabi
export SSL_ARCH=linux-armv4
export GCC_ADD_CONF=""

export KERNEL_IMAGE_TYPE="zImage"
export KERNEL_DTBS="YES"

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

SRC_PACKAGE_KERNEL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.43.tar.xz"
#"https://github.com/altera-fpga/linux-socfpga/archive/refs/tags/rel_socfpga-6.18.2-lts_26.04.01_pr.tar.gz"

SRC_PACKAGE_PERL=
SRC_PACKAGE_PERLCROSS=

#uboot
export UBOOT_DEFCONF=socfpga_de10_nano_defconfig
SRC_PACKAGE_UBOOT="https://github.com/altera-fpga/u-boot-socfpga/archive/refs/tags/QPDS24.3.1_REL_GSRD_PR.tar.gz" #"https://github.com/u-boot/u-boot/archive/refs/tags/v2026.07.tar.gz"
#"https://github.com/altera-opensource/u-boot-socfpga/archive/rel_socfpga_v2013.01.01_19.03.02_pr.tar.gz"

#SRC_PACKAGE_FTRACE="https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-v3.4.tar.gz"
SRC_PACKAGE_VALGRIND=

