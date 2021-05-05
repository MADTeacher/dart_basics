import 'dart:io';

void main(List<String> arguments) {
  var myFile = File('text.txt');
  myFile.writeAsStringSync('Привет! О, этот чудный мир!!');
  print(myFile.readAsStringSync()); // чтение всего файла
}
