#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2021 Sebastien CORBEAU
#
# patch function
#

function apply_patches()
{
	if [ -d $1 ]; then
		if [ ! -z "$(ls -A $1)" ]; then
			for p in $1/*patch ; do
				patch -p1 < $p
			done
		fi
	fi
}
