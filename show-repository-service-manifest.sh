#!/bin/bash

LOCAL_JAR_FILE=$(tempfile --suffix .jar --prefix edusharing-repository-service)
LOCAL_MANIFEST_FILE=$(tempfile --suffix .MF --prefix EDUSHARING-MANIFEST)
DOCKER_JAR_FILE="/opt/alfresco/tomcat/webapps/edu-sharing/WEB-INF/lib/\
edu_sharing-community-repository-backend-services-core-\
maven-feature-ltiplatform-8.1-SNAPSHOT.jar"

docker cp \
  "$(./get-repository-service-container-name.sh):$DOCKER_JAR_FILE" \
  "$LOCAL_JAR_FILE"

unzip -p "$LOCAL_JAR_FILE" META-INF/MANIFEST.MF > "$LOCAL_MANIFEST_FILE"

cat "$LOCAL_MANIFEST_FILE"
