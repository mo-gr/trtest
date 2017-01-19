#!/bin/bash

if [[ "$TRAVIS_BRANCH" == master ]]; then
	make release-patch
else
	make check-precommit
fi
