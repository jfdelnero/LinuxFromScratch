#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2025 Jean-François DEL NERO
#
# DE10-Nano target post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

# setup the altera env
export _SOCEDS_ROOT=${ALTERA_TOOLS_ROOT}/embedded
export SOCEDS_DEST_ROOT="${_SOCEDS_ROOT}"
source ${_SOCEDS_ROOT}/env.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

# Make the u-boot script image

mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Boot Script Name" -d ${TARGET_CONFIG}/boot.script ${TARGET_HOME}/output_objects/u-boot.scr

# build the preloader

cd ${FPGA_GHRD_FOLDER}/software/spl_bsp || exit 1
make clean  || exit 1
make  || exit 1

cp ${FPGA_GHRD_FOLDER}/software/spl_bsp/preloader-mkpimage.bin ${TARGET_HOME}/output_objects/  || exit 1 

# Generate the dts and build the dtb

cd ${FPGA_GHRD_FOLDER} || exit 1
sopc2dts --input soc_system.sopcinfo --output ${TARGET_HOME}/output_objects/soc_system.dts --type dts --board soc_system_board_info.xml --board hps_common_board_info.xml --bridge-removal all --clocks  || exit 1
dtc -I dts -O dtb -o ${TARGET_HOME}/output_objects/soc_system.dtb ${TARGET_HOME}/output_objects/soc_system.dts  || exit 1 

# copy u-boot and the kernel to the output folder.

cp ${TARGET_SOURCES}/u-boot-socfpga-rel_socfpga_v2013.01.01_19.03.02_pr/u-boot.img ${TARGET_HOME}/output_objects/  || exit 1
cp ${TARGET_SOURCES}/linux-kernel/arch/arm/boot/zImage ${TARGET_HOME}/output_objects/  || exit 1

# convert the fpga sof file to rbf.

${ALTERA_TOOLS_ROOT}/quartus/bin/quartus_cpf -c -o bitstream_compression=on ${FPGA_GHRD_FOLDER}/output_files/DE10_NANO_SoC_GHRD.sof ${TARGET_HOME}/output_objects/soc_system.rbf || exit 1

#sudo dd if=${TARGET_HOME}/output_objects/preloader-mkpimage.bin of=/dev/sdd3 bs=64k seek=0

