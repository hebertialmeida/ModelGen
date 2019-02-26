SHELL = /bin/bash

prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox -Xswiftc -static-stdlib

install: build
	install ".build/release/modelgen" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/modelgen"

clean:
	rm -rf .build

.PHONY: build install uninstall clean