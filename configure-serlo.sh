#!/bin/bash

set -e
source utils.sh

info "Update PLATFORM_CLIENT_ID of editor"
PLATFORM_CLIENT_ID="$(./get-serlo-editor-lti-tool-id.py)"
save_client_id_for_editor "$PLATFORM_CLIENT_ID"

# Update the editor container since the environment variables changed
./docker-compose.sh up -d
