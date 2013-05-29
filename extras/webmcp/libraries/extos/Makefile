include ../../Makefile.options

extos.so: extos.o
	$(LD) $(LDFLAGS) -lrt -lcrypt -o extos.$(SLIB_EXT) extos.o 

extos.o: extos.c
	$(CC) -c $(CFLAGS) -o extos.o extos.c

clean::
	rm -f extos.so extos.o
