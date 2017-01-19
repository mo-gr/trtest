currentVersion = $(shell git describe --tags)
nextMajor = $(shell go run packaging/version/version.go major $(currentVersion))
nextMinor = $(shell go run packaging/version/version.go minor $(currentVersion))
nextPatch = $(shell go run packaging/version/version.go patch $(currentVersion))

init:

version:
	echo $(currentVersion) $(nextMajor) $(nextMinor) $(nextPatch)

bump-minor:
	git tag $(nextPatch)

bump-patch:
	git tag $(nextPatch)

push-tags:
	git push --tags https://3136c2700bdbd45bd7e93ec88756a6f0be39bf3d@github.com/aryszka/trtest
