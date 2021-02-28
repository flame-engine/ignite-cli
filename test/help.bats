#!/usr/bin/env bats

source ./_inc.sh

@test "help error with no arg" {
  result=$(clean_ignite)
  expected=$(clean "Invalid command. Please select an option, use --help for help.")
  [[ "$result" == "$expected" ]]
}

@test "display help with --help" {
  result=$(clean_ignite --help)
  expected=$(clean "-h, --[no-]help Displays this message. -v, --[no-]version Shows relevant version info. List of available commands: create:")
  echo $result
  [[ "$result" == "$expected"* ]]
}

@test "display help with -h" {
  result=$(clean_ignite -h)
  expected=$(clean "-h, --[no-]help Displays this message. -v, --[no-]version Shows relevant version info. List of available commands: create:")
  [[ "$result" == "$expected"* ]]
}
