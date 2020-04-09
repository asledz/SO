#include <stdio.h>
#include <stdlib.h>

#include "pix.h"

int main(){
	uint64_t n = 8;
	uint32_t* tab = malloc(n * sizeof(uint32_t));
	uint64_t index = 0;

	pix(tab, &index, n);

	 for (uint64_t i = 0; i < n; ++i) {
	 	printf("%08x\n", tab[i]);
	 }
}
