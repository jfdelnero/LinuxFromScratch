#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Debug & Devs tools
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "********************"
echo "*Debug & Devs tools*"
echo "********************"

####################################################################
# GDB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GDB:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		#fake makeinfo...
		echo '#!/bin/sh'                          >makeinfo
		echo 'echo "makeinfo (GNU texinfo) 5.2"' >>makeinfo
		chmod a+x makeinfo


		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir gdb
		cd gdb || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				MAKEINFO="${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/makeinfo" \
				|| exit 1
		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# STRACE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_STRACE:-"UNDEF"}
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

		cd ${TMP_BUILD_FOLDER}  || exit 1
		mkdir strace
		cd strace || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--enable-mpers=check \
				CFLAGS=-DIOV_MAX=1024 \
				--target=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# FTRACE (Linux kernel function trace utility)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FTRACE:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		export CROSS_COMPILE=${TGT_MACH}-
		export DESTDIR=${TARGET_ROOTFS}
		export prefix=/usr

		make ${MAKE_FLAGS} ${NBCORE} trace-cmd || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LTRACE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LTRACE:-"UNDEF"}
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

		cd ${TMP_BUILD_FOLDER}  || exit 1
		mkdir ltrace
		cd ltrace || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				CFLAGS=-DIOV_MAX=1024 \
				--target=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# VALGRIND
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_VALGRIND:-"UNDEF"}
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

		cd ${TMP_BUILD_FOLDER}  || exit 1
		mkdir valgrind
		cd valgrind || exit 1

		# ArmV6 support.
		sed -i 's/armv7\*)/armv[67]\*)/g' ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

