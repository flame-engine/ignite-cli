import 'package:ignite_cli/version.g.dart';
import 'package:mason/mason.dart';
import 'package:process_run/process_run.dart';

Future<void> versionCommand(Logger logger) async {
  logger.info('ignite --version: $igniteVersion\n');

  final [dartProcess, flutterProcess] = await [
    runExecutableArguments(
      'dart',
      ['--version'],
      commandVerbose: false,
      verbose: false,
    ),
    runExecutableArguments(
      'flutter',
      ['--version'],
      commandVerbose: false,
      verbose: false,
    ),
  ].wait;

  logger.info('${dartProcess.stdout}');
  logger.info('${flutterProcess.stdout}');

  if (dartProcess.stderr case final String err when err.isNotEmpty) {
    logger.err(err);
  }
  if (flutterProcess.stderr case final String err when err.isNotEmpty) {
    logger.err(err);
  }
}
