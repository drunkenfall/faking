LINTER_ARGS = -j 4 --enable-gc --disable=errcheck --disable=gotype --deadline=10m --tests

.DEFAULT_GOAL: all

all: download lint test

check: test lint

.PHONY: download
download:
	go get -t -d -v ./...

.PHONY: install-linter
install-linter:
	go get -v -u github.com/alecthomas/gometalinter
	gometalinter --install

.PHONY: test
test:
	go test -v -coverprofile=cover.out

.PHONY: lint
lint: install-linter
	gometalinter $(LINTER_ARGS) $(SOURCEDIR)

# Listing all the make targets; http://stackoverflow.com/a/26339924/983746
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
