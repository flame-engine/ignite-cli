import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason/mason.dart';
import 'package:mason_logger/mason_logger.dart';

abstract class IgniteCommand extends Command<ExitCode> {
  late IgniteContext context;

  void setup(ArgParser argParser);

  @override
  void addSubcommand(Command<ExitCode> command) {
    if (command is IgniteCommand) {
      command
        ..context = context
        ..setup(command.argParser);
    }

    super.addSubcommand(command);
  }

  @override
  Future<ExitCode> run();
}

class IgniteContext {
  const IgniteContext({
    required this.logger,
    required this.flameVersionManager,
  });

  final Logger logger;
  final FlameVersionManager flameVersionManager;
}
