#!/usr/bin/env bats

function _pipe_clean {
  tr -d '[:space:]'
}

function clean {
  echo $1 | _pipe_clean
}

function ignite {
  dart ../../bin/ignite.dart "$@" 3>&-
}

function clean_ignite {
  ignite "$@" | _pipe_clean
}

function setup {
  rm -rf test_dir
  mkdir test_dir
  cd test_dir
}

function teardown {
  rm -rf test_dir
}
