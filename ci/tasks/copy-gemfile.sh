#!/bin/bash

set -e -x

cp app-ci/images/stablebase/Dockerfile dockerfile/
cp app-gemfile/Gemfile* dockerfile/
