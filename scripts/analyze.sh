#!/usr/bin/env bash

dart pub get

result=$(dart analyze .)
if ! echo "$result" | grep -q "No issues found!"; then
  echo "$result"
  echo "dart analyze issue: $1"
fi

exit 0
