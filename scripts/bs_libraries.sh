#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2024 Jean-François DEL NERO
#
# system librairies
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "****************"
echo "*  Librairies  *"
echo "****************"

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

		cd ${TMP_BUILD_FOLDER} || exit 1
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
# LZ4
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LZ4:-"UNDEF"}
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

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

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
				--host=$TGT_MACH \
				--without-docbook \
				CC=${TGT_MACH}-gcc || exit 1

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
# NCURSES
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBNCURSES:-"UNDEF"}
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
		mkdir ncurses
		cd ncurses || exit 1
		# wide version
		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-stripping STRIPPROG=${TGT_MACH}-strip \
				--with-shared \
				--enable-widec \
				--without-normal \
				--with-cxx-shared \
				--without-debug \
				--without-ada \
				--without-manpages \
				--with-curses-h \
				--enable-pc-files \
				--with-termlib \
				--with-versioned-syms \
				--with-pkg-config-libdir=${TARGET_ROOTFS}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		make ${MAKE_FLAGS} ${NBCORE} clean   || exit 1

		# standard version
		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-stripping STRIPPROG=${TGT_MACH}-strip \
				--with-shared \
				--without-normal \
				--with-cxx-shared \
				--without-debug \
				--without-ada \
				--without-manpages \
				--with-curses-h \
				--enable-pc-files \
				--with-termlib \
				--with-versioned-syms \
				--with-pkg-config-libdir=${TARGET_ROOTFS}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		make ${MAKE_FLAGS} ${NBCORE} clean   || exit 1

		# rebuild standard version without termlib to fix the missing "cursrc" symbol issue with nano...

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH CC=${TGT_MACH}-gcc \
				--disable-stripping STRIPPROG=${TGT_MACH}-strip \
				--with-shared \
				--without-normal \
				--with-cxx-shared \
				--without-debug \
				--without-manpages \
				--without-ada \
				--with-curses-h \
				--enable-pc-files \
				--with-versioned-syms \
				--with-pkg-config-libdir=${TARGET_ROOTFS}/lib/pkgconfig || exit 1

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
# LIBXML
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBXML2:-"UNDEF"}
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
		mkdir libxml2
		cd libxml2 || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					CC=${TGT_MACH}-gcc \
					--without-python || exit 1

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
# LIBYAML
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBYAML:-"UNDEF"}
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
		mkdir libyaml
		cd libyaml || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${TARGET_ROOTFS}" \
			--host=$TGT_MACH \
			CC=${TGT_MACH}-gcc \
			--without-python || exit 1

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
# LIBFFI
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBFFI:-"UNDEF"}
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

		if [ -f ${TARGET_CONFIG}/patches/ffi.patch ]
		then
		(
			cd src/aarch64 || exit 1
			patch -Zf < ${TARGET_CONFIG}/patches/ffi.patch  || exit 1
		) || exit 1
		fi

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libffi
		cd libffi || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--host=$TGT_MACH \
					--prefix="${TARGET_ROOTFS}" || exit 1

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
# LIBGDM
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBGDM:-"UNDEF"}
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
		mkdir libgdm
		cd libgdm || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--host=$TGT_MACH \
					--prefix="${TARGET_ROOTFS}" \
					--disable-static \
					--enable-libgdbm-compat \
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
# LIBGMP
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBGMP:-"UNDEF"}
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
		mkdir libgmp
		cd libgmp || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# MPFR
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_MPFR:-"UNDEF"}
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
		mkdir mpfr
		cd mpfr || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# MPC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_MPC:-"UNDEF"}
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
		mkdir mpc
		cd mpc || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# NETTLE
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_NETTLE:-"UNDEF"}
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
		mkdir libnettle
		cd libnettle || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# GnuTLS
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GNUTLS:-"UNDEF"}
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
		mkdir libgnutls
		cd libgnutls || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					--with-included-libtasn1 \
					--with-included-unistring \
					--without-p11-kit || exit 1

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
# OpenSSL
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_OPENSSL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/Configure \
				${SSL_ARCH} shared --prefix="${TARGET_ROOTFS}" || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install_sw || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBXCRYPT
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBXCRYPT:-"UNDEF"}
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
		mkdir libxcrypt
		cd libxcrypt || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# gpg-error
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GPGERROR:-"UNDEF"}
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
		mkdir libgpgerror
		cd libgpgerror || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--enable-install-gpg-error-config \
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
# libassuan
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_LIBASSUAN:-"UNDEF"}
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
		mkdir libassuan
		cd libassuan || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_ROOTFS}" \
					--host=$TGT_MACH \
					--with-libgpg-error-prefix="${TARGET_ROOTFS}" || exit 1

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
# gpgme
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GPGME:-"UNDEF"}
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
		mkdir libgpgme
		cd libgpgme || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
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
# LibEvent
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBEVENT:-"UNDEF"}
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
		mkdir libevent
		cd libevent || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--host=$TGT_MACH \
					--prefix="${TARGET_ROOTFS}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

