#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <limits.h>
#include <string.h>
#include <math.h>

#define KERN_WIDTH 50
#define KERN_SIZE (2 * KERN_WIDTH + 1)
#define CRIT_FREQ 880.0f
#define SAMP_RATE 44100

void lowpass(float critFreq, int W, int sampRate, float *result)
{
	int i;
	float t, h, sum;
	int M = 2 * W;

	for (i = 0; i <= M; i++) {
		t = (i - W) / (float) sampRate;
		if (t == 0) {
			result[i] = 1.0f;
			sum += 1.0f;
		} else {
			h = sin(2 * M_PI * critFreq * t) / (2 * M_PI * critFreq * t);
			h *= (0.54 - 0.46 * cos(2 * M_PI * i / M));
			result[i] = h;
			sum += h;
		}
	}

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

int32_t convolute(int16_t *audio, int16_t *kernel, size_t start, size_t size)
{
	int i, ai;
	int32_t sum = 0;

	for (i = 0; i < size; i++) {
		ai = (i + start) % size;
		sum += audio[ai] * kernel[i];
	}

	return sum;
}

int main(int argc, char *argv[])
{
	float f_kernel[KERN_SIZE];
	int16_t i_kernel[KERN_SIZE];
	int16_t audio_rb[KERN_SIZE];
	int16_t sum;
	int i, cur_addr, nitems;
	FILE *inf;

	highpass(CRIT_FREQ, KERN_WIDTH, SAMP_RATE, f_kernel);

	for (i = 0; i < KERN_SIZE; i++)
		i_kernel[i] = SHRT_MAX * f_kernel[i];

	memset(audio_rb, 0, KERN_SIZE * 2);

	if (argc > 1)
		inf = fopen(argv[1], "r");
	else
		inf = stdin;

	while ((nitems = fread(audio_rb + cur_addr, 2, 1, inf)) > 0) {
		cur_addr = (cur_addr + 1) % KERN_SIZE;
		sum = convolute(audio_rb, i_kernel, cur_addr, KERN_SIZE) >> 16;
		fwrite(&sum, 2, 1, stdout);
	}

	fclose(inf);

	return 0;
}
