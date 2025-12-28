#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Miscellaneous stuffs
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "*********************"
echo "*   Miscellaneous   *"
echo "*********************"

####################################################################
# SDPARM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SDPARM:-"UNDEF"}
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
		mkdir sdparm
		cd sdparm || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# HDIDLE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HDIDLE:-"UNDEF"}
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

		export CROSS=${TGT_MACH}
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}

		sed -i s#-g\ root\ -o\ root##g Makefile || exit 1

		make ${MAKE_FLAGS} ${NBCORE}          || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# GRUB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_GRUB:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
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
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--disable-werror \
				--disable-efiemu \
				|| exit 1

		./autogen.sh ||  exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LILO
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LILO:-"UNDEF"}
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

		if [ -f ${TARGET_CONFIG}/patches/lilo.patch ]
		then
		(
			cd src || exit 1
			patch -Zf < ${TARGET_CONFIG}/patches/lilo.patch  || exit 1
		) || exit 1
		fi

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS}  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# SYSLINUX
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SYSLINUX:-"UNDEF"}
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

		if [ -f ${TARGET_CONFIG}/patches/syslinux.patch ]
		then
		(
			patch -s -p0 < ${TARGET_CONFIG}/patches/syslinux.patch  || exit 1
		) || exit 1
		fi

		make ${MAKE_FLAGS} ${NBCORE} CROSS_COMPILE="${TGT_MACH}-"  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} CROSS_COMPILE="${TGT_MACH}-"  install INSTALLROOT=${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PCI UTILS
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PCIUTILS:-"UNDEF"}
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

		make ${MAKE_FLAGS} ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} HOST=${TGT_MACH}-linux || exit 1
		make ${MAKE_FLAGS} ${NBCORE} CROSS_COMPILE=${TGT_MACH}- PREFIX=${TARGET_ROOTFS} HOST=${TGT_MACH}-linux STRIP="-s --strip-program=${TGT_MACH}-strip"  install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Flashrom
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FLASHROM:-"UNDEF"}
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

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS} ${NBCORE} CONFIG_ENABLE_LIBPCI_PROGRAMMERS=no CONFIG_ENABLE_LIBUSB0_PROGRAMMERS=no CONFIG_ENABLE_LIBUSB1_PROGRAMMERS=no || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# readline
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_READLINE:-"UNDEF"}
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
		mkdir readline
		cd readline || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--build=$MACHTYPE \
					--host=$TGT_MACH \
					--target=$TGT_MACH \
					--with-curses \
					--prefix="${TARGET_ROOTFS}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} SHLIB_LIBS="-lncursesw"         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} SHLIB_LIBS="-lncursesw" install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# XZ
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_XZ:-"UNDEF"}
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
		mkdir xz
		cd xz || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--build=$MACHTYPE \
					--host=$TGT_MACH \
					--target=$TGT_MACH \
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
# BZIP2
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BZIP2:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		sed -i -e 's/CC=gcc/CC\ ?=\ gcc/g' Makefile
		sed -i -e 's/AR=ar/AR\ ?=\ ar/g' Makefile
		sed -i -e 's/RANLIB=ranlib/RANLIB\ ?=\ ranlib/g' Makefile
		sed -i -e 's/CFLAGS=/CFLAGS\ ?=/g' Makefile
		sed -i -e 's/LDFLAGS=/LDFLAGS\ ?=/g' Makefile
		sed -i -e 's/PREFIX=/PREFIX\ ?=/g' Makefile

		sed -i -e 's/CC=gcc/CC\ ?=\ gcc/g' Makefile-libbz2_so
		sed -i -e 's/CFLAGS=/CFLAGS\ ?=/g' Makefile-libbz2_so

		make ${MAKE_FLAGS} -f Makefile-libbz2_so      || exit 1
		make ${MAKE_FLAGS} libbz2.a bzip2 bzip2recover || exit 1

		make ${MAKE_FLAGS} -n install PREFIX="${TARGET_ROOTFS}" || exit 1
		cp -v bzip2-shared ${TARGET_ROOTFS}/bin/bzip2
		cp -av libbz2.so* ${TARGET_ROOTFS}/lib
		ln -sv libbz2.so.1.0 ${TARGET_ROOTFS}/lib/libbz2.so

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PYTHON
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PYTHON:-"UNDEF"}
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

		mkdir python
		cd python || exit 1

		echo ac_cv_file__dev_ptmx=no > ./config.site
		echo ac_cv_file__dev_ptc=no >> ./config.site
		echo ac_cv_buggy_getaddrinfo=no >> ./config.site

		export CONFIG_SITE=config.site

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix= \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--with-build-python="${BUILDTOOLS_HOME}/bin/python3" \
				--enable-ipv6 \
				--enable-shared \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} build_all || exit 1
		make ${MAKE_FLAGS} ${NBCORE} altinstall DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Perl
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PERL:-"UNDEF"}
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

		tar --strip-components=1 -zxf ${COMMON_DOWNLOAD}/${SRC_PACKAGE_PERLCROSS##*/}

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix=/usr \
				--target=$TGT_MACH \
				-Duseshrplib \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBAIO
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBAIO:-"UNDEF"}
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

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS} ${NBCORE} prefix=${TARGET_ROOTFS} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} prefix=${TARGET_ROOTFS} install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBUSB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSB:-"UNDEF"}
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
		mkdir libusb
		cd libusb || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--disable-udev \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# LIBUSB Gadget
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBUSBGADGET:-"UNDEF"}
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
		mkdir libusbgadget
		cd libusbgadget || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# Nano
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_NANOEDITOR:-"UNDEF"}
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
		mkdir nano
		cd nano || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} CFLAGS="-I/${TARGET_ROOTFS}/include/ncurses" CPPFLAGS="-I${TARGET_ROOTFS}/include/ncurses" || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Libcurl
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBCURL:-"UNDEF"}
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
		mkdir libcurl
		cd libcurl || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-ssl \
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
# Uboot
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_UBOOT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "****************"
		echo "*   Uboot...   *"
		echo "****************"

		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		if [ -f ${TARGET_CONFIG}/uboot_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patchs or anything else
			source ${TARGET_CONFIG}/uboot_pre_process.sh || exit 1
		)
		fi

		# Don't let u-boot build system using the cross-compiled libraries
		# (fix issue with ncurses -> ".config" not found error...)
		#unset PKG_CONFIG_LIBDIR

		export CROSS_COMPILE="$TGT_MACH"-

		make ${MAKE_FLAGS} ${NBCORE} mrproper || exit 1
		make ${MAKE_FLAGS} ${NBCORE} distclean || exit 1
		make ${MAKE_FLAGS} ${NBCORE} clean || exit 1

		# Generate the default config if needed.
		TMP_VAR=${UBOOT_DEFCONF:-"UNDEF"}
		TMP_VAR="${TMP_VAR##*/}"
		if [ "$TMP_VAR" != "UNDEF" ]
		then
		(
			make ${MAKE_FLAGS} $TMP_VAR || exit 1
		)
		fi

		# use a predefined config if present.
		if [ -f ${TARGET_CONFIG}/uboot_config ]
		then
		(
			cp ${TARGET_CONFIG}/uboot_config .config || exit 1
		)
		fi

		#make SHELL="/bin/bash -x" || exit 1 # see commands
		make ${MAKE_FLAGS} || exit 1

		if [ -f ${TARGET_CONFIG}/uboot_post_process.sh ]
		then
		(
			echo Post process script available... executing it...
			#To prepare the u-boot image or anything else
			${TARGET_CONFIG}/uboot_post_process.sh || exit 1
		)
		fi

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# e2fsprogs
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_E2FSPROGS:-"UNDEF"}
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
		mkdir e2fsprogs
		cd e2fsprogs || exit 1

		sed -e 's/HAVE_LINUX_FSVERITY_H/HAVE_LINUX_FSVERITY__H__/g'  -i ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				CFLAGS=" -std=gnu17 -O3" \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-crond-dir=no \
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
# exfatprogs
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_EXFATPROGS:-"UNDEF"}
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
		mkdir exfatprogs
		cd exfatprogs || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-crond-dir=no \
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
# FSWEBCAM
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FSWEBCAM:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# DDRESCUE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_DDRESCUE:-"UNDEF"}
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

		export CXX=${TGT_MACH}-g++
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			CXX=${TGT_MACH}-g++ \
			--prefix="${TARGET_ROOTFS}" \
			--build=$MACHTYPE \
			--host=$TGT_MACH \
			--target=$TGT_MACH \
			|| exit 1

			export CXX=${TGT_MACH}-g++
			export CC=${TGT_MACH}-gcc
			export LD=${TGT_MACH}-ld
			export AS=${TGT_MACH}-as
			export AR=${TGT_MACH}-ar

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
# OpenOCD
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_OPENOCD:-"UNDEF"}
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

		if [ -f ${TARGET_CONFIG}/patches/openocd.patch ]
		then
		(
			patch -s -p0 < ${TARGET_CONFIG}/patches/openocd.patch  || exit 1
		) || exit 1
		fi

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir openocd
		cd openocd || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--enable-sysfsgpio \
				--enable-bcm2835gpio \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# USB modeswitch
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_USBMODESWITCH:-"UNDEF"}
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

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# lib fftw
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_FFTW:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--enable-shared \
				--enable-threads \
				--enable-float \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
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
# hackrf
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HACKRF:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/host || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export DESTDIR=${TARGET_ROOTFS}

		cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_SYSTEM_PREFIX_PATH=${TARGET_ROOTFS} -DFFTW_LIBRARIES=${TARGET_ROOTFS}/lib/libfftw3.a .

		make ${MAKE_FLAGS} ${NBCORE} clean DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} || exit 1

		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} install  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
