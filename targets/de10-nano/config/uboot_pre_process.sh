#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2019 Jean-François DEL NERO
#
# DE10-Nano uboot patches
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp ${TARGET_CONFIG}/patches/socfpga_cyclone5.h include/configs/

