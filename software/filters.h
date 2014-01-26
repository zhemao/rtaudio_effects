#ifndef __FILTERS_H__
#define __FILTERS_H__

#include <stdint.h>
#include <stdio.h>

void lowpass(float critFreq, int W, int sampRate, float *result);
void highpass(float critFreq, int W, int sampRate, float *result);

void to_fixed_point(float *f_data, int16_t *i_data, int n);
int16_t convolute(int16_t *audio, int16_t *kernel, int start, int size);

void rt_filter(FILE *inf, FILE *outf, int16_t *kernel, int size);

#endif
