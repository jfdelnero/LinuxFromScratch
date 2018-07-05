/*
//
// Copyright (C) 2018 Jean-François DEL NERO / HxC2001
//
// This file is part of the ppc_spi_flash_builder software
//
// ppc_spi_flash_builder may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// ppc_spi_flash_builder is free software; you can redistribute it
// and/or modify  it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.
//
// ppc_spi_flash_builder is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//   See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ppc_spi_flash_builder; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
//
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#if IS_LITTLE_ENDIAN
// Little Endian
	#define ENDIAN_32BIT(value) value
	#define ENDIAN_16BIT(value) value
#else
// Big Endian
	#define ENDIAN_32BIT(value) ( ((uint32_t)(value&0x000000FF)<<24) + ((uint32_t)(value&0x0000FF00)<<8) + ((uint32_t)(value&0x00FF0000)>>8) + ((uint32_t)(value&0xFF000000)>>24) )
	#define ENDIAN_16BIT(value) ( ((uint16_t)(value&0x00FF)<<8) + ((uint16_t)(value&0xFF00)>>8)  )
#endif

#define DEST_BASE_ADDR 0xF8F80000 // Cache memory

int main(int argc, char *argv[])
{
	FILE * f;
	unsigned char * bootloader_buffer;
	unsigned char * flash_mem_spi;
	unsigned char pad_byte;

	uint32_t * config_array;
	uint32_t conf_adr,conf_dat;
	int total_size,cfg_pad;

	uint32_t * tmpptr;


	int bootloader_size,nbconfig,i;
	char config_line[512];


	bootloader_buffer = 0;
	bootloader_size = 0;
	nbconfig = 0;

	printf("ppc_spi_flash_builder v0.1\n");

	/////////////////////////////////////////////////////////////////////////////////////////

	printf("Loading boot loader\n");
	f = fopen("bootloader.bin","rb");
	if(f)
	{
		fseek(f, 0, SEEK_END);
		bootloader_size = ftell(f);

		if( (bootloader_size & 3) || !bootloader_size )
		{
			bootloader_size = ((bootloader_size & ~3) + 4);
		}

		fseek(f, 0, SEEK_SET);

		bootloader_buffer = malloc(  bootloader_size );
		if(bootloader_buffer)
		{
			fread(bootloader_buffer,bootloader_size,1,f);
		}
		printf("bootloader.bin loaded ! (%d bytes)\n",bootloader_size);
		fclose(f);
	}
	else
	{
		printf("Warning : No boot loader file loaded !\n");
	}

	/////////////////////////////////////////////////////////////////////////////////////////

	printf("Loading config table\n");
	f = fopen("config.txt","rb");
	if(f)
	{
		fseek(f, 0, SEEK_SET);
		do
		{
			memset(config_line,0,sizeof(config_line));
			fgets(config_line, sizeof(config_line), f);
			if(sscanf(config_line,"0x%x=0x%x\n",&conf_adr,&conf_dat) == 2)
			{
				nbconfig++;
			}
		}while(!feof(f));


		if(nbconfig)
		{
			fseek(f, 0, SEEK_SET);

			config_array = malloc( nbconfig * (4 + 4) );
			memset(config_array,0,nbconfig * (4 + 4));

			nbconfig = 0;
			do
			{
				memset(config_line,0,sizeof(config_line));
				fgets(config_line, sizeof(config_line), f);
				if(strchr(config_line,'='))
				{
					if(sscanf(config_line,"0x%x=0x%x\n",&conf_adr,&conf_dat) == 2)
					{
						printf("Config : [0x%.8x] = 0x%.8x\n",conf_adr,conf_dat);
						config_array[ (nbconfig * 2) ] = ENDIAN_32BIT(conf_adr);
						config_array[ (nbconfig * 2) + 1 ] = ENDIAN_32BIT(conf_dat);
						nbconfig++;
				   }
				}
			}while(!feof(f));
		}

		fclose(f);
	}
	else
	{
		printf("Warning : No config file loaded !\n");
	}

	/////////////////////////////////////////////////////////////////////////////////////////

	// Header + Config pairs + pad + bootcode
	cfg_pad = 0;

	if( (nbconfig * 8) & 0x1f )
		cfg_pad = 0x20;

	total_size = 0x80 + (nbconfig * 8) + cfg_pad + bootloader_size;

	printf("Flash total size = %d bytes\n",total_size);

	flash_mem_spi = malloc( total_size );
	if( flash_mem_spi )
	{
		memset(flash_mem_spi, 0xff, total_size);

		// BOOT Signature
		flash_mem_spi[0x40] = 'B';
		flash_mem_spi[0x41] = 'O';
		flash_mem_spi[0x42] = 'O';
		flash_mem_spi[0x43] = 'T';

		memset(&flash_mem_spi[0x44], 0 , 4); // Reserved

		// User code lenght
		tmpptr = (uint32_t*)&flash_mem_spi[0x48];
		*tmpptr = (uint32_t)ENDIAN_32BIT(bootloader_size);

		memset(&flash_mem_spi[0x4c], 0 , 4); // Reserved

		// Source Address
		tmpptr = (uint32_t*)&flash_mem_spi[0x50];
		*tmpptr = (uint32_t)ENDIAN_32BIT((0x80 + (nbconfig * 8) + cfg_pad));

		memset(&flash_mem_spi[0x54], 0 , 4); // Reserved

		// Target Address
		tmpptr = (uint32_t*)&flash_mem_spi[0x58];
		*tmpptr = (uint32_t)ENDIAN_32BIT(DEST_BASE_ADDR);

		memset(&flash_mem_spi[0x5c], 0 , 4); // Reserved

		// Exec addr
		tmpptr = (uint32_t*)&flash_mem_spi[0x60];
		*tmpptr = (uint32_t)ENDIAN_32BIT(DEST_BASE_ADDR);

		memset(&flash_mem_spi[0x64], 0 , 4); // Reserved

		// Nb of Config pairs
		tmpptr = (uint32_t*)&flash_mem_spi[0x68];
		*tmpptr = (uint32_t)ENDIAN_32BIT(nbconfig);

		memset(&flash_mem_spi[0x6C], 0 , 4); // Reserved

		memcpy( &flash_mem_spi[0x80], config_array, nbconfig * 8 );

		memcpy( &flash_mem_spi[ 0x80 + (nbconfig * 8) + cfg_pad ], bootloader_buffer, bootloader_size );

		printf("Saving SPI flash\n");
		f = fopen("spiflash.bin","wb");
		if(f)
		{
			fwrite(flash_mem_spi,total_size,1,f);

			// Pad
			pad_byte = 0xFF;
			i = 0;
			while( (total_size + i) & 0x7F )
			{
				fwrite ( &pad_byte, 1, 1, f );
				i++;
			}

			fclose(f);

			printf("spiflash.bin saved ! (%d bytes)\n",total_size);
		}

		free( flash_mem_spi );
	}
	else
	{
		printf("Warning : No boot loader file loaded !\n");
	}

	/////////////////////////////////////////////////////////////////////////////////////////

	if(bootloader_buffer)
		free(bootloader_buffer);

	exit(0);
}

