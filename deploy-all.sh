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
PLATFORM_CLIENT_ID="$(./get-serlo-editor-lti-tool-id.py)"
echo "PLATFORM_CLIENT_ID=$PLATFORM_CLIENT_ID" > .env.plattform_id
docker-compose down
./deploy-serlo.sh
