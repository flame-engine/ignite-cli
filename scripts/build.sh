#!/bin/bash -xe

./scripts/generate-version.sh

# TODO(luan): use a wildcard once supported
function bundle {
    dart run mason_cli:mason bundle $1 -t dart -o lib/templates/bricks/
}

rm -rf lib/templates/bricks
bundle bricks/simple
bundle bricks/basics
bundle bricks/example