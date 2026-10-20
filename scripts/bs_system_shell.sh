#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# System shell and tools
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "*********************************"
echo "*   System shell and tools...   *"
echo "*********************************"

####################################################################
# Bash
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BASH:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# AWK
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GAWK:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# GREP
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GREP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SED
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SED:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# diff utils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_DIFFUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		autoconf

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						gl_cv_func_strcasecmp_works=y \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# find utils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FINDUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# CoreUtils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_COREUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		cd ${TMP_ARCHIVE_FOLDER} || exit 1

		./configure \
						--build="${BUILDMACH}" \
						--prefix="${TARGET_ROOTFS}" \
						--disable-doc \
						--host=$TGT_MACH \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

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
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} busybox
		cd busybox || exit 1

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  defconfig || exit 1
		#make ${MAKE_FLAGS} ${NBCORE}  ARCH=${KERNEL_ARCH}  CROSS_COMPILE=${TGT_MACH}-  menuconfig || exit 1

		if [ -f ${TARGET_CONFIG}/busybox_config ]
		then
		(
			echo Busybox target config available...
			# Use the target config
			cp ${TARGET_CONFIG}/busybox_config .config || exit 1
		)
		fi

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}-  install CONFIG_PREFIX=${TARGET_ROOTFS} || exit 1

		delete_src_dir

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir util-linux
		cd util-linux || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
						--prefix="${TARGET_ROOTFS}" \
						--host=$TGT_MACH \
						--disable-all-programs \
						--enable-mount \
						--enable-libmount \
						--enable-libblkid \
						--disable-liblastlog2 \
						--with-bashcompletiondir=${TARGET_ROOTFS}/usr/share/bash-completion/completions/ \
						--disable-makeinstall-chown \
						--disable-makeinstall-setuid \
						|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
