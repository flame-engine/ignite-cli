import 'dart:io';

import 'package:args/args.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;
import 'package:prompts/prompts.dart' as prompts;

String getBundledFile(String name) {
  final binFolder = p.dirname(p.fromUri(Platform.script));
  return p.join(binFolder, '..', name);
}

String getString(
  ArgResults results,
  bool isInteractive,
  String name,
  String message, {
  String desc,
}) {
  var value = results[name] as String;
  if (!isInteractive) {
    if (value == null || value.isEmpty) {
      print('Missing parameter $name is required.');
      exit(1);
    }
  }
  while (value == null || value.isEmpty) {
    if (desc != null) {
      stdout.write(ansi.darkGray.wrap('\n$desc\u{1B}[1A\r'));
    }
    value = prompts.get(message, validate: (it) => !it.contains('-'));
    if (desc != null) {
      stdout.write('\r\u{1B}[K');
    }
  }
  return value;
}

String getOption(
  ArgResults results,
  bool isInteractive,
  String name,
  String message,
  Map<String, String> options, {
  String desc,
}) {
  var value = results[name] as String;
  if (!isInteractive) {
    if (value == null) {
      print('Missing parameter $name is required.');
      exit(1);
    }
  }
  if (value != null && !options.values.contains(value)) {
    print('Invalid value $value provided. Must be in: ${options.values}');
    value = null;
  }
  while (value == null) {
    if (desc != null) {
      stdout.write(ansi.darkGray.wrap('\n$desc\u{1B}[1A\r'));
    }
    value = options[prompts.choose(message, options.keys)];
    if (desc != null) {
      stdout.write('\r\u{1B}[K');
    }
  }
  return value;
}
