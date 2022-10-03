#!/bin/bash

set -e
source utils.sh

CONTAINER_ID=$(get_container_id editor)

if [ -z "$CONTAINER_ID" ]; then
  error "Serlo editor is not running"
fi

DOCKER_PATH="$CONTAINER_ID:/usr/src/app/server.js"
LOCAL_PATH=$(tempfile --suffix js --prefix serlo-editor-server)

docker cp "$DOCKER_PATH" "$LOCAL_PATH"
$EDITOR $LOCAL_PATH
docker cp "$LOCAL_PATH" "$DOCKER_PATH"
docker container restart "$CONTAINER_ID"
