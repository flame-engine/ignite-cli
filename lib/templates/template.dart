import 'dart:io';

import '../utils.dart';
import 'simple_template.dart';

class Variables {
  String name;
  String flameVersion;
  Variables(this.name, this.flameVersion);
}

abstract class Template {
  Future<void> apply(String projectDir, Variables variables);

  String get templatesFolder => getBundledFile('templates');

  Future<void> copyFile(
    String from,
    String to,
    Map<String, String> variables,
  ) async {
    final input = await File(from).readAsString();
    final output = variables.entries.fold<String>(
      input,
      (lines, element) => lines.replaceAll('\${${element.key}}', element.value),
    );
    await File(to).writeAsString(output);
  }

  Future<void> rmFile(String from) {
    return File(from).delete();
  }

  Future<void> rmDir(String path) async {
    final dir = Directory(path);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }
}

Template getTemplateForName(String name) {
  final template = {
    'simple': SimpleTemplate(),
  }[name];
  if (template == null) {
    throw 'Invalid template $name';
  }
  return template;
}
