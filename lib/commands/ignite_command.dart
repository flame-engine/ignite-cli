import 'package:args/command_runner.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/main.dart';
import 'package:mason_logger/mason_logger.dart';

mixin ContextProvider<T> on Command<T> {
  IgniteContext get context {
    if (runner case IgniteCommandRunner(:final IgniteContext context)) {
      return context;
    }
    throw Exception('The current runner must be a [IgniteCommandRunner]');
  }
}

class IgniteContext {
  final Logger logger;
  final FlameVersionManager flameVersionManager;

  IgniteContext({required this.logger, required this.flameVersionManager});
}
