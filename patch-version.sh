#!/bin/bash
set -e

MANIFEST_FILE="$1/typeorm/package.json"
GIT_DIRECTORY="$1/typeorm/.git/"
VERSION_FILE="$1/VERSION"

NEXT_VERSION=`cat "$VERSION_FILE"`

PACKAGE_MANIFEST=`cat "$MANIFEST_FILE"`

PACKAGE_MANIFEST=$(
    echo "$PACKAGE_MANIFEST" | jq --arg VERSION "$NEXT_VERSION" \
        '.version = $VERSION'
)

echo $PACKAGE_MANIFEST > "$MANIFEST_FILE"
