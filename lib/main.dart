import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;

import 'commands/create_command.dart';
import 'commands/version_command.dart';
import 'flame_versions.dart';

void mainCommand(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag('help', abbr: 'h', help: 'Displays this message.');
  parser.addFlag('version', abbr: 'v', help: 'Shows relevant version info.');

  final create = parser.addCommand('create');
  create.addOption(
    'interactive',
    abbr: 'i',
    help: 'Whether to run in interactive mode or not.',
    allowed: ['true', 'false'],
    defaultsTo: 'true',
  );
  create.addOption(
    'name',
    help: 'The name of your game (valid dart identifier).',
  );
  create.addOption(
    'org',
    help:
        'The org name, in reverse domain notation (package name/bundle identifier).',
  );
  create.addOption(
    'create-folder',
    abbr: 'f',
    help:
        "If you want to create a new folder on the current location with the project name or if you are already on the new project's folder.",
    allowed: ['true', 'false'],
  );
  create.addOption(
    'template',
    help: 'What Flame template you would like to use for your new project',
    allowed: ['simple', 'example'],
  );
  create.addOption(
    'flame-version',
    help: 'What Flame version you would like to use.',
    allowed: flameVersions.values,
    defaultsTo: flameVersions.values.first,
  );

  final results = completion.tryArgsCompletion(args, parser);
  if (results['help'] as bool) {
    print(parser.usage);
    print('');
    print('List of available commands:');
    print('');
    print('create:');
    print('  ${create.usage}');
    return;
  } else if (results['version'] as bool) {
    await versionCommand();
    return;
  }

  final command = results.command;
  if (command?.name == 'create') {
    await createCommand(command);
  } else {
    print('Invalid command. Please select an option, use --help for help.');
  }
}
