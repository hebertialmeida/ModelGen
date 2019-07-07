SHELL = /bin/bash

prefix ?= /usr/local
bindir = $(prefix)/bin

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build

build:
	@swift build \
		-c release \
		--disable-sandbox \
		--build-path "$(BUILDDIR)"

install: build
	@install -d "$(bindir)"
	@install "$(BUILDDIR)/release/modelgen" "$(bindir)/modelgen"

uninstall:
	@rm -rf "$(bindir)/modelgen"

generate-examples: install
	(cd Example/Java && modelgen)
	(cd Example/Kotlin && modelgen)
	(cd Example/Swift/Imutable && modelgen)
	(cd Example/Swift/Mutable && modelgen)
	(cd Example/Swift/RocketDataImutable && modelgen)

clean:
	@rm -rf .build

.PHONY: build install uninstall clean