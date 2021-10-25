[![Pub](https://img.shields.io/pub/v/ignite_cli.svg?style=popout)](https://pub.dartlang.org/packages/ignite_cli)
[![Test](https://github.com/flame-engine/ignite-cli/workflows/Test/badge.svg?branch=main&event=push)](https://github.com/flame-engine/ignite-cli/actions)
[![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

# ignite-cli

Simple CLI interface for Ignite; scaffold and setup your Flame projects with ease.

## Usage

Install it via pub (or build from src if you prefer the latest version):

```bash
pub global activate ignite_cli
```

Then you can run commands like `ignite --version` or `ignite create`.

## Instructions

Run

```bash
cd test
./run.sh
```

To run all tests. Always make sure the build is green.

In order to run the application locally, run

```bash
dart bin/ignite_cli.dart
```

## Managing Templates

This project uses [package:mason](https://pub.dev/packages/mason) to manage and generate templates (bricks).

All supported bricks can be found in the [bricks](./bricks) directory.

Whenever a new brick is added or an existing brick is modified, make sure to regenerate the corresponding bundles via:

```bash
mason bundle bricks/<BRICK-NAME> -t dart -o lib/templates
```

This will generate a new bundle for `<BRICK-NAME>` under `lib/templates`.

## Credits

This project was created with [Dart Stagehand](https://github.com/dart-lang/stagehand).
