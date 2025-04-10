#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2024 Jean-François DEL NERO
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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "* Local texinfo *"
		echo "*****************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv texinfo_local
		cd texinfo_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# gnu m4
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_GNU_M4:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "* Local M4      *"
		echo "*****************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gnu_m4_local
		cd gnu_m4_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# libtextstyle
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBTEXTSTYLE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libtextstyle_local
		cd libtextstyle_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE}  install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# gettext
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_GETTEXT:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gettext_local
		cd gettext_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# gawk
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_GAWK:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gawk_local
		cd gawk_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBTIRPC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBTIRPC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libtirpc_local
		cd libtirpc_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--disable-gssapi \
					--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# libtool
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBTOOL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libtool_local
		cd libtool_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# autoconf
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_AUTOCONF:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv autoconf_local
		cd autoconf_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi


####################################################################
# automake
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_AUTOMAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv automake_local
		cd automake_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# bison
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_BISON:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "* Local bison   *"
		echo "*****************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv bison_local
		cd bison_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# help2man
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_HELP2MAN:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "******************"
		echo "* Local help2man *"
		echo "******************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv help2man_local
		cd help2man_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all || exit 1
		make ${MAKE_FLAGS} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# flex (bootstrap -> the latest flex need flex to build...)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_FLEXBOOTSTRAP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv flex_local
		cd flex_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# flex
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_FLEX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv flex_local
		cd flex_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "**********************"
		echo "* Host Binutils...   *"
		echo "**********************"

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_local
		cd binutils_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--disable-doc \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "**************"
		echo "*   GCC...   *"
		echo "**************"

		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPFR##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_GMP##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPC##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_ISL##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_CLOOG##*/}"
		#unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gcc_local || exit 1
		cd gcc_local || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		if [ "$CROSSCOMPILERONLY_TMP" = "1" ];
		then
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--enable-languages=c,c++   \
				--disable-multilib         \
				${GCC_ADD_CONF} || exit 1
		else
			${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
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

		# u-boot is using "cc"
		ln -s ${BUILDTOOLS_HOME}/bin/gcc ${BUILDTOOLS_HOME}/bin/cc

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# LIBGMP
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBGMP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libgmp_local
		cd libgmp_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# MPFR
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_MPFR:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir mpc_local
		cd mpc_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# MPC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_MPC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir mpc_local
		cd mpc_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_REBUILD_DONE ]
	then
	(
		echo "***************************"
		echo "* Local texinfo (rebuild) *"
		echo "***************************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv texinfo_local
		cd texinfo_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_REBUILD_DONE
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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "******************"
		echo "*  Local Gperf   *"
		echo "******************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gperf_local
		cd gperf_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libffi_local
		cd libffi_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir expat_local
		cd expat_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--without-docbook \
				--prefix="${BUILDTOOLS_HOME}" \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libxml2_local
		cd libxml2_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					--datarootdir="${BUILDTOOLS_HOME}" \
					--exec-prefix="${BUILDTOOLS_HOME}" \
					--without-python || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/Configure \
				shared --prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install_sw || exit 1
		make ${MAKE_FLAGS} ${NBCORE} clean

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir cmake_local
		cd cmake_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir make_local
		cd make_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# pkgconfig
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_PKGCONFIG:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir pkgconfig_local
		cd pkgconfig_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--with-internal-glib \
				--prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Util linux
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_UTILLINUX:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "****************"
		echo "*  util linux  *"
		echo "****************"

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		mkdir ${BUILDTOOLS_HOME}/usr/share
		mkdir ${BUILDTOOLS_HOME}/usr/share/bash-completion
		mkdir ${BUILDTOOLS_HOME}/usr/share/bash-completion/completions

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv util-linux_local || exit 1
		cd util-linux_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
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
				--disable-liblastlog2 \
				--with-bashcompletiondir=${BUILDTOOLS_HOME}/usr/share/bash-completion/completions/  || exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# LIBNSL
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBNSL:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		autoupdate
		./autogen.sh

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libnsl_local
		cd libnsl_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					PKG_CONFIG_PATH=${BUILDTOOLS_HOME}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# ZLIB
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_ZLIB:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir zlib_local
		cd zlib_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir ncurses_local
		cd ncurses_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--with-shared \
				--enable-widec \
				--with-cxx-shared \
				--without-debug \
				--without-ada \
				--without-manpages \
				--with-curses-h \
				--enable-pc-files \
				--with-termlib \
				--with-versioned-syms \
				--with-pkg-config-libdir=${BUILDTOOLS_HOME}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		make ${MAKE_FLAGS} ${NBCORE} clean   || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--disable-stripping STRIPPROG=strip \
				--with-shared \
				--enable-widec \
				--with-cxx-shared \
				--without-debug \
				--without-manpages \
				--without-ada \
				--with-curses-h \
				--enable-pc-files \
				--with-versioned-syms \
				--with-pkg-config-libdir=${BUILDTOOLS_HOME}/lib/pkgconfig || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all     || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		create_build_dir

		export PKG_CONFIG_PATH=${BUILDTOOLS_HOME}/lib/pkgconfig
		export LIBRARY_PATH=${BUILDTOOLS_HOME}/lib/

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir heimdal
		cd heimdal || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
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

		cp ./lib/com_err/compile_et ${BUILDTOOLS_HOME}/bin
		cp -a ./lib/com_err/.libs ${BUILDTOOLS_HOME}/bin

		ln -sf ${BUILDTOOLS_HOME}/libexec/heimdal/asn1_compile	${BUILDTOOLS_HOME}/bin/asn1_compile
		#ln -sf ${BUILDTOOLS_HOME}/bin/compile_et ${BUILDTOOLS_HOME}/libexec/heimdal/compile_et

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# readline
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_READLINE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir readline_local
		cd readline_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--with-curses \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} SHLIB_LIBS="-lncursesw"         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} SHLIB_LIBS="-lncursesw" install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# XZ
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_XZ:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir xz_local
		cd xz_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# BZIP2
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_BZIP2:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit

		make ${MAKE_FLAGS} -f Makefile-libbz2_so      || exit 1
		make ${MAKE_FLAGS} || exit 1
		make ${MAKE_FLAGS} install PREFIX="${BUILDTOOLS_HOME}" || exit 1
		cp -v bzip2-shared ${BUILDTOOLS_HOME}/bin/bzip2
		cp -av libbz2.so* ${BUILDTOOLS_HOME}/lib
		ln -sv libbz2.so.1.0 ${BUILDTOOLS_HOME}/lib/libbz2.so

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBGDM
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBGDM:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir libgdm_local
		cd libgdm_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
					--prefix="${BUILDTOOLS_HOME}" \
					--disable-static \
					--enable-libgdbm-compat \
					|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir python_local
		cd python_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--enable-ipv6 \
				--enable-optimizations \
				--enable-shared \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		cd ${TMP_SRC_FOLDER} || exit 1

		unpack_buildtools "${SRC_PACKAGE_BUILD_PYTHON_SETUPTOOLS##*/}" ""
		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}
		python3 setup.py install

		unpack_buildtools "${SRC_PACKAGE_BUILD_PYTHON_JINJA2##*/}" ""
		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}
		python3 setup.py install

		#python3 -m ensurepip --upgrade

		pip3 install "${SRC_PACKAGE_BUILD_PYTHON_JINJA2##*/}"

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# MESON
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_MESON:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		python3 ./setup.py install

		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NINJA
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_NINJA:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
		if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
		then
		(
				create_src_dir

				unpack_buildtools ${CUR_PACKAGE} ""

				cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

				python3 configure.py --bootstrap

				install -vm755 ninja ${BUILDTOOLS_HOME}/bin/
				install -vDm644 misc/bash-completion ${BUILDTOOLS_HOME}/usr/share/bash-completion/completions/ninja
				install -vDm644 misc/zsh-completion  ${BUILDTOOLS_HOME}/usr/share/zsh/site-functions/_ninja

				delete_src_dir

				echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${MAKE_FLAGS} DESTDIR=${BUILDTOOLS_HOME}  || exit 1
		make ${MAKE_FLAGS} DESTDIR=${BUILDTOOLS_HOME} install  || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*****************"
		echo "*   Local bash  *"
		echo "*****************"

		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		create_build_dir

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv bash_local
		cd bash_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--datarootdir="${BUILDTOOLS_HOME}" \
				--exec-prefix="${BUILDTOOLS_HOME}" || exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE
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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir nano_local
		cd nano_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure.gnu \
				--prefix="${BUILDTOOLS_HOME}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		perl Makefile.PL || exit 1
		make install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

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
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		perl Makefile.PL || exit 1
		make install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# dev86
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_DEV86:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		make ${MAKE_FLAGS} DESTDIR=${BUILDTOOLS_HOME} as86 ld86 || exit 1

		install -d ${BUILDTOOLS_HOME}/usr/bin                        || exit 1
		install -m 755 bin/as86 ${BUILDTOOLS_HOME}/usr/bin               || exit 1
		install -m 755 bin/as86_encap ${BUILDTOOLS_HOME}/usr/bin/as86_encap   || exit 1
		install -m 755 bin/ld86 ${BUILDTOOLS_HOME}/usr/bin               || exit 1

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Sharutils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_SHARUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		sed -i 's/BUFSIZ/rw_base_size/' src/unshar.c
		sed -i '/program_name/s/^/extern /' src/*opts.h
		sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
		echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir sharutils_local
		cd sharutils_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# USERSPACE RCU
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_USERSPACE_RCU:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/bootstrap

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NTIRPC
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_BUILD_NTIRPC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		cmake .  -DCMAKE_INSTALL_PREFIX=${BUILDTOOLS_HOME} -DCMAKE_SYSTEM_PREFIX_PATH=${BUILDTOOLS_HOME} || exit 1

		make ${MAKE_FLAGS} ${NBCORE} || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		cp -av ${BUILDTOOLS_HOME}/include/tirpc/* ${BUILDTOOLS_HOME}/include/  || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi
) || exit 1
fi


####################################################################
# libelf
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_LIBELF:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*******************"
		echo "*  local libelf   *"
		echo "*******************"

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv libelf_local || exit 1
		cd libelf_local || exit 1

		autoupdate

		sed -i s#main\(\)\{return\(0\)\;\}#int\ main\(\)\{return\(0\)\;\}#g ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--target=$TGT_MACH \
				--enable-elf64 \
				--enable-compat || exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# local elfutils
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_ELFUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE ]
	then
	(
		echo "*********************"
		echo "*  local elfutils   *"
		echo "*********************"

		create_src_dir
		create_build_dir
		unpack_buildtools ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv elfutils_local || exit 1
		cd elfutils_local || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${BUILDTOOLS_HOME}" \
				--disable-libdebuginfod --disable-debuginfod || exit 1

		make ${MAKE_FLAGS} ${NBCORE}  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} -C libelf install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

