#!/bin/bash

docker-compose -p serlo-edusharing \
  --project-directory . \
  -f edusharing/edusharing-common.yml \
  -f edusharing/edusharing-remote.yml \
  -f edusharing/repository/repository-common.yml \
  -f edusharing/repository/repository-remote.yml \
  -f edusharing/repository/plugin-elastic/plugin-elastic-common.yml \
  -f edusharing/repository/plugin-elastic/plugin-elastic-remote.yml \
  -f edusharing/repository/plugin-mongo/plugin-mongo-common.yml \
  -f edusharing/repository/plugin-mongo/plugin-mongo-remote.yml \
  -f edusharing/services/rendering/rendering-common.yml \
  -f edusharing/services/rendering/rendering-remote.yml \
  -f serlo.yml \
  "$@"
