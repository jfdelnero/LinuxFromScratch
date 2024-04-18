#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2024 Jean-François DEL NERO
#
# Redpitaya / Zynq 7020 target post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

# Generate the dts and build the dtb
echo --- Generate the dts and build the dtb ---

#dtc -I dts -O dtb -o ${TARGET_HOME}/output_objects/soc_system.dtb ${TARGET_HOME}/output_objects/soc_system.dts  || exit 1

#############################################################################"

##git clone https://github.com/altera-opensource/u-boot-socfpga
##cd u-boot-socfpga
##git checkout -b test -t origin/socfpga_v2019.04

#git clone https://github.com/altera-opensource/u-boot-socfpga  || exit 1
#cd u-boot-socfpga || exit 1
#git checkout -b test -t origin/socfpga_v2019.04  || exit 1

#tar -xvzf ${FPGA_GHRD_FOLDER}/software/spl_bsp/u-boot-socfpga-2019-04.tar.gz

#cd ${FPGA_GHRD_FOLDER}/software/spl_bsp/u-boot-socfpga
#${FPGA_GHRD_FOLDER}/software/spl_bsp/u-boot-socfpga/arch/arm/mach-socfpga/qts-filter.sh cyclone5 ${FPGA_GHRD_FOLDER} ${FPGA_GHRD_FOLDER}/software/spl_bsp/ ${FPGA_GHRD_FOLDER}/software/spl_bsp/u-boot-socfpga/board/terasic/de10-nano/qts/

#cd ${FPGA_GHRD_FOLDER}/software/spl_bsp/u-boot-socfpga
#make socfpga_de10_nano_defconfig || exit 1
#make || exit 1

#############################################################################"

# Make the u-boot script image

mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Boot Script Name" -d ${TARGET_CONFIG}/boot.script ${TARGET_HOME}/output_objects/u-boot.scr

# copy u-boot and the kernel to the output folder.

#cp ${TARGET_SOURCES}/u-boot-socfpga-rel_socfpga_v2013.01.01_19.03.02_pr/u-boot.img ${TARGET_HOME}/output_objects/  || exit 1
cp ${TARGET_SOURCES}/linux-kernel/arch/arm/boot/uImage ${TARGET_HOME}/output_objects/  || exit 1

# convert the fpga sof file to rbf.

############################################################################################
# Create SD Card image

dd if=/dev/zero of=${TARGET_HOME}/output_objects/sdcard.img iflag=fullblock bs=1M count=500 && sync
sudo losetup loop0 --sector-size 512  ${TARGET_HOME}/output_objects/sdcard.img
sudo sfdisk /dev/loop0 < ${TARGET_CONFIG}/sfdisk.txt
sudo losetup -d /dev/loop0

############################################################################################

#921600
dd if=${TARGET_HOME}/output_objects/preloader-mkpimage.bin of=${TARGET_HOME}/output_objects/sdcard.img bs=512 seek=921600  conv=notrunc && sync
dd if=${TARGET_HOME}/output_objects/u-boot.img of=${TARGET_HOME}/output_objects/sdcard.img bs=512 seek=922112 conv=notrunc && sync

fdisk -l ${TARGET_HOME}/output_objects/sdcard.img

############################################################################################

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/sdcard.img
sudo mkfs.vfat /dev/loop0p1
sudo mkfs.ext2 /dev/loop0p2
sudo losetup -d /dev/loop0

############################################################################################
echo "Copy boot files to the file image ..."
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/sdcard.img
sudo mount /dev/loop0p1 ${TARGET_HOME}/output_objects/tmp_mount_point
sudo cp ${TARGET_HOME}/output_objects/u-boot.scr        ${TARGET_HOME}/output_objects/tmp_mount_point  && sync
sudo cp ${TARGET_HOME}/output_objects/soc_system.rbf    ${TARGET_HOME}/output_objects/tmp_mount_point  && sync
sudo cp ${TARGET_HOME}/output_objects/soc_system.dtb    ${TARGET_HOME}/output_objects/tmp_mount_point  && sync
sudo cp ${TARGET_HOME}/output_objects/soc_system.dts    ${TARGET_HOME}/output_objects/tmp_mount_point  && sync
sudo cp ${TARGET_HOME}/output_objects/zImage            ${TARGET_HOME}/output_objects/tmp_mount_point  && sync
sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop0

############################################################################################
echo "Copy rootfs to the file image ..."

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/sdcard.img
sudo mount /dev/loop0p2 ${TARGET_HOME}/output_objects/tmp_mount_point

sudo cp -av ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.

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

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop0

############################################################################################

#sudo dd if=${TARGET_HOME}/output_objects/preloader-mkpimage.bin of=/dev/sdd3 bs=64k seek=0
#sudo dd if=${TARGET_HOME}/output_objects/u-boot.img of=/dev/sdd3 bs=64k seek=4

