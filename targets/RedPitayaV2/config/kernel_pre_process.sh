#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Zynq / Red Pitaya target kernel compilation
# pre process
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp  ${TARGET_CONFIG}/patches/*.dts ./arch/arm/boot/dts/
sed -i -e "s/YYLTYPE\ yylloc/extern\ YYLTYPE\ \ yylloc/g" ./scripts/dtc/dtc-lexer.lex.c
