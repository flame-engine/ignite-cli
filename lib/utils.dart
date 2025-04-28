import 'dart:io';

import 'package:args/args.dart' show ArgResults;
import 'package:mason_logger/mason_logger.dart';
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
  required Logger logger,
  String? desc,
  String? Function(String)? validate,
}) {
  var value = results[name] as String?;
  if (!isInteractive) {
    if (value == null || value.isEmpty) {
      logger.err('Missing parameter $name is required.');
      exit(ExitCode.usage.code);
    }
    final error = validate?.call(value);
    if (error != null) {
      logger.err('Invalid value $value provided: $error');
      exit(ExitCode.usage.code);
    }
  }

  String? validation;

  do {
    desc = darkGray.wrap(desc);
    var msg = message;

    if (desc != null) {
      msg = '$msg ($desc)';
    }

    if (validation != null) {
      validation = logger.theme.warn(validation);
      msg = '$message [$validation]'; // omit the description on errors
    }

    value = logger.prompt(msg);
    validation = validate?.call(value);
  } while (validation != null);

  return value;
}

String getOption(
  ArgResults results,
  String name,
  String message,
  Map<String, String> options, {
  required bool isInteractive,
  required Logger logger,
  String? desc,
  String? defaultsTo,
  Map<String, String> fullOptions = const {},
}) {
  var value = results[name];

  if (!isInteractive) {
    if (value == null) {
      if (defaultsTo != null) {
        return defaultsTo;
      } else {
        logger.info('Missing parameter $name is required.');
        exit(ExitCode.usage.code);
      }
    }
  }
  final fullValues = {...options, ...fullOptions}.values;
  if (value != null && !fullValues.contains(value)) {
    logger.info('Invalid value $value provided. Must be in: ${options.values}');
    value = null;
  }

  while (value == null) {
    if (desc != null) {
      logger.info(darkGray.wrap('\n$desc\u{1B}[1A\r'));
    }

    final option = logger.chooseOne(message, choices: options.keys.toList());
    value = options[option];

    if (desc != null) {
      logger.info('\r\u{1B}[K');
    }
  }
  return switch (value) {
    final String value => value,
    final bool value => 'true',
    _ => '',
  };
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
  required Logger logger,
  List<String> startingOptions = const [],
  String? desc,
}) {
  var value = _unwrap(results[name]);
  if (!isInteractive) {
    if (value.isEmpty) {
      if (startingOptions.isNotEmpty) {
        return startingOptions;
      } else {
        logger.info('Missing parameter $name is required.');
        exit(ExitCode.usage.code);
      }
    } else {
      return value;
    }
  }

  if (value.any((e) => !options.contains(e))) {
    logger.info('Invalid value $value provided. Must be in: $options');
    value = [];
  }
  if (desc != null) {
    logger.info(darkGray.wrap('\n$desc\u{1B}[1A\r'));
  }

  value = logger.chooseAny(message, choices: options);

  if (desc != null) {
    logger.info('\r\u{1B}[K');
  }
  return value;
}

extension SortedBy<T> on Iterable<T> {
  Iterable<T> sortedBy(Comparable Function(T) selector) {
    return toList()..sort((a, b) => selector(a).compareTo(selector(b)));
  }
}
