CC = gcc
CFLAGS = -fPIC -g

all: loader.32 loader.64

loader.32: loader.c
	$(CC) $(CFLAGS) -m32 loader.c -o loader.32

loader.64: loader.c
	$(CC) $(CFLAGS) -m64 loader.c -o loader.64

clean:
	rm *.o loader.64 loader.32
