include ../../Makefile.options

multirand.so: multirand.o
	$(LD) $(LDFLAGS) -o multirand.$(SLIB_EXT) multirand.o

multirand.o: multirand.c
	$(CC) -c $(CFLAGS) -o multirand.o multirand.c

clean::
	rm -f multirand.so multirand.o
