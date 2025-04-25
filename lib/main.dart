import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ignite_cli/commands/create_command.dart';
import 'package:ignite_cli/commands/ignite_command.dart';
import 'package:ignite_cli/commands/version_command.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason_logger/mason_logger.dart';

class IgniteCommandRunner extends CommandRunner<ExitCode> {
  late final IgniteContext context;

  IgniteCommandRunner({
    required Logger logger,
    required FlameVersionManager flameVersionManager,
  }) : super(_name, _description) {
    context = IgniteContext(
      logger: logger,
      flameVersionManager: flameVersionManager,
    );

    addCommand(CreateCommand());

    argParser.addFlag(
      'version',
      help: 'Print the current version.',
      negatable: false,
    );
  }

  @override
  void addCommand(covariant ContextProvider<ExitCode> command) {
    // forces commands to use the [ContextProvider] mixin on any new commands
    super.addCommand(command);
  }

  @override
  Future<ExitCode> run(Iterable<String> args) async {
    try {
      final parsedArgs = parse(args);

      if (parsedArgs['version'] == true) {
        await versionCommand(context.logger);
        return ExitCode.success;
      }

      return await runCommand(parsedArgs) ?? ExitCode.success;
    } on FormatException catch (exception) {
      context.logger
        ..err(exception.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage;
    } on UsageException catch (exception) {
      context.logger
        ..err(exception.message)
        ..info('')
        ..info(exception.usage);
      return ExitCode.usage;
    } on ProcessException catch (error) {
      context.logger.err(error.message);
      return ExitCode.unavailable;
    } on Exception catch (error) {
      context.logger.err('$error');
      return ExitCode.software;
    }
  }

  static const _name = 'ignite';
  static const _description = 'Ignite your projects with flame; '
      'a CLI scaffolding tool to create and setup your Flame projects.';
}
