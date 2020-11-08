#!/usr/bin/env bats

source ./_inc.sh

@test "help error with no arg" {
  result=$(ignite)
  expected=$(clean "Invalid command. Please select an option, use --help for help.")
  [[ "$result" == "$expected" ]]
}

@test "display help with --help" {
  result=$(ignite --help)
  expected=$(clean "-h, --[no-]help Displays this message. -v, --[no-]version Shows relevant version info. List of available commands: create: --name The name of your game (valid dart identifier). --org The org name, in reverse domain notation (package name/bundle identifier).")
  [[ "$result" == "$expected" ]]
}

@test "display help with -h" {
  # result=$(ignite -h)
  results='false'
  expected=$(clean "-h, --[no-]help Displays this message. -v, --[no-]version Shows relevant version info. List of available commands: create: --name The name of your game (valid dart identifier). --org The org name, in reverse domain notation (package name/bundle identifier).")
  [[ "$result" == "$expected" ]]
}
