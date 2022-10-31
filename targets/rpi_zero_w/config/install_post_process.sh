#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2021 Jean-François DEL NERO
#
# Raspberry Pi Zero W target post install process
#

source ${TARGET_CONFIG}/config.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

###############################################################################
# Create SD Card image

dd if=/dev/zero of=${TARGET_HOME}/output_objects/sdcard.img iflag=fullblock bs=1M count=1024 && sync
sudo losetup loop6 --sector-size 512  ${TARGET_HOME}/output_objects/sdcard.img || exit 1
sudo sfdisk -f /dev/loop6 < ${TARGET_CONFIG}/sfdisk.txt || exit 1
sudo losetup -d /dev/loop6

fdisk -l ${TARGET_HOME}/output_objects/sdcard.img

###############################################################################
# Format the partitions

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img

sleep 1

# Boot partion -> FAT
sudo mkfs.vfat /dev/loop6p1

# System partition
sudo mkfs.ext2 /dev/loop6p2

sudo losetup -d /dev/loop6

###############################################################################

echo "Copy boot files to the file image ..."
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point

sleep 1
sudo losetup loop6 --show --sector-size 512 -P ${TARGET_HOME}/output_objects/sdcard.img
sleep 1

sudo mount /dev/loop6p1 ${TARGET_HOME}/output_objects/tmp_mount_point

# Boot loader blob
rm -rf ${TARGET_HOME}/output_objects/RPIZw_bootpart
unzip ${TARGET_HOME}/config/boot_part/RPIZw_bootpart.zip -d ${TARGET_HOME}/output_objects/ || exit 1
sudo cp -a ${TARGET_HOME}/output_objects/RPIZw_bootpart/* ${TARGET_HOME}/output_objects/tmp_mount_point

# Kernel
sudo cp ${TARGET_ROOTFS_MIRROR}/boot/Image ${TARGET_HOME}/output_objects/tmp_mount_point/kernel.img
sudo cp -a ${TARGET_ROOTFS_MIRROR}/boot/dts/overlays ${TARGET_HOME}/output_objects/tmp_mount_point/
sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point

# Fix/force the disk partitions uuid -> Must be equal to the cmdline.txt value
sudo fdisk /dev/loop6 <<EOF > /dev/null
p
x
i
0x80e567d8
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

sudo mount /dev/loop6p2 ${TARGET_HOME}/output_objects/tmp_mount_point

sudo cp -av ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.
sudo tar -xvzf ${BASE_DIR}/blobs/RaspberryPi/firmware.tar.gz -C ${TARGET_HOME}/output_objects/tmp_mount_point/lib

# Add here the customizations

#sudo cp -av ${TARGET_HOME}/output_objects/a_new_program  ${TARGET_HOME}/output_objects/tmp_mount_point/usr/sbin || exit 1

###############################################################################
# owner / group / right accesses fix

cd ${TARGET_HOME}/output_objects/tmp_mount_point/ || exit 1

${SCRIPTS_HOME}/fix_fs_perm.sh

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo losetup -d /dev/loop6

###############################################################################
