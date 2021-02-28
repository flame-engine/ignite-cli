#!/usr/bin/env bats

source ./_inc.sh

@test "create requires name" {
  result=$(clean_ignite create -i false)
  expected=$(clean "Missing parameter name is required.")
  [[ "$result" == "$expected" ]]
}

@test "create requires org" {
  result=$(clean_ignite create --name foo -i false)
  expected=$(clean "Missing parameter org is required.")
  [[ "$result" == "$expected" ]]
}

@test "create new flutter project with correct project name and org" {
  ignite create --org xyz.luan --name my_game -i false --create-folder false --template simple
  result=$(cat pubspec.yaml | grep "name: my_game")
  [[ "$result" == "name: my_game" ]]
  result=$(cat pubspec.yaml | grep "flame: 1.0.0-rc5")
  [[ "$result" == *"flame: 1.0.0-rc5" ]]
  result=$(wc -l < lib/main.dart)
  [ "$result" -le 10 ]
}
