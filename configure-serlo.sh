#!/bin/bash

set -e
source utils.sh

info "Update PLATFORM_CLIENT_ID of editor"
PLATFORM_CLIENT_ID="$(python -c 'import utils; print(utils.get_current_editor_id())')"
save_client_id_for_editor "$PLATFORM_CLIENT_ID"

# Update the editor container since the environment variables changed
./docker-compose.sh up -d
