currentVersion = $(shell git tag --sort=version:refname | tail -n1)
nextMajor = $(shell go run packaging/version/version.go major $(currentVersion))
nextMinor = $(shell go run packaging/version/version.go minor $(currentVersion))
nextPatch = $(shell go run packaging/version/version.go patch $(currentVersion))
commit = $(shell git rev-parse --short HEAD)

default: build

build-version:
	go install -ldflags "-X main.version=$(version) -X main.commit=$(commit)" ./...

build:
	make version=$(currentVersion) build-version

ci-user:
	git config --global user.email "builds@travis-ci.com"
	git config --global user.name "Travis CI"

tag-major: ci-user
	git tag $(nextMajor)

tag-minor: ci-user
	git tag $(nextMinor)

tag-patch: ci-user
	git tag $(nextPatch)

push-tags:
	git push --tags https://$(github_auth)@github.com/aryszka/trtest

release-major:
	make version=$(nextMajor) build-version tag-major push-tags

release-minor:
	make version=$(nextMinor) build-version tag-minor push-tags

release-patch:
	make version=$(nextPatch) build-version tag-patch push-tags

clean:
	go clean -i ./...
