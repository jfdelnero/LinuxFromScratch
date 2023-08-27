#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Local build tools
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "*******************"
echo "*   Build Tools   *"
echo "*******************"

####################################################################
# texinfo
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_TEXINFO:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "* Local texinfo *"
		echo "*****************"

		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv texinfo_local
		cd texinfo_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Host Binutils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "**********************"
		echo "* Host Binutils...   *"
		echo "**********************"

		create_src_dir
		create_build_dir
		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_local
		cd binutils_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--disable-doc \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Host GCC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
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

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_GMP##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gcc_local || exit 1
		cd gcc_local || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		if [ "$CROSSCOMPILERONLY_TMP" = "1" ];
		then
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--enable-languages=c,c++   \
				--disable-multilib         \
				${GCC_ADD_CONF} || exit 1
		else
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--enable-languages=c,c++   \
				--disable-multilib         \
				${GCC_ADD_CONF} || exit 1
		fi

		make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all-target-libgcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-target-libgcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# texinfo (Rebuild with the new gcc)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_TEXINFO:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_REBUILD_DONE ]
	then
	(
		echo "***************************"
		echo "* Local texinfo (rebuild) *"
		echo "***************************"

		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv texinfo_local
		cd texinfo_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_REBUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Gperf (Re)build
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_GPERF:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "******************"
		echo "*  Local Gperf   *"
		echo "******************"

		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gperf_local
		cd gperf_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# LIBFFI
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBFFI:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libffi_local
		cd libffi_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# XML EXPAT
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_XMLEXPAT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir expat_local
		cd expat_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--without-docbook \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBXML
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBXML2:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libxml2_local
		cd libxml2_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${TARGET_CROSS_TOOLS}" \
					--datarootdir="${TARGET_CROSS_TOOLS}" \
					--exec-prefix="${TARGET_CROSS_TOOLS}" \
					--without-python || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# OpenSSL
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_OPENSSL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/Configure \
				shared --prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install_sw || exit 1
		make ${MAKE_FLAGS} clean

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# CMAKE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_CMAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir cmake_local
		cd cmake_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# MAKE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_MAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir make_local
		cd make_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NCURSES
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBNCURSES:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir ncurses_local
		cd ncurses_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
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
				--with-pkg-config-libdir=${TARGET_CROSS_TOOLS}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		make ${MAKE_FLAGS} ${NBCORE} clean   || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--disable-stripping STRIPPROG=strip \
				--with-shared \
				--without-normal \
				--with-cxx-shared \
				--without-debug \
				--without-manpages \
				--without-ada \
				--with-curses-h \
				--enable-pc-files \
				--with-versioned-syms \
				--with-pkg-config-libdir=${TARGET_CROSS_TOOLS}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# heimdal
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_HEIMDAL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		create_build_dir

		export PKG_CONFIG_PATH=${TARGET_CROSS_TOOLS}/lib/pkgconfig
		export LIBRARY_PATH=${TARGET_CROSS_TOOLS}/lib/

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir heimdal
		cd heimdal || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--disable-shared \
				--enable-static \
				--without-openldap \
				--without-capng \
				--with-db-type-preference= \
				--without-sqlite3 \
				--without-libintl \
				--with-openssl \
				--without-berkeley-db \
				--without-readline \
				--without-libedit \
				--without-hesiod \
				--without-x \
				--disable-mdb-db \
				--disable-ndbm-db \
				--disable-heimdal-documentation || exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		cp ./lib/com_err/compile_et ${TARGET_CROSS_TOOLS}/bin
		cp -a ./lib/com_err/.libs ${TARGET_CROSS_TOOLS}/bin

		ln -sf ${TARGET_CROSS_TOOLS}/libexec/heimdal/asn1_compile	${TARGET_CROSS_TOOLS}/bin/asn1_compile
        #ln -sf ${TARGET_CROSS_TOOLS}/bin/compile_et ${TARGET_CROSS_TOOLS}/libexec/heimdal/compile_et

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PYTHON
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_PYTHON:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir python_local
		cd python_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				--enable-ipv6 \
				--enable-optimizations \
				--enable-shared \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} altinstall DESTDIR=${TARGET_CROSS_TOOLS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# dos2unix
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_DOS2UNIX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_CROSS_TOOLS}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_CROSS_TOOLS} install  || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Bash
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_BASH:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "*   Local bash  *"
		echo "*****************"

		create_src_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv bash_local
		cd bash_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${TARGET_CROSS_TOOLS}" \
				--exec-prefix="${TARGET_CROSS_TOOLS}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Nano
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_NANOEDITOR:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir nano_local
		cd nano_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_CROSS_TOOLS}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Perl
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_PERL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure.gnu \
				--prefix="${TARGET_CROSS_TOOLS}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Perl - Parse-Yapp (Required by Samba...)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_PERLPARSEYAPP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		perl Makefile.PL || exit 1
		make install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Perl - JSON.PM (Required by Samba...)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_PERLJSON:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		perl Makefile.PL || exit 1
		make install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

