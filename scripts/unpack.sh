#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Unpack function
#

function unpack {
	echo "Unpacking $1 ..."
	export TMP_ARCHIVE_FOLDER=`tar tf ${BASE_DIR}/download/${TARGET_NAME}/$1 | sed -e 's@/.*@@' | uniq`
	tar xvf ${BASE_DIR}/download/${TARGET_NAME}/$1 --directory=${BASE_DIR}/sources/${TARGET_NAME}/$2  || exit 1
}
