import 'package:args/args.dart';
import 'package:process_run/process_run.dart';

void createCommand(ArgResults command) async {
  final org = command['org'] as String;
  if (org == null || org.isEmpty) {
    print('The org option is required.');
    return;
  }
  final name = command['name'] as String;
  if (name == null || name.isEmpty) {
    print('The name option is required.');
    return;
  }

  final currentDir = (await run('pwd', [])).stdout;
  print('Running flutter create on $currentDir');

  await run(
    'flutter',
    'create --org $org --project-name $name .'.split(' '),
    verbose: true,
  );
}
