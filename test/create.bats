#!/usr/bin/env bats

source ./_inc.sh

@test "create requires org" {
  result=$(clean_ignite create)
  expected=$(clean "The org option is required.")
  [[ "$result" == "$expected" ]]
}

@test "create requires name" {
  result=$(clean_ignite create --org xyz.luan)
  expected=$(clean "The name option is required.")
  [[ "$result" == "$expected" ]]
}

@test "create new flutter project with correct project name and org" {
  ignite create --org xyz.luan --name my_game
  result=$(cat pubspec.yaml | grep "name: my_game")
  echo "result = $result"

  [[ "$result" == "name: not_my_game" ]]
}
