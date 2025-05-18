#include <stdio.h>
#include <stdlib.h>
void printKey( unsigned char k[], unsigned int nbytes ){
	unsigned char ch, cl;
	char hexDigits[]="0123456789abcdef";
	printf("key = ");
	for( int i = nbytes -1 ; i >= 0; i-- ){
		ch= k[i] / 16;
		cl= k[i] % 16;
		printf("%c%c", hexDigits[ch], hexDigits[cl]);
	}
	printf("\n");
}
int main(int argc, char *argv[]){
	FILE *r, *k;
	unsigned char *buf;
	int nbytes, n;

	if(argc != 3){
		printf("Uso: %s file n_bytes\n", argv[0]);
		return 1;
	}else nbytes = atoi(argv[2]);

	r = fopen("/dev/urandom", "rb");
	if( r == NULL){
		printf("Erro na abertura de /dev/random");
		return 2;
	}
	buf = calloc( nbytes, sizeof(unsigned char));

	n = fread( buf, sizeof(unsigned char), nbytes, r);
	if( n != nbytes ){
		printf("Erro na leitura de /dev/random");
		return 3;
	}
	
	k = fopen(argv[1], "wb+");
	if( k == NULL){
		printf("Erro na abertura de %s", argv[1]);
		return 4;
	}
	n = fwrite( buf, sizeof(unsigned char), nbytes, k);
	if( n != nbytes ){
		printf("Erro na escrita de %s", argv[1]);
		return 5;
	}
	fclose(k);
	fclose(r);
	
	printKey( buf, 16 );
	return 0;
}
