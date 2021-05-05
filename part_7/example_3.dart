import 'dart:io';

void main(List<String> arguments) {
  var myFile = File('text.txt');
  myFile.writeAsStringSync('\nХочу обратно в школу!!!', 
   mode: FileMode.append);
  print(myFile.readAsStringSync()); // чтение всего файла
}
