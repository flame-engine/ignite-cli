import 'dart:io';

import 'template.dart';
import 'package:process_run/process_run.dart';

class SimpleTemplate extends Template {
  @override
  Future<void> apply(String projectDir, Variables variables) async {
    await copyFile(
      '$templatesFolder/simple_main.dart.template',
      '$projectDir/lib/main.dart',
    );
    await copyFile(
      '$templatesFolder/simple_pubspec.yaml.template',
      '$projectDir/pubspec.yaml',
    );
    await run(
      'sed',
      '-ie s/\\\${name}/${variables.name}/ $projectDir/pubspec.yaml'.split(' '),
    );
    await rmFile('$projectDir/test/widget_test.dart');
    await rmFile('$projectDir/integration_test/app_test.dart');
  }
}
