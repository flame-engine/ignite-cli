import 'dart:io';

import 'package:path/path.dart' as p;

import 'simple_template.dart';

class Variables {
  String name;
  Variables(this.name);
}

abstract class Template {
  Future<void> apply(String projectDir, Variables variables);

  String get templatesFolder {
    final binFolder = p.dirname(p.fromUri(Platform.script));
    return p.join(binFolder, '..', 'templates');
  }

  Future<void> copyFile(String from, String to) {
    return File(from).copy(to);
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
