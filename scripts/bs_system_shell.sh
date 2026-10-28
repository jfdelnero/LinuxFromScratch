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
# kbd
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KBD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*********"
		echo "*  kbd  *"
		echo "*********"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv kbd || exit 1
		cd kbd || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				CFLAGS="-std=gnu17 -O3" \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# PROCPS
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_PROCPS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************"
		echo "*  procps  *"
		echo "************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		#autoupdate
		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv procps || exit 1
		cd procps || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Util linux
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_UTILLINUX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "****************"
		echo "*  util linux  *"
		echo "****************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		mkdir ${TARGET_ROOTFS}/usr/share
		mkdir ${TARGET_ROOTFS}/usr/share/bash-completion
		mkdir ${TARGET_ROOTFS}/usr/share/bash-completion/completions

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv util-linux || exit 1
		cd util-linux || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=${TGT_MACH}   \
				 || exit 1

		sed "s/install-exec-hook-mount:/install-exec-hook-mount:\ninstall-exec-hook-mount_:/g" -i Makefile
		sed "s/install-exec-hook-wall::/install-exec-hook-wall::\ninstall-exec-hook-wall_::/g" -i Makefile
		sed "s/install-exec-hook:/install-exec-hook:\ninstall-exec-hook_:/g" -i Makefile

		make ${MAKE_FLAGS} ${NBCORE} LIBS="-lncursesw -ltinfo" || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-exec-hook-mount= install-exec-hook-wall= install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

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

		ln -rsv ${TARGET_ROOTFS}/bin/bash ${TARGET_ROOTFS}/bin/sh

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
# OpenRC
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_OPENRC:-"UNDEF"}
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
		mkdir -pv openrc || exit 1
		cd openrc || exit 1

		create_meson_crossfile meson_cross.txt
		meson setup ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} --buildtype=release --cross-file meson_cross.txt || exit 1

		ninja || exit 1
		DESTDIR=${TARGET_ROOTFS} ninja install || exit 1

		cd ${TARGET_ROOTFS}/sbin || exit 1
		ln -s -r ${TARGET_ROOTFS}/sbin/openrc-init ${TARGET_ROOTFS}/sbin/init

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

