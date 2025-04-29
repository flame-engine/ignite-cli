import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:ignite_cli/ignite_context.dart';

abstract class IgniteCommand extends Command<int> {
  final IgniteContext context;

  IgniteCommand(this.context);

  @override
  Future<int> run();
}
