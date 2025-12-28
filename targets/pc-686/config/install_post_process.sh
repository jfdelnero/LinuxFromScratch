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

dd if=/dev/zero of=${TARGET_HOME}/output_objects/hdd.img iflag=fullblock bs=1M count=1024 && sync
sudo losetup loop0 --sector-size 512  ${TARGET_HOME}/output_objects/hdd.img || exit 1
sudo sfdisk -f /dev/loop0 < ${TARGET_CONFIG}/sfdisk.txt || exit 1
sudo losetup -d /dev/loop0

fdisk -l ${TARGET_HOME}/output_objects/hdd.img

###############################################################################
# Format the partitions

sudo losetup --show --sector-size 512 -f -P ${TARGET_HOME}/output_objects/hdd.img

# efi partion -> FAT
sudo mkfs.vfat -F32 /dev/loop0p2

# System partition
sudo mkfs.ext2 /dev/loop0p3

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
sudo mount /dev/loop0p3 ${TARGET_HOME}/output_objects/tmp_mount_point

sudo cp -av ${TARGET_ROOTFS_MIRROR}/* ${TARGET_HOME}/output_objects/tmp_mount_point/.
sudo cp -av ${TARGET_HOME}/sources/linux-kernel/arch/x86/boot/bzImage ${TARGET_HOME}/output_objects/tmp_mount_point/boot
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


#sudo mkdir ${TARGET_HOME}/output_objects/tmp_mount_point/boot/extlinux
#sudo cp  ${TARGET_HOME}/config/extlinux.conf ${TARGET_HOME}/output_objects/tmp_mount_point/boot/extlinux/extlinux.conf

#sudo mkdir ${TARGET_HOME}/output_objects/tmp_mount_point/boot/syslinux
#sudo cp  ${TARGET_HOME}/config/extlinux.conf ${TARGET_HOME}/output_objects/tmp_mount_point/boot/syslinux/syslinux.cfg

#sudo strace ${TARGET_ROOTFS_MIRROR}/sbin/extlinux --install  ${TARGET_HOME}/output_objects/tmp_mount_point/boot

sudo mount /dev/loop0p2 ${TARGET_HOME}/output_objects/tmp_mount_point2

CUR_PACKAGE=${SRC_PACKAGE_GRUB_EFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	create_src_dir

	unpack ${CUR_PACKAGE} ""

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	if [ -f ${TARGET_CONFIG}/patches/grub.patch ]
	then
	(
		cd conf || exit 1
		patch -Zf < ${TARGET_CONFIG}/patches/grub.patch  || exit 1
	) || exit 1
	fi

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	unset PKG_CONFIG_LIBDIR

	export GRUB_AUTORECONF=1
	export GRUB_AUTOGEN=1

	echo depends bli part_gpt > ./grub-core/extra_deps.lst || exit 1

	${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${BUILDTOOLS_HOME}" \
			--disable-werror \
			--with-platform=efi \
			|| exit 1

	./autogen.sh ||  exit 1

	make ${MAKE_FLAGS} ${NBCORE}         || exit 1

	sudo ./grub-install --target=x86_64-efi --directory=grub-core --efi-directory=${TARGET_HOME}/output_objects/tmp_mount_point2 --bootloader-id=GRUB --modules="normal part_msdos part_gpt multiboot" --root-directory=${TARGET_HOME}/output_objects/tmp_mount_point --no-floppy /dev/loop0 || exit 1

	sudo mkdir  ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT || exit 1
	sudo mv     ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB/grubx64.efi ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT/BOOTX64.EFI || exit 1
	sudo rm -rf ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB || exit 1
	#make ${MAKE_FLAGS} ${NBCORE} install || exit 1

	delete_src_dir

	echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
) || exit 1
fi

CUR_PACKAGE=${SRC_PACKAGE_GRUB_EFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	create_src_dir

	unpack ${CUR_PACKAGE} ""

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	if [ -f ${TARGET_CONFIG}/patches/grub.patch ]
	then
	(
		cd conf || exit 1
		patch -Zf < ${TARGET_CONFIG}/patches/grub.patch  || exit 1
	) || exit 1
	fi

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	unset PKG_CONFIG_LIBDIR

	export GRUB_AUTORECONF=1
	export GRUB_AUTOGEN=1

	echo depends bli part_gpt > ./grub-core/extra_deps.lst || exit 1

	${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${BUILDTOOLS_HOME}" \
			--disable-werror \
			--target=${TGT_MACH} \
			--with-platform=efi \
			|| exit 1

	./autogen.sh ||  exit 1

	make ${MAKE_FLAGS} ${NBCORE}         || exit 1

	sudo ./grub-install --target=i386-efi --directory=grub-core --efi-directory=${TARGET_HOME}/output_objects/tmp_mount_point2 --bootloader-id=GRUB --modules="normal part_msdos part_gpt multiboot" --root-directory=${TARGET_HOME}/output_objects/tmp_mount_point --no-floppy /dev/loop0 || exit 1

	sudo mv     ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB/grubia32.efi ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT/BOOTIA32.EFI || exit 1
	sudo rm -rf ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB || exit 1

	#make ${MAKE_FLAGS} ${NBCORE} install || exit 1

	delete_src_dir

	echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
) || exit 1
fi

CUR_PACKAGE=${SRC_PACKAGE_GRUB_BIOS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	create_src_dir

	unpack ${CUR_PACKAGE} ""

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	if [ -f ${TARGET_CONFIG}/patches/grub.patch ]
	then
	(
		cd conf || exit 1
		patch -Zf < ${TARGET_CONFIG}/patches/grub.patch  || exit 1
	) || exit 1
	fi

	cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

	unset PKG_CONFIG_LIBDIR

	export GRUB_AUTORECONF=1
	export GRUB_AUTOGEN=1

	echo depends bli part_gpt > ./grub-core/extra_deps.lst || exit 1

	${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${BUILDTOOLS_HOME}" \
			--disable-werror \
			--disable-efiemu \
			--with-platform=pc \
			|| exit 1

	./autogen.sh ||  exit 1

	make ${MAKE_FLAGS} ${NBCORE}         || exit 1

	#sudo chmod ou+w -R ${TARGET_HOME}/output_objects/tmp_mount_point/boot
	sudo ./grub-install --target=i386-pc --directory=grub-core --root-directory=${TARGET_HOME}/output_objects/tmp_mount_point --modules="normal part_msdos part_gpt multiboot" --no-floppy /dev/loop0 || exit 1

	#make ${MAKE_FLAGS} ${NBCORE} install || exit 1

	delete_src_dir

	echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
) || exit 1
fi


###############################################################################
# owner / group / right accesses fix

cd ${TARGET_HOME}/output_objects/tmp_mount_point/ || exit 1

${SCRIPTS_HOME}/fix_fs_perm.sh

sudo chown 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chgrp 1001 ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk
sudo chmod o+wr ${TARGET_HOME}/output_objects/tmp_mount_point/ramdisk

sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point
sudo umount ${TARGET_HOME}/output_objects/tmp_mount_point2

sudo losetup -d /dev/loop0

###############################################################################
