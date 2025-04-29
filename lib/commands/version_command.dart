import 'dart:math';

import 'package:ignite_cli/commands/ignite_command.dart';
import 'package:ignite_cli/version.g.dart';

Future<int> versionCommand(IgniteContext context) async {
  context.logger.info('ignite --version: $igniteVersion\n');

  final (dartProcess, flutterProcess) = await (
    context.process.run('dart', ['--version']),
    context.process.run('flutter', ['--version']),
  ).wait;

  if (dartProcess.stdout case final String out) {
    context.logger.info(out);
  }

  if (flutterProcess.stdout case final String out) {
    context.logger.info(out);
  }

  if (dartProcess.stderr case final String err when err.isNotEmpty) {
    context.logger.err(err);
  }

  if (flutterProcess.stderr case final String err when err.isNotEmpty) {
    context.logger.err(err);
  }

  return max<int>(dartProcess.exitCode, flutterProcess.exitCode);
}
