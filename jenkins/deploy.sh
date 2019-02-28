#!/usr/bin/env bash
#
# Deploy
#

SERVICE_ENV="$1"

. ./jenkins/vars.sh "$SERVICE_ENV"

IMAGE_URL="${SERVICE_IMAGE}:${SERVICE_ENV}-v${BUILD_NUMBER}"
SERVICE_NAME="${SERVICE_NAME}-${SERVICE_ENV}"


deploy_service() {

  for host in $(echo "$DOCKER_HOSTS_DEPLOY"); do
    export DOCKER_HOST="$host"

    echo
    echo "Environment: ${SERVICE_ENV}"
    echo "Docker host: ${DOCKER_HOST}"
    echo "Service name: ${SERVICE_NAME}"
    echo "Service image: ${IMAGE_URL}"
    echo "Build number: ${BUILD_NUMBER}"
    echo

    send_deploy_command

  done  
}

send_deploy_command() {

  code_service_exists=$(docker service inspect "$SERVICE_NAME" > /dev/null 2>&1; echo "$?")

  if [[ "$code_service_exists" == "1" ]]; then

    echo "Creating service ${SERVICE_NAME}.."
    docker service create --name "$SERVICE_NAME" \
    --replicas "$REPLICAS"
    --publish 5000:5000 \
    --limit-memory "$LIMIT_MEMORY" \
    --restart-condition "$RESTART_CONDITION" \
    --restart-max-attempts "$RESTART_MAX_ATTEMPTS" \
    --restart-window "$RESTART_WINDOW" \
    --update-failure-action rollback \
    "$IMAGE_URL"

  elif [[ "$code_service_exists" == "0" ]]; then

    echo "Updating service ${SERVICE_NAME}.."
    docker service update \
    --replicas "$REPLICAS" \
    --limit-memory "$LIMIT_MEMORY" \
    --update-failure-action rollback \
    --update-parallelism "$UPDATE_PARALLELISM" \
    --update-delay "$UPDATE_DELAY" \
    --image "$IMAGE_URL" \
    "$SERVICE_NAME"

  fi
}

main() {
  deploy_service
}

main
