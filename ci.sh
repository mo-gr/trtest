#!/bin/bash

if [[ "$TRAVIS_BRANCH" == master ]] && [[ "$TRAVIS_PULL_REQUEST" == false ]]; then
	make release-patch
elif [[ "$TRAVIS_BRANCH" == master ]] && [[ "$TRAVIS_PULL_REQUEST" == false ]]; then
	make check-precommit
fi
