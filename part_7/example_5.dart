import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  final myFile = File('text.txt');
  var stringList = <String>[
    'Пятнадцать человек на сундук мертвеца.\n',
    'Йо-хо-хо, и бутылка рому!\n',
    'Пей, и дьявол тебя доведет до конца.\n',
    'Йо-хо-хо, и бутылка рому!'
  ];
  stringList.forEach((element) {
    myFile.writeAsStringSync(element, mode: FileMode.append);
  });

  Stream<String> lines = myFile
      .openRead()
      .transform(utf8.decoder) // Декодирование байтов в UTF-8.
      .transform(LineSplitter()); // Перевод потока в отдельные строки
  try {
    await for (var line in lines) {
      print('$line: ${line.length}');
    }
    print('Файл закрыт');
  } catch (e) {
    print('Ошибка: $e');
  }
}
