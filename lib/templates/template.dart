import 'package:ignite_cli/templates/bricks/basics_bundle.dart';
import 'package:ignite_cli/templates/bricks/example_bundle.dart';
import 'package:ignite_cli/templates/bricks/simple_bundle.dart';
import 'package:mason/mason.dart';

class Template {
  static final templates = [
    Template(
      key: 'simple',
      name: 'Simple',
      description: 'The emptiest possible Flame project. '
          'Just the bare minimum to get you up and running.',
      bundle: simpleBundle,
    ),
    Template(
      key: 'basics',
      name: 'Basics',
      description: 'The basic structure that most games will require. '
          'No boilerplate required, but no extra fluff.',
      bundle: basicsBundle,
    ),
    Template(
      key: 'example',
      name: 'Example',
      description: 'An actual complete, working game example. '
          "Extra code that you won't need but will teach you how to wire the "
          'most important pieces. ',
      bundle: exampleBundle,
    ),
  ];

  final String key;
  final String name;
  final String description;
  final MasonBundle bundle;

  const Template({
    required this.key,
    required this.name,
    required this.description,
    required this.bundle,
  });

  static Template byKey(String key) {
    return templates.firstWhere((e) => e.key == key);
  }
}
