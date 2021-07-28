#!/bin/bash

MANIFEST_FILE="$1/package.json"
VERSION_FILE="$1/VERSION"
GIT_DIRECTORY="$1/.git/"

REPO_NAME="@imnotjames/typeorm"
REPO_URL="https://github.com/imnotjames/typeorm.git"
BUGS_URL="https://github.com/imnotjames/typeorm/issues"

PACKAGE_MANIFEST=`cat "$MANIFEST_FILE"`

CURRENT_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] // "0.0.0"'`

NEXT_PATCH_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ .[0] // 0, .[1] // 0, (.[2] | tonumber? // 0) + 1 ] | join(".")'`
NEXT_MINOR_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ .[0] // 0, (.[1] | tonumber? // 0) + 1, 0 ] | join(".")'`
NEXT_MAJOR_VERSION=`echo "$PACKAGE_MANIFEST" | jq -r '.version | split("-")[0] | split(".") | [ (.[0] | tonumber? // 0) + 1, 0, 0 ] | join(".")'`
GIT_HASH=`git --git-dir "$GIT_DIRECTORY" rev-parse --short HEAD`

RC_SUFFIX="dev+${GIT_HASH}"

IS_RC_ALREADY=`echo "$PACKAGE_MANIFEST" | jq '.version | test("^.*-rc.[a-f0-9]+$")'`

if [[ "$IS_RC_ALREADY" == "true" ]]; then
    NEXT_VERSION="$CURRENT_VERSION-$RC_SUFFIX"
else
    NEXT_VERSION="$NEXT_PATCH_VERSION-$RC_SUFFIX"
fi

echo $NEXT_VERSION > "$VERSION_FILE"