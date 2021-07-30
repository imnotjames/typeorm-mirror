#!/bin/bash
set -e

MANIFEST_FILE="$1/typeorm/package.json"
VERSION_FILE="$1/VERSION"

REPO_NAME="@imnotjames/typeorm"
REPO_URL="https://github.com/imnotjames/typeorm.git"
BUGS_URL="https://github.com/imnotjames/typeorm/issues"

PACKAGE_MANIFEST=`cat "$MANIFEST_FILE"`

PACKAGE_MANIFEST=$(
    echo "$PACKAGE_MANIFEST" | jq --arg NAME "$REPO_NAME" --arg REPO_URL "$REPO_URL" --arg BUGS_URL "$BUG_URL" \
        '.name = $NAME | .repository.url = $REPO_URL | .bugs.url = $BUGS_URL'
)

PACKAGE_MANIFEST=$(
    echo "$PACKAGE_MANIFEST" | jq 'del(.author, .funding, .collective)'
)

echo $PACKAGE_MANIFEST > "$MANIFEST_FILE"
