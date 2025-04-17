[![Pub](https://img.shields.io/pub/v/ignite_cli.svg?style=popout)](https://pub.dartlang.org/packages/ignite_cli)
[![Test](https://github.com/flame-engine/ignite-cli/workflows/Test/badge.svg)](https://github.com/flame-engine/ignite-cli/actions)
[![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

# ignite-cli

Simple CLI interface for Ignite; scaffold and setup your Flame projects with ease.


## Usage

Install it via pub (or build from src if you prefer the latest version):

```bash
flutter pub global activate ignite_cli
```

After you have added the bin folder to your path (the previous command will tell you what to add),
you can create a new project with Ignite, just run:

```bash
ignite create
```

And follow the instructions (this is called interactive mode - you might need a compatible shell for the interactive pickers to work).

Alternatively, you can set `--interactive=false` and manually specify all required options (error messages will be your friend):

```bash
ignite create --interactive=false --name=my_flame_game --org=org.flame-engine.example --create-folder=true --template=example
```


## Instructions for contributors

Run

```bash
cd test
./run.sh
```

To run all tests. Always make sure the build is green.

You will need to install the bash testing framework [bats](https://bats-core.readthedocs.io/en/stable/installation.html).

In order to run the application locally, run

```bash
dart bin/ignite_cli.dart
```


### Managing Templates

This project uses [package:mason](https://pub.dev/packages/mason) to manage and generate templates (bricks).

All supported bricks can be found in the [bricks](./bricks) directory.

Whenever a new brick is added or an existing brick is modified, make sure to regenerate the corresponding bundles via:

```bash
./scripts/build.sh
```


## Credits

This project was created with [Dart Stagehand](https://github.com/dart-lang/stagehand) and uses [Mason](https://pub.dev/packages/mason) for templating.
