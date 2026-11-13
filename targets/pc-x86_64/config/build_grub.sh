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

if [[ $# -eq 0 ]] ; then
	echo "./build_grup.sh x86_64 efi"
	echo "./build_grup.sh i386   efi"
	echo "./build_grup.sh i386   pc"
	exit 1
fi

CUR_PACKAGE=${SRC_PACKAGE_GRUB_EFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	create_src_dir

	unpack ${CUR_PACKAGE} ""

	export GRUB_CPU=$1 #"x86_64"
	export GRUB_PLAT=$2 #"efi"
	export GRUB_TRGT="${GRUB_CPU}-${GRUB_PLAT}"

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

	rm -rf build-grub-${GRUB_TRGT}

	echo depends bli part_gpt > ./grub-core/extra_deps.lst || exit 1

	./autogen.sh ||  exit 1

	mkdir build-grub-${GRUB_TRGT} && cd build-grub-${GRUB_TRGT} || exit 1

	#make distclean || exit 1
	#./bootstrap ||  exit 1

	${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${BUILDTOOLS_HOME}" \
			--host=$TGT_MACH \
			--target=${GRUB_CPU} \
			--disable-werror \
			--disable-nls \
			--disable-efiemu \
			--disable-grub-mkfont \
			--disable-grub-mount \
			--with-platform=${GRUB_PLAT} \
			|| exit 1

	make ${MAKE_FLAGS} ${NBCORE}         || exit 1

	if [ ${GRUB_TRGT} == "x86_64-efi" ]
	then
	(
		echo Install x86_64-efi...

		sudo mkdir -p  ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT || exit 1

		sudo ./grub-install --target=${GRUB_TRGT} \
						--directory=grub-core \
						--efi-directory=${TARGET_HOME}/output_objects/tmp_mount_point2 \
						--bootloader-id=GRUB \
						--modules="normal part_msdos part_gpt multiboot" \
						--boot-directory="${TARGET_HOME}/output_objects/tmp_mount_point/boot" \
						--root-directory=${TARGET_HOME}/output_objects/tmp_mount_point \
						--no-floppy \
						/dev/loop0 || exit 1

		sudo mv     ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB/grubx64.efi ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT/BOOTX64.EFI || exit 1
		sudo rm -rf ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB || exit 1
	) || exit 1
	fi

	if [ ${GRUB_TRGT} == "i386-efi" ]
	then
	(
		echo Install i386-efi...

		sudo ./grub-install --target=${GRUB_TRGT} \
						--directory=grub-core \
						--efi-directory=${TARGET_HOME}/output_objects/tmp_mount_point2 \
						--bootloader-id=GRUB \
						--modules="normal part_msdos part_gpt multiboot" \
						--boot-directory="${TARGET_HOME}/output_objects/tmp_mount_point/boot" \
						--root-directory=${TARGET_HOME}/output_objects/tmp_mount_point \
						--no-floppy \
						/dev/loop0 || exit 1

		sudo mv     ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB/grubia32.efi ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/BOOT/BOOTIA32.EFI || exit 1
		sudo rm -rf ${TARGET_HOME}/output_objects/tmp_mount_point2/EFI/GRUB || exit 1
	) || exit 1
	fi

	if [ ${GRUB_TRGT} == "i386-pc" ]
	then
	(
		echo Install i386-pc...

		sudo ./grub-install --target=${GRUB_TRGT} \
						--directory=grub-core \
						--modules="part_gpt biosdisk ext2 fat normal configfile linux" \
						--boot-directory="${TARGET_HOME}/output_objects/tmp_mount_point/boot" \
						--root-directory=${TARGET_HOME}/output_objects/tmp_mount_point \
						--no-floppy \
						/dev/loop0 || exit 1

	) || exit 1
	fi

	cd ${TMP_SRC_FOLDER}

	delete_src_dir

	echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
) || exit 1
fi

exit 0

