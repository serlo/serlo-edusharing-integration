#!/bin/bash

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
