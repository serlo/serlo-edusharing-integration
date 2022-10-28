#!/bin/bash

COMPOSE_LIST=""

if [ "$SETUP_PROFILE" != "serlo" ]; then
  COMPOSE_LIST="$COMPOSE_LIST -f edusharing/edusharing-common.yml \
  -f edusharing/edusharing-remote.yml \
  -f edusharing/repository/repository-common.yml \
  -f edusharing/repository/repository-remote.yml \
  -f edusharing/repository/plugin-elastic/plugin-elastic-common.yml \
  -f edusharing/repository/plugin-elastic/plugin-elastic-remote.yml \
  -f edusharing/repository/plugin-mongo/plugin-mongo-common.yml \
  -f edusharing/repository/plugin-mongo/plugin-mongo-remote.yml \
  -f edusharing/services/rendering/rendering-common.yml \
  -f edusharing/services/rendering/rendering-remote.yml"
fi

if [ "$SETUP_PROFILE" != "edusharing" ]; then
  COMPOSE_LIST="$COMPOSE_LIST -f serlo.yml"
fi

docker-compose -p serlo-edusharing --project-directory . $COMPOSE_LIST "$@"
