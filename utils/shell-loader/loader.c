/*
 *  Copyright © 2001-2006 Freescale Semiconductor Inc.  All Rights Reserved.
 *
 *
 *  Questions and comments to:
 *       <mailto:support@freescale.com>
 *       <http://www.freescale.com/>
 */

/*------------------------------------------------------------------------------*
	main.c
 *------------------------------------------------------------------------------*/
#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>

int main(int argc, char **argv)
{
	char *bin_file_name = NULL;
	FILE *bin_file = NULL;
	long bin_size = 0;
	char *buffer = NULL;
	void (*callable)() = NULL;
	
	//Make sure we have the arguments we need
	if(argc < 2)
	{
		printf("Usage: %s [filename]\n",argv[0]);
		fflush(stdout);
		return 1;
	}
		
	//Open the file
	bin_file_name = argv[1];
	printf("Loading file %s...\n",bin_file_name);
	bin_file = fopen(bin_file_name,"rb");
	
	//get the size of the file
	if ( fseek(bin_file, 0, SEEK_END) || (bin_size = ftell(bin_file)) < 0 || fseek(bin_file,0, SEEK_SET))
	{
		
		printf("Error getting size of binary file: %d\n",errno);		
		fflush(stdout);
		return 2;
	}
	
	printf("Reading %08x bytes\n",bin_size);
	fflush(stdout);
	
	if(!(buffer = valloc(bin_size)))
	{
		printf("Insufficient memory to allocate buffer\n");		
		fflush(stdout);
		return 3;
		
	}
	
	if( bin_size != fread(buffer, 1, bin_size, bin_file))
	{
		printf("Could not read in all the data\n");		
		fflush(stdout);
		return 4;
	}
	
	if (mprotect(buffer, bin_size, PROT_READ|PROT_WRITE|PROT_EXEC))
	{
		printf("Error on reassigning permissions: %d\n",errno);
		fflush(stdout);
		return 5;
	}
	callable = buffer;

	printf("Executing bytes\n");
	fflush(stdout);

	callable();

	printf("Bytes executed\n");
	fflush(stdout);

	
	return 0;
}

