#!/bin/bash
#
# Updates the deploy scripts of edusharing.

source utils.sh
set -e

ZIP_URL=$(python scripts/get-current-edusharing-deploy-scripts.py)
ZIP_FILE=$(tempfile --suffix .zip --prefix edusharing-deploy-scripts)
TARGET_DIR=edusharing

curl "$ZIP_URL" > "$ZIP_FILE"

if [ "$(file -b --mime-type "$ZIP_FILE")" == "application/zip" ]; then
  if [ -d "$TARGET_DIR" ]; then
    # Make sure we will not have leftover files
    rm -r "$TARGET_DIR"
  fi

  unzip -d "$TARGET_DIR" "$ZIP_FILE"

  patch -i repository-common.yml.patch \
        -u "$TARGET_DIR/repository/repository-common.yml"
else
  error "$ZIP_URL does not belong to a ZIP file"
fi
