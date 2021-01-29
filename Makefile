all: Makefile.coq
	$(MAKE) -f Makefile.coq all


deps:
	git submodule update  
	opam install ./coq-library-undecidability --deps-only

html: Makefile.coq
	$(MAKE) -f Makefile.coq html
	mv html/*.html ./website
	rm -rf html

install: Makefile.coq
	$(MAKE) -f Makefile.coq install

uninstall: Makefile.coq
	$(MAKE) -f Makefile.coq uninstall

realclean: Makefile.coq clean
	$(MAKE) -C coq-library-undecidability/theories -f Makefile clean

clean: Makefile.coq
	$(MAKE) -f Makefile.coq clean
	rm -f Makefile.coq Makefile.coq.conf

Makefile.coq: _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq

.PHONY: all install html clean

dummy:

force _CoqProject Makefile: ;

%: Makefile.coq force
	@+$(MAKE) -f Makefile.coq $@
