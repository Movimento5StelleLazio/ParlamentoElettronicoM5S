include Makefile.options

all::
	make documentation
	make accelerator
	make libraries
	make symlinks
	make precompile

documentation::
	rm -f doc/autodoc.tmp
	lua framework/bin/autodoc.lua framework/cgi-bin/ framework/env/ libraries/ > doc/autodoc.tmp
	cat doc/autodoc-header.htmlpart doc/autodoc.tmp doc/autodoc-footer.htmlpart > doc/autodoc.html
	rm -f doc/autodoc.tmp

accelerator::
	cd framework/accelerator; make

libraries::
	cd libraries/extos; make
	cd libraries/mondelefant; make
	cd libraries/multirand; make

symlinks::
	ln -s -f ../../libraries/atom/atom.lua framework/lib/
	ln -s -f ../../libraries/extos/extos.so framework/lib/
	ln -s -f ../../libraries/mondelefant/mondelefant.lua framework/lib/
	ln -s -f ../../libraries/mondelefant/mondelefant_native.so framework/lib/
	ln -s -f ../../libraries/mondelefant/mondelefant_atom_connector.lua framework/lib/
	ln -s -f ../../libraries/multirand/multirand.so framework/lib/
	ln -s -f ../../libraries/rocketcgi/rocketcgi.lua framework/lib/
	ln -s -f ../../libraries/nihil/nihil.lua framework/lib/
	ln -s -f ../../libraries/luatex/luatex.lua framework/lib/

precompile::
	rm -Rf framework.precompiled
	rm -Rf demo-app.precompiled
	sh framework/bin/recursive-luac framework/ framework.precompiled/
	rm -f framework.precompiled/accelerator/Makefile
	rm -f framework.precompiled/accelerator/webmcp_accelerator.c
	rm -f framework.precompiled/accelerator/webmcp_accelerator.o
	framework/bin/recursive-luac demo-app/ demo-app.precompiled/

clean::
	rm -f doc/autodoc.tmp doc/autodoc.html
	rm -Rf framework.precompiled
	rm -Rf demo-app.precompiled
	rm -f demo-app/tmp/*
	rm -f framework/lib/*
	cd libraries/extos; make clean
	cd libraries/mondelefant; make clean
	cd libraries/multirand; make clean
	cd framework/accelerator; make clean
