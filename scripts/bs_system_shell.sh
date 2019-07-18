#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# System shell and tools
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "*********************************"
echo "*   System shell and tools...   *"
echo "*********************************"

####################################################################
# Busybox
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUSYBOX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} busybox
		cd busybox || exit 1

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  defconfig || exit 1
		#make ${NBCORE}  ARCH=${KERNEL_ARCH}  CROSS_COMPILE=${TGT_MACH}-  menuconfig || exit 1

		if [ -f ${TARGET_CONFIG}/busybox_config ]
		then
		(
			echo Busybox target config available...
			# Use the target config
			cp ${TARGET_CONFIG}/busybox_config .config || exit 1
		)
		fi

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  install CONFIG_PREFIX=${TARGET_ROOTFS} || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Util Linux
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_UTILLINUX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD}
		mkdir util-linux
		cd util-linux || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						--disable-all-programs \
						--enable-mount \
						--enable-libmount \
						--enable-libblkid \
						--with-bashcompletiondir=${TARGET_ROOTFS}/usr/share/bash-completion/completions/ \
						--disable-makeinstall-chown \
						--disable-makeinstall-setuid \
						|| exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
