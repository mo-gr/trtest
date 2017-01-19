currentVersion = $(shell git tag | tail -n1)
nextMajor = $(shell go run packaging/version/version.go major $(currentVersion))
nextMinor = $(shell go run packaging/version/version.go minor $(currentVersion))
nextPatch = $(shell go run packaging/version/version.go patch $(currentVersion))
commit = $(shell git rev-parse --short HEAD)

default: build

build-version:
	go install -ldflags "-X main.version=$(version) -X main.commit=$(commit)" ./...

build:
	make version=$(currentVersion) build-version

tag-major:
	git tag $(nextMajor)

tag-minor:
	git tag $(nextMinor)

tag-patch:
	git tag $(nextPatch)

push-tags:
	git push --tags https://c6dc37e396a8a4629bef7e472c2c8ffad7eb203c@github.com/aryszka/trtest

release-major:
	make version=$(nextMajor) build-version bump-major push-tags

release-minor:
	make version=$(nextMinor) build-version bump-minor push-tags

release-patch:
	make version=$(nextPatch) build-version bump-patch push-tags

clean:
	go clean -i ./...
