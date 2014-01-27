#include "filters.h"
#include <math.h>
#include <limits.h>
#include <string.h>

void lowpass(float critFreq, int W, int sampRate, float *result)
{
	int i;
	float t, h, sum = 0.0f;
	int M = 2 * W;

	for (i = 0; i <= M; i++) {
		// t is symmetric around the Y axis
		t = (i - W) / (float) sampRate;
		if (t == 0) {
			// avoid discontinuity at t = 0
			result[i] = 1.0f;
			sum += 1.0f;
		} else {
			// sinc function
			h = sin(2 * M_PI * critFreq * t) / (2 * M_PI * critFreq * t);
			// hamming window
			h *= (0.54 - 0.46 * cos(2 * M_PI * i / M));
			result[i] = h;
			sum += h;
		}
	}

	// normalize so that DC gain is 1
	for (i = 0; i <= M; i++) {
		result[i] /= sum;
	}
}

void highpass(float critFreq, int W, int sampRate, float *result)
{
	int i;

	lowpass(critFreq, W, sampRate, result);

	for (i = 0; i <= 2 * W; i++) {
		result[i] = -result[i];
	}

	result[W + 1] += 1.0f;
}

int16_t convolute(int16_t *audio, int16_t *kernel, int start, int size)
{
	int i, ai;
	int32_t sum = 0;

	for (i = 0; i < size; i++) {
		ai = (i + start) % size;
		sum += audio[ai] * kernel[i];
	}

	return sum >> 16;
}

void to_fixed_point(float *f_data, int16_t *i_data, int n)
{
	int i;

	for (i = 0; i < n; i++)
		i_data[i] = SHRT_MAX * f_data[i];
}

void rt_filter(FILE *inf, FILE *outf, int16_t *kernel, int kern_size)
{
	int16_t audio_rb[kern_size];
	int16_t sum;
	int cur_addr = 0, nitems;

	memset(audio_rb, 0, kern_size * 2);

	while ((nitems = fread(audio_rb + cur_addr, 2, 1, inf)) > 0) {
		cur_addr = (cur_addr + 1) % kern_size;
		sum = convolute(audio_rb, kernel, cur_addr, kern_size);
		fwrite(&sum, 2, 1, outf);
	}
}

static inline int little_endian(void)
{
	int16_t word = 1;
	uint8_t *addr = (uint8_t *) &word;

	// little-endian means byte 0 is LSB
	return addr[0] == 1;
}

void swap_endian_if_needed(int16_t *kernel, int size)
{
	int i;
	uint8_t *bytes = (uint8_t *) kernel;
	uint8_t temp;

	// don't need to do anything if the system is big-endian
	if (!little_endian())
		return;

	for (i = 0; i < size; i++) {
		temp = bytes[2 * i];
		bytes[2 * i] = bytes[2 * i + 1];
		bytes[2 * i + 1] = temp;
	}
}
