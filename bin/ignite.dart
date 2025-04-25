import 'dart:io';

import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/main.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> main(List<String> args) async {
  final runner = IgniteCommandRunner(
    logger: Logger(),
    flameVersionManager: await FlameVersionManager.fetch(),
  );

  exit((await runner.run(args)).code);
}
