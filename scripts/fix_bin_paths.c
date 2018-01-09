/*
  Cross compiler and Linux generation scripts
  (c)2014-2018 Jean-François DEL NERO

  Quick & dirty post process path fixer.
  This shouldn't be needed...
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char replaceseq[]="lib/../";

int main(int argc, char *argv[])
{
	FILE *f;
	int filesize,stringsize,i,j,k,l,m,altered;
	unsigned char * buffer;
	int ret;

	altered = 0;

	if ( argc > 2 )
	{
		f = fopen(argv[1],"r");
		if ( f )
		{
			fseek(f,0,SEEK_END);
			filesize = ftell(f);
			fseek(f,0,SEEK_SET);

			if ( filesize )
			{
				// Allocating and reading the whole file.
				buffer = malloc(filesize);

				if ( !buffer )
				{
					printf("Malloc error ! (%d bytes)\n",filesize);
					fclose(f);
					exit(-1);
				}

				memset((void*)buffer,0,filesize);
				fread(buffer,filesize,1,f);

				printf("File %s,%d bytes read\n",argv[1],filesize);
				printf("Path to suppress : %s\n",argv[2]);

				fclose(f);

				stringsize = strlen(argv[2]);

				if ( filesize > stringsize )
				{
					// Scan the whole file for the path to patch
					for ( i = 0 ; i < (filesize - stringsize) ; i++ )
					{
						if ( !memcmp(&buffer[i],argv[2],stringsize) )
						{
							// Matching string found
							// Patching the leading part of the path...

							printf("Path found at offset %d\n",i);
							j = stringsize;

							l = strlen(replaceseq);
							k = i;

							if( j )
							{
								buffer[k] = '/';
								k++;
								j--;
							}

							while( j )
							{
								if( j > l )
								{
									for( m = 0 ; m < l ; m++ )
									{
										buffer[k] = replaceseq[m];
										k++;
										j--;
									}
								}
								else
								{
									buffer[k] = '.';
									k++;
									j--;

									if( j )
									{
										buffer[k] = '/';
										k++;
										j--;
									}
								}
							}
							altered = 1;
						}
					}

					if ( altered )
					{
						// Change(s) made, write back them to the file...
						f = fopen(argv[1],"w");
						if ( f )
						{
							fwrite(buffer,filesize,1,f);
							printf("Patched...\n");
							fclose(f);
						}
					}
					else
						printf("nothing to patch...\n");

				}

				free(buffer);
			}
		}
		else
		{
			printf("Error, Couldn't open %s...\n",argv[1]);
		}
	}
	else
	{
		printf("Syntax : %s [FILE NAME] [PATH TO PATCH]\n",argv[0]);
	}

	exit(0);
}
