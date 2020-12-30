#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Services
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1

source ${TARGET_CONFIG}/config.sh || exit 1

echo "****************"
echo "*   Services   *"
echo "****************"

####################################################################
# VSFTPD
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_VSFTPD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""
		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER} || exit 1

		sed -i s#locate_library\ #locate_library\ ${TARGET_ROOTFS}/#g vsf_findlibs.sh || exit 1
		sed -i s#echo\ \"/lib#echo\ \"${TARGET_ROOTFS}/lib#g vsf_findlibs.sh || exit 1
		sed -i s#define\ VSF_BUILD_PAM#undef\ VSF_BUILD_PAM#g builddefs.h || exit 1

		#FIXME ! potential security vulnerability : stack-protector not available with ppc arch !
		[[ $TGT_MACH == *@(ppc*) ]] && sed -i s#-fstack-protector##g Makefile

		make ${NBCORE} CC=${TGT_MACH}-gcc   || exit 1
		cp vsftpd ${TARGET_ROOTFS}/usr/sbin || exit 1
		cp vsftpd.conf ${TARGET_ROOTFS}/etc || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Lighttpd
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIGHTTPD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD}  || exit 1
		mkdir lighttpd
		cd lighttpd || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--without-pcre \
				--without-bzip2 || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# CVS
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_CVS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD}  || exit 1
		mkdir cvs
		cd cvs || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# OpenSSH
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_OPENSSH:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_BUILD} || exit 1
		mkdir openssh
		cd openssh || exit 1

		${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="/" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				CFLAGS=-DMB_LEN_MAX=16 || exit 1

		make ${NBCORE} LD=${TGT_MACH}-gcc                          || exit 1
		make ${NBCORE} DESTDIR=${TARGET_ROOTFS} STRIP_OPT= install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# PXE Server
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_PXESERVER:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		sed -i s#/usr/sbin#${TARGET_ROOTFS}/usr/sbin#g Makefile || exit 1
		sed -i s#/etc/#${TARGET_ROOTFS}/etc/#g Makefile || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# TFTPD
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TFTPD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# uMTP Responder
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_UMTPRD:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		make  CC=${TGT_MACH}-gcc || exit 1
		cp    umtprd ${TARGET_ROOTFS}/sbin || exit 1
		mkdir ${TARGET_ROOTFS}/etc/umtprd || exit 1
		cp    conf/umtprd.conf ${TARGET_ROOTFS}/etc/umtprd || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# mailutils
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MAILUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--disable-python \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# msmtp
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_MSMTP:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${NBCORE}         || exit 1
		make ${NBCORE} install || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Samba
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_SAMBA:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_DONE ]
	then
	(
		unpack ${CUR_PACKAGE} ""

		cd ${TARGET_SOURCES}/${TMP_ARCHIVE_FOLDER}  || exit 1

		cd source3 || exit 1

		./autogen.sh  || exit 1

		cat "config.sub" | sed s#armv\\[345\\]\\[lb\\]#armv\\[3457\\]\\[alb\\]#g > "config_new.sub" || exit 1
		cp config_new.sub config.sub

		./configure --without-krb5 --without-ldap --without-ads --without-sys-quotas --without-quotas\
				--disable-cups --enable-swat=no --with-winbind=no \
				--build=$MACHTYPE \
				--target=$TGT_MACH --host=$TGT_MACH \
				--with-configdir=/etc \
				samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
				libreplace_cv_HAVE_GETADDRINFO=no \
				ac_cv_file__proc_sys_kernel_core_pattern=yes || exit 1

		mkdir ${TARGET_ROOTFS}/bin/smbd
		mkdir ${TARGET_ROOTFS}/bin/smbclient

		echo "#define USE_SETRESUID 1" >> "include/config.h"
		echo "" >> "include/config.h"

		make ${NBCORE} || exit 1
		make ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
