#!/bin/bash

set -eux

set -o allexport
source .env
set +o allexport

./bin/corteza-server-monolith ${@:1}
