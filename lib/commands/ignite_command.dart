import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason/mason.dart';
import 'package:mason_logger/mason_logger.dart';

abstract class IgniteCommand extends Command<ExitCode> {
  final IgniteContext context;

  IgniteCommand(this.context);

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
