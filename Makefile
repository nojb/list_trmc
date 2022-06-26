all:
	dune build --profile release
	_build/default/test.exe
