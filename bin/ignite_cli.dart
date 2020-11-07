import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;
import 'package:ignite_cli/ignite_cli.dart' as ignite_cli;

void main(List<String> args) {
  final argParser = ArgParser();
  argParser.addFlag('help', abbr: 'h', help: 'Displays this message.');
  argParser.addOption('option', abbr: 'o', help: 'Specify some option.');

  final parsedArgs = completion.tryArgsCompletion(args, argParser);
  if (parsedArgs['help']) {
    print(argParser.usage);
    return;
  }

  final option = parsedArgs['option'];
  final result = ignite_cli.calculate(option);
  print(result);
}
