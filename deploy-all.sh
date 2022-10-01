#!/bin/bash

set -e
source utils.sh

info "Deploy edusharing"
./deploy-edusharing.sh

info "Deploy serlo editor"
./deploy-serlo.sh

info "Wait for edusharing and register serlo editor"
./register-serlo-editor.py

info "Update CLIENT ID in serlo editor"
docker-compose down
./deploy-serlo.sh
