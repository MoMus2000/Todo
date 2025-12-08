PREFIX ?= /usr/local

all:
	dune build

run:
	./_build/default/todo.exe $(args)

clean:
	sudo rm -rf _build

install:
	dune build --profile release
	mkdir -p $(PREFIX)/bin
	cp ./_build/default/todo.exe $(PREFIX)/bin/todo

uninstall:
	rm -f $(PREFIX)/bin/todo

