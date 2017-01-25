SOURCES =        $(shell find . -name '*.go')
currentVersion = $(shell git tag | sort -V | tail -n1)
nextMajor =      $(shell go run packaging/version/version.go major $(currentVersion))
nextMinor =      $(shell go run packaging/version/version.go minor $(currentVersion))
nextPatch =      $(shell go run packaging/version/version.go patch $(currentVersion))
commit =         $(shell git rev-parse --short HEAD)

default: build

build-version:
	go install -ldflags "-X main.version=$(version) -X main.commit=$(commit)" ./...

build: $(SOURCES)
	make version=$(currentVersion) build-version

check: build
	go test ./...

fmt: $(SOURCES)
	gofmt -w $(SOURCES)

check-fmt: $(SOURCES)
	if [ "$$(gofmt -d $(SOURCES))" != "" ]; then false; else true; fi

vet: $(SOURCES)
	go vet ./...

precommit: build check fmt vet

check-precommit: build check check-fmt vet

ci-user:
	git config --global user.email "builds@travis-ci.com"
	git config --global user.name "Travis CI"

tag: ci-user
	git tag $(version)

push-tags:
	git push --tags https://$(github_auth)@github.com/aryszka/trtest

release-major:
	make version=$(nextMajor) build-version tag push-tags

release-minor:
	make version=$(nextMinor) build-version tag push-tags

release-patch:
	make version=$(nextPatch) build-version tag push-tags

ci-trigger:
ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST)_$(findstring major-release,$(TRAVIS_COMMIT_MESSAGE)), master_false_major-release)
	make release-major
else ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST)_$(findstring minor-release,$(TRAVIS_COMMIT_MESSAGE)), master_false_minor-release)
	make release-minor
else ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST), master_false)
	make release-patch
else ifeq ($(TRAVIS_BRANCH), master)
	make check-precommit
else
	make check
endif
