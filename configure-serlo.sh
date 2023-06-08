#!/bin/bash

set -e
source utils.sh

info "Update EDITOR_CLIENT_ID_FOR_LAUNCH"
EDITOR_CLIENT_ID_FOR_LAUNCH="$(python -c 'import utils; print(utils.get_current_editor_id())')"
save_client_id_for_editor "$EDITOR_CLIENT_ID_FOR_LAUNCH"

# Update the editor container since the environment variables changed
./docker-compose.sh up -d
