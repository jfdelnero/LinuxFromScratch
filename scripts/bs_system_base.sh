#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Cross compiler + System base
# GCC + GCC Libs + GLIBC + Kernel
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "************************************************"
echo "*   Cross Compiler & System base building...   *"
echo "************************************************"

####################################################################
# Binutils build
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*******************"
		echo "*   Binutils...   *"
		echo "*******************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils
		cd binutils || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-doc \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
	) || exit 1
	fi

) || exit 1
fi

CROSSCOMPILERONLY_TMP=${CROSSCOMPILERONLY:-"UNDEF"}
CROSSCOMPILERONLY_TMP="${CROSSCOMPILERONLY_TMP##*/}"

####################################################################
# Kernel headers generation
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KERNEL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ] && [ "$CROSSCOMPILERONLY_TMP" != "1" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************************"
		echo "*   Kernel Header...   *"
		echo "************************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} linux-kernel  || exit 1
		cd linux-kernel                        || exit 1

		if [ -f ${TARGET_CONFIG}/kernel_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patches or anything else
			source ${TARGET_CONFIG}/kernel_pre_process.sh || exit 1
		)
		fi

		# Don't let the Linux kernel build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		unset PKG_CONFIG_LIBDIR

		cd ${TMP_SRC_FOLDER}/linux-kernel || exit 1

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  mrproper || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  distclean || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  clean || exit 1

		# Generate the default config if needed.
		TMP_VAR=${KERNEL_DEFCONF:-"UNDEF"}
		TMP_VAR="${TMP_VAR##*/}"
		if [ "$TMP_VAR" != "UNDEF" ]
		then
		(
			make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- $TMP_VAR
		)
		fi

		# use a predefined config if present.
		if [ -f ${TARGET_CONFIG}/kernel_config ]
		then
		(
			cp ${TARGET_CONFIG}/kernel_config .config || exit 1
		)
		fi

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  olddefconfig || exit 1
		#make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  headers_check || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  INSTALL_HDR_PATH="${TARGET_ROOTFS}" headers_install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Bootstrap GCC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "**************"
		echo "*   GCC...   *"
		echo "**************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_GCC_GMP##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gcc || exit 1
		cd gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		if [ "$CROSSCOMPILERONLY_TMP" = "1" ];
		then
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--target=$TGT_MACH          \
				--enable-languages=c,c++   \
				--disable-multilib         \
				${GCC_ADD_CONF} || exit 1
		else
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--target=$TGT_MACH          \
				--enable-languages=c,c++   \
				--disable-multilib         \
				--with-sysroot=${TARGET_ROOTFS} \
				--with-native-system-header-dir=/include \
				${GCC_ADD_CONF} || exit 1
		fi

		# To force the fixed limits.h generation...
		echo > ${TARGET_ROOTFS}/include/limits.h
		ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		rm ${TARGET_ROOTFS}/sys-include

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Exit here in simple cross compiler mode
####################################################################
if [ "$CROSSCOMPILERONLY_TMP" = "1" ];
then
	exit 0
fi

####################################################################
# Glibc headers
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GLIBC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************************"
		echo "*   GlibC Headers...   *"
		echo "************************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv glibc || exit 1
		cd glibc || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="/" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-headers="${TARGET_ROOTFS}/include" \
				--disable-multilib \
				libc_cv_forced_unwind=yes \
				libc_cv_c_cleanup=yes || exit 1

		make ${MAKE_FLAGS} ${NBCORE} install_root=${TARGET_ROOTFS} install-bootstrap-headers=yes install-headers  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install_root=${TARGET_ROOTFS} csu/subdir_lib                                 || exit 1
		install csu/crt1.o csu/crti.o csu/crtn.o "${TARGET_ROOTFS}/lib"                             || exit 1

		${TGT_MACH}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${TARGET_ROOTFS}/lib/libc.so"
		touch ${TARGET_ROOTFS}/include/gnu/stubs.h

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Gcc lib
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_LIB_DONE ]
	then
	(
		echo "********************"
		echo "*   GCC Libs ...   *"
		echo "********************"

		create_build_dir

		cd  ${TMP_BUILD_FOLDER}/gcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all-target-libgcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-target-libgcc || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_LIB_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Standard C libraries
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_LIBC_DONE ]
	then
	(
		echo "*************"
		echo "*   GlibC   *"
		echo "*************"

		create_build_dir

		cd  ${TMP_BUILD_FOLDER}/glibc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} install_root=${TARGET_ROOTFS}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install_root=${TARGET_ROOTFS} install   || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_LIBC_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Standard GCC C++ libraries
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_LIBCPP_DONE ]
	then
	(
		echo "************************"
		echo "*   GCC C++ Libs ...   *"
		echo "************************"

		create_build_dir

		cd  ${TMP_BUILD_FOLDER}/gcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		#FIXME ! C++ libs not in the root fs ?
		cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib64/*   ${TARGET_ROOTFS}/lib
		cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib/*   ${TARGET_ROOTFS}/lib

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_LIBCPP_DONE

		delete_build_dir
		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# ZLIB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_ZLIB:-"UNDEF"}
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

		cd ${TMP_BUILD_FOLDER}
		mkdir zlib
		cd zlib || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
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
# LIBTIRPC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBTIRPC:-"UNDEF"}
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
		mkdir libtirpc
		cd libtirpc || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--disable-gssapi \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH || exit 1

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
# LIBNSL
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBNSL:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		autoupdate
		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libnsl
		cd libnsl || exit 1
		
		export PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--with-sysroot="${TARGET_ROOTFS}/lib" \
					--prefix="${TARGET_ROOTFS}" \
					PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig \
					--host=$TGT_MACH || exit 1

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
# libelf
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBELF:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "**************"
		echo "*   libelf   *"
		echo "**************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libelf || exit 1
		cd libelf || exit 1

		export CC=${TGT_MACH}-gcc

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--target=$TGT_MACH \
				--enable-elf64 \
				--enable-compat || exit 1

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
# elfutils
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_ELFUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "**************"
		echo "*  elfutils   *"
		echo "**************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv elfutils || exit 1
		cd elfutils || exit 1

		export CC=${TGT_MACH}-gcc

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" -host=$TGT_MACH \
				--disable-libdebuginfod --disable-debuginfod || exit 1

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
# Build kernel
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KERNEL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_KERNEL_DONE ]
	then
	(

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} linux-kernel  || exit 1
		cd linux-kernel                        || exit 1

		if [ -f ${TARGET_CONFIG}/kernel_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patches or anything else
			source ${TARGET_CONFIG}/kernel_pre_process.sh || exit 1
		)
		fi

		# Don't let the Linux kernel build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		unset PKG_CONFIG_LIBDIR

		cd ${TMP_SRC_FOLDER}/linux-kernel || exit 1

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  mrproper || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  distclean || exit 1
		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH}  clean || exit 1

		# Generate the default config if needed.
		TMP_VAR=${KERNEL_DEFCONF:-"UNDEF"}
		TMP_VAR="${TMP_VAR##*/}"
		if [ "$TMP_VAR" != "UNDEF" ]
		then
		(
			make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- $TMP_VAR
		)
		fi

		# use a predefined config if present.
		if [ -f ${TARGET_CONFIG}/kernel_config ]
		then
		(
			cp ${TARGET_CONFIG}/kernel_config .config || exit 1
		)
		fi

		#make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- menuconfig

		# Don't let the Linux kernel build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		unset PKG_CONFIG_LIBDIR

		#Tell where is the host openssl ... TODO : Check if this doesn't affect the cross compiler too...
		export LIBRARY_PATH=${TARGET_CROSS_TOOLS}/lib/:${TARGET_CROSS_TOOLS}/lib64/
		export C_INCLUDE_PATH=${TARGET_CROSS_TOOLS}/include

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- clean || exit 1

		# use a predefined config if present.
		#if [ -f ${TARGET_CONFIG}/kernel_config ]
		#then
		#(
		#	cp ${TARGET_CONFIG}/kernel_config .config || exit 1
		#)
		#fi

		make ${MAKE_FLAGS} ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- olddefconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} ${KERNEL_IMAGE_TYPE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1

		make ${MAKE_FLAGS} ${NBCORE} modules              ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1

		TMP_VAR=${KERNEL_DTBS:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ${MAKE_FLAGS} ${NBCORE} dtbs             ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1
		)
		fi

		make ${MAKE_FLAGS} ${NBCORE} modules_install      ARCH=${KERNEL_ARCH} INSTALL_MOD_PATH=${TARGET_ROOTFS}  || exit 1

		TMP_VAR=${KERNEL_FIRMWARES:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ${MAKE_FLAGS} ${NBCORE} firmwares_install   ARCH=${KERNEL_ARCH} INSTALL_MOD_PATH=${TARGET_ROOTFS}  || exit 1
		)
		fi

		TMP_VAR=${KERNEL_BOOTINSTALL:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ${MAKE_FLAGS} ARCH=${KERNEL_ARCH} INSTALL_PATH=${TARGET_ROOTFS}/boot install  || exit 1
		)
		fi

		if [ -f ${TARGET_CONFIG}/kernel_post_process.sh ]
		then
		(
			echo Post process script available... executing it...
			#To prepare the kernel image or anything else
			${TARGET_CONFIG}/kernel_post_process.sh || exit 1
		)
		fi

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_KERNEL_DONE

		delete_build_dir
		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# libmtdev
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_MTDEV:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "********************"
		echo "*   lib mtdev...   *"
		echo "********************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}

		# aarch64 support...
		sed -i s#mips64vr5900el#aarch64#g config-aux/config.sub || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libmtdev || exit 1
		cd libmtdev || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
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
# libevdev
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBEVDEV:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "****************"
		echo "*   libevdev   *"
		echo "****************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libevdev || exit 1
		cd libevdev || exit 1

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
# attr
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_ATTR:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************"
		echo "*   attr   *"
		echo "************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--target=$TGT_MACH || exit 1

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
# libcap
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBCAP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************"
		echo "*  libcap  *"
		echo "************"

		export CC=${TGT_MACH}-gcc
		export AR=${TGT_MACH}-ar
		export RANLIB=${TGT_MACH}-ranlib

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

#		export DESTDIR=${TARGET_ROOTFS}
		export PKGCONFIGDIR=/lib/pkgconfig
		export lib=lib

		make ${MAKE_FLAGS} prefix="${TARGET_ROOTFS}" BUILD_CC=gcc CROSS_COMPILE=${TGT_MACH}- || exit 1

		make ${MAKE_FLAGS} install prefix="${TARGET_ROOTFS}" BUILD_CC=gcc CROSS_COMPILE=${TGT_MACH}- || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# XML EXPAT
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_XMLEXPAT:-"UNDEF"}
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
		mkdir expat
		cd expat || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--without-docbook \
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
# dbus
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_DBUS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "********"
		echo "* dbus *"
		echo "********"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv dbus || exit 1
		cd dbus || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-xml-docs \
				--disable-doxygen-docs \
				--disable-ducktype-docs \
				|| exit 1

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
				--without-systemdsystemunitdir \
				--disable-makeinstall-chown \
				--disable-makeinstall-setuid \
				--enable-nologin     \
				--without-python     \
				--disable-login      \
				--disable-su         \
				--disable-schedutils \
				--without-ncurses    \
				--without-selinux    \
				--without-tinfo      \
				--disable-nls        \
				--enable-libuuid     \
				--enable-libblkid    \
				--enable-libmount    \
				--disable-mount      \
				--disable-losetup    \
				--enable-fsck        \
				--disable-partx      \
				--enable-uuidd       \
				--disable-mountpoint \
				--disable-fallocate  \
				--disable-unshare    \
				--disable-arch       \
				--disable-ddate      \
				--disable-agetty     \
				--disable-cramfs     \
				--disable-switch_root\
				--disable-pivot_root \
				--disable-elvtune    \
				--disable-kill       \
				--disable-last       \
				--disable-line       \
				--disable-mesg       \
				--disable-raw        \
				--disable-rename     \
				--disable-reset      \
				--disable-login-utils\
				--disable-schedutils \
				--disable-wall       \
				--disable-write      \
				--disable-chsh-only-listed \
				--disable-eject      \
				--with-bashcompletiondir=${TARGET_ROOTFS}/usr/share/bash-completion/completions/  || exit 1

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
# EUDEV
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_EUDEV:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*************"
		echo "*  EUDEV    *"
		echo "*************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv eudev || exit 1
		cd eudev || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix=${TARGET_ROOTFS} \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# libpam
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBPAM:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "**********"
		echo "* libpam *"
		echo "**********"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		#autoupdate
		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libpam || exit 1
		cd libpam || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-nis \
				--disable-doc \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		cp -a ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/libpam/include/ ${TARGET_ROOTFS} || exit 1
		cp -a ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/libpamc/include/ ${TARGET_ROOTFS} || exit 1
		cp -a ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/libpam_misc/include/ ${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# SystemD
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_SYSTEMD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*************"
		echo "*  SystemD  *"
		echo "*************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv systemd || exit 1
		cd systemd || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH            \
				--disable-python-devel      \
				--enable-dbus               \
				--disable-utmp              \
				--disable-compat-libs       \
				--disable-coverage          \
				--disable-kmod              \
				--disable-xkbcommon         \
				--enable-blkid              \
				--disable-seccomp           \
				--disable-ima               \
				--disable-selinux           \
				--disable-apparmor          \
				--disable-xz                \
				--disable-zlib              \
				--enable-bzip2              \
				--disable-lz4               \
				--enable-pam                \
				--disable-acl               \
				--disable-smack             \
				--disable-gcrypt            \
				--disable-audit             \
				--disable-elfutils          \
				--disable-libcryptsetup     \
				--disable-qrencode          \
				--disable-microhttpd        \
				--disable-gnutls            \
				--disable-libcurl           \
				--disable-libidn            \
				--disable-libiptc           \
				--disable-binfmt            \
				--disable-vconsole          \
				--disable-bootchart         \
				--disable-quotacheck        \
				--disable-tmpfiles          \
				--disable-sysusers          \
				--disable-firstboot         \
				--disable-randomseed        \
				--disable-backlight         \
				--disable-rfkill            \
				--enable-logind             \
				--disable-machined          \
				--disable-importd           \
				--disable-hostnamed         \
				--disable-timedated         \
				--disable-timesyncd         \
				--disable-localed           \
				--disable-coredump          \
				--disable-polkit            \
				--disable-resolved          \
				--disable-networkd          \
				--disable-efi               \
				--disable-gnuefi            \
				--disable-terminal          \
				--disable-kdbus             \
				--disable-myhostname        \
				--disable-hwdb              \
				--disable-manpages          \
				--disable-hibernate         \
				--disable-ldconfig          \
				--enable-split-usr          \
				--disable-tests             \
				--without-python            \
				--with-bashcompletiondir="${TARGET_ROOTFS}/share/bash-completions/completions" \
				--with-rootprefix="${TARGET_ROOTFS}" \
				--with-sysvinit-path="${TARGET_ROOTFS}"/etc/init.d \
				--with-sysvrcnd-path="${TARGET_ROOTFS}"/etc \
				PKG_CONFIG_PATH=${TARGET_ROOTFS}/lib/pkgconfig \
				ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes || exit 1

		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# libinput
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBINPUT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************"
		echo "* libinput *"
		echo "************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libinput || exit 1
		cd libinput || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-documentation --disable-debug-gui --disable-tests --disable-libwacom || exit 1

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
# haveged
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_HAVEGED:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*************"
		echo "*  haveged  *"
		echo "*************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv haveged || exit 1
		cd haveged || exit 1

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
