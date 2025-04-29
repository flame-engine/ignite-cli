import 'dart:io' show Directory, Process, ProcessResult;

import 'package:ignite_cli/flame_version_manager.dart';
import 'package:mason/mason.dart';

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

  Future<MasonGenerator> generatorFromBundle(MasonBundle bundle) {
    return MasonGenerator.fromBundle(bundle);
  }

  DirectoryGeneratorTarget createTarget(Directory directory) {
    return DirectoryGeneratorTarget(directory);
  }
}
