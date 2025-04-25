import 'dart:io';

import 'package:args/args.dart';
import 'package:dartlin/dartlin.dart';
import 'package:ignite_cli/commands/ignite_command.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/templates/template.dart';
import 'package:ignite_cli/utils.dart';
import 'package:mason/mason.dart';
import 'package:process_run/process_run.dart';

class CreateCommand extends IgniteCommand {
  CreateCommand(super.context) {
    final packages = context.flameVersionManager.versions;
    final flameVersions = packages[Package.flame]!;

    argParser.addFlag(
      'interactive',
      abbr: 'i',
      help: 'Whether to run in interactive mode or not.',
      defaultsTo: true,
    );
    argParser.addOption(
      'name',
      help: 'The name of your game (valid dart identifier).',
    );
    argParser.addOption(
      'org',
      help: 'The org name, in reverse domain notation '
          '(package name/bundle identifier).',
    );
    argParser.addFlag(
      'create-folder',
      abbr: 'f',
      help: 'If you want to create a new folder on the current location with '
          "the project name or if you are already on the new project's folder.",
    );
    argParser.addOption(
      'template',
      help: 'What Flame template you would like to use for your new project',
      allowed: ['simple', 'example'],
    );
    argParser.addOption(
      'flame-version',
      help: 'What Flame version you would like to use.',
      allowed: [
        ...flameVersions.versions.take(5),
        '...',
        flameVersions.versions.last,
      ],
    );
    argParser.addMultiOption(
      'extra-packages',
      help: 'Which packages to use',
      allowed: packages.keys.map((e) => e.name).toList(),
    );
  }

  @override
  String get description => 'Create a new Flame project';

  @override
  String get name => 'create';

  @override
  Future<ExitCode> run() async {
    final argResults = this.argResults;
    if (argResults == null) {
      return ExitCode.usage;
    }

    await createCommand(
      context.logger,
      argResults,
      context.flameVersionManager,
    );

    return ExitCode.success;
  }
}

Future<void> createCommand(
  Logger logger,
  ArgResults command,
  FlameVersionManager flameVersionManager,
) async {
  final interactive = command['interactive'] != 'false';

  if (interactive) {
    logger
      ..info('\nWelcome to ${red.wrap('Ignite CLI')}! 🔥')
      ..info("Let's create a new project!\n");
  }

  final name = getString(
    isInteractive: interactive,
    logger: logger,
    command,
    'name',
    'Choose a name for your project',
    desc: 'Note: this must be a valid dart identifier (no dashes). '
        'For example: my_game',
    validate: (it) => switch (it) {
      _ when it.isEmpty => 'Name cannot be empty',
      _ when it.contains('-') => 'Name cannot contain dashes',
      _ when it == 'test' => 'Name cannot be "test", '
          'as it conflicts with the Dart package',
      _ => null,
    },
  );

  final org = getString(
    logger: logger,
    isInteractive: interactive,
    command,
    'org',
    'Choose an org for your project: ',
    desc: 'Note: this is a dot separated list of "packages", '
        'normally in reverse domain notation. '
        'For example: org.flame_engine.games',
    validate: (it) => switch (it) {
      _ when it.isEmpty => 'Org cannot be empty',
      _ when it.contains('-') => 'Org cannot contain dashes',
      _ => null,
    },
  );

  final versions = flameVersionManager.versions;
  final flameVersions = versions[Package.flame]!;
  final flameVersion = getOption(
    logger: logger,
    isInteractive: interactive,
    command,
    'flame-version',
    'Which Flame version do you wish to use?',
    flameVersions.visible.associateWith((e) => e),
    defaultsTo: flameVersions.versions.first,
    fullOptions: flameVersions.versions.associateWith((e) => e),
  );

  final extraPackageOptions = flameVersionManager.versions.keys
      .where((key) => !Package.includedByDefault.contains(key))
      .map((key) => key.name)
      .toList();
  final extraPackages = getMultiOption(
    logger: logger,
    isInteractive: interactive,
    isRequired: false,
    command,
    'extra-packages',
    'Which extra packages do you wish to include?',
    extraPackageOptions,
    startingOptions: Package.preSelectedByDefault.map((e) => e.name).toList(),
  );
  final packages = extraPackages
      .map(Package.valueOf)
      .toSet()
      .union(Package.includedByDefault);

  // TODO(luan): use partition function
  final dependencies = packages.where((e) => !e.isDevDependency);
  final devDependencies = packages.where((e) => e.isDevDependency);

  final currentDir = Directory.current.path;
  logger.info('\nYour current directory is: $currentDir');

  final createFolder = getOption(
        logger: logger,
        isInteractive: interactive,
        command,
        'create-folder',
        'Do you want to put your project files directly on the current dir, '
            'or do you want to create a folder called $name?',
        {
          'Create a folder called $name': 'true',
          'Put the files directly on $currentDir': 'false',
        },
      ) ==
      'true';

  logger.info('\n');
  final template = getOption(
    logger: logger,
    isInteractive: interactive,
    command,
    'template',
    'What template would you like to use for your new project?',
    Template.templates
        .associate((e) => Pair('${e.name}: ${e.description}', e.key)),
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
    verbose: logger.level == Level.verbose,
  );

  await runExecutableArguments(
    'rm',
    '-rf lib test'.split(' '),
    workingDirectory: actualDir,
    verbose: logger.level == Level.verbose,
  );

  final bundle = Template.byKey(template).bundle;
  final generator = await MasonGenerator.fromBundle(bundle);
  final target = DirectoryGeneratorTarget(Directory(actualDir));

  final variables = <String, dynamic>{
    'name': name,
    'description': 'A simple Flame game.',
    'version': '0.1.0',
    'extra-dependencies': dependencies
        .sortedBy((e) => e.name)
        .map((package) => package.toMustache(versions, flameVersion))
        .toList(),
    'extra-dev-dependencies': devDependencies
        .sortedBy((e) => e.name)
        .map((package) => package.toMustache(versions, flameVersion))
        .toList(),
  };
  final files = await generator.generate(target, vars: variables);

  final canHaveTests = devDependencies.contains(Package.flameTest);
  if (!canHaveTests) {
    await runExecutableArguments(
      'rm',
      '-rf test'.split(' '),
      workingDirectory: actualDir,
      verbose: logger.level == Level.verbose,
    );
  }

  await runExecutableArguments(
    'flutter',
    'pub get'.split(' '),
    workingDirectory: actualDir,
    verbose: logger.level == Level.verbose,
  );

  // logger.info('Updated ${files.length} files on top of flutter create.\n');
  logger.info('Your new Flame project was successfully created!');
}
