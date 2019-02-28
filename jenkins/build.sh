#!/usr/bin/env bash
#
# Build image
#

SERVICE_ENV="$1"

build_image() {
  docker build \
  -t "${SERVICE_IMAGE}:${SERVICE_ENV}-v${BUILD_NUMBER}" \
  -t "${SERVICE_IMAGE}:${SERVICE_ENV}-latest" .
}

main() {
  build_image
}

main
