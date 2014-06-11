include ../../Makefile.options

mondelefant_native.so: mondelefant_native.o
	$(LD) $(LDFLAGS) $(LDFLAGS_PGSQL) -o mondelefant_native.$(SLIB_EXT) mondelefant_native.o -lpq

mondelefant_native.o: mondelefant_native.c
	$(CC) -c $(CFLAGS) $(CFLAGS_PGSQL) -o mondelefant_native.o mondelefant_native.c

test:: mondelefant_native.so mondelefant.lua
	lua -l mondelefant

clean::
	rm -f mondelefant_native.so mondelefant_native.o
