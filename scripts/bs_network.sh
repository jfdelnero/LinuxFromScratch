#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Network support
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

source ${SCRIPTS_HOME}/apply_patches.sh || exit 1

echo "***********"
echo "* Network *"
echo "***********"

####################################################################
# LIBMNL (iptables)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBMNL:-"UNDEF"}
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
		mkdir libmnl
		cd libmnl || exit 1

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
# LIBNFTNL (iptables)
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBNFTNL:-"UNDEF"}
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
		mkdir libnftnl
		cd libnftnl || exit 1

		export LIBMNL_LIBS="-L${TARGET_ROOTFS}/lib/libmnl.so"
		export LIBMNL_CFLAGS="-I${TARGET_ROOTFS}/include"

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
# Iptables
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_IPTABLES:-"UNDEF"}
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

		apply_patches ${COMMON_PATCHES}/iptables

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir iptables
		cd iptables || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				CFLAGS=-DPATH_MAX=4096 \
				LDFLAGS="${TARGET_ROOTFS}/lib/libmnl.so  ${TARGET_ROOTFS}/lib/libnftnl.so"  || exit 1

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
# ntp client
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_NTP:-"UNDEF"}
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

		apply_patches ${COMMON_PATCHES}/ntp

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir ntp
		cd ntp || exit 1

		# gcc 14 support workaround patch ... should be removed with version > ntp-4.2.8p18
		sed -i s#ol_cv_func_pthread_detach\=no#ol_cv_func_pthread_detach\=yes#g ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure || exit 1
		sed -i s#ol_cv_func_pthread_detach\=no#ol_cv_func_pthread_detach\=yes#g ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/sntp/configure || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				CFLAGS="-DMAX_PATH=4096 -DMB_LEN_MAX=16"\
				--with-yielding-select=yes || exit 1

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
# Chrony client
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_CHRONY:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix= \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH || exit 1

		make ${MAKE_FLAGS} ${NBCORE}         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# dhcp server
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_DHCPSERVER:-"UNDEF"}
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

		export CROSS=${TGT_MACH}
		export CC="${TGT_MACH}-gcc -latomic"
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}
		export PREFIX=${TARGET_ROOTFS}
		export BUILD_CC=gcc

		# x86-x86 cross compilation : Force the cross compile mode !
		cd bind
		tar -xvzf bind.tar.gz
		sed -i s#cross_compiling\=no#cross_compiling\=yes#g bind-9.11.14/configure || exit 1
		sed -i s#=\ val\;#=\ value\;#g bind-9.11.14/lib/isc/stats.c || exit 1

		rm bind.tar.gz
		tar -cvzf bind.tar.gz bind-9.11.14
		rm -R bind-9.11.14
		cd ..

		sed -i s#u_int16_t\ local_port#u_int16_t\ local_port____#g client/dhclient.c || exit 1
		sed -i s#u_int16_t\ remote_port#u_int16_t\ remote_port____#g client/dhclient.c || exit 1
		sed -i s#u_int16_t\ local_port#u_int16_t\ local_port___#g relay/dhcrelay.c || exit 1
		sed -i s#u_int16_t\ remote_port#u_int16_t\ remote_port___#g relay/dhcrelay.c || exit 1
		sed -i s#omapi_object_type_t#//omapi_object_type_t#g server/mdb.c || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix= \
				--sysconfdir=${TARGET_ROOTFS}/etc/dhcp \
				--localstatedir=/var \
				--with-srv-lease-file=/var/db/dhcpd.leases \
				--with-srv6-lease-file=/var/db/dhcpd6.leases \
				--with-cli-lease-file=/var/db/dhclient.leases \
				--with-cli6-lease-file=/var/db/dhclient6.leases \
				--host=$TGT_MACH \
				--cache-file=config.cache \
				BUILD_CC=gcc \
				--with-randomdev=no || exit 1

		make ${MAKE_FLAGS} -j1         || exit 1
		make ${MAKE_FLAGS} -j1 install DESTDIR=${TARGET_ROOTFS} || exit 1

		touch ${TARGET_ROOTFS}/var/db/dhcpd.leases

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
#              ----------- Wifi Stack -----------
####################################################################

####################################################################
# Wireless tools
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_WIRELESSTOOLS:-"UNDEF"}
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

		export CROSS=${TGT_MACH}
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}
		export PREFIX=${TARGET_ROOTFS}

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc         || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install CC=${TGT_MACH}-gcc || exit 1

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

		delete_src_dir

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBNL 3
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBNL3:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				CFLAGS="-DNAME_MAX=255"\
				|| exit 1


		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBNL 1
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBNL1:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				CFLAGS="-DNAME_MAX=255"\
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# IW
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_IW:-"UNDEF"}
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

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc                      || exit 1
		cp iw ${TARGET_ROOTFS}/sbin/                || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# WPA Supplicant
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_WPASUPPLICANT:-"UNDEF"}
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

		cd wpa_supplicant     || exit 1

		cp defconfig .config  || exit 1

		sed -i s#CONFIG_CTRL_IFACE_DBUS_NEW\=y#\\#CONFIG_CTRL_IFACE_DBUS_NEW\=y#g .config || exit 1
		sed -i s#CONFIG_CTRL_IFACE_DBUS_INTRO\=y#\\#CONFIG_CTRL_IFACE_DBUS_INTRO\=y#g .config || exit 1

		export LIBDIR=/lib/
		export INCDIR=/include/
		export BINDIR=/sbin/

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc LDFLAGS+=-ldl || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Hostapd
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_HOSTAPD:-"UNDEF"}
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

		cd hostapd     || exit 1

		cp ${TARGET_CONFIG}/hostapd_config .config || exit 1

		export LIBDIR=/lib/
		export INCDIR=/include/
		export BINDIR=/sbin/

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc LDFLAGS+=-ldl || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# RFKill
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_RFKILL:-"UNDEF"}
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

		make ${MAKE_FLAGS} ${NBCORE} CC=${TGT_MACH}-gcc              || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install PREFIX=${TARGET_ROOTFS}

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# LIBPCAP
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_LIBPCAP:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# TCPDUMP
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TCPDUMP:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# NMAP
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_NMAP:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# TCPSLICE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TCPSLICE:-"UNDEF"}
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

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# IPROUTE2
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_IPROUTE2:-"UNDEF"}
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

		export CROSS=${TGT_MACH}
		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export TARGET_DIR=${TARGET_ROOTFS}
		export PREFIX=${TARGET_ROOTFS}

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}" \
				--host=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} ${NBCORE}           || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install DESTDIR=${TARGET_ROOTFS} || exit 1

		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi
) || exit 1
fi

