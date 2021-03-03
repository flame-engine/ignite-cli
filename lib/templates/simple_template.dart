import 'template.dart';

class SimpleTemplate extends Template {
  @override
  Future<void> apply(String projectDir, Variables variables) async {
    await copyFile(
      '$templatesFolder/simple_pubspec.yaml.template',
      '$projectDir/pubspec.yaml',
      {
        'name': variables.name,
        'description': 'A simple Flame game.',
        'flame-version': variables.flameVersion,
      },
    );
    await copyFile(
      '$templatesFolder/simple_main.dart.template',
      '$projectDir/lib/main.dart',
      {},
    );
    await rmFile('$projectDir/test/widget_test.dart');
    await rmDir('$projectDir/integration_test');
  }
}
