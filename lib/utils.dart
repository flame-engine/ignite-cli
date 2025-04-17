import 'dart:io';

import 'package:args/args.dart';
import 'package:charcode/ascii.dart' as ascii;
import 'package:io/ansi.dart' as ansi;
import 'package:path/path.dart' as p;
import 'package:prompts/prompts.dart' as prompts;

String getBundledFile(String name) {
  final binFolder = p.dirname(p.fromUri(Platform.script));
  return p.join(binFolder, '..', name);
}

String getString(
  ArgResults results,
  String name,
  String message, {
  required bool isInteractive,
  String? desc,
  bool Function(String)? validate,
}) {
  var value = results[name] as String?;
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
    value = prompts.get(message, validate: validate);
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
    value = options[prompts.choose(message, options.keys)];
    if (desc != null) {
      stdout.write('\r\u{1B}[K');
    }
  }
  return value;
}

List<String> _unwrap(dynamic value) {
  return switch(value) {
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
  final selectedOptions = value.isEmpty
      ? startingOptions
      : value;
  value = cbx(message, options, selectedOptions);
  if (desc != null) {
    stdout.write('\r\u{1B}[K');
  }
  return value;
}

List<String> cbx(
  String message,
  List<String> keys,
  List<String> startingKeys,
) {
  final selected = startingKeys;
  var hereIdx = 0;

  var needsClear = false;
  void writeIt() {
    if (needsClear) {
      for (var i = 0; i <= keys.length; i++) {
        prompts.goUpOneLine();
        prompts.clearLine();
      }
    } else {
      needsClear = true;
    }
    print(message);
    keys.asMap().forEach((index, option) {
      final isSelected = selected.contains(option);
      final isHere = index == hereIdx;
      final text = ' ${isSelected ? '♦' : '♢'} $option';
      final color = isHere ? ansi.cyan : ansi.darkGray;
      print(color.wrap(text));
    });
  }

  final oldEchoMode = stdin.echoMode;
  final oldLineMode = stdin.lineMode;
  while (true) {
    int ch;
    writeIt();

    try {
      stdin.lineMode = stdin.echoMode = false;
      ch = stdin.readByteSync();

      if (ch == ascii.$esc) {
        ch = stdin.readByteSync();
        if (ch == ascii.$lbracket) {
          ch = stdin.readByteSync();
          if (ch == ascii.$A) {
            // Up key
            hereIdx--;
            if (hereIdx < 0) {
              hereIdx = keys.length - 1;
            }
            writeIt();
          } else if (ch == ascii.$B) {
            // Down key
            hereIdx++;
            if (hereIdx >= keys.length) {
              hereIdx = 0;
            }
            writeIt();
          }
        }
      } else if (ch == ascii.$lf) {
        // Enter key pressed - submit
        return selected;
      } else if (ch == ascii.$space) {
        // Space key pressed - selected/unselect
        final key = keys[hereIdx];
        if (selected.contains(key)) {
          selected.remove(key);
        } else {
          selected.add(key);
        }
        writeIt();
      }
    } finally {
      stdin.lineMode = oldLineMode;
      stdin.echoMode = oldEchoMode;
    }
  }
}

extension SortedBy<T> on Iterable<T> {
  Iterable<T> sortedBy(Comparable Function(T) selector) {
    return toList()..sort((a, b) => selector(a).compareTo(selector(b)));
  }
}
