#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# i686-pc post install process
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

mkdir ${TARGET_HOME}/output_objects

###############################################################################
# Create SD Card image

dd if=/dev/zero of=${TARGET_HOME}/output_objects/hdd.img iflag=fullblock bs=1M count=2048 && sync
sudo losetup loop0 --sector-size 512  ${TARGET_HOME}/output_objects/hdd.img || exit 1
sudo sfdisk -f /dev/loop0 < ${TARGET_CONFIG}/sfdisk.txt || exit 1
sudo losetup -d /dev/loop0

fdisk -l ${TARGET_HOME}/output_objects/hdd.img

###############################################################################
# Format the partitions

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/hdd.img

# efi partion -> FAT
sudo mkfs.vfat -F32 /dev/loop0p2 || exit 1

# System partition
sudo mkfs.ext2 /dev/loop0p3 || exit 1

sudo losetup -d /dev/loop0

###############################################################################

echo "Copy boot files to the file image ..."
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point
mkdir ${TARGET_HOME}/output_objects/tmp_mount_point2

#sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/hdd.img
#sudo mount /dev/loop0p1 ${TARGET_HOME}/output_objects/tmp_mount_point

# Boot loader blob
#rm -rf ${TARGET_HOME}/output_objects/RPIZw_bootpart
#unzip ${TARGET_HOME}/config/boot_part/RPIZw_bootpart.zip -d ${TARGET_HOME}/output_objects/
#sudo cp -a ${TARGET_HOME}/output_objects/RPIZw_bootpart/* ${TARGET_HOME}/output_objects/tmp_mount_point

# Kernel
#sudo cp ${TARGET_ROOTFS_MIRROR}/boot/Image ${TARGET_HOME}/output_objects/tmp_mount_point/kernel.img
#sudo cp -a ${TARGET_ROOTFS_MIRROR}/boot/dts/overlays ${TARGET_HOME}/output_objects/tmp_mount_point/
#sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point

#sudo losetup -d /dev/loop0

sync

###############################################################################

echo "Copy rootfs to the file image ..."

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/hdd.img
sudo mount /dev/loop0p3 ${TARGET_HOME}/output_objects/tmp_mount_point || exit 1

sudo cp -a ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.
sudo cp -a ${TARGET_HOME}/sources/linux-kernel/arch/x86/boot/bzImage ${TARGET_HOME}/output_objects/tmp_mount_point/boot
# Add here the customizations

# Keymaps
sudo unzip ${BASE_DIR}/blobs/Keymaps/keymaps.zip -d ${TARGET_HOME}/output_objects/tmp_mount_point/

#sudo cp -av ${TARGET_HOME}/output_objects/a_new_program  ${TARGET_HOME}/output_objects/tmp_mount_point/usr/sbin || exit 1

###############################################################################
# owner / group / right accesses fix

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

sudo chown -R root ${TARGET_HOME}/output_objects/tmp_mount_point/*
sudo chgrp -R root ${TARGET_HOME}/output_objects/tmp_mount_point/*

sudo chmod ugo-w   ${TARGET_HOME}/output_objects/tmp_mount_point/home
sudo chmod +x      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*.sh
sudo chmod +x      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/rcS.d/*.sh
sudo chmod +x      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/rcS
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/rcS
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*.sh
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/rcS.d/*.sh
sudo chmod go-w    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/*
sudo chmod ugo-rwx ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd
sudo chmod u+rw    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd
sudo chmod go+r    ${TARGET_HOME}/output_objects/tmp_mount_point/etc/passwd

sudo chmod +x ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/*
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/sshd         ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/default/sshd
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/rcS          ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/default/rcS
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/udevd        ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/default/udevd
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/udev-trigger ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/default/udev-trigger
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/agetty       ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/default/agetty.tty1
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/agetty       ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/agetty.tty1
sudo ln -rs ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/etc_ram      ${TARGET_HOME}/output_objects/tmp_mount_point/etc/runlevels/sysinit/etc_ram

sudo ln -rs  ${TARGET_HOME}/output_objects/tmp_mount_point/lib/ld-linux-x86-64.so.2 ${TARGET_HOME}/output_objects/tmp_mount_point/lib64/ld-linux-x86-64.so.2
#sudo mkdir ${TARGET_HOME}/output_objects/tmp_mount_point/boot/extlinux
#sudo cp  ${TARGET_HOME}/config/extlinux.conf ${TARGET_HOME}/output_objects/tmp_mount_point/boot/extlinux/extlinux.conf

#sudo mkdir ${TARGET_HOME}/output_objects/tmp_mount_point/boot/syslinux
#sudo cp  ${TARGET_HOME}/config/extlinux.conf ${TARGET_HOME}/output_objects/tmp_mount_point/boot/syslinux/syslinux.cfg

#sudo strace ${TARGET_ROOTFS_MIRROR}/sbin/extlinux --install  ${TARGET_HOME}/output_objects/tmp_mount_point/boot

sudo ldconfig -r ${TARGET_HOME}/output_objects/tmp_mount_point/

sudo mount /dev/loop0p2 ${TARGET_HOME}/output_objects/tmp_mount_point2 || exit 1

chmod +x ${TARGET_HOME}/config/build_grub.sh

${TARGET_HOME}/config/build_grub.sh x86_64 efi || exit 1

${TARGET_HOME}/config/build_grub.sh i386   efi || exit 1

${TARGET_HOME}/config/build_grub.sh i386   pc  || exit 1

###############################################################################
# owner / group / right accesses fix

cd ${TARGET_HOME}/output_objects/tmp_mount_point/ || exit 1

sudo chmod +x ${TARGET_HOME}/output_objects/tmp_mount_point/etc/local.d/*
sudo chmod +x ${TARGET_HOME}/output_objects/tmp_mount_point/etc/init.d/*

${SCRIPTS_HOME}/fix_fs_perm.sh

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

echo "\EFI\GRUB\grubx64.efi" > ${TARGET_HOME}/output_objects/startup.nsh

sudo cp ${TARGET_HOME}/output_objects/startup.nsh ${TARGET_HOME}/output_objects/tmp_mount_point2/startup.nsh

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point2

sudo losetup -d /dev/loop0

###############################################################################
