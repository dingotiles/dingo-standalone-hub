#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

cp ../../Gemfile* .
docker build -t dingotiles/dingo-standalone-hub-base .
docker push dingotiles/dingo-standalone-hub-base
rm Gemfile*
