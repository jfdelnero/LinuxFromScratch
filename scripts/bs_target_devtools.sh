#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2019 Jean-François DEL NERO
#
# Target compiler
# Binutils + GCC + GCC Libs
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "******************"
echo "*   Target GCC   *"
echo "******************"

####################################################################
# Binutils build
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "**************************"
		echo "*   Target Binutils...   *"
		echo "**************************"

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv binutils_target
		cd binutils_target || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make all install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Bootstrap GCC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_TARGET_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "*********************"
		echo "*   Target GCC...   *"
		echo "*********************"

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_GMP##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv target_gcc || exit 1
		cd target_gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH          \
				--enable-languages=c,c++   \
				--disable-multilib         \
				--with-sysroot=${TARGET_ROOTFS} \
				--with-native-system-header-dir=/include \
				--enable-languages=c,c++ \
				${GCC_ADD_CONF} || exit 1

		# To force the fixed limits.h generation...
		# echo > ${TARGET_ROOTFS}/include/limits.h
		# ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make ${NBCORE} all-gcc || exit 1
		make ${NBCORE} install-gcc|| exit 1

		# rm ${TARGET_ROOTFS}/sys-include

		# Install the GCC libraries
		cp  -aR  ${TARGET_CROSS_TOOLS}/lib/gcc/${TGT_MACH} ${TARGET_ROOTFS}/usr/lib/gcc/

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE

	) || exit 1
	fi

) || exit 1
fi

