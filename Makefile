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

print:
ifeq ($(findstring [minor-release],something with [minor-release] in it),[minor-release])
	echo minor
else
	echo not
endif

ci-trigger:
ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST)_$(findstring [major-release],$(TRAVIS_COMMIT_MESSAGE)), master_false_[major-release])
	make release-major
ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST)_$(findstring [minor-release],$(TRAVIS_COMMIT_MESSAGE)), master_false_[minor-release])
	make release-minor
ifeq ($(TRAVIS_BRANCH)_$(TRAVIS_PULL_REQUEST), master_false)
	make release-patch
else ifeq ($(TRAVIS_BRANCH), master)
	make check-precommit
else
	make check
endif
