#!/bin/bash

(cd edusharing/ && ./deploy.sh ps) | grep repository-service | cut -f 1 -d " "
