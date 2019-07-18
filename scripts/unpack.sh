#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Unpack function
#

function unpack {

	if [ -f ${TARGET_DOWNLOAD}/$1 ]
	then
		export DOWNLOAD_FOLDER=${TARGET_DOWNLOAD}
	else
		export DOWNLOAD_FOLDER=${COMMON_DOWNLOAD}
	fi

	echo "Unpacking $1 (from common download folder)..."
	export TMP_ARCHIVE_FOLDER=`tar tf ${DOWNLOAD_FOLDER}/$1 | sed -e 's@/.*@@' | uniq`
	tar xvf ${DOWNLOAD_FOLDER}/$1 --directory=${TARGET_SOURCES}/$2  || exit 1
}
