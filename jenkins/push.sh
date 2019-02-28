#!/usr/bin/env bash
#
# Push image
#

SERVICE_ENV="$1"

. ./jenkins/vars.sh

echo "Images to push:"
echo "${SERVICE_IMAGE}:${SERVICE_ENV}-latest"
echo "${SERVICE_IMAGE}:${SERVICE_ENV}-v${BUILD_NUMBER}"

docker push "${SERVICE_IMAGE}:${SERVICE_ENV}-latest"
docker push "${SERVICE_IMAGE}:${SERVICE_ENV}-v${BUILD_NUMBER}"
