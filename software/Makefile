CC=clang
CFLAGS=-Wall -g
LDFLAGS=-lm

all: highpass lowpass apply_filter

highpass: highpass.c filters.o

lowpass: lowpass.c filters.o

apply_filter: apply_filter.c filters.o

%.o: %.c %.h

clean:
	rm -f highpass lowpass *.o
