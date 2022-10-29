#!/bin/bash

set -e
set -o pipefail

source utils.sh

function setup {
  init
  check_tools

  info "Deploy edusharing & serlo editor"
  ./docker-compose.sh pull && ./docker-compose.sh up -d

  if [ $SETUP_PROFILE == "all" ]; then
    info "Configure edu-sharing"
    ./configure-edusharing.py

    info "Configure the serlo editor"
    ./configure-serlo.sh
  fi
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
}

function check_tools {
  for TOOL in python docker docker-compose curl; do
    if ! which $TOOL > /dev/null; then
      error "The tool '$TOOL' need to be installed accessable in \$PATH"
    fi
  done

  if ! python -c "import requests"; then
    error "The python package 'requests' needs to be installed. Run 'pip install -r requirements.txt'"
  fi
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
