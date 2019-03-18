/*
 * Copyright (C) 2017, Intel Corporation
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef __CONFIG_TERASIC_DE10_H__
#define __CONFIG_TERASIC_DE10_H__

#include <asm/arch/base_addr_ac5.h>

/* U-Boot Commands */
#define CONFIG_FAT_WRITE
#define CONFIG_HW_WATCHDOG

/* Memory configurations */
#define PHYS_SDRAM_1_SIZE		0x40000000	/* 1GiB */

/* Booting Linux */
#define CONFIG_BOOTFILE		"zImage"
#define CONFIG_BOOTARGS		"console=ttyS0," __stringify(CONFIG_BAUDRATE)
#define CONFIG_LOADADDR		0x01000000
#define CONFIG_SYS_LOAD_ADDR	CONFIG_LOADADDR

/* Ethernet on SoC (EMAC) */
#if defined(CONFIG_CMD_NET)
#define CONFIG_PHY_MICREL
#define CONFIG_PHY_MICREL_KSZ9031
#endif

#define CONFIG_ENV_IS_IN_MMC

#ifndef CONFIG_SPL_BUILD
#define CONFIG_EXTRA_ENV_SETTINGS \
	"verify=n\0" \
	"bootimage=" CONFIG_BOOTFILE "\0" \
	"bootdelay=0\0" \
	"fdt_addr=100\0" \
	"fdtfile=" CONFIG_DEFAULT_FDT_FILE "\0" \
	"bootm_size=0xa000000\0" \
	"kernel_addr_r="__stringify(CONFIG_SYS_LOAD_ADDR)"\0" \
	"fdt_addr_r=0x02000000\0" \
	"scriptaddr=0x02100000\0" \
	"pxefile_addr_r=0x02200000\0" \
	"ramdisk_addr_r=0x02300000\0" \
	\
	"fpga_cfg="							\
		"env exists fpga_file || setenv fpga_file "		\
			"${board}.rbf; "				\
		"if test -e mmc 0:1 ${fpga_file}; then "		\
			"load mmc 0:1 ${kernel_addr_r} "		\
				"${fpga_file}; "			\
			"fpga load 0 ${kernel_addr_r} "			\
				"${filesize}; "				\
			"bridge enable; "				\
		"fi;\0"							\
	\
	"hdmi_init="							\
		"run hdmi_cfg; "					\
		"if test \"${HDMI_status}\" = \"complete\"; then "	\
			"run hdmi_fdt_mod; "				\
		"fi;\0"							\
	"hdmi_fdt_mod="							\
		"load mmc 0:1 ${fdt_addr} "				\
			"socfpga_cyclone5_de10_nano.dtb; "		\
		"fdt addr ${fdt_addr}; "				\
		"fdt resize; "						\
		"fdt mknode /soc framebuffer@3F000000; "		\
		"setenv fdt_frag /soc/framebuffer@3F000000; "		\
		"fdt set ${fdt_frag} compatible \"simple-framebuffer\"; "\
		"fdt set ${fdt_frag} reg <0x3F000000 8294400>; "	\
		"fdt set ${fdt_frag} format \"x8r8g8b8\"; "		\
		"fdt set ${fdt_frag} width <${HDMI_h_active_pix}>; "	\
		"fdt set ${fdt_frag} height <${HDMI_v_active_lin}>; "	\
		"fdt set ${fdt_frag} stride <${HDMI_stride}>; "		\
		"fdt set /soc stdout-path \"display0\"; "		\
		"fdt set /aliases display0 \"/soc/framebuffer@3F000000\";"\
		"sleep 2;\0"						\
	"HDMI_enable_dvi="						\
		"no\0"							\
	"hdmi_cfg="							\
		"i2c dev 2; "						\
		"load mmc 0:1 0x0c300000 STARTUP.BMP; "			\
		"load mmc 0:1 0x0c100000 de10_nano_hdmi_config.bin; "	\
		"go 0x0C100001; "					\
		"dcache flush;"						\
		"if test \"${HDMI_enable_dvi}\" = \"yes\"; then "	\
			"i2c mw 0x39 0xAF 0x04 0x01; "			\
		"fi;\0"							\
	"hdmi_dump_regs="						\
		"i2c dev 2;icache flush; "				\
		"load mmc 0:1 0x0c100000 dump_adv7513_regs.bin; "	\
		"go 0x0C100001; icache flush;\0"			\
	"hdmi_dump_edid="						\
		"i2c dev 2;icache flush; "				\
		"load mmc 0:1 0x0c100000 dump_adv7513_edid.bin; "	\
		"go 0x0C100001; icache flush;\0"			\
	BOOTENV

#endif

#define CONFIG_BOOTCOMMAND "run fpga_cfg; run hdmi_init; run distro_bootcmd"

/* The rest of the configuration is shared */
#include <configs/socfpga_common.h>

#endif	/* __CONFIG_TERASIC_DE10_H__ */
