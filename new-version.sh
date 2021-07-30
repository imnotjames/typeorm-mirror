#!/bin/bash
set -e

GIT_DIRECTORY="$1/typeorm/.git/"
MANIFEST_FILE="$1/typeorm/package.json"
VERSION_FILE="$1/VERSION"

PACKAGE_MANIFEST=`cat "$MANIFEST_FILE"`

CURRENT_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] // "0.0.0"'`

NEXT_PATCH_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ .[0] // 0, .[1] // 0, (.[2] | tonumber? // 0) + 1 ] | join(".")'`
NEXT_MINOR_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ .[0] // 0, (.[1] | tonumber? // 0) + 1, 0 ] | join(".")'`
NEXT_MAJOR_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ (.[0] | tonumber? // 0) + 1, 0, 0 ] | join(".")'`

GIT_HASH=`git --git-dir "$GIT_DIRECTORY" rev-parse --short HEAD`

VERSION_SUFFIX="dev.${GIT_HASH}"

IS_SNAPSHOT_ALREADY=`echo "$PACKAGE_MANIFEST" | jq '.version | test("^.*-[.+a-z0-9]+$")'`

if [[ "$IS_SNAPSHOT_ALREADY" == "true" ]]; then
    NEXT_VERSION="$CURRENT_VERSION-$VERSION_SUFFIX"
else
    NEXT_VERSION="$NEXT_PATCH_VERSION-$VERSION_SUFFIX"
fi

echo $NEXT_VERSION > "$VERSION_FILE"