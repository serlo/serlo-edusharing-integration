#!/bin/bash

function info {
  echo "INFO: $@" 1>&2
}

function error {
  echo "ERROR: $@" 1>&2
  exit 1
}

function save_client_id_for_editor {
  echo "PLATFORM_CLIENT_ID=$1" > .env.plattform_id
}
