import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ignite_cli/commands/create_command.dart';
import 'package:ignite_cli/commands/ignite_command.dart';
import 'package:ignite_cli/commands/version_command.dart';
import 'package:mason_logger/mason_logger.dart';

class IgniteCommandRunner extends CommandRunner<int> {
  late IgniteContext context;

  IgniteCommandRunner(this.context) : super('ignite', _description) {
    addCommand(CreateCommand(context));
    argParser.addFlag('verbose');
    argParser.addFlag(
      'version',
      help: 'Print the current version.',
      negatable: false,
    );
  }

  @override
  void printUsage() => context.logger.info(usage);

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final parsedArgs = parse(args);

      if (parsedArgs['verbose'] == true) {
        context.logger.level = Level.verbose;
      }

      if (parsedArgs['version'] == true) {
        return await versionCommand(context);
      }

      return await runCommand(parsedArgs) ?? ExitCode.success.code;
    } on FormatException catch (exception) {
      context.logger
        ..err(exception.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (exception) {
      context.logger
        ..err(exception.message)
        ..info('')
        ..info(exception.usage);
      return ExitCode.usage.code;
    } on ProcessException catch (error) {
      context.logger.err(error.message);
      return ExitCode.unavailable.code;
    } on Exception catch (error) {
      context.logger.err('$error');
      return ExitCode.software.code;
    }
  }

  static const _description = 'Ignite your projects with Flame; '
      'a CLI scaffolding tool to create and setup your Flame projects.';
}
