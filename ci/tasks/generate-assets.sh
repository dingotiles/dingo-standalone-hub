#!/bin/bash

git clone app app_with_assets
cd app_with_assets

bundle install
rake assets:precompile
