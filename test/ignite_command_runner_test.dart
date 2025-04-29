import 'dart:io';

import 'package:ignite_cli/commands/ignite_command.dart';
import 'package:ignite_cli/flame_version_manager.dart';
import 'package:ignite_cli/ignite_command_runner.dart';
import 'package:ignite_cli/version.g.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

class _MockFlameVersionManager extends Mock implements FlameVersionManager {}

class _MockStdin extends Mock implements Stdin {}

class _MockStdout extends Mock implements Stdout {}

class _MockIgniteContext extends Mock implements IgniteContext {}

void main() {
  group('IgniteCommandRunner', () {
    late Logger logger;
    late IgniteCommandRunner commandRunner;
    late FlameVersionManager flameVersionManager;
    late Stdin stdin;
    late Stdout stdout; // ignore: close_sinks
    late IgniteContext context;

    setUp(() {
      logger = _MockLogger();
      flameVersionManager = _MockFlameVersionManager();
      stdin = _MockStdin();
      stdout = _MockStdout();
      context = _MockIgniteContext();
      when(() => context.logger).thenReturn(logger);
      when(() => context.flameVersionManager).thenReturn(flameVersionManager);

      when(
        () => context.run(
          any(),
          any(),
          workingDirectory: any(named: 'workingDirectory'),
        ),
      ).thenAnswer((_) async => ProcessResult(0, 0, stdin, stdout));

      when(() => flameVersionManager.versions).thenReturn({
        Package.flame: const Versions(['1.28.1']),
      });

      commandRunner = IgniteCommandRunner(context);
    });

    test('exits with code 0 when [version] is called', () async {
      final exitCode = await commandRunner.run(['--version']);
      expect(exitCode, equals(ExitCode.success.code));

      verify(() => logger.info('ignite --version: $igniteVersion\n'));
      verify(() => context.run('flutter', ['--version'])).called(1);
      verify(() => context.run('dart', ['--version'])).called(1);
      verifyNever(() => logger.err(any()));
    });

    test('exits with code 0 when [verbose] is set', () async {
      final exitCode = await commandRunner.run(['--verbose']);
      expect(exitCode, equals(ExitCode.success.code));

      verify(() => logger.level = Level.verbose).called(1);
      verifyNever(() => logger.err(any()));
    });
  });
}
