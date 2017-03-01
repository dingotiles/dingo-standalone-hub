#!/bin/bash

env
rails db:migrate:status

set -e
rails db:migrate
rails s -p 5000
