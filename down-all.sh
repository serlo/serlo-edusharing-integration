#!/bin/bash

(cd edusharing && ./deploy.sh down)
docker-compose down
