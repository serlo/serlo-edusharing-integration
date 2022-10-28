#!/bin/bash

set -e
set -o pipefail

source utils.sh

function setup {
  init

  info "Deploy edusharing & serlo editor"
  ./docker-compose.sh pull && ./docker-compose.sh up -d

  info "Wait for edusharing and register serlo editor"
  ./register-serlo-editor.py

  info "Update CLIENT ID in serlo editor"
  PLATFORM_CLIENT_ID="$(./get-serlo-editor-lti-tool-id.py)"
  save_client_id_for_editor "$PLATFORM_CLIENT_ID"
  # Update the editor container since the environment variables changed
  ./docker-compose.sh up -d
}

function help {
  echo """./setup.sh [COMMAND]

Commands:
  all        – Deploy edu-sharing and the serlo editor and configure both (default command)
  edusharing – Deploy only edu-sharing (without configuring it)
  serlo      – Deploy only the serlo editor (without configuring it)"""
}

function init {
  if [ ! -f .env.plattform_id ]; then
    info "Create .env.plattform_id"
    save_client_id_for_editor foo123456
  fi

  if ! which python > /dev/null; then
    error "Python need to be installed"
  fi

  if ! python -c "import requests"; then
    error "The python package 'requests' needs to be installed. Run 'pip install -r requirements.txt'"
  fi
}

function save_client_id_for_editor {
  echo "PLATFORM_CLIENT_ID=$1" > .env.plattform_id
}

case "$1" in
  "" | all)
    SETUP_PROFILE=all setup;;
  edusharing)
    SETUP_PROFILE=edusharing setup;;
  serlo)
    SETUP_PROFILE=serlo setup;;
  *)
    help;;
esac
