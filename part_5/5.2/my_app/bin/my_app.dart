import 'package:args/args.dart';

void main(List<String> arguments) {
  var parser = ArgParser();

  parser.addOption(
    'firts',
    abbr: 'a',
    help: 'First number',
    defaultsTo: '1',
  );
  parser.addOption(
    'second',
    abbr: 'b',
    help: 'Second number',
    defaultsTo: '5',
  );
  parser.addFlag(
    'subtract',
    abbr: 's',
    help: 'Subtract mode',
    defaultsTo: false,
  );

  var args = parser.parse(arguments);
  print(arguments);
  var a = int.parse(args['firts']);
  var b = int.parse(args['second']);

  if (args['subtract']){
    print('a - b = ${a - b}');
  }else{
    print('a + b = ${a + b}');
  }
}
