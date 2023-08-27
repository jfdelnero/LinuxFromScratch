#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Services
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

source ${SCRIPTS_HOME}/apply_patches.sh || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""
		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER} || exit 1

		sed -i s#locate_library\ #locate_library\ ${TARGET_ROOTFS}/#g vsf_findlibs.sh || exit 1
		sed -i s#echo\ \"/lib#echo\ \"${TARGET_ROOTFS}/lib#g vsf_findlibs.sh || exit 1
		sed -i s#define\ VSF_BUILD_PAM#undef\ VSF_BUILD_PAM#g builddefs.h || exit 1
		sed -i s#open_mode\ \=\ kVSFSysStrOpenUnknown#open_mode\ \=\ \(enum\ EVSFSysUtilOpenMode\)kVSFSysStrOpenUnknown#g sysstr.c || exit 1
		#sed -i s#-fstack-protector##g Makefile || exit 1

		#FIXME ! potential security vulnerability : stack-protector not available with ppc arch !
		[[ $TGT_MACH == *@(ppc*) ]] && sed -i s#-fstack-protector##g Makefile

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc   || exit 1
		cp vsftpd ${TARGET_ROOTFS}/usr/sbin || exit 1
		cp vsftpd.conf ${TARGET_ROOTFS}/etc || exit 1

		delete_build_dir
		delete_src_dir

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER}  || exit 1
		mkdir lighttpd
		cd lighttpd || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--without-pcre \
				--without-pcre2 \
				--without-bzip2 || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER}  || exit 1
		mkdir cvs
		cd cvs || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir openssh
		cd openssh || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="/" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				CFLAGS=-DMB_LEN_MAX=16 || exit 1

		make ${MAKE_FLAGS} ${NBCORE} LD=${TGT_MACH}-gcc                          || exit 1
		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} STRIP_OPT= install || exit 1

		delete_build_dir
		delete_src_dir

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		sed -i s#/usr/sbin#${TARGET_ROOTFS}/usr/sbin#g Makefile || exit 1
		sed -i s#/etc/#${TARGET_ROOTFS}/etc/#g Makefile || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		sed -i s#sigjmp_buf\ toplevel#extern\ sigjmp_buf\ toplevel#g tftp/tftp.c || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		make ${MAKE_FLAGS}  CC=${TGT_MACH}-gcc || exit 1
		cp    umtprd ${TARGET_ROOTFS}/sbin || exit 1
		mkdir ${TARGET_ROOTFS}/etc/umtprd || exit 1
		cp    conf/umtprd.conf ${TARGET_ROOTFS}/etc/umtprd || exit 1

		delete_build_dir
		delete_src_dir

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--disable-python \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--without-gssapi \
				--target=$TGT_MACH || exit 1

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		./configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

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
# Ripmime
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_RIPMIME:-"UNDEF"}
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

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		sed -i 's/strip/${TGT_MACH}-strip/g' Makefile

		make ${MAKE_FLAGS} CC=${TGT_MACH}-gcc || exit 1
		make ${MAKE_FLAGS} install LOCATION="${TARGET_ROOTFS}/usr" CC=${TGT_MACH}-gcc || exit 1

		delete_build_dir
		delete_src_dir

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
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

# Native build just to get the right embedded asn1_compile and compile_et...
 
		rm ${TARGET_CROSS_TOOLS}/bin/asn1_compile
		rm ${TARGET_CROSS_TOOLS}/bin/compile_et

		./configure \
			--without-acl-support --disable-cups --disable-avahi --without-fam \
			--prefix=/usr \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-libiconv=${TARGET_ROOTFS}/usr \
			--enable-fhs \
			--disable-rpath \
			--disable-rpath-install \
			--disable-iprint \
			--without-pam \
			--without-dmapi \
			--without-gpgme \
			--without-ldb-lmdb \
			--without-json \
			--without-ad-dc \
			--without-libarchive \
			--without-ldap \
			--without-ads \
			--without-regedit \
			--without-libunwind \
			--disable-glusterfs \
			--disable-python \
			--without-cluster-support \
			--with-shared-modules='!vfs_snapper' || exit 1

		make ${MAKE_FLAGS}

# Get the host asn1_compile and compile_et...

		cp ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/bin/default/third_party/heimdal_build/asn1_compile ${TARGET_CROSS_TOOLS}/bin || exit 1
		cp ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/bin/compile_et ${TARGET_CROSS_TOOLS}/bin || exit 1

		cd ${TMP_SRC_FOLDER}/..  || exit 1

# And restart and build the cross compile version...

		delete_build_dir
		delete_src_dir

		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}  || exit 1

		#cp ${COMMON_CONFIG}/../patches/samba4/samba_cross.py ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/buildtools/wafsamba
		cp ${COMMON_CONFIG}/../patches/samba4/cache.txt ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}
		echo 'Checking uname machine type: "'$SAMBA_ARCH'"' >> ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/cache.txt;

		apply_patches ${COMMON_PATCHES}/samba4

		export CC=${TGT_MACH}-gcc

		./configure --hostcc=gcc --cross-compile --cross-answers=${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/cache.txt \
			--without-acl-support --disable-cups --disable-avahi --without-fam \
			--prefix=/usr \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-libiconv=${TARGET_ROOTFS}/usr \
			--enable-fhs \
			--disable-rpath \
			--disable-rpath-install \
			--disable-iprint \
			--without-pam \
			--without-dmapi \
			--without-gpgme \
			--without-ldb-lmdb \
			--without-json \
			--without-ad-dc \
			--without-libarchive \
			--without-ldap \
			--without-ads \
			--without-regedit \
			--without-libunwind \
			--disable-glusterfs \
			--disable-python \
			--with-cluster-support \
			--with-shared-modules='!vfs_snapper' \
			--bundled-libraries='!asn1_compile,!compile_et' || exit 1

		#WAF_CMD_FORMAT=string PYTHONHASHSEED=1 WAF_MAKE=1  ./buildtools/bin/waf -v build
		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc || exit 1
		make install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi
