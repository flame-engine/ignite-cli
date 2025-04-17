#!/bin/bash -xe

./scripts/build.sh
./scripts/analyze.sh
(cd test ; ./run.sh)