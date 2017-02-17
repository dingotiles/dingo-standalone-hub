#!/bin/bash

set -e

cp app-ci/ci/ci_image/Dockerfile dockerfile/
cp app-ci/Gemfile* dockerfile/
