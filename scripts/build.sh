#!/usr/bin/env bash

set -e

basename="khulnasoft/docker-with-compose"
latest_tag="${basename}:latest"

docker build -t "$latest_tag" .
