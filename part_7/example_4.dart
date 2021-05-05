import 'dart:io';

void main(List<String> arguments) {
  var myFile = File('text.txt');
  var sink = myFile.openWrite(mode: FileMode.write);
  var stringList = <String>['Ий-хо-хо!', 'И', 'бутылка', 'рома!'];
  sink.writeAll(stringList, ' ');
}
