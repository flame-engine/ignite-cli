import 'template.dart';
import 'package:process_run/process_run.dart';

class SimpleTemplate extends Template {
  @override
  Future<void> apply(String projectDir, Variables variables) async {
    await run(
      'cp',
      [
        '$templatesFolder/simple_main.dart.template',
        '$projectDir/lib/main.dart',
      ],
    );
    await run(
      'cp',
      [
        '$templatesFolder/simple_pubspec.yaml.template',
        '$projectDir/pubspec.yaml',
      ],
    );
    await run(
      'sed',
      '-ie s/\\\${name}/${variables.name}/ $projectDir/pubspec.yaml'.split(' '),
    );
    await run('rm', ['$projectDir/test/widget_test.dart']);
    await run('rm', ['$projectDir/integration_test/app_test.dart']);
  }
}
