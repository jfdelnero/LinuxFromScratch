#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2022 Jean-François DEL NERO
#
# Clearfog target post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

#cd ${TARGET_CONFIG}/boot_part
#tar -xvzf u-boot-armada38x.tar.gz
#cd u-boot-armada38x
#export CROSS_COMPILE=armv7a-hardfloat-linux-gnueabi-
#cp include/linux/compiler-gcc4.h include/linux/compiler-gcc12.h
#make armada_38x_clearfog_config
#make u-boot.mmc

###############################################################################
# Create SD Card image
rm ${TARGET_HOME}/output_objects/sdcard.img

dd if=/dev/zero of=${TARGET_HOME}/output_objects/sdcard.img iflag=fullblock bs=1M count=1024 && sync

cd ${TARGET_CONFIG}/boot_part
rm clearfog_sd_uboot.bin
unzip clearfog_sd_uboot.zip || exit 1
dd if=${TARGET_CONFIG}/boot_part/clearfog_sd_uboot.bin of=${TARGET_HOME}/output_objects/sdcard.img bs=512 seek=0  conv=notrunc && sync

sudo losetup loop6 --sector-size 512  ${TARGET_HOME}/output_objects/sdcard.img || exit 1
sudo sfdisk -f /dev/loop6 < ${TARGET_CONFIG}/sfdisk.txt || exit 1
sudo losetup -d /dev/loop6

fdisk -l ${TARGET_HOME}/output_objects/sdcard.img

###############################################################################
# Format the partitions

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1
# System partition
sudo mkfs.ext4 /dev/loop6p1 -O ^64bit,^metadata_csum

sudo losetup -d /dev/loop6

###############################################################################

echo "Copy boot files to the file image ..."
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1
# Fix/force the disk partitions uuid
sudo fdisk /dev/loop6 <<EOF > /dev/null
p
x
i
0x000083ec
r
p
w
EOF

sudo losetup -d /dev/loop6

sync

###############################################################################
sleep 1

echo "Copy rootfs to the file image ..."

sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1

sudo mount /dev/loop6p1 ${TARGET_HOME}/output_objects/tmp_mount_point

sudo cp -av ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.

# Add here the customizations

#sudo mkimage -A arm -T script -O linux -d ${TARGET_CONFIG}/boot_part/boot.script ${TARGET_HOME}/output_objects/tmp_mount_point/boot.scr
sudo cp -av ${TARGET_CONFIG}/boot_part/boot.scr  ${TARGET_HOME}/output_objects/tmp_mount_point/  || exit 1

if [[ -d ${TARGET_CONFIG}/private_rootfs_cfg/ ]]
then
	sudo cp -av ${TARGET_CONFIG}/private_rootfs_cfg/       ${TARGET_HOME}/output_objects/tmp_mount_point/  || exit 1
fi

#sudo cp -av ${TARGET_HOME}/output_objects/a_new_program  ${TARGET_HOME}/output_objects/tmp_mount_point/usr/sbin || exit 1

###############################################################################
# owner / group / right accesses fix

cd ${TARGET_HOME}/output_objects/tmp_mount_point/ || exit 1

sudo mkdir data

${SCRIPTS_HOME}/fix_fs_perm.sh

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

sync

cd ${TARGET_HOME}

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop6

###############################################################################
