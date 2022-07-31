#!/bin/bash -xe

rm -rf lib/templates/bricks
# TODO(luan): use a wildcard once supported
mason bundle bricks/simple -t dart -o lib/templates/bricks/
mason bundle bricks/basics -t dart -o lib/templates/bricks/
mason bundle bricks/example -t dart -o lib/templates/bricks/
