#!/bin/bash

set -e
WAIT_FOR_EDUSHARING=180

function wait_for_edusharing {
  START_TIMESTAMP=$(current_timestamp)

  while true; do
    if edusharing_is_up; then
      break
    fi

    if [ -n "$CARGO_BACKGROUND_PID" ]; then
      if ! cargo_is_running; then
        error "Server could not be compiled"
      fi
    fi

    if (($(current_timestamp) - $START_TIMESTAMP > $WAIT_FOR_CARGO_TIMEOUT)); then
      error "Timeout: The server has not be started"
    fi

    sleep 1
  done
}

function edusharing_is_running {
  curl -X 'GET' \
    'http://repository.127.0.0.1.nip.io:8100/edu-sharing/rest/_about' \
    -H 'accept: application/json' > /dev/null 2>&1
}

function current_timestamp() {
  date "+%s"
}

curl -X 'POST' -u "admin:admin" \
  'http://repository.127.0.0.1.nip.io:8100/edu-sharing/rest/ltiplatform/v13/manual-registration' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "toolName": "Serlo Editor",
  "toolUrl": "http://localhost:3000/lti",
  "toolDescription": "Serlo Editor",
  "keysetUrl": "http://host.docker.internal:3000/lti/keys",
  "loginInitiationUrl": "http://localhost:3000/lti/login",
  "redirectionUrls": [
    "http://localhost:3000/lti"
  ],
  "customParameters": [],
  "logoUrl": "https://de.serlo.org/_assets/apple-touch-icon.png",
  "targetLinkUri": "http://localhost:3000/lti",
  "targetLinkUriDeepLink": "http://localhost:3000/lti",
  "clientName": "Serlo Editor"
}'
