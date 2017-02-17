#!/bin/bash

set -e -x

cp app-ci/ci/ci_image/Dockerfile dockerfile/
cp app-ci/Gemfile* dockerfile/
