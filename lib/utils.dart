import 'dart:io';

import 'package:args/args.dart';
import 'package:prompts/prompts.dart' as prompts;
import 'package:io/ansi.dart' as ansi;

String getString(
  ArgResults results,
  String name,
  String message, {
  String desc,
}) {
  var value = results[name] as String;
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

T getOption<T>(
  ArgResults results,
  String name,
  String message,
  Map<String, T> options, {
  String desc,
}) {
  var value = results[name] as T;
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
