/*
 *  Copyright Altera Corporation (C) 2012-2013. All rights reserved
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms and conditions of the GNU General Public License,
 *  version 2, as published by the Free Software Foundation.
 *
 *  This program is distributed in the hope it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 *  more details.
 *
 *  You should have received a copy of the GNU General Public License along with
 *  this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#define CONFIG_SOCFPGA_CYCLONE5

#ifndef __CONFIG_H
#define __CONFIG_H

#include "../../board/altera/socfpga/build.h"
#include "../../board/altera/socfpga/pinmux_config.h"
#include "../../board/altera/socfpga/pll_config.h"
#include "../../board/altera/socfpga/sdram/sdram_config.h"
#include "../../board/altera/socfpga/reset_config.h"
#include "socfpga_common.h"
#ifdef CONFIG_SPL_BUILD
#include "../../board/altera/socfpga/iocsr_config_cyclone5.h"
#endif

/*
 * Console setup
 */
/* Monitor Command Prompt */
#define CONFIG_SYS_PROMPT		"SOCFPGA_CYCLONE5 # "

/* EMAC controller and PHY used */
#define CONFIG_EMAC_BASE		CONFIG_EMAC1_BASE
#define CONFIG_EPHY_PHY_ADDR		CONFIG_EPHY1_PHY_ADDR
#define CONFIG_PHY_INTERFACE_MODE	SOCFPGA_PHYSEL_ENUM_RGMII

/* Define machine type for Cyclone 5 */
#define CONFIG_MACH_TYPE 4251

#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS \
	"verify=n\0" \
    "bootdelay=0\0" \
	"loadaddr=" __stringify(CONFIG_SYS_LOAD_ADDR) "\0" \
	"fdtaddr=0x00000100\0" \
	"bootimage=zImage\0" \
	"bootimagesize=0x600000\0" \
	"fdtimage=socfpga.dtb\0" \
	"fdtimagesize=0x7000\0" \
	"mmcloadcmd=fatload\0" \
	"mmcloadpart=1\0" \
	"mmcroot=/dev/mmcblk0p2\0" \
	"qspiloadcs=0\0" \
	"qspibootimageaddr=0xa0000\0" \
	"qspifdtaddr=0x50000\0" \
	"qspiroot=/dev/mtdblock1\0" \
	"qspirootfstype=jffs2\0" \
	"nandbootimageaddr=0x120000\0" \
	"nandfdtaddr=0xA0000\0" \
	"nandroot=/dev/mtdblock1\0" \
	"nandrootfstype=jffs2\0" \
	"ramboot=setenv bootargs " CONFIG_BOOTARGS ";" \
		"bootz ${loadaddr} - ${fdtaddr}\0" \
	"mmcload=mmc rescan;" \
		"${mmcloadcmd} mmc 0:${mmcloadpart} ${loadaddr} ${bootimage};" \
		"${mmcloadcmd} mmc 0:${mmcloadpart} ${fdtaddr} ${fdtimage}\0" \
	"mmcboot=setenv bootargs " CONFIG_BOOTARGS \
		" root=${mmcroot} rw rootwait;" \
		"bootz ${loadaddr} - ${fdtaddr}\0" \
	"netboot=dhcp ${bootimage} ; " \
		"tftp ${fdtaddr} ${fdtimage} ; run ramboot\0" \
	"qspiload=sf probe ${qspiloadcs};" \
		"sf read ${loadaddr} ${qspibootimageaddr} ${bootimagesize};" \
		"sf read ${fdtaddr} ${qspifdtaddr} ${fdtimagesize};\0" \
	"qspiboot=setenv bootargs " CONFIG_BOOTARGS \
		" root=${qspiroot} rw rootfstype=${qspirootfstype};"\
		"bootz ${loadaddr} - ${fdtaddr}\0" \
	"nandload=nand read ${loadaddr} ${nandbootimageaddr} ${bootimagesize};"\
		"nand read ${fdtaddr} ${nandfdtaddr} ${fdtimagesize}\0" \
	"nandboot=setenv bootargs " CONFIG_BOOTARGS \
		" root=${nandroot} rw rootfstype=${nandrootfstype};"\
		"bootz ${loadaddr} - ${fdtaddr}\0" \
	"fpga=0\0" \
	"fpgadata=0x2000000\0" \
	"fpgadatasize=0x700000\0" \
	CONFIG_KSZ9021_CLK_SKEW_ENV "=" \
		__stringify(CONFIG_KSZ9021_CLK_SKEW_VAL) "\0" \
	CONFIG_KSZ9021_DATA_SKEW_ENV "=" \
		__stringify(CONFIG_KSZ9021_DATA_SKEW_VAL) "\0" \
	"scriptfile=u-boot.scr\0" \
	"callscript=if fatload mmc 0:1 $fpgadata $scriptfile;" \
			"then source $fpgadata; " \
		"else " \
			"echo Optional boot script not found. " \
			"Continuing to boot normally; " \
		"fi;\0"

#endif	/* __CONFIG_H */
