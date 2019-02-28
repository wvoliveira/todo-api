#!/usr/bin/env bash
#
# Export VARS
#

SERVICE_ENV="$1"

SERVICE_NAME="todo-api"
SERVICE_IMAGE="algumregistry.com.br/todo-api"
DOCKER_HOSTS_TESTING="manager-swarm-testing.servers"

# To deploy
if [[ -n "$SERVICE_ENV" ]]; then
  case "$SERVICE_ENV" in
    "testing")    export DOCKER_HOSTS_DEPLOY="$DOCKER_HOSTS_TESTING" ;;
  esac
fi

# Docker create and update policies
REPLICAS="3"
RESTART_MAX_ATTEMPTS="5"
RESTART_WINDOW="1m"
RESTART_CONDITION="any"
UPDATE_PARALLELISM="1"
UPDATE_DELAY="1s"
LIMIT_MEMORY="100M"
