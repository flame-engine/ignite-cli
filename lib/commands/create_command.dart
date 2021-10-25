import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:process_run/process_run.dart';

import '../flame_versions.dart';
import '../templates/template.dart';
import '../utils.dart';

Future<void> createCommand(ArgResults command) async {
  final logger = Logger();
  final interactive = command['interactive'] != 'false';

  final name = getString(
    command,
    interactive,
    'name',
    'Choose a name for your project: ',
    desc:
        'Note: this must be a valid dart identifier (no dashes). For example: my_game',
  );

  final org = getString(
    command,
    interactive,
    'org',
    'Choose an org for your project: ',
    desc:
        'Note: this is a dot separated list of "packages", normally in reverse domain notation. For example: org.flame_engine.games',
  );

  final flameVersion = getOption(
    command,
    interactive,
    'flame-version',
    'Which Flame version do you wish to use?',
    flameVersions,
  );

  final currentDir = Directory.current.path;
  logger.info('\nYour current directory is: $currentDir');

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

  logger.info('');
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
    await runExecutableArguments('mkdir', [actualDir]);
  }
  logger.info('\nRunning flutter create on $actualDir ...');

  await runExecutableArguments(
    'flutter',
    'create --org $org --project-name $name .'.split(' '),
    workingDirectory: actualDir,
    verbose: true,
  );

  final bundle = getBundleForName(template);
  final generator = await MasonGenerator.fromBundle(bundle);
  final generateDone = logger.progress('Generating $name');
  final target = DirectoryGeneratorTarget(
    Directory(actualDir),
    logger,
    FileConflictResolution.overwrite,
  );
  final variables = <String, dynamic>{
    'name': name,
    'description': 'A simple Flame game.',
    'flame-version': flameVersion,
  };
  final files = await generator.generate(target, vars: variables);
  generateDone('Generated $files file(s)');
  logger.success('Your new Flame project was successfully created!');
}
