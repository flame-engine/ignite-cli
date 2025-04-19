import 'package:ignite_cli/version.g.dart';
import 'package:mason/mason.dart';
import 'package:process_run/process_run.dart';

Future<void> versionCommand(Logger logger) async {
  logger.detail(r'$ ignite --version:');
  logger.detail(igniteVersion);
  logger.detail('');
  await runExecutableArguments('dart', ['--version'], verbose: true);
  logger.detail('');
  await runExecutableArguments('flutter', ['--version'], verbose: true);
}
