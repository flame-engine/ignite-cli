import 'package:ignite_cli/version.g.dart';
import 'package:process_run/process_run.dart';

Future<void> versionCommand() async {
  print(r'$ ignite --version:');
  print(igniteVersion);
  print('');
  await runExecutableArguments('dart', ['--version'], verbose: true);
  print('');
  await runExecutableArguments('flutter', ['--version'], verbose: true);
}
