#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "filters.h"

#define SAMP_RATE 44100

int main(int argc, char *argv[])
{
	int kern_width, kern_size;
	float *f_kernel;
	int16_t *i_kernel;
	float crit_freq;

	if (argc < 3) {
		printf("Usage: %s crit-freq kern-width\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	crit_freq = atof(argv[1]);
	kern_width = atoi(argv[2]);
	kern_size = kern_width * 2 + 1;

	f_kernel = calloc(kern_size, sizeof(float));
	i_kernel = calloc(kern_size, sizeof(int16_t));

	lowpass(crit_freq, kern_width, SAMP_RATE, f_kernel);
	to_fixed_point(f_kernel, i_kernel, kern_size);
	swap_endian_if_needed(i_kernel, kern_size);

	fwrite(i_kernel, sizeof(int16_t), kern_size, stdout);

	free(f_kernel);
	free(i_kernel);

	return 0;
}
