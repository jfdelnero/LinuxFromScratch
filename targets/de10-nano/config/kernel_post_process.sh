#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# DE10-Nano target kernel compilation
# post process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp ${TMP_SRC_FOLDER}/linux-kernel/arch/arm/boot/zImage ${TARGET_HOME}/output_objects/  || exit 1
cp ${TMP_SRC_FOLDER}/linux-kernel/arch/arm/boot/dts/intel/socfpga/socfpga_cyclone5_de10nano.dtb ${TARGET_HOME}/output_objects/soc_system.dtb  || exit 1
