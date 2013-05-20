include ../../Makefile.options

webmcp_accelerator.so: webmcp_accelerator.o
	$(LD) $(LDFLAGS) -o webmcp_accelerator.$(SLIB_EXT) webmcp_accelerator.o

webmcp_accelerator.o: webmcp_accelerator.c
	$(CC) -c $(CFLAGS) -o webmcp_accelerator.o webmcp_accelerator.c

clean::
	rm -f webmcp_accelerator.so webmcp_accelerator.o
