import 'dart:async';
import 'dart:io' show Process, ProcessResult;

import 'package:args/command_runner.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason/mason.dart';
import 'package:mason_logger/mason_logger.dart';

abstract class IgniteCommand extends Command<int> {
  final IgniteContext context;

  IgniteCommand(this.context);

  @override
  Future<int> run();
}

class IgniteContext {
  const IgniteContext({
    required this.logger,
    required this.flameVersionManager,
  });

  final Logger logger;
  final FlameVersionManager flameVersionManager;

  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
  }) {
    return Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
    );
  }
}
