import 'dart:io';

import 'package:args/args.dart';
import 'package:process_run/process_run.dart';

import 'templates/template.dart';
import 'utils.dart';

Future<void> createCommand(ArgResults command) async {
  final interactive = command['interactive'] != 'false';

  final name = getString(
    command,
    interactive,
    'name',
    'Choose a name for your project: ',
    desc: 'Note: this must be a valid dart identifier (no dashes).',
  );

  final org = getString(
    command,
    interactive,
    'org',
    'Choose an org for your project: ',
    desc:
        'Note: this is a dot separated list of "packages", normally in reverse domain notation.',
  );

  final currentDir = Directory.current.path;
  print('\nYour current directory is: $currentDir');

  final createFolder = getOption(
        command,
        interactive,
        'create-folder',
        'Do you want to put your project files directly on the current dir or do you want to create a folder called $name?',
        {
          'Create a folder called $name': 'true',
          'Put the files directly on $currentDir': 'false',
        },
      ) ==
      'true';

  print('');
  final template = getOption(
    command,
    interactive,
    'template',
    'What template would you like to use for your new project?',
    {
      'Simple: an empty Flame project with just the bare minimums to get you up and running.':
          'simple',
      'Example: a very simple example game built on top of Simple; give you some ideas of how to use Flame if you are new.':
          'example',
    },
  );

  final actualDir = '$currentDir${createFolder ? '/$name' : ''}';
  if (createFolder) {
    await run('mkdir', [actualDir]);
  }
  print('\nRunning flutter create on $actualDir ...');

  await run(
    'flutter',
    'create --org $org --project-name $name .'.split(' '),
    workingDirectory: actualDir,
    verbose: true,
  );

  final variables = Variables(name);
  await getTemplateForName(template).apply(actualDir, variables);
  print('Your new Flame project was successfully created!');
}
