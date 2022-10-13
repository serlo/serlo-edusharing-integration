#!/bin/bash

(cd edusharing && ./deploy.sh stop)
docker-compose down
