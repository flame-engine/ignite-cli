import 'dart:io';

import 'package:args/args.dart';
import 'package:io/ansi.dart' as ansi;
import 'package:mason_logger/mason_logger.dart' as logger;
import 'package:path/path.dart' as p;

String getBundledFile(String name) {
  final binFolder = p.dirname(p.fromUri(Platform.script));
  return p.join(binFolder, '..', name);
}

String getString(
  ArgResults results,
  String name,
  String message, {
  required bool isInteractive,
  required logger.Logger logger,
  String? desc,
  String? Function(String)? validate,
}) {
  var value = results[name] as String?;
  if (!isInteractive) {
    if (value == null || value.isEmpty) {
      print('Missing parameter $name is required.');
      exit(1);
    }
    final error = validate?.call(value);
    if (error != null) {
      print('Invalid value $value provided: $error');
      exit(1);
    }
  }
  while (value == null || value.isEmpty) {
    if (desc != null) {
      stdout.write(ansi.darkGray.wrap('\n$desc\u{1B}[1A\r'));
    }

    value = logger.prompt(message);

    // TODO(elijah): validation callback
    if (desc != null) {
      stdout.write('\r\u{1B}[K');
    }
  }
  return value;
}

String getOption(
  ArgResults results,
  String name,
  String message,
  Map<String, String> options, {
  required bool isInteractive,
  required logger.Logger logger,
  String? desc,
  String? defaultsTo,
  Map<String, String> fullOptions = const {},
}) {
  var value = results[name] as String?;

  if (!isInteractive) {
    if (value == null) {
      if (defaultsTo != null) {
        return defaultsTo;
      } else {
        print('Missing parameter $name is required.');
        exit(1);
      }
    }
  }
  final fullValues = {...options, ...fullOptions}.values;
  if (value != null && !fullValues.contains(value)) {
    print('Invalid value $value provided. Must be in: ${options.values}');
    value = null;
  }

  while (value == null) {
    if (desc != null) {
      stdout.write(ansi.darkGray.wrap('\n$desc\u{1B}[1A\r'));
    }

    final option = logger.chooseOne(message, choices: options.keys.toList());
    value = options[option];

    if (desc != null) {
      stdout.write('\r\u{1B}[K');
    }
  }
  return value;
}

List<String> _unwrap(dynamic value) {
  return switch (value) {
    null => [],
    String _ => [value],
    List<String> _ => value,
    List _ => value.map((e) => e.toString()).toList(),
    _ => throw ArgumentError(
        'Invalid type for value (${value.runtimeType}): $value',
      ),
  };
}

List<String> getMultiOption(
  ArgResults results,
  String name,
  String message,
  List<String> options, {
  required bool isInteractive,
  required bool isRequired,
  required logger.Logger logger,
  List<String> startingOptions = const [],
  String? desc,
}) {
  var value = _unwrap(results[name]);
  if (!isInteractive) {
    if (value.isEmpty) {
      if (startingOptions.isNotEmpty) {
        return startingOptions;
      } else {
        print('Missing parameter $name is required.');
        exit(1);
      }
    } else {
      return value;
    }
  }

  if (value.any((e) => !options.contains(e))) {
    print('Invalid value $value provided. Must be in: $options');
    value = [];
  }
  if (desc != null) {
    stdout.write(ansi.darkGray.wrap('\n$desc\u{1B}[1A\r'));
  }

  value = logger.chooseAny(message, choices: options);

  if (desc != null) {
    stdout.write('\r\u{1B}[K');
  }
  return value;
}

extension SortedBy<T> on Iterable<T> {
  Iterable<T> sortedBy(Comparable Function(T) selector) {
    return toList()..sort((a, b) => selector(a).compareTo(selector(b)));
  }
}
