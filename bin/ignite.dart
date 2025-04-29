import 'dart:io';

import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/ignite_command_runner.dart';
import 'package:ignite_cli/ignite_context.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> main(List<String> args) async {
  final manager = await FlameVersionManager.fetch();
  final context = IgniteContext(logger: Logger(), flameVersionManager: manager);
  final runner = IgniteCommandRunner(context);
  final code = await runner.run(args);

  // ensure all buffered output is written before exit
  await Future.wait([stdout.close(), stderr.close()]).then((_) => exit(code));
}
