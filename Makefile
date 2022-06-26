all: test.bc test.exe
	./test.bc
	./test.exe

test.bc: test.ml Makefile
	ocamlc -o $@ -I +unix unix.cma test.ml

test.exe: test.ml Makefile
	ocamlopt -o $@ -I +unix unix.cmxa test.ml

clean:
	rm -f *.cm* *.o *.obj *.bc *.exe
