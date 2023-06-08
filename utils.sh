#!/bin/bash

function info {
  echo "INFO: $@" 1>&2
}

function error {
  echo "ERROR: $@" 1>&2
  exit 1
}

function save_client_id_for_editor {
  echo "EDITOR_CLIENT_ID_FOR_LAUNCH=$1" > .env.plattform_id
}
