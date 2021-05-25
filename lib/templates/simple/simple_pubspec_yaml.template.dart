String data({
  required String name,
  required String description,
  required String version,
  required String flameVersion,
}) =>
    '''name: $name
description: $description
version: $version

publish_to: 'none'

environment:
  sdk: ">=2.10.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flame: $flameVersion

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: false''';
