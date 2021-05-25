import 'dart:io';

import 'package:process_run/process_run.dart';
import 'package:yaml/yaml.dart';

import '../utils.dart';

Future<void> versionCommand() async {
  print('\$ ignite --version:');
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
