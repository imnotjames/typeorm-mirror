#!/bin/bash

MANIFEST_FILE="$1/typeorm/package.json"
GIT_DIRECTORY="$1/typeorm/.git/"
VERSION_FILE="$1/VERSION"

REPO_NAME="@imnotjames/typeorm"
REPO_URL="https://github.com/imnotjames/typeorm.git"
BUGS_URL="https://github.com/imnotjames/typeorm/issues"

NEXT_VERSION=`cat "$VERSION_FILE"`

PACKAGE_MANIFEST=`cat "$MANIFEST_FILE"`

PACKAGE_MANIFEST=$(
    echo "$PACKAGE_MANIFEST" | jq --arg VERSION "$NEXT_VERSION" --arg NAME "$REPO_NAME" --arg REPO_URL "$REPO_URL" --arg BUGS_URL "$BUG_URL" \
        '.name = $NAME | .version = $VERSION | .repository.url = $REPO_URL | .bugs.url = $BUGS_URL'
)

PACKAGE_MANIFEST=$(
    echo "$PACKAGE_MANIFEST" | jq 'del(.author, .funding, .collective)'
)

echo $PACKAGE_MANIFEST > "$MANIFEST_FILE"
