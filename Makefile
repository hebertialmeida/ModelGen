SHELL = /bin/bash

prefix ?= /usr/local
bindir = $(prefix)/bin

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build

build:
	@swift build \
		-c release \
		--disable-sandbox \
		-Xswiftc \
		-static-stdlib \
		--build-path "$(BUILDDIR)"

install: build
	@install -d "$(bindir)"
	@install "$(BUILDDIR)/release/modelgen" "$(bindir)"

uninstall:
	@rm -rf "$(bindir)/modelgen"

clean:
	@rm -rf .build

.PHONY: build install uninstall clean