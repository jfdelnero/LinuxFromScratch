#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Cross compiler + System base
# GCC + GCC Libs + GLIBC + Kernel
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

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

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv binutils
		cd binutils || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make all install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Kernel headers generation
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KERNEL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************************"
		echo "*   Kernel Header...   *"
		echo "************************"

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} linux-kernel  || exit 1
		cd linux-kernel                        || exit 1

		if [ -f ${TARGET_CONFIG}/kernel_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patchs or anything else
			source ${TARGET_CONFIG}/kernel_pre_process.sh || exit 1
		)
		fi

		# Don't let the Linux kernel build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		unset PKG_CONFIG_LIBDIR

		cd ${TARGET_SOURCES}/linux-kernel || exit 1

		make ${NBCORE} ARCH=${KERNEL_ARCH}  mrproper || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH}  distclean || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH}  clean || exit 1

		# Generate the default config if needed.
		TMP_VAR=${KERNEL_DEFCONF:-"UNDEF"}
		TMP_VAR="${TMP_VAR##*/}"
		if [ "$TMP_VAR" != "UNDEF" ]
		then
		(
			make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- $TMP_VAR
		)
		fi

		# use a predefined config if present.
		if [ -f ${TARGET_CONFIG}/kernel_config ]
		then
		(
			cp ${TARGET_CONFIG}/kernel_config .config || exit 1
		)
		fi

		make ${NBCORE} ARCH=${KERNEL_ARCH}  oldconfig || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH}  headers_check || exit 1
		make ${NBCORE} ARCH=${KERNEL_ARCH}  INSTALL_HDR_PATH="${TARGET_ROOTFS}" headers_install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}   || exit 1

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

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv gcc || exit 1
		cd gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--target=$TGT_MACH          \
				--enable-languages=c,c++   \
				--disable-multilib         \
				--with-sysroot=${TARGET_ROOTFS} \
				--with-native-system-header-dir=/include \
				--enable-languages=c,c++ \
				${GCC_ADD_CONF} || exit 1

		# To force the fixed limits.h generation...
		echo > ${TARGET_ROOTFS}/include/limits.h
		ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make ${NBCORE} all-gcc || exit 1
		make ${NBCORE} install-gcc|| exit 1

		rm ${TARGET_ROOTFS}/sys-include

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv glibc || exit 1
		cd glibc || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="/" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-headers="${TARGET_ROOTFS}/include" \
				--disable-multilib \
				libc_cv_forced_unwind=yes \
				libc_cv_c_cleanup=yes || exit 1

		make ${NBCORE} install_root=${TARGET_ROOTFS} install-bootstrap-headers=yes install-headers  || exit 1
		make ${NBCORE} install_root=${TARGET_ROOTFS} csu/subdir_lib                                 || exit 1
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

		cd  ${TARGET_BUILD}/gcc || exit 1

		make ${NBCORE} all-target-libgcc || exit 1
		make ${NBCORE} install-target-libgcc || exit 1

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

		cd  ${TARGET_BUILD}/glibc || exit 1

		make ${NBCORE} install_root=${TARGET_ROOTFS}           || exit 1
		make ${NBCORE} install_root=${TARGET_ROOTFS} install   || exit 1

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

		cd  ${TARGET_BUILD}/gcc || exit 1

		make ${NBCORE} all   || exit 1
		make ${NBCORE} install   || exit 1

		#FIXME ! C++ libs not in the root fs ?
		cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib64/*   ${TARGET_ROOTFS}/lib
		cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib/*   ${TARGET_ROOTFS}/lib

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_LIBCPP_DONE

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
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libtirpc
		cd libtirpc || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--disable-gssapi \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

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
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir libnsl
		cd libnsl || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv libelf || exit 1
		cd libelf || exit 1

		export CC=${TGT_MACH}-gcc

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--target=$TGT_MACH \
				--enable-compat || exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

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
		cd ${TARGET_SOURCES}/linux-kernel || exit 1

		if [ -f ${TARGET_CONFIG}/kernel_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patchs or anything else
			source ${TARGET_CONFIG}/kernel_pre_process.sh || exit 1
		)
		fi

		#make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- menuconfig

		# Don't let the Linux kernel build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		unset PKG_CONFIG_LIBDIR

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- clean || exit 1

		# use a predefined config if present.
		#if [ -f ${TARGET_CONFIG}/kernel_config ]
		#then
		#(
		#	cp ${TARGET_CONFIG}/kernel_config .config || exit 1
		#)
		#fi

		make ${NBCORE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- oldconfig || exit 1

		make ${NBCORE} ${KERNEL_IMAGE_TYPE} ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1

		make ${NBCORE} modules              ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1

		TMP_VAR=${KERNEL_DTBS:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ${NBCORE} dtbs             ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1
		)
		fi

		make ${NBCORE} modules_install      ARCH=${KERNEL_ARCH} INSTALL_MOD_PATH=${TARGET_ROOTFS}  || exit 1

		TMP_VAR=${KERNEL_FIRMWARES:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ${NBCORE} firmwares_install   ARCH=${KERNEL_ARCH} INSTALL_MOD_PATH=${TARGET_ROOTFS}  || exit 1
		)
		fi

		TMP_VAR=${KERNEL_BOOTINSTALL:-"UNDEF"}
		if [ "$TMP_VAR" = "YES" ]
		then
		(
			make ARCH=${KERNEL_ARCH} INSTALL_PATH=${TARGET_ROOTFS}/boot install  || exit 1
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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}

		# aarch64 support...
		sed -i s#be64#aarch64#g config-aux/config.sub || exit 1

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv libmtdev || exit 1
		cd libmtdev || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH || exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv libevdev || exit 1
		cd libevdev || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH || exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--target=$TGT_MACH || exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install-lib install-dev || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

#		export DESTDIR=${TARGET_ROOTFS}
		export PKGCONFIGDIR=/lib/pkgconfig
		export lib=lib

		make prefix="${TARGET_ROOTFS}" BUILD_CC=gcc CC=${TGT_MACH}-gcc AR=${TGT_MACH}-ar RANLIB=${TGT_MACH}-ranlib || exit 1

		make install prefix="${TARGET_ROOTFS}" BUILD_CC=gcc  CC=${TGT_MACH}-gcc AR=${TGT_MACH}-ar RANLIB=${TGT_MACH}-ranlib

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
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir expat
		cd expat || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--without-docbook \
				|| exit 1

		make ${NBCORE} all     || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv dbus || exit 1
		cd dbus || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-xml-docs \
				--disable-doxygen-docs \
				--disable-ducktype-docs \
				|| exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		mkdir ${TARGET_ROOTFS}/usr/share
		mkdir ${TARGET_ROOTFS}/usr/share/bash-completion
		mkdir ${TARGET_ROOTFS}/usr/share/bash-completion/completions

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv util-linux || exit 1
		cd util-linux || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
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

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv eudev || exit 1
		cd eudev || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix=${TARGET_ROOTFS} \
				--host=$TGT_MACH \
				|| exit 1

		make ${NBCORE} || exit 1
		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv libpam || exit 1
		cd libpam || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-nis \
				|| exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

		cp -a ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/libpam/include/ ${TARGET_ROOTFS} || exit 1
		cp -a ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/libpamc/include/ ${TARGET_ROOTFS} || exit 1
		cp -a ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/libpam_misc/include/ ${TARGET_ROOTFS} || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv systemd || exit 1
		cd systemd || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
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

		make ${NBCORE} install || exit 1

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

		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir -pv libinput || exit 1
		cd libinput || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				--disable-documentation --disable-debug-gui --disable-tests --disable-libwacom || exit 1

		make ${NBCORE}  || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi
