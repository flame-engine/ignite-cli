import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;
import 'package:ignite_cli/commands/create_command.dart';
import 'package:ignite_cli/commands/version_command.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> mainCommand(List<String> args) async {
  await FlameVersionManager.init();

  final parser = ArgParser();
  final logger = Logger();

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
    help: 'The org name, in reverse domain notation '
        '(package name/bundle identifier).',
  );
  create.addOption(
    'create-folder',
    abbr: 'f',
    help: 'If you want to create a new folder on the current location with '
        "the project name or if you are already on the new project's folder.",
    allowed: ['true', 'false'],
  );
  create.addOption(
    'template',
    help: 'What Flame template you would like to use for your new project',
    allowed: ['simple', 'example'],
  );

  final packages = FlameVersionManager.singleton.versions;
  final flameVersions = packages[Package.flame]!;
  create.addOption(
    'flame-version',
    help: 'What Flame version you would like to use.',
    allowed: flameVersions.versions,
  );
  create.addMultiOption(
    'extra-packages',
    help: 'Which packages to use',
    allowed: packages.keys.map((e) => e.name).toList(),
  );

  final results = completion.tryArgsCompletion(args, parser);
  if (results['help'] as bool) {
    logger.info(parser.usage);
    logger.info('');
    logger.info('List of available commands:');
    logger.info('');
    logger.info('create:');
    logger.info('  ${create.usage}');
    return;
  } else if (results['version'] as bool) {
    await versionCommand(logger);
    return;
  }

  final command = results.command;
  if (command?.name == 'create') {
    await createCommand(command!, logger);
  } else {
    logger.info(
      'Invalid command. Please select an option, use --help for help.',
    );
  }
}
