#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# DE10-Nano target post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

export ALTERA_SOPC2DTS_FOLDER=/media/jeff/ExtData/altera_lite/20.1/embedded/host_tools/altera/device_tree
export ALTERA_SOPCINFO_FOLDER=/media/jeff/Data_fast/github/Pauline/FPGA_Pauline/Rev_A
export ALTERA_QUARTUS_CPF_FOLDER=/media/jeff/ExtData/altera_lite/20.1/qprogrammer/linux64

# Make the u-boot script image
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Boot Script" -d ${TARGET_CONFIG}/boot.script ${TARGET_HOME}/output_objects/u-boot.scr

# Generate the dts and build the dtb
#${ALTERA_SOPC2DTS_FOLDER}/sopc2dts --input ${ALTERA_SOPCINFO_FOLDER}/soc_system.sopcinfo --output ${TARGET_HOME}/output_objects/soc_system_fpga.dts --type dts --board ${TARGET_CONFIG}/fpga/soc_system_board_info.xml --board ${TARGET_CONFIG}/fpga/hps_common_board_info.xml --bridge-removal all --clocks  || exit 1
#dtc -I dts -O dtb -o ${TARGET_HOME}/output_objects/soc_system_fpga.dtb ${TARGET_HOME}/output_objects/soc_system_fpga.dts  || exit 1

# convert the fpga sof file to rbf.

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${ALTERA_QUARTUS_CPF_FOLDER}

${ALTERA_QUARTUS_CPF_FOLDER}/quartus_cpf -c -o bitstream_compression=on ${ALTERA_SOPCINFO_FOLDER}/output_files/FPGA_Pauline_Rev_A.sof ${TARGET_HOME}/output_objects/soc_system.rbf || exit 1
cd ${TARGET_HOME}

#sudo dd if=${TARGET_HOME}/output_objects/preloader-mkpimage.bin of=/dev/sdd3 bs=64k seek=0

############################################################################################
# Create SD Card image

dd if=/dev/zero of=${TARGET_HOME}/output_objects/sdcard.img iflag=fullblock bs=1M count=2048 && sync
sudo losetup loop6 --sector-size 512  ${TARGET_HOME}/output_objects/sdcard.img || exit 1
sudo sfdisk -f /dev/loop6 < ${TARGET_CONFIG}/sfdisk.txt || exit 1
sudo losetup -d /dev/loop6

############################################################################################

#sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/pauline_sdcard.img
#sudo dd if=${TARGET_HOME}/output_objects/preloader-mkpimage.bin of=/dev/loop6p3 bs=64k seek=0  && sync
#sudo dd if=${TARGET_HOME}/output_objects/u-boot.img of=/dev/loop6p3 bs=64k seek=4              && sync
#sudo losetup -d /dev/loop6

#1040384
dd if=${TARGET_HOME}/output_objects/u-boot-with-spl.sfp of=${TARGET_HOME}/output_objects/sdcard.img bs=512 seek=4186112  conv=notrunc || exit 1 && sync

fdisk -l ${TARGET_HOME}/output_objects/sdcard.img || exit 1

############################################################################################

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img || exit 1
sleep 1

sudo mkfs.vfat /dev/loop6p1 || exit 1
sudo mkfs.ext2 /dev/loop6p2 || exit 1
sudo losetup -d /dev/loop6

############################################################################################
echo "Copy boot files to the file image ..."
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1

sudo mount /dev/loop6p1 ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1
sudo cp ${TARGET_HOME}/output_objects/u-boot.scr        ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1 && sync
sudo cp ${TARGET_HOME}/output_objects/soc_system.rbf    ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1 && sync
sudo cp ${TARGET_HOME}/output_objects/soc_system.dtb    ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1 && sync
sudo cp ${TARGET_HOME}/output_objects/zImage            ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1 && sync
sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop6

############################################################################################
echo "Copy rootfs to the file image ..."

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1
sudo mount /dev/loop6p2 ${TARGET_HOME}/output_objects/tmp_mount_point

sudo cp -av ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.

#
# Prepare data folder.
#

sudo mkdir  ${TARGET_HOME}/output_objects/tmp_mount_point/data


###

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

sudo chown -R root ${TARGET_HOME}/output_objects/tmp_mount_point/*
sudo chgrp -R root ${TARGET_HOME}/output_objects/tmp_mount_point/*

sudo chmod ugo-w   ${TARGET_HOME}/output_objects/tmp_mount_point/home
sudo chmod +x      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*.sh
sudo chmod +x      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/rcS.d/*.sh
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*.sh
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/rcS.d/*.sh
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*
sudo chmod ugo-rwx ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd
sudo chmod u+rw    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd
sudo chmod go+r    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd

cd ${TARGET_HOME}/output_objects/tmp_mount_point
${SCRIPTS_HOME}/fix_fs_perm.sh
cd ${TARGET_HOME}

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop6

