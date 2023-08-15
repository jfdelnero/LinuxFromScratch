#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Target compiler
# Binutils + GCC + GCC Libs
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
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

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		unpack ${CUR_PACKAGE} "target_devtools"

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_target
		cd binutils_target || exit 1

		${TMP_SRC_FOLDER}/target_devtools/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

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

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		unpack ${CUR_PACKAGE} "target_devtools"

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=target_devtools/$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/target_devtools/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_GMP##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv target_gcc || exit 1
		cd target_gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH          \
				--disable-multilib         \
				--with-sysroot=${TARGET_ROOTFS} \
				--with-native-system-header-dir=/include \
				--with-gmp-lib=${TARGET_ROOTFS}/lib \
				--with-gmp-include=${TARGET_ROOTFS}/include \
				--enable-languages=c,c++ \
				${GCC_ADD_CONF} || exit 1

		# To force the fixed limits.h generation...
		# echo > ${TARGET_ROOTFS}/include/limits.h
		# ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		# rm ${TARGET_ROOTFS}/sys-include

		# Install the GCC libraries
		cp  -aR  ${TARGET_CROSS_TOOLS}/lib/gcc/${TGT_MACH} ${TARGET_ROOTFS}/usr/lib/gcc/

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Target Binutils cross-compiler
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_CROSS_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE ]
	then
	(
		echo "*****************************************"
		echo "*   Target Binutils cross-compiler...   *"
		echo "****************************************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools/crosscompiler
		unpack ${CUR_PACKAGE} "target_devtools/crosscompiler"

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_cross_target
		cd binutils_cross_target || exit 1

		${TMP_SRC_FOLDER}/target_devtools/crosscompiler/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$CROSS_TGT_MACH \
				--disable-werror \
				--disable-interwork \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Target GCC cross-compiler
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_TARGET_CROSS_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE ]
	then
	(
		echo "***********************************"
		echo "*   Target GCC cross-compiler...  *"
		echo "***********************************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools/crosscompiler
		unpack ${CUR_PACKAGE} "target_devtools/crosscompiler"

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=target_devtools/crosscompiler/$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/target_devtools/crosscompiler/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_GMP##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv target_cross_gcc || exit 1
		cd target_cross_gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH                \
				--target=$CROSS_TGT_MACH        \
				--disable-libada                \
				--disable-libsanitizer          \
				--disable-multilib              \
				--disable-bootstrap             \
				--disable-libssp                \
				--disable-libgomp               \
				--disable-libmudflap            \
				--disable-multilib              \
				--disable-libphobos             \
				--disable-decimal-float         \
				--disable-libffi                \
				--disable-libmudflap            \
				--disable-libquadmath           \
				--disable-libquadmath-support   \
				--disable-libssp                \
				--disable-libstdcxx-pch         \
				--disable-nls                   \
				--disable-shared                \
				--disable-threads               \
				--disable-tls                   \
				--disable-werror                \
				--disable-interwork             \
				--disable-libvtv                \
				--disable-decimal-float         \
				--disable-fixed-point           \
				--with-gnu-as                   \
				--with-gnu-ld                   \
				--with-cpu=$CROSS_TGT_CPU       \
				--with-mode=$CROSS_TGT_CPUMODE  \
				--without-headers               \
				--enable-target-optspace        \
				--with-float=soft               \
				--enable-languages=c    || exit 1

		# dumpspecs bypass... create a dummy cross compiler:
		if [ ! -f ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc ];
		then
			echo > ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc
			chmod +x ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc

			make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
			make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

			rm ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc
		else

			make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
			make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		fi

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Make
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_MAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "**********************"
		echo "*   Target Make...   *"
		echo "**********************"

		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv make_target
		cd make_target || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE
	) || exit 1
	fi

) || exit 1
fi

