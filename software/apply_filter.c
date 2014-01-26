#include "filters.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
	int16_t *kernel;
	int kern_size;
	int off;
	FILE *f;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s kernel.dat [stream.raw]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	f = fopen(argv[1], "r");
	if (f == NULL) {
		perror("fopen");
		exit(EXIT_FAILURE);
	}

	off = fseek(f, 0, SEEK_END);
	if (off < 0) {
		fclose(f);
		exit(EXIT_FAILURE);
	}
	off = ftell(f);
	rewind(f);

	kern_size = off / 2;
	kernel = calloc(kern_size, sizeof(int16_t));

	if (fread(kernel, sizeof(int16_t), kern_size, f) < kern_size) {
		perror("fread");
		fclose(f);
		free(kernel);
		exit(EXIT_FAILURE);
	}
	fclose(f);

	swap_endian_if_needed(kernel, kern_size);

	if (argc < 3)
		f = stdin;
	else {
		f = fopen(argv[2], "r");
		if (f == NULL) {
			perror("fopen");
			free(kernel);
			exit(EXIT_FAILURE);
		}
	}

	rt_filter(f, stdout, kernel, kern_size);

	fclose(f);
	free(kernel);

	return 0;
}
