#!/bin/bash

set -e
source utils.sh

info "Deploy edusharing & serlo editor"
./docker-compose.sh pull && ./docker-compose.sh up -d

info "Wait for edusharing and register serlo editor"
./register-serlo-editor.py

info "Update CLIENT ID in serlo editor"
PLATFORM_CLIENT_ID="$(./get-serlo-editor-lti-tool-id.py)"
echo "PLATFORM_CLIENT_ID=$PLATFORM_CLIENT_ID" > .env.plattform_id
# Update the editor container since the environment variables changed
./docker-compose.sh up -d
