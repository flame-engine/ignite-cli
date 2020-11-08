#!/bin/bash -x

# you need to have bats to run the tests
# to install run `pacman -S bash-bats` or similar

echo 'Started running bats'
bats *.bats
echo 'Finished running bats'
