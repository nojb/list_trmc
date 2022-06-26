all: test.bc test.exe
	OCAMLRUNPARAM=l=10000000 ./test.bc
	./test.exe

test.bc: test.ml Makefile
	ocamlc -o $@ unix.cma test.ml

test.exe: test.ml Makefile
	ocamlopt -o $@ unix.cmxa test.ml

clean:
	rm -f *.cm* *.o *.obj *.bc *.exe
