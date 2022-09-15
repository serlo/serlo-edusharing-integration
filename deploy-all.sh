#!/bin/bash

(cd edusharing && ./deploy.sh start)

docker-compose up -d
