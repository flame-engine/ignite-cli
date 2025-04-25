import 'package:args/command_runner.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/main.dart';
import 'package:mason/mason.dart';
import 'package:mason_logger/mason_logger.dart';

mixin IgniteCommand<T> on Command<T> {
  /// Forces sun-commands added to [IgniteCommand] command
  /// to use the [IgniteCommand] mixin on those sun-commands.
  @override
  void addSubcommand(covariant IgniteCommand<T> command) {
    super.addSubcommand(command);
  }

  IgniteContext get context {
    if (runner case IgniteCommandRunner(:final IgniteContext context)) {
      return context;
    }
    // definitely in some invalid state
    throw StateError('The current runner must be a [IgniteCommandRunner]');
  }
}

class IgniteContext {
  final Logger logger;
  final FlameVersionManager flameVersionManager;

  IgniteContext({required this.logger, required this.flameVersionManager});
}
