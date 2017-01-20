currentVersion = $(shell git tag | sort -V | tail -n1)
nextMajor = $(shell go run packaging/version/version.go major $(currentVersion))
nextMinor = $(shell go run packaging/version/version.go minor $(currentVersion))
nextPatch = $(shell go run packaging/version/version.go patch $(currentVersion))
commit = $(shell git rev-parse --short HEAD)

default: build

build-version:
	go install -ldflags "-X main.version=$(version) -X main.commit=$(commit)" ./...

build:
	make version=$(currentVersion) build-version

check:
	go test ./...

clean:
	go clean -i ./...

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

check-precommit: check
	go vet ./...

ci-trigger:
	ifeq ($(TRAVIS_BRANCH), master)
		ifeq ($(TRAVIS_PULL_REQUEST), false)
			make release-patch
		else
			make check-precommit
		endif
	else
		make check
	endif
