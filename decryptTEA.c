/*
 * decryptTea.c
 * 
 */

#include <stdio.h>

extern void decrypt( unsigned char block[], unsigned char key[] );

int main(int argc, char **argv)
{
	FILE *fPlain, *fCiphered, *fKey;
	unsigned char buf[8];
	unsigned char key[16];
	int nr;
	

	if(argc != 4){
		printf("Uso: %s fileWithKey fileEncoded fileDecoded\n", argv[0]);
		return 1;
	}
	fKey = fopen(argv[1], "rb");
	if( fKey == NULL){
		printf("Error in opening file with key\n");
		return 2;
	}
	fCiphered = fopen(argv[2], "rb");
	if( fCiphered == NULL){
		printf("Error in opening file with ciphered contents\n");
		return 3;
	}
	fPlain = fopen(argv[3], "wb+");
	if( fPlain == NULL){
		printf("Error in opening file with plain content\n");
		return 4;
	}
	// read key
	fread( key, sizeof(unsigned char), 16, fKey);
	fclose(fKey);	
	
	while(1){
		nr = fread( buf, sizeof(unsigned char), 8, fCiphered);
		if (nr > 0){
			decrypt( buf, key );
			fwrite( buf, sizeof(unsigned char), 8, fPlain);
		}
		else
			break;
	}

	fclose(fPlain);
	fclose(fCiphered);
	
	return 0;
}

