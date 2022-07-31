import 'dart:io';

import 'package:args/args.dart';
import 'package:dartlin/dartlin.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/templates/template.dart';
import 'package:ignite_cli/utils.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:mason/mason.dart';
import 'package:process_run/process_run.dart';

Future<void> createCommand(ArgResults command) async {
  final interactive = command['interactive'] != 'false';

  stdout.write('\nWelcome to ${ansi.red.wrap('Ignite CLI')}! 🔥\n');
  stdout.write("Let's create a new project!\n\n");

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
    desc: 'Note: this is a dot separated list of "packages", '
        'normally in reverse domain notation. '
        'For example: org.flame_engine.games',
  );

  final versions = FlameVersionManager.singleton.versions;
  final flameVersions = versions[Package.flame]!;
  final flameVersion = getOption(
    command,
    interactive,
    'flame-version',
    'Which Flame version do you wish to use?',
    flameVersions.versions.associateWith((e) => e),
  );

  final extraPackageOptions = FlameVersionManager.singleton.versions.keys
      .where((key) => !Package.includedByDefault.contains(key))
      .map((key) => key.name)
      .toList();
  final extraPackages = getMultiOption(
    command,
    interactive,
    'extra-packages',
    'Which extra packages do you wish to include?',
    false,
    extraPackageOptions,
    startingOptions: Package.preSelectedByDefault.map((e) => e.name).toList(),
  );
  final packages = extraPackages
      .map(Package.valueOf)
      .toSet()
      .union(Package.includedByDefault);

  // TODO(luan) use partition function
  final dependencies = packages.where((e) => !e.isDevDependency);
  final devDependencies = packages.where((e) => e.isDevDependency);

  final currentDir = Directory.current.path;
  print('\nYour current directory is: $currentDir');

  final createFolder = getOption(
        command,
        interactive,
        'create-folder',
        'Do you want to put your project files directly on the current dir, '
            'or do you want to create a folder called $name?',
        {
          'Create a folder called $name': 'true',
          'Put the files directly on $currentDir': 'false',
        },
      ) ==
      'true';

  print('\n');
  final template = getOption(
    command,
    interactive,
    'template',
    'What template would you like to use for your new project?',
    Template.templates
        .associate((e) => Pair('${e.name}: ${e.description}', e.key)),
  );

  final actualDir = '$currentDir${createFolder ? '/$name' : ''}';
  if (createFolder) {
    await runExecutableArguments('mkdir', [actualDir]);
  }
  print('\nRunning flutter create on $actualDir ...');

  await runExecutableArguments(
    'flutter',
    'create --org $org --project-name $name .'.split(' '),
    workingDirectory: actualDir,
    verbose: true,
  );
  await runExecutableArguments(
    'rm',
    '-rf lib test'.split(' '),
    workingDirectory: actualDir,
    verbose: true,
  );

  final bundle = Template.byKey(template).bundle;
  final generator = await MasonGenerator.fromBundle(bundle);
  final target = DirectoryGeneratorTarget(
    Directory(actualDir),
  );
  final variables = <String, dynamic>{
    'name': name,
    'description': 'A simple Flame game.',
    'version': '0.1.0',
    'extra-dependencies':
        dependencies.map((package) => package.toMustache(versions)).toList(),
    'extra-dev-dependencies':
        devDependencies.map((package) => package.toMustache(versions)).toList(),
  };
  final files = await generator.generate(target, vars: variables);

  final canHaveTests = devDependencies.contains(Package.flameTest);
  if (!canHaveTests) {
    await runExecutableArguments(
      'rm',
      '-rf test'.split(' '),
      workingDirectory: actualDir,
      verbose: true,
    );
  }

  print('Updated ${files.length} files on top of flutter create.\n');
  print('Your new Flame project was successfully created!');
}
