import '../template.dart';
import 'simple_main_dart.template.dart' as main;
import 'simple_pubspec_yaml.template.dart' as pubspec;

class SimpleTemplate extends Template {
  @override
  Future<void> apply(String projectDir, Variables variables) async {
    await Future.wait([
      createFile(
        '$projectDir/lib/main.dart',
        main.data(),
      ),
      createFile(
        '$projectDir/pubspec.yaml',
        pubspec.data(
          name: variables.name,
          description: 'A simple Flame game.',
          version: '0.1.0',
          flameVersion: variables.flameVersion,
        ),
      ),
      rmFile('$projectDir/test/widget_test.dart'),
      rmDir('$projectDir/integration_test'),
    ]);
  }
}
