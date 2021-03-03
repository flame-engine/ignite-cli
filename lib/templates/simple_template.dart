import 'package:process_run/process_run.dart';

import 'template.dart';

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
    await rmDir('$projectDir/integration_test');
  }
}
