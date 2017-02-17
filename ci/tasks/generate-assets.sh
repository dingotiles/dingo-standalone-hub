#!/bin/bash

git clone api app_with_assets
cd app_with_assets
rake assets:precompile
