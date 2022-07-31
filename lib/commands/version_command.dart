import 'dart:io';

import 'package:ignite_cli/utils.dart';
import 'package:process_run/process_run.dart';
import 'package:yaml/yaml.dart';

Future<void> versionCommand() async {
  print(r'$ ignite --version:');
  print(await getVersionFromPubspec());
  print('');
  await runExecutableArguments('dart', ['--version'], verbose: true);
  print('');
  await runExecutableArguments('flutter', ['--version'], verbose: true);
}

Future<String> getVersionFromPubspec() async {
  final f = File(getBundledFile('pubspec.yaml'));
  final yaml = loadYaml(await f.readAsString()) as Map;
  return yaml['version'] as String;
}
