import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;
import 'create_command.dart';
import 'package:process_run/process_run.dart';

void mainCommand(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag('help', abbr: 'h', help: 'Displays this message.');
  parser.addFlag('version', abbr: 'v', help: 'Shows relevant version info.');

  final create = parser.addCommand('create');
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
    help:
        'If you want to create a new folder on the current location with the project name or if you are already on the new project\'s folder.',
    allowed: ['true', 'false'],
  );
  create.addOption(
    'template',
    help: 'What Flame template you would like to use for your new project',
    allowed: ['simple', 'example'],
  );

  final results = completion.tryArgsCompletion(args, parser);
  if (results['help']) {
    print(parser.usage);
    print('');
    print('List of available commands:');
    print('');
    print('create:');
    print('  ${create.usage}');
    return;
  } else if (results['version']) {
    print('Current version: TODO fetch version');
    print('');
    print('Dart & Flutter versions:');
    print('');
    await run('dart', ['--version'], verbose: true);
    await run('flutter', ['--version'], verbose: true);
    return;
  }

  final command = results.command;
  if (command?.name == 'create') {
    await createCommand(command);
  } else {
    print('Invalid command. Please select an option, use --help for help.');
  }
}
