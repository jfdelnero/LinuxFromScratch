#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2022 Jean-François DEL NERO
#
# arm-none-eabi cross compiler only target
#

export CROSSCOMPILERONLY="1"

export KERNEL_ARCH=arm
export TGT_MACH=arm-none-eabi
export GCC_ADD_CONF=""

source ${BASE_DIR}/targets/common/config/config.sh || exit 1

